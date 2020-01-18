+++
title = "Terraform の秘匿情報を mozilla/sops で管理する"
date = 2020-01-18T13:17:06+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

Terraform を使う上での長年の悩みとして、秘匿情報 (secrets) をどう扱うべきかというものがある。例えば AWS Secrets Manager への secrets の登録を Terraform で行うとして、 tf file には平文で secrets を書き記すことになってしまう。これをそのまま Git repository に commit するのは当然ながらよろしくない。

いろんな Terraform ユーザーに話を聞いたりしてもなかなか解決しなかったこの問題だが、ようやく決定版と言えそうな解決策として [mozilla/sops](https://github.com/mozilla/sops) を使う方法を見つけた。

## SOPS

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/mozilla/sops" data-iframely-url="//cdn.iframe.ly/Uy7gztd"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

Secrets OPerationS の略らしい。 YAML や JSON など Key/Value 形式の設定ファイルにおいて、 Value の箇所だけを暗号化できるコマンドラインツールである。 homebrew でインストールできる。

```bash
$ brew install sops
```

暗号化にあたり、まず鍵を指定しておく必要がある。鍵は AWS KMS や GCP KMS などの各種クラウドサービスの暗号化サービスに対応していて、環境変数で使うキーを指定する。鍵がファイルだったり手入力のパスフレーズだったりすると扱いに困りがちだが、クラウドの KMS であればキーへのアクセス権を適切に管理するだけでいいので、これは嬉しいポイント。

```bash
$ export SOPS_KMS_ARN='arn:aws:kms:ap-northeast-1:999999999999:key/XXXXXXXX-XXXX-XXXX-bd50-ac0ec6d03d63'
```

新しく暗号化したファイルを作る場合は、 `sops` コマンドに secret を保存するファイル名を引数として与えて実行する。

```bash
$ sops secrets.yaml
```

すると、そのファイルの編集画面が `$EDITOR` で開く。ファイル名の拡張子からファイル形式が自動的に判断されて、以下のようにサンプルが表示される。

```yaml
hello: Welcome to SOPS! Edit this file as you please!
example_key: example_value
# Example comment
example_array:
- example_value1
- example_value2
example_number: 1234.5679
example_booleans:
- true
- false
```

別にこのサンプルを踏襲する必要はまったくなくて、すべて消して好きなように内容は書いてよい。そしてファイルを保存したタイミングで、 value 部分に暗号化が施される。例えば以下のような YAML を書く。

```yaml
db_user: user
db_password: password
```

これを保存後に `cat` してみると以下の通り。

```yaml
db_user: ENC[AES256_GCM,data:vioDUg==,iv:j7O4xlHMcfb6DzY0ptSa38tkeCFKy2e8qVGwTCG3M8k=,tag:qqcothINK6OKhJb/3jvuxw==,type:str]
db_password: ENC[AES256_GCM,data:vCo7u6AggyU=,iv:3y90FXchrZfXQ7b6JGfVJABdxk5r+mIezTf9jb19VdM=,tag:3Gq5IrDeJiz46snahFn4Og==,type:str]
sops:
    kms:
    -   arn: arn:aws:kms:ap-northeast-1:999999999999:key/XXXXXXXX-XXXX-XXXX-bd50-ac0ec6d03d63
        created_at: '2020-01-17T14:04:58Z'
        enc: AQICAHgIueX8MsuSyX/hToTAJGoN2l3ZRsFfBaJMo5aNEN6CPAG4Y2Bo1oWyGA+enYwwsaa+AAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMbbKFmXXsd1DuWI/5AgEQgDt7SbVbUUD4rsLO1mNC0MdCU5kXZt0qrL/SrCIwGWLUwFO8jYlJrgZFlOY2jKL1ODMXjfvUiM6YsQOqVw==
        aws_profile: ""
    gcp_kms: []
    azure_kv: []
    lastmodified: '2020-01-18T04:48:01Z'
    mac: ENC[AES256_GCM,data:2Rf0IgpyGXJxWCtFDn7Fl1Gv4qPMN9IXuWt+w71Iu9ngFBp4URSDCSthyxbXtt8jhiTl4IgvLkv0lyYAGa/dM+l/2OcR3LeZldv4oR3cm6LjErwKD8O65Lh7Z9J+LR/TmS7E4I0lN+JhePn8qrIGjL4x3J16mD45I2dNtlAoRus=,iv:HEttY0FACDix5plof0mP4B2lkikPcKiLEVSt7dqpql0=,tag:ZZR7witKJgZS/jf5rprXeQ==,type:str]
    pgp: []
    unencrypted_suffix: _unencrypted
    version: 3.5.0
```

最初の2行の通り、確かに暗号化が施されている。 `sops:` 以下は sops が付加するメタ情報で、見ると暗号化に使ったキーの ARN が埋め込まれている。復号には `sops -d filename` コマンドを使うが、このときは環境変数ではなくてこの YAML 内の ARN の指示先が復号キーとして扱われる。なのでチームメンバー内でこのファイルを共有するのであれば、該当のキーに対するアクセス権限をそれぞれが保持さえしていれば、容易に復号することができる。 ARN が割れたところで何かクラックできるわけではないので、この状態のファイルであればパブリックレポジトリに入れても良さそうな気もするのだが、気になるのであればプライベートレポジトリで commit しておけばいい。

なおこのファイルに対して再度 `sops filename` コマンドを使うと、複合した状態で YAML を再編集できる。編集後は編集した箇所と、メタ情報の一部だけが書き換わるので、 `git diff` で差分を見るときもわかりやすい。

## terraform-provider-sops

本題の sops を使った Terraform での秘匿値管理だが、残念ながら HCL を直接暗号化することには対応していない。しかし community provider として terraform-provider-sops がありがたいことに存在している。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/carlpett/terraform-provider-sops" data-iframely-url="//cdn.iframe.ly/6WxGX58"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

これは data source として、 sops で暗号化されたファイルからの値読み込みを提供してくれる provider だ。先の `db_user` と `db_password` を書き入れた `secrets.yaml` を作成した状態で、同じディレクトリに以下のような `sample.tf` を作成してみる。

```hcl
provider "sops" {}

provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-1"
}

data "sops_file" "secrets" {
  source_file = "secrets.yaml"
}

resource "aws_ssm_parameter" "sensitive" {
  for_each = data.sops_file.secrets.data
  type     = "String"
  name     = each.key
  value    = each.value
}
```

すると `terraform plan` の結果は以下の通りになる。

```bash
  # aws_ssm_parameter.sensitive["db_password"] will be created
  + resource "aws_ssm_parameter" "sensitive" {
      + arn    = (known after apply)
      + id     = (known after apply)
      + key_id = (known after apply)
      + name   = "db_password"
      + type   = "String"
      + value  = (sensitive value)
    }

  # aws_ssm_parameter.sensitive["db_user"] will be created
  + resource "aws_ssm_parameter" "sensitive" {
      + arn    = (known after apply)
      + id     = (known after apply)
      + key_id = (known after apply)
      + name   = "db_user"
      + type   = "String"
      + value  = (sensitive value)
    }

Plan: 2 to add, 0 to change, 0 to destroy.
```

普段の Terraform の使い勝手とほぼ変わらず、簡単に秘匿値を取り扱うことができてこれはうれしい。普通に tf file を書き、秘匿したい値だけは YAML へ切り出して sops で暗号化し、一緒に git commit してしまえば管理は簡単そうだ。

### Terraform Cloud での活用

sops の暗号化を AWS KMS key で行い、 aws provider を併用している場合について、Terraform Cloud 上でも正常に復号可能か試してみた。

結論から言えば復号できたのだが、若干動作が腑に落ちていない。 Terraform Cloud で aws provider を使う場合、 provider を以下のように記述して、 Terraform Cloud 側で API キーを `AWS_ACCESS_KEY` と `AWS_SECRET_KEY` の2変数に設定する形が一般的かと思う。

```hcl
provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-1"
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
}
```

どういうわけだが、ここで設定した API キーはあくまで aws provider でしか読み込まれない気がするのだが、そのキーに KMS の復号権限があれば、 sops の復号も動作した。設定が楽で助かるのは助かるが、どうしてこれで動くのかがよくわかっていない。気が向いたら深堀りしておきたい。

なお Terraform Cloud で community provider （GitHub の [Terraform Providers org](https://github.com/terraform-providers) で管理されていない provider）を使うときは、あらかじめ Git repository 内の `terraform.d/plugins/linux_amd64` 配下に provider のバイナリを含めておく必要があり、少々面倒。このことについては [Installing Software in the Run Environment - Runs - Terraform Cloud - Terraform by HashiCorp](https://www.terraform.io/docs/cloud/run/install-software.html#custom-and-community-providers) に記載されており、将来的にはより良い方法を提供したいとも書かれているので期待したいところ。

## Conclusion

本当にずっと悩まされてきた課題をスマートな形で解決できてものすごいテンションが上がっている。実はもともと Kubernetes の secrets 管理の方法を調べる中で見つけたツールで、「これは Terraform にも活用できるのでは？」と調べてみたところ、なんと provider を作ってくれている人がいると気付いた、という形の出会いだった。1月から今年は幸先が良さそう。
