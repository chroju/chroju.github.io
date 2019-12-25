+++
title = "GCP 公開の Terraform modules から module による効果的な抽象化を学ぶ"
date = 2019-12-24T19:16:59+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

Terraform はずっとほぼ AWS でしか使っていなくて、最近 GCP で使い始めたところ結構使い勝手が違って驚いている。その中でも公式提供されている Terraform modules がかなり良くて、 GCP 使わない人でも参考になるので紹介してみる。

## Terraform modules for Google Cloud

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/terraform-google-modules" data-iframely-url="//cdn.iframe.ly/l2qMnlK"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

上記 GitHub Organization にて、現時点で 64 の module が公開されている。 Organization のメンバーを見ると GCP に属している方が多いので、どうも Google 公認で提供されているものらしい。 AWS にも [Terraform AWS modules](https://github.com/terraform-aws-modules) という Organization があるが、こちらは見る限り AWS 関係者ではなく有志による提供となっている。昨今のアレじゃないけど、 Google のほうが OSS コミュニティと良い関係を築こうという意思が見て取れるなぁという気がしなくもない。

公開されている module はいろいろあるが、一例として IAM に関して見てみる。 GCP の IAM に関する Terraform resources は [Google: google_project_iam - Terraform by HashiCorp](https://www.terraform.io/docs/providers/google/r/google_project_iam.html) で触れられている通り、何種類かのものが存在するのだが、ざっくり以下2種類に気を付ける必要がある。

* `google_project_iam_member` : Role とメンバーを1対1で紐つける
* `google_project_iam_binding` : ある Role と紐付くメンバーすべてを管理する

GCP ではあらかじめ複数の権限が割り当てられた Role というものが存在し（ AWS のマネージドポリシーみたいなものと考えればいいかもしれない）、これとメンバーを紐つけて権限の割り当てを行う。前者の `member` は1対1対応しか作れないので、ある Role に複数のメンバーを結びつけたい場合（が大半だと思うが）はちょっと不便だ。しかし一方で `binding` はある Role と紐付く **すべての** メンバーを管理する。そのため Terraform を apply する前に、すでに Role と紐ついたメンバーがいて、 Terraform 内ではそのメンバーを宣言していなかった場合、 `apply` 時に除外されてしまうことになるので注意が必要となる。

という、それぞれ一長一短ある resource をうまいこと使い分けなくてはならないのだが、 GCP が module で解決策を提示してくれている。 [terraform-google-iam/modules/projects_iam at master · terraform-google-modules/terraform-google-iam](https://github.com/terraform-google-modules/terraform-google-iam/tree/master/modules/projects_iam) からサンプルを引用する。

```hcl
module "project-iam-bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  projects = ["my-project_one", "my-project_two"]
  mode     = "additive"

  bindings = {
    "roles/compute.networkAdmin" = [
      "serviceAccount:my-sa@my-project.iam.gserviceaccount.com",
      "group:my-group@my-org.com",
      "user:my-user@my-org.com",
    ]
    "roles/appengine.appAdmin" = [
      "serviceAccount:my-sa@my-project.iam.gserviceaccount.com",
      "group:my-group@my-org.com",
      "user:my-user@my-org.com",
    ]
  }
}
```

2つの resource の使い分けを気にする必要はなく、 `bindings` 変数に role と members の1対多のリストを渡せばいいだけ。既存の紐付きを置き換える ( `authoritative` ) のか、既存のものは触らず新たな紐付きを追加する ( `additive` ) のかは `mode` 変数で指定ができ、さらにデフォルトは安全側に倒れて `additive` となっている。だいぶ使いやすく抽象化されていると言っていい。

抽象化のロジックを見てみる。呼び出している [module](https://github.com/terraform-google-modules/terraform-google-iam/blob/master/modules/projects_iam/main.tf) 自体はわりと簡素な内容になっている。というのも、見ればわかるのだが、ロジック部分を `helper` という別の module に飛ばしているからだ。ここではほぼ resource 作成だけが行われている。

```hcl
module "helper" {
  source   = "../helper"
  bindings = var.bindings
  mode     = var.mode
  entity   = var.project
  entities = var.projects
}

resource "google_project_iam_binding" "project_iam_authoritative" {
  for_each = module.helper.set_authoritative
  project  = module.helper.bindings_authoritative[each.key].name
  role     = module.helper.bindings_authoritative[each.key].role
  members  = module.helper.bindings_authoritative[each.key].members
}

resource "google_project_iam_member" "project_iam_additive" {
  for_each = module.helper.set_additive
  project  = module.helper.bindings_additive[each.key].name
  role     = module.helper.bindings_additive[each.key].role
  member   = module.helper.bindings_additive[each.key].member
}
```

使っている resource は、やはり先程見た `iam_binding` と `iam_member` の2つだ。それぞれ `for_each` が使われていることから、変数 `bindings` で指定された role と members と project あたりをいい感じに list に変換して、選択された mode に応じて `module.helper.set_authoritative` か `module.helper.set_additive` に代入しているのだろうと想像がつく。代入されていないほうの変数は空のリストになるので、 resource の作成は行われない。

実際に [helper](https://github.com/terraform-google-modules/terraform-google-iam/blob/master/modules/helper/main.tf) を覗いてみると、確かにそのようなロジックになっている。 `module.helper.set_authoritative` について追ってみる。

```hcl
  set_authoritative = (
    local.authoritative
    ? toset(local.keys_authoritative)
    : []
  )
```

`local.authoritative` による三項演算子だ。 `local.authoritative` は先の `mode` が `authoritative` だった場合にのみ値が代入されるようになっており、 やはり `authoritative` を指定した場合に限り、 `set_authoritative` にリストが代入されているとわかる。そして代入される値は、 `keys_authoritative` を set に変換したものとなっている。では `keys_authoritative` とは何か。

```hcl
  keys_authoritative = distinct(flatten([
    for alias in local.aliased_entities
    : [
      for role in keys(var.bindings)
      : "${alias}--${role}"
    ]
  ]))
```

`local.aliased_entities` は project のリストと思ってよい。二重ループになっているため少しわかりづらいが、各 project ごとに `bindings` から keys, すなわち `role` の値を取り出し、 project 名と繋げた文字列の配列を作っている。前述したサンプルのように、 projects と role をそれぞれ2つずつ指定している場合であれば、 2 × 2 で長さ4の配列が作られることになるわけだ。 `helper` の別のところでは、この4つの project - role それぞれに紐つけるべきメンバーのリストが生成されている。最終的に `for_each` のループによって、これらを組み合わせて `iam_binding` が生成されている。

ここではざっくりと GCP Terraform modules の中身を見てみたが、これ以外にも非常に多くの Terraform functions を上手く使って抽象化を試みている。コメントも多く盛り込まれていて読みやすいので、各 functions はどういう場面でどのように活用できるのか、とても参考になる。

## Conclusion

Terraform provider はその仕組み上、各クラウドサービスの API サービスをそのまま愚直に変換したものであり、 API の仕様を把握していなければ上手く扱えないこともある。しかし我々が欲しているのはクラウドリソースのコード化という点のみであり、 API の仕様を細部まで常に気にしなくてはならない、という状況は歓迎したくない。 GCP の modules はそういった低レイヤーな知識がなくとも、簡潔な記載でクラウドリソースを使えるようにしてくれているものが多い。 Terraform modules を作るとき、単に組織内でのデフォルト値を埋め込んでいるだけ、のような使い方になってしまうことも少なくないと思うが、 GCP のそれは「抽象化」という観点で module を作る上で、大きなヒントになりそう。

## Appendix: GCP with Terraform 所感

おまけで、 Terraform で GCP を扱うときに、 AWS を扱うときとこのへんが感覚違うなーと思う点をいくつか。

* 認証に JSON が必要なのはちょっと面倒。
* 個々のユーザーでは credential json 吐き出せなくてサービスアカウントが必要なのも面倒。 
* でも複数の project に横断的にリソースを作るのは AWS マルチアカウントより遥かに楽ですごい。
* 各 resource とも attibute references ( outputs で出力できるやつ) がちょっと少なめな印象を受ける。
* 一部 resoruce はドキュメントから直接 Cloud Shell で実践できるボタンがあって強い。
  * https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html とか。
