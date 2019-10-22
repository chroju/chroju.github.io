+++
title = "GitHub Actions - Dockerfile を突っ込んで自動化するという考え方"
date = 2018-12-15T12:26:04+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

[GitHub Actions](https://blog.github.com/jp/2018-10-24-action-demos/) が Limited Public Beta で使えるようになっていたので触ってみた。[マニュアルはすでにパブリックに公開されている](https://developer.github.com/actions/) ので、使い方的なことは書かずに、触ってみた印象感想中心で少し書きます。

現状では private レポジトリだけで、このように「Actions」タブが現れるようになっている。ここを開くとビジュアルエディターで Actions を設定できるし、テキストエディタで `.github/main.workflow` ファイルを手動で作成しても使える。

<a href="https://gyazo.com/c0edc7d6f195f09b00582021835662de"><img src="https://i.gyazo.com/c0edc7d6f195f09b00582021835662de.png" alt="Image from Gyazo" width="608"/></a>

## docker run を組み合わせてワークフローをつくる

とはいえ CI ツールは Jenkins と CircleCI しか使ったことがないので、自ずとそれらとの比較になってしまうが、あえて挙げれば  CircleCI 2.0 と近いところが多い。CircleCI 2.0 では自動で実行する一連のプロセスを `Job` という単位に分割し、各 Job では指定した Docker コンテナの中でコマンドを実行していく形を取るが、 GitHub Actions も同様に Job に相当する `Action` で分割され、個々の Action に Docker コンテナを紐付ける。

ただし大きく異なる点として、CircleCI における Docker コンテナがあくまでコマンドの実行環境としての扱いであるのに対し、 GitHub Actions では `docker run` の実行 = コマンドの実行、という感覚になる。どういうことかと言うと、各 Action では実行するコマンドを `runs` と `args` という項目で設定できるのだが、これらは `runs` が Docker の `ENTRYPOINT` を、 `args` が `CMD` を override するものとして設定されているものであって、 Docker コンテナ内で実行させるというものではないから。

<a href="https://gyazo.com/5acf3940d83bf721d1d025cd31833861"><img src="https://i.gyazo.com/5acf3940d83bf721d1d025cd31833861.png" alt="Image from Gyazo" width="361"/></a>

つまり、各 Action は `docker run` コマンドを一発実行するだけのものと捉えてよく、コンテナ起動後にその中で何かを実行する、という形を取らない。これは単純に考えれば各 Job で1回しかコマンドの実行機会が与えられないということであり、実行したいコマンドの数だけ Job を作る必要が出てきてしまう。それはさすがにちょっと冗長ではという気もするが、 https://github.com/actions にいくつか公開済みのサンプルを見てもわりとそういう組み方をしている。以下は Dockerfile から image を build して、 AWS の EKS へデプロイするサンプルだが、 Action 数は計10個に及んでいる。

[example-aws/main.workflow at master · actions/example-aws](https://github.com/actions/example-aws/blob/master/.github/main.workflow)

まだユースケースが少ないので、どういう Action の組み方がベストなのかはわからないが、仮に1つの Action で複数のコマンドを実行させたい場合には、スクリプトを作って `ENTRYPOINT` に渡す形になるかと思う。 Action で起動する Docker コンテナは、レポジトリ内の Dockerfile から build させることができる（ちなみに実行の度に逐一 build するので実行時間は速くない。キャッシュしたい）ので、任意のコマンドを複数実行する Dockerfile を作るのは手かもしれない。ただ、個人的にはそういうやり方は求められていなくて、あくまで Docker コンテナの、というべきか、 `docker run` の、というべきか、その組み合わせでワークフローを組むものだと考えている。先に挙げた https://github.com/actions には GitHub Actions で使うための Dockerfile がいくつか GitHub から提供されている。現状は `AWS CLI` を実行できるもの、 `docker` コマンドを扱えるものなど数が限られるが、これが今後増えていき、またユーザーが作成する Dockerfile も集まってくれば、それらを組み合わせて様々なワークフローが作れるはず。

## Trigger できるイベントはかなり豊富

GitHub と連携させて使う CI ツールは多くの場合 `git push` で triggered されるが、 GitHub Actions は GitHub 組み込みなだけあって、 [trigger として扱えるイベント](https://developer.github.com/actions/creating-workflows/workflow-configuration-options/#events-supported-in-workflow-files)が非常に多い。 star を付けられたときにも trigger することができる。

star を付けられたタイミングで test や build を回したいというユースケースもあんまりないと思うし、これは CI ツールよりもっと広く、 GitHub レポジトリで何かしらのイベントが発生したときに、自動実行したいこと全般を管理するための広範なツールとして捉えるべきなんだろうと思う。今までであれば IFTTT や何かしらの bot を使って、例えば star やプルリクが発生したときに slack へ通知させたりしていた人も多いと思うが、これを GitHub Actions を使う形にしてしまえば、外部のツールを使わずにレポジトリ内だけで外部連携関係の管理が完結する。

> 継続的インテグレーションと継続的デリバリー（CI/CD）はActionsのユースケースのほんの一部だ。たしかにその面で役立つが、Actionsはそれ以上のものだ。これはDevOps全体に革命を起こすものだとと思う。なぜならActionsを用いることでこの種のものとして最高のアプリケーション、フレームワークのデプロイメントのサイクルを構築できるからだ。

[GitHubからワークフロー自動化ツール、Actions登場――独自サービス提供の第一弾 | TechCrunch Japan](https://jp.techcrunch.com/2018/10/17/2018-10-16-github-launches-actions-its-workflow-automation-tool/)

slack などに通知するときに必要となる API キーも `secrets` として暗号化した変数で渡すことができる。ただ現状は各レポジトリ間で `secrets` を共有することができないので、レポジトリを切るたびにいちいち設定が必要になり逆に管理が面倒とも言えるかもしれない（bot で通知を制御する場合、bot 内で一括管理ができるはずなので）。他にもまだまだ不足している要素は多く感じる。例えば golang の build を実装しようと思ったとき、 Docker の `WORKSPACE` が現状だと `/github/workspace` というディレクトリに固定されてしまっているので、 `$GOPATH` 内で実行する必要のある `dep ensure` が上手く実行できなくてだいぶ苦労したりした。

ただそういった細かな点さえ解消すれば、結構魅力的なツールになりそうだと感じる。GitHub レポジトリを中心として仕事をする中で自動化したいことがあれば、全部 Dockerfile を書いてレポジトリの中に放り込めばいい、ということになるわけだから。
