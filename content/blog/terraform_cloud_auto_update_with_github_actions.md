+++
title = "Terraform Cloud の terraform バージョンアップを GitHub Actions で自動化する"
date = 2020-06-01T08:06:51+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

Terraform Cloud がサービス開始して約1年、 state file の保存のみならず、 `plan` と `apply` の実行環境としてもバリバリ使わせてもらっている。ちょっと面倒なのが、 plan 等を実行する workspace の Terraform バージョン設定である。常に `latest` を使うというアグレッシブな設定もできるが、そうしない限りは手動でバージョンアップが必要になっている。

<a href="https://gyazo.com/ddda6bbe377f7c0c09a9bed473e24374"><img src="https://i.gyazo.com/ddda6bbe377f7c0c09a9bed473e24374.png" alt="Image from Gyazo" width="921"/></a>

まぁガンガン `latest` にしていくのも考え方によってはありかもしれないが、メジャーバージョンアップ（ Terraform の場合 0.12 → 0.13 をメジャーバージョンアップと呼びたい）までされてしまうのは抵抗がある人も多いのではないだろうか。そもそも Terraform には remote config の中にバージョン指定を出来る箇所があり、自分の場合はこんな感じで 0.12 台のみを許可している。

```hcl
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "sample"

    workspaces {
      name = "sample"
    }
  }
  required_version = "~> 0.12.0"
}
```

望むらくは、この `required version` をもとにしていい感じにバージョン設定してほしい。なのでそういう GitHub Actions を作った。

## terraform-cloud-updater

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/marketplace/actions/terraform-cloud-workspace-auto-update" data-iframely-url="//cdn.iframe.ly/s3PFvW5"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

input として最低限、対象の Terraform ファイルが保存された `working_dir` を指定し、環境変数 `TFE_TOKEN` で Terraform Cloud の API トークンを渡してあげれば動作する。

```yaml
on:
  push:
    branches:
      - master

jobs:
  tf_cloud_update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: check update
        id: check
        uses: chroju/terraform-cloud-updater@v1
        with:
          working_dir: ./terraform
        env:
          TFE_TOKEN: ${{ secrets.TFE_TOKEN }}
      - name: result
        run: echo "${{ steps.check.outputs.output }}"
        if: "${{ steps.check.outputs.is_available_update == 'true' }}"
```

デフォルトの設定だと workspace のバージョンアップまでは自動で行わず、新しいバージョンが見つかったら `outputs.is_available_update` の値が `true` になり、バージョン情報が `outputs.output` にセットされるだけだ。あとは `is_available_update` で条件分岐して、例えば slack などで通知する方式を想定している。 `comment_pr` という input を `true` にすれば、 Pull request をトリガーとして使った際にコメントで通知してくれる機能も作ってはあるが、バージョンチェックであれば cron 形式で定期実行するほうがいいだろう。

input の `auto_update` を `true` にすることで、自動的に更新まで行ってくれる。その際、 required version との整合性を確認し、整合しない場合には更新は行わず、通知だけが行われる。以下は `comment_pr` を `true` にした場合のサンプルだが、 `outputs.output` からも同様のメッセージが取得できる。

<a href="https://gyazo.com/c05c61d030dd2b6f06bd9573a905152a"><img src="https://i.gyazo.com/c05c61d030dd2b6f06bd9573a905152a.png" alt="Image from Gyazo" width="741"/></a>

## 実装

### go-tfe

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/hashicorp/go-tfe" data-iframely-url="//cdn.iframe.ly/CxCwopM"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

Terraform Cloud の API ライブラリは hashicorp が公開している。名前が `tfe` になっているが、これは Terraform Enterprise と Cloud の共通 API ライブラリだからであって、 Cloud で特に問題なく使えた。

ちなみに Go で CLI ツールとして書いているので、この Action のもとになっているレポジトリを build すれば、ローカルで実行する CLI としても使うことができる。

```bash
$ terraform-cloud-updater -h
Usage: terraform-cloud-updater [--version] [--help] <command> [<args>]

Available commands are:
    check     Check if new Terraform version is available
    update    Update Terraform cloud workspace terraform version
```

### required version の処理

一番面倒くさかったのが required version だった。セマンティックバージョニングはいわゆる小数ではなく、ドットを2つ挟んだ数値形式なので、単なる数値比較を行なうことができず、逐一ロジックを組んでいった。また required version を示すオペランドの中には、 `~> 0.12` （0.12.0 以上かつ 0.13.0 未満の意）といった複数の意味をはらんだものもあり、これも自前で判定ロジックを組んだ。

と、いろいろ書いた末に「セマンティックバージョニングをよろしくやってくれるライブラリあるんでは？」と思って探してみたら当の hashicorp から公開されていたわけなのだが。勉強になったのでいいか、と思いつつ、こちらも比較で見てみようと思っている。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/hashicorp/go-version" data-iframely-url="//cdn.iframe.ly/xFgS2MK"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

### 初めての GitHub Actions

GitHub Actions 自体はよく使っているものの、自分で Action を作るのはこれが初めてだった。ここでは詳細な作り方などには触れないが、 Action を実行する Dockerfile と entrypoint.sh を書き、あとはメタ情報を定義した action.yml を設置するだけでよいので、非常にお手軽に感じた。ちなみに Action は JS か Docker で作れるのだが、後者を選んだのは単に JS が書けないから。書けるのであれば実行速度などを鑑みても JS のほうがいいと思う。

なお、 GitHub Actions は [GitHub Marketplace](https://github.com/marketplace) で公開ができる。そのための操作も非常にシンプルで、レポジトリのルートに action.yml を置くと勝手に判定されて、 Marketplace で公開するためのボタンが表示されるようになっていた。

<a href="https://gyazo.com/229fea07a252ea16fb56de4637fe3553"><img src="https://i.gyazo.com/229fea07a252ea16fb56de4637fe3553.png" alt="Image from Gyazo" width="461"/></a>

## Terraform のバージョン管理という根深い問題

Terraform のバージョン管理問題はなかなか根深い。というのも Terraform の仕様上、一度使用したバージョンより古いバージョンに戻ることはできないようになっているからだ。そのため複数の Terraform レポジトリを扱っている場合、バージョンは `required version` に従って一括で揃えられるようにしたいという欲求が大きい。

複数の Terraform バージョンを切り替えるためのコマンドラインツール tfenv においても、 [tfenv doesn't read the required_version from conf.tf · Issue #124 · tfutils/tfenv](https://github.com/tfutils/tfenv/issues/124) ということで、 required version に則って自動的に切り替えてほしいという issue が挙がっており、このあたりは悩んでいる人が多いのではないかと推察している。
