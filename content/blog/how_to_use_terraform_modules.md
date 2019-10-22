+++
title = "Terraform moduleは何が嬉しいのか"
date = 2017-12-27T22:09:25+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

Terraformの「[module](https://www.terraform.io/intro/getting-started/modules.html)」を最近使うようになった。moduleは複数のクラウドリソースをまとめてテンプレート化して、呼び出すときに必要な引数だけ与えてあげれば発動可能になるというもので、要するにリソースの抽象化に使われる。Ansibleで言うところのRoleに近い。

Terraform自体は1年ぐらい前から使っていたので、結構長いことmoduleには触れていなかったんだけど、理由としては結構複雑化しそうというのがあった。今回改めて触れてみて、メリットは確かに感じられるがやっぱり複雑だなという気持ちが強くて、一旦まとめてみる。

宣言地獄
----

moduleはクラウドリソースの枠を作り、各種設定値は変数として空けておいて、呼び出されるときに変数を埋めてもらう、という形を取るので、変数宣言をそこここに書くことになる。これがあまりDRYではないというか、何度も同じものを書く必要があったりする。

簡単に書いてしまうとmoduleはこうなる。

```hcl:main.tf
variable "name" {}
variable "instnace_type" { default = "t2.micro" }

resource "aws_ec2_instance" "hoge" {
  name          = "${var.name}"
  instance_type = "${var.type}"
}
```

resourceの中に変数のプレースホルダを置き、さらにその変数名を
 `variable` 句で宣言する。ここでは簡略化してresourceと同じファイル内に変数宣言も置いたが、推奨のプラクティスとしては `variable.tf` という別ファイルに変数宣言だけ切り出すことが多い。

このmoduleを呼び出すときは、以下のように変数に値を埋めてやる。

```hcl:main.tf
variable "name" {
  value = "hoge"
}

variable "type" {
  value = "c4.xlarge"
}

module {
  source = "./hoge"

  name   = "${var.name}"
  type   = "${var.type}"
}
```

若干大げさに書いた。ここで `module` 内にもプレースホルダを置いて、さらに `variable` を宣言する必要はなくて、プレースホルダの箇所に直接値を書けばそれで済む。ただ、可変値とそれ以外は分けて記述した方がわかりやすいという人もいるので、そこは好みかなと。

というわけで結構何回も同じ変数名を書くことになる。少なくともmodule内のプレースホルダで1回、その変数宣言で1回、呼び出すときに1回の計3回必要。

これさすがに冗長だなぁという気がしていて、例えば特定のmoduleを使うときに、入力が必要な変数を全部tfファイルに書き出すツールとかあったらいいんではと思ってる。Terraform本体にも `validate` サブコマンドはあるけど、あれは文法的なエラーしか確認してくれないので。来月作れたら作りたい。

moduleはどの単位で切るべきか
----

moduleは何のために使うのかと言えば、繰り返し使うような部分を隠蔽して、DRYに書くことを実現するためなので、再利用性のある単位でresourceをまとめるのが効率がよいということになる。

これは各位のAWSの使い方に依存するので、唯一解はない。例えばEC2を立ち上げるときに必ずIAM Roleも個別に用意して付与するような使い方をしているなら、EC2とIAM Role双方を作れるようなmoduleでパッケージするのが効率いいはず。

ただ、再利用性を高めたmoduleを書くのが結構難しい。例えば以下のリンクは [Terraform module registry](https://registry.terraform.io/) にあるAWSセキュリティグループのmoduleだが、ちょっと見てみてほしい。

[terraform-aws-security-group/modules at master · terraform-aws-modules/terraform-aws-security-group](https://github.com/terraform-aws-modules/terraform-aws-security-group/tree/master/modules)

セキュリティグループはかなり書き方の幅が広くて、自力で書こうともしてみたけど、様々な利用ケースを想定して書くのは相当難しかった。なので先のレポジトリではある程度割り切って、元から代表的なポート番号を開けるためのmoduleを用意して使わせる形になっている。おそらくこっちの方が現実的。

そしてここまでのものを自前で用意したところで、そんなに再利用するかな？って話になるので、moduleが複雑化しそうであれば、無理して作らずにmodule registryから持ってくるか、逐一resourceを普通に書いた方が省エネだったりもする。一方でIAM Userとか設定がシンプルなものはmoduleに任せるとかなり楽。

module registry、少し使ってみたけど楽なのは確かで、例えばすぐにリソース立ち上げたいからTerraform書くのめんどくせーや手動起動→結局そのリソース長期で使うハメになりブラックボックス化、とかよくあるけど、module registryから引っ張ってきて取りあえず使えば雑にコード化は可能になったりする。

Best Practice
----

今回は断片的にmoduleに触れただけなので、どこかでもう少し包括的な視点からベストプラクティスっぽいのまとめたいなと思う。

実のところ [hashicorp/best-practices](https://github.com/hashicorp/best-practices/) というのが公開されてはいるのだけど、残念ながら「Deprecated」になっていて、現状HashiCorp公開のベストプラクティスは存在していない（多分）（知らないだけでどこかにあるなら教えてほしい）。最近Terraformもいろいろ機能追加があってプラクティス変わってきてるので、どこかのタイミングで再度ベストプラクティスを公開してほしいとは思う。

Qiitaにあったこちらはかなり参考にさせていただいた。文中では触れられていないが、「immutable」と「not_immutable（mutable？）」でtfファイルを分けるというのはとても同意したい。Desired Instancesを手動、自動で変化させ得るAutoScalingグループのようなmutableなオブジェクトは、Terraformだけで変更をかけ得るオブジェクトとは別で管理した方がいい。

[Terraform Best Practices in 2017 - Qiita](https://qiita.com/shogomuranushi/items/e2f3ff3cfdcacdd17f99)

表題に対する現時点の結論としては、

* シンプルな設定のリソースについては、再利用性の高いmoduleを書くとDRYなtfファイルになって嬉しい。
* 先日公開されたTerraform module registryから引っ張ってくれば、すぐリソース作りたいときにも少ない手間でコード化ができて嬉しい。
* 変数宣言の多さと、複雑化した場合の管理コストの多さは嬉しくない。

というところ。なので3点目を解消する方向へ頑張りたい。
