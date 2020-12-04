+++
title = "Terraform Cloud を Alfred や CLI から操作する"
date = 2020-12-05T07:00:00+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

この記事は [Terraform Advent Calendar 2020](https://qiita.com/advent-calendar/2020/terraform) 5日目の記事です。

[Terraform Cloud](https://www.hashicorp.com/products/terraform) がフルリリースされて1年あまり経過しました。僕はこの1年だいぶ便利に使わせてもらっていて、 state file の保存のみならず、チームで共有する  private module の管理のほか、 Terraform の実行も現在は Cloud 上ですべて賄っており、手で `terraform apply` を打つ機会もほとんど無くなりました。

そんな便利な Terraform Cloud ですが、現状 UI はウェブのみとなっており、 hashicorp が得意とする CLI は用意されていません。そのため画面ポチポチクリック業がそれなりの頻度で発生しており、地味にストレスになっています。そこで macOS 用のランチャーアプリである [Alfred](https://www.alfredapp.com/) を使って、一部機能を検索、操作できるようにしてみました。

## alfred-terraform-cloud-workflow

Alfred には有料版 (Powerpack) 限定で、 workflow という拡張機能があります。これはデフォルトの検索機能に加えて、自分で任意の検索コマンドをスクリプトで組んで追加できるというものです。今回はこれを活用して Terraform Cloud の検索用 workflow を作成しました。 GitHub で OSS として公開しているので、手元の Alfred でも使っていただけます。

動作イメージは GIF で見てもらうと早いかと思います。

<a href="https://gyazo.com/a6ddc5a3f1aee2d8a41f5fc43639138e"><img src="https://i.gyazo.com/a6ddc5a3f1aee2d8a41f5fc43639138e.gif" alt="Image from Gyazo" width="600"/></a>


こんな感じで Alfred で検索して、該当の URL をサクッと開くことができます。検索可能なのは workspace 、 private module registry 、 run の3つです。 run はあまり耳馴染みがないかもしれませんが、 Terraform Cloud 上で実行される plan, apply がこう呼ばれます。この Alfred workflow では、実行中の run 、要するに承認待ち状態のままになっているものを検索可能としています。 Terraform Cloud 上での `plan` は実行に時間がかかることも多いので、いつでもサッと開けるようになっていると非常に便利です。

### 使い方

以下のレポジトリの Releases から、最新の `.alfredworkflow` ファイルをダウンロードして、 Alfred へインポートしてください。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/chroju/alfred-terraform-cloud-workflow" data-iframely-url="//cdn.iframe.ly/kjEYjpm"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

インポート後に変数の設定が必要です。 Alfred の Preferences を開き、 `organization` に検索対象とする organization を設定してください。 organization はここで決め打ちとなるため、複数の organization を動的に切り替えて検索することには現在対応していません。

<a href="https://gyazo.com/c7a29e90b469d8b6052cec6b834328fa"><img src="https://i.gyazo.com/c7a29e90b469d8b6052cec6b834328fa.png" alt="Image from Gyazo" width="489"/></a>

もう1つ、 `TF_CLI_CONFIG_FILE` という変数も用意されています。こちらは [Terraform における同名の環境変数](https://www.terraform.io/docs/commands/cli-config.html#development-overrides-for-provider-developers)と同じものです。この workflow は `$HOME/.terraformrc` から API token を読み込んで使用しますが、別のパスのファイルを使いたい場合は、ここに設定します。パス変更が必要ない場合は空欄で大丈夫です。

これでセットアップは完了です。 `tfcws` で workspace 、 `tfcmd` で private module registry 、 `tfcruns` で run がそれぞれ検索できるようになったはずです。

なお、先のサンプル GIF では Terraform のロゴが設定されていましたが、配布の workflow にはライセンスの関係でロゴ画像は含めていません。お好みでご自身で設定してください。

## 内部実装 : tfcloud

ここからは内部実装の話をします。

とはいえ、ここで Alfred workflow の作り方を長々説明するのはアドカレの趣旨に反すると思いますので、その点は割愛します。ざっくり説明すると、 Alfred が定めるフォーマットで JSON を食わせると、あのインクリメンタル検索の候補として流れるという、それだけです。従って原始的な実装であれば、 curl で Terraform Cloud の API をたたき、結果を jq で整形するような形でも workflow は作成可能です。ただそれでは面白くないなという思いもあり、今回は go で Terraform Cloud の CLI ツール `tfcloud` を作って中で実行しています。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/chroju/tfcloud" data-iframely-url="//cdn.iframe.ly/uAA4Sjs"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

この CLI ツールは単独でももちろん利用可能です。普通に使う分には出力も human readable な形ですが、一部コマンドについて、隠れオプションを渡すことで Alfred に適合した JSON 形式で出力するようになっており、この仕組みを workflow 内部で呼び出しています。先ほど掲載した workflow は `tfcloud` のバイナリを内包した形で配布しているので、別途インストールは不要になっています。依存関係をあまり気にせず、ワンバイナリで配布できる Go は、こういう場面で便利ですね。


### tfcloud だけの機能

`tfcloud` を単独でも使ってみたい場合は、 `brew install chroju/tap/tfcloud` でインストール可能です。

tfcloud には少しだけ、 CLI 版でしか実行できない機能も存在しています。個人的に推したいのは、 Terraform Cloud workspace の Terraform version をアップグレードする機能です。

Terraform Cloud では各 workspace 個別で Terraaform version を設定する必要があるため、メジャーバージョンアップの際などに数十の workspace を GUI でポチポチと upgrade して回らなくてはならず、かなり骨が折れます。 `tfcloud workspace upgrade` コマンドを実行すれば、カレントディレクトリに紐付いた workspace の Terraform version を CLI からアップグレードできます。

<a href="https://gyazo.com/90b3f9d30a47a74025c9f29a9a14d5c8"><img src="https://i.gyazo.com/90b3f9d30a47a74025c9f29a9a14d5c8.png" alt="Image from Gyazo" width="557"/></a>

このように `-u` オプションでバージョン指定して upgrade もできますし、指定しなければ自動的に最新が当たります。ただし、 `required_version` と整合性がとれないバージョンには上げないようになっています。オススメの使い方は、 `tfcloud workspace list` で各 workspace の Terraform version が一覧できるので、これと併用してバージョンアップを進めることです。

このほかに、 remote backend の記述内容を元にして、 workspace をイチから自動作成するようなコマンドも実装を検討しています。

### Terraform Cloud / Enterprise API

なお、 tfcloud がやっていることは、単純に Terraform Cloud の API を叩いて、結果を整形して出力しているだけです。

Terraform Cloud の API は、 [Terraform Cloud / Enterprise API](https://www.terraform.io/docs/cloud/api/index.html) という形で提供されています。Terraform Enterprise の SaaS 版にあたるのが Terraform Cloud と言えるようで、両者の API は共通しています。 Go による API ライブラリも hashicorp から提供されており、その名も [go-tfe](https://github.com/hashicorp/go-tfe) と、 Enterprise 由来のものになっています。 `tfcloud` もまた、その名に反して Enterprise でも動作するはずですが、筆者は Enterprise の使用経験がないため、試してはいません。

Terraform Cloud / Enterprise API （以下、 tfe API） は GUI におけるほとんどの機能を実装していますが、1点だけ Registry Modules API のみ、以下のようにちょっと癖があります。

* tfe API は Registry Modules API を一部しか実装しておらず、一部は [Registry standard API](https://www.terraform.io/docs/registry/api.html) (public な Terraform Registry の方) を踏襲している。
* 残念ながら `go-tfe` は Registry standard API 踏襲部分については実装がない。
* Registry standard API に対する Go のライブラリは提供されていない。
* tfe API と terraform registry API では、出力フォーマットの JSON 形式が異なる。
* tfe API と terraform registry API では、 API endpoint の URL も異なる。

ということで、 registry 周りの API だけ一部自分で実装する羽目になりました。これについては [issue も上がっています](https://github.com/hashicorp/go-tfe/issues/136)が、 `go-tfe` で対応しないとしても、 Registry standard API 用のライブラリを別途リリースしてほしいところです。

## Conclusion

以上、 Alfred や CLI から Terraform Cloud を操作できるようになるまでを簡単にご紹介しました。アドカレの〆切駆動で開発したので最後はかなりギリギリで作っており、粗もあるかと思いますが、何か気になることがあれば issue や PR をいただけるととても嬉しいです。

ただ CLI を得意とする hashicorp ですので、どこかのタイミングで公式の CLI が出てくれないかな、とはちょっと期待しています。
