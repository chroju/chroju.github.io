+++
date = "2016-06-05T23:46:12+09:00"
description = ""
title = "Serverlessの時代とas code"

+++

先週[Ansible Meetup in Tokyo 2016.06](http://ansible-users.connpass.com/event/31222/)と、[AWS Summit Tokyo 2016](http://www.awssummit.tokyo/)に行ってきたので軽めのレポートにします。

## AWS Summit

AWS Summitは初参加でしたが、会場を見渡したときのスーツ率の高さからいわゆるEnterprise系のイベントに近いのかと思いきや、DevConの方を中心にテクニカルな話題も多めで楽しめました。とはいえAWSサービス紹介にとどまるセッションや、タイトル通りの内容ではなく、各企業の内部事情を抽象的に話すだけで終わるようなセッションも少なくなく、セッションの選択はそれなりにコツがいるなとも思ったのですが。。

自分が受けたセッションで特に多く話されていたのは、Serverlessの話とDevOps、具体的にはCI/CDの話。いずれも要はこれまで複雑に運用していたシステムが、AWSのマネージドサービスを使うことで簡単に実現できるという話なのですが、特にServerlessに力を入れてる感じがしました。Lambdaの話がすごく多い。先日Serverless confで「サーバーを叩き割る」というパフォーマンスで話題になった、AWSのTim Wagnerも来てましたしね。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="en" dir="ltr">This is how you go <a href="https://twitter.com/hashtag/serverless?src=hash">#serverless</a> – @timalleneagner <a href="https://t.co/SpllWVz76u">pic.twitter.com/SpllWVz76u</a></p>&mdash; Lars Trieloff (@trieloff) <a href="https://twitter.com/trieloff/status/735839549729996800">2016年5月26日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Lambda、簡単なジョブや解析処理であればEC2立てずとも実行が可能になるわけで、いわゆるアプリケーションが担っていた仕事、これまでサーバーを立てなければならなかった部分がごっそり持っていかれることになる。Lambda自体は発表が2014年なのでそれなりに経っているけれど、Pythonに対応したあたりから実用される動きが大きくなってきたような感触があります。とはいえLambdaだけですべて済むというわけでもなく、例えばそのエンドポイントとしてAPI Gatewayが使えたり、SNSと連携してメッセージのプッシュを行ったりと、これまで連綿と作られてきたAWS各サービスがあって、それらを繋げる部分に位置することで真価を発揮している。そう考えるとLambdaが単体ですごいというより、AWS全体を見回したときに足りなかった1ピースを埋めてくれたような印象がある。

## Ansible

そこに来てAnsible、というのはどういう位置付けになるのか。Ansibleの役割はServerlessとは対極、基本的にはサーバーの設定管理というところになります。仮にシステムをServerlessに置き換えていくのだとしたら、ひょっとしたら徐々に要らなくなってくるツールなのかもと思ったり。無論、AnsibleにもAWSモジュールがあるけれど、端々まで対応しているというわけではなく、AWSの設定を管理するのであればCloudFormationやTerraformを使う方が現実的かなという気がします（AWS Summit内で、CloudFormationにLambdaや周辺サービスの設定を書いて、サーバーレスのマイクロサービスをパッケージングする手法が紹介されてました。Lambdaのコードもそのjsonの中に含むので「つらそう」という声は多かったですが）

[Cloud Modules — Ansible Documentation](http://docs.ansible.com/ansible/list_of_cloud_modules.html)v

まぁ、とはいえ現状を鑑みてサーバーが一切なくなるというのはまずないとも思います。AWS Summitでの趣旨も別にサーバー全廃しろよと言ってるわけではなくて、Lambdaに肩代わりさせることでコストダウンしたり効率化が図れる部分が大きいよという点。だからポイントとしてはAWSのマネージドサービスを上手く使えないかというのが設計上第一に来て、困難な部分はEC2（やオンプレのサーバー）を使用するという発想の転換にあるのかと。

そしていずれにせよas codeであることが求められる。AWS上のマネージドサービスはもはや「インフラ」という言葉で括るにはふさわしくないように思いますが、システムおあらゆるレイヤーをcodeで管理し、アプリケーションと同じCI/CDのサイクルに載せてDevOpsで回していくことはもはや必須になる。そこで使うツールには選択の余地があって、Ansibleでもある程度AWSレイヤーをまかなえたりするし、一方でマネージドサービスはTerraformなどを使う方法もある。そのあたりの匙加減が難しい。

さらに言えば、まだツールが充実しきったとも言えない気がするんですよね。GitHubへのcommitをトリガーとしてサーバーの設定変更まで行うような、インフラCIの手法はまだ確立しきったとは言い難い（そういえばCodePipelineにOpsWorksが対応しましたね）し、Serverspecのようなインフラテストツールもより広がる必要がある。インフラの考え方はここ数年どんどん変化してますけど、まだまだ本格的な動きはこれからなんじゃないかという気がしています。

