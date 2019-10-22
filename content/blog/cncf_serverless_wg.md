+++
title = "CNCF の活動から Serverless の今を追う"
date = 2018-12-05T00:10:00+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

この記事は [Serverless Advent Calendar 2018 - Qiita](https://qiita.com/advent-calendar/2018/serverless) の5日目です。最初に断りですが、すみません具体的実装などの話は用意できませんでした。

AWS Lambda あたりを発火点として広がってきたサーバーレスの動きも、近年では他のクラウドサービスは当然として、特定クラウドにロックインされない OpenFaaS のようなプロダクトが出てきたりなど、多岐に渡ってきた印象があります。それに伴って全体像と言えるようなものがなかなか捉えづらくなってきて、何か良い追い方はないかと探していたところ、見つけたのが CNCF の Serverless WG (Working Group) でした。

[cncf/wg-serverless: CNCF Serverless WG](https://github.com/cncf/wg-serverless)

CNCF ではクラウドネイティブな特定技術分野に関するワーキンググループをいくつか設けており、そのうちの1つが Serverless WG です。これまでの成果は上記の GitHub レポジトリで公開されていますが、主なところでは以下の2点が挙げられています。

## A Serverless Overview Whitepaper

[wg-serverless/cncf_serverless_whitepaper_v1.0.pdf at master · cncf/wg-serverless](https://github.com/cncf/wg-serverless/blob/master/whitepapers/serverless-overview/cncf_serverless_whitepaper_v1.0.pdf)

2018年2月に公開された、Serverless を取り巻く当時の状況や、ユースケースなどについて解説したホワイトペーパーです。非常に内容が多いですが、すでに @IT などで翻訳や解説も公開されており、読み進める上でとても助かりました。

* [サーバレスコンピューティングとは何か、その典型的ユースケースとは (1/4)：【完訳】CNCF Serverless Whitepaper v1.0（1） - ＠IT](http://www.atmarkit.co.jp/ait/articles/1802/28/news027.html)
* [CNCF Serverless Whitepaper v1.0 の重要部分の抜粋と雑感 - GS2 Blog](http://gs2.hatenablog.com/entry/2018/02/16/114739)

## Landscape

[CNCF Cloud Native Interactive Landscape](https://landscape.cncf.io/grouping=landscape&landscape=serverless)

個人的に最近よく参照しているのがこちらの Landscape です。主な Serverless 技術を「Hosted Platform」「Installable Platform」「Framework」「Tools」「Security」の5種類に区分してマッピングしたもので、 Serverless の現況をざっと概観するのにちょうどいい資料になっています。なお補足しておくと、これは Cloud Native Landscape というさらに広い Landscape の一部という扱いになっています。

実際に資料を見ると、あまり国内では耳にしないサービス、プロダクトも数多くあります。例えば「Platform」には AWS Lambda, Azure Function, netlify といったお馴染みのクラウドサービスや、 "Installable" な OpenFaaS や Kubeless などが並んでいますが、ここに連なっている Huawei Function Stage にはなかなかピンと来なかったりします。知らないものをたまに拾っては少し触ったり調べたりしてます。

### example: Dashbird

一例として、最近ここで見つけて使ってみたサービスに [Dashbird](https://dashbird.io/) があります。 AWS X-Ray や CloudWatch と連携して、 Lambda や API Gateway の見やすいダッシュボードを作ってくれるシンプルなサービスです。

<a href="https://gyazo.com/c20fabd4ac3f332c32b8d3732a80ec37"><img src="https://i.gyazo.com/c20fabd4ac3f332c32b8d3732a80ec37.png" alt="Image from Gyazo" width="2856"/></a>

Lambda Function の一覧画面にはリージョンを問わずすべての Function が掲載され、24時間以内の実行状態が確認できます。

<a href="https://gyazo.com/a1f00d750221985c552d870baaf1adc5"><img src="https://i.gyazo.com/a1f00d750221985c552d870baaf1adc5.png" alt="Image from Gyazo" width="1513"/></a>

個々の Lambda Function の詳細では実行時間やメモリ使用率のグラフ、また直近実行履歴において、それが cold start だったかどうかといった点まで一覧できて、結構使い勝手が良さそうだと感じています。ほかにも特定の Function を指定して、 tail コマンドのようにリアルタイムで実行ログを追う機能があったり、 slack へのアラート機能もあったり、およそダッシュボードに求められる機能はそれなりに揃っている印象です。カスタマイズ性は高くないものの、 Lambda を駆使して作った環境をサクッと監視したいときに使うにはアリかなと思っています。

## 仕様の検討

サーバーレスコンピューティングにベンダーロックインという問題は付き物のように思われていますが、 Serverless WG ではこれを解消する一助となる、共通仕様の検討も行われています。現状形になってきているものとしては、サーバーレスなりソースがやり取りする「イベント」の記述形式を共通化する CloudEvents が上げられます。

[cloudevents/spec: CloudEvents Specification](https://github.com/cloudevents/spec)

他にも [Proposals](https://github.com/cncf/wg-serverless/blob/master/proposals/README.md) によれば、 Wokrflows や Event Orchestration といった、いくつかのテーマが審議対象として挙げられているようです。

個人的には、ベンダーロックインを必ずしも忌避すべきものとしては捉えていません。というのも、特に AWS Lambda を使っていて感じていることですが、あれは単なるミニマムなコード片の実行サービスとして重宝されているわけではなく、AWS 内に様々存在するマネージドサービス間を相互に繋ぐ簡易かつ信頼性の高い手段として価値があると認識していて、いわば「ロックインされていることに意味がある」からです。DynamoDB と API Gateway と Cognito と連携してバリバリ動いている Lambda Function に、ベンダーレスな可搬性が必要かと言うと、あんまり要らないんじゃないかなと思っています。

とはいえマルチクラウドに対応する機会も多くなってきましたし、群雄割拠状態のサーバーレスコンピューティングに、ベンダー間共通の仕様が出来ることは、開発スピードを上げる意味でも、アーキテクチャの可能性を広げる意味でも意義があることだと思います。ぶっちゃけ CloudEvents の定義に沿って記述されたイベントを webhook で投げ合うぐらいがシンプルで使いやすいよなとも思ったりはしてます。CNCF が今後どのような Specification を策定していくのか、またそれが具体的にどう実装されていくかは注目したいところです。

## Conclusion

以上、ざっくり見てみましたが CNCF Serverless WG が公開している情報から、特定のクラウドサービスに依存せず、広くサーバーレスコンピューティングの在り方を追っていけるのではないかなと考えています。今後も継続的に追いかけていく予定です。
