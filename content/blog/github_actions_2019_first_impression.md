+++
title = "GitHub Actions (2019) ファーストインプレッション"
date = 2019-10-30T22:52:38+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

GitHub Actions が新しくなって2か月ほど経つが、遅ればせながらいろいろと触ってみたのでインプレッションを書き留めておく。

まず最初に断っておくと、2019年8月に発表された GitHub Actions をこのエントリーでは「新版」、それ以前のものは「旧版」と表記する。タイトルも「新版」にしようかと思ったが、今後またリニューアルされた場合にどれが「新」なのかわからなくなるので「(2019)」とした。GitHub は新版に対して「GitHub Actions v2」とか、何かしら旧版と識別できる名称を付けるべきだったと思う。ググラビリティが著しく低くてわりと困っている。

Actions を書いたのは以下の2レポジトリ。前者はこのブログを支える hugo の自動化で、 `source` ブランチに `push` するとビルド結果を `master` へ `push` してくれる。後者は Go の一般的なビルドで、タグを切るとテストしてビルドしてバイナリを GitHub Release に貼ってくれる。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/chroju/chroju.github.io" data-iframely-url="//cdn.iframe.ly/3Dsuyap"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/chroju/parade" data-iframely-url="//cdn.iframe.ly/v9brQHK"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

## 何が変わったのか

GitHub Actions 旧版については昨年末に公開されて早々に触り、このブログにも感想を書いている。

* 関連 : [GitHub Actions - Dockerfile を突っ込んで自動化するという考え方 · the world as code](https://chroju.github.io/blog/2018/12/15/github_actions_first_impression/)

当時との差異として強く感じるのは2点ある。1つ目は記述言語自体変わったことで、 HCL から YAML に変わった。そもそも HCL は HashiCorp Configuration Language という名前通り、 もともと Terraform などの HashiCorp 製ツールの中だけで使われていた DSL なので、 HashiCorp と関わりの薄い GitHub がなぜ HCL を採用したのかが疑問だったし、これでよかったのではないかという気がしている。

2つ目は Action の実行環境。先のエントリーでも書いたが、GitHub Actions 旧版は一連のプロセスが Action という単位に分割され、 実行環境は各 Action で Docker コンテナが個別に起動されていくという形を取っていた。一方の新版では、 Linux / macOS / Windows の中から選んだ VM をワークフロー全体を通した実行環境として利用する。各 Action において旧版同様に Docker コンテナを立ち上げることもできるが必須ではなく、 VM 上で直にコマンドを実行させることもできる。これにより、ちょっとしたコマンドを実行したいときでさえ Dockerfile を書かなくてはならないというようなことは無くなったので、設定の柔軟性が高くなったと感じる。またワークフロー全体で1つの実行環境を共有するようになったことで、ソースを checkout してビルド、テストしてデプロイするという流れを組む、一般的な CI/CD 相当の Action を書きやすくなった。

もともと GitHub Actions は「CI/CD だけではなくて、 DevOps 全体における自動化サイクルを構築するもの」とされていた。先のエントリー内でもリンクした [GitHubからワークフロー自動化ツール、Actions登場――独自サービス提供の第一弾 | TechCrunch Japan](https://jp.techcrunch.com/2018/10/17/2018-10-16-github-launches-actions-its-workflow-automation-tool/) を読むとよくわかる。

> 誰かがリポジトリで「緊急」というタグを使った場合、[Twilio](https://twilio.kddi-web.com/availability/) を使ってメッセージを送信するという仕組みを作ることができる。レポジトリを検索する一行のコードを書いてgrepコマンドで実行することもできる。

つまり、レポジトリに直接紐付けられた FaaS に近いものを作ろうとしていたように見える。しかし実際のところユーザーが旧版でやろうとしたことの多くは CI/CD の範囲であり、今回の新版では、 CI/CD に軸足を置いた旨が明確に示されている。 

<div class="iframely-embed"><div class="iframely-responsive" style="padding-bottom: 66.5%; padding-top: 120px;"><a href="https://cloud.watch.impress.co.jp/docs/news/1205405.html" data-iframely-url="//cdn.iframe.ly/XRWDJwi"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

## Impression

自分のレポジトリ2つほどで使ってみた経験から感じたことを書こうと思うが、本職プログラマーではないためゴリゴリに重いビルドの CI で苦労した経験などが少なく、書けることは限定的だと思う、と前置きする。

### CI を始めるのに必要なことが YAML を書くことしかない

YAML を書いて push すればそれだけでジョブが始まるのは体験としてすごく楽。 Circle CI にせよ AWS の開発者向けツールにせよ、何かしら GUI 操作は避けられなかったが、 GitHub Actions は完全に YAML だけで済む。 `GITHUB_TOKEN` という環境変数が自動的に発行されるので、自レポジトリへの操作も簡単にでき、タグを切る、 release にバイナリを添付するといった、 GitHub 上でやりたかった操作はだいたいすぐに出来るようになる。

### Action を共有できる

ワークフローを組み立てる個々の Action は Docker コンテナか JavaScript で書くことができる。 Docker の Action は Dockerfile とその中で実行する処理内容を書いた `entrypoint.sh` 、 GitHub Actions 向けのメタ情報を書いた yaml から成るのだが、これを GitHub レポジトリで公開して、他者と共有することができる。 Circle CI の Orbs に近い。

すでに GitHub が公開する Action が https://github.com/actions にいくつか設けられており、これらは例えば Go や node.js といった言語環境構築といった、広く使われうるものが準備されている。その他 OSS などが Action を公開している場合ももちろんあって、例えば GitHub Release に Go のバイナリを添付してくれる goreleaser という CI で絶対使いたい超便利ツールがあるが、すでに Action を公開しており、簡単に導入できる。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/marketplace/actions/goreleaser-action" data-iframely-url="//cdn.iframe.ly/ETQo0Jh"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

### Trigger が豊富

旧版の頃からそうだったけど、 Trigger が豊富なのがいい。 Git のプルリクエストや `push` をトリガーにする場合に、特定のファイルが変更されたのみトリガーさせることができるとか最高（インフラマンなので、インフラ用レポジトリに Ansible と Terraform 両方詰め込んでたりがあるあるなので、ディレクトリ単位で実行振り分けしたいことは多い）。

あと使い道は思いついていないが cron で定期実行できるのも興味深かった。 CI / CD を時間トリガーで実行したいケースはあまり無かろうと思うので、どちらかといえば先述のように旧版から希求していた「DevOps全体における自動化サイクルを構築する」ためのものだろうか。例えば issue の自動的なチェックだとか、レポジトリに関係する自動化タスクはここに定義しておくと見通しが良くなりそうではある。

長々と書いたけど個人的には楽、とにかく管理が楽というそれに尽きる。最近特に AWS Code 3兄弟をガチャガチャする機会が多くて Terraform 書いたり GUI ポチポチしたりというのに疲弊していたので、余計に「YAML 置けば OK」というのが魅力的に見えてるのだとは思う。もちろん他のツールのほうが利がある部分もあるわけだが、積極的に使っていきたいなとは感じている。

