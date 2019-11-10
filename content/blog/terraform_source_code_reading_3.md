+++
title = "Terraform Source Code Reading#3 に参加した"
date = 2019-11-10T15:11:37+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://terraform-jp.connpass.com/event/150359/" data-iframely-url="//cdn.iframe.ly/L6QnitY"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

先週開催されたこちらのイベントに参加しました。

## 参加の動機

Terraform の AWS provider には何度か commit 経験はあるものの、 Terraform 本体のソースコードや、本体と provider 間のやり取りに関してはあんまり読んだことがなくて、コードリーディングを進めてみたかったというのが1つ。また自分はソフトウェアエンジニア出身ではないので、そもそものコードリーディングのやり方があんまり効率良い感じがしていなくて、他の方々（特に Terraform なのでインフラ寄りの方が多そうだし）がどんな感じで読んでいるのか知りたかったのが1つという感じです。

ソースコード読んでコントリビュートもしている人が参加する勉強会となるとそれなりに強い人がいっぱいいそうでだいぶドキドキしてました。

## 当日の流れ

当時は20人に少し足りないぐらいの人数が参加してましたが、全員で1つのことをやるのではなく、読みたいソースコードごとにグループ分けがありました。具体的には Terraform 本体を読むグループ、 AWS provider を読むグループが2つ、その他の provider を読むグループが1つの計4グループ。私はと言えば AWS provider を読んでました（あれ？）。

で、特に当日は決められた筋書きはなし。各グループで集まった人同士でやりたいことを話し合って決めて、それぞれで進めていき、最後に全員で一言ずつ成果報告をするという形でした。

## やったこと

私のグループでは issue を漁ってプルリクエストを送れそうなものがあったら送ってみようという形で進めました。4人グループで、 contribute 経験者が私含めて2人、他2人はこれからやってみたい、という感じでした。

### contribute チャンスをどう見つけるか

しかし正直結構難しい。例えば OSS contribute を志し始めた人へのアドバイスとして `good first issue` ラベルが付いたものが取り組みやすい、というものがありますが、[今日時点で2299件中17件しかありません。](https://github.com/terraform-providers/terraform-provider-aws/labels/good%20first%20issue) もちろん絶対数で見ればそれなりの数がありますけど、比率で言うと1%未満だし、年単位で塩漬けにされている issue も多くて必ずしも手を付けやすいものではないかなという印象がありました。

当日1つ、 Pull Request のきっかけとして有力な方法かもしれないと見つけたのが、 [aws-sdk-go の release](https://github.com/aws/aws-sdk-go/releases) を定期的に見ること。これがなかなかエゲツない頻度で更新されていて、 API が更新されれば Terraform 側にもそれを吸収しなくてはならない場合というのが当然出てきます。なので aws-sdk-go 側の更新を見張っていれば contribute チャンスも見えてくるのではないかと。

あとは自分の経験上ですけど、ドキュメントに小さな誤字があることは案外多いのでチャンスも転がってますよという話をしました。実際、当日ドキュメント修正で時間内にプルリクエストを上げられた方がいました。

Terraform のコードはとにかく膨大なので、なかなか contribute するぞ！という目的で挑んでも難しい部分がある気がしました。自分のこれまでを振り返ってもバグを踏んでから contribute に至ったのがほとんどです。

### validators.go に関する知見

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/terraform-providers/terraform-provider-aws/issues/9445" data-iframely-url="//cdn.iframe.ly/vTwY8Q0"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

これは個人的な話ですが、以前上記 issue にハマったことがありました。 `aws_route` resource には、ルーティング先に各種ゲートウェイを指定する `nat_gateway_id` や `transit_gateway_id` といった argument があります。本来であればゲートウェイの種類ごとに異なる argument を遣うべきところ、 `gateway_id` という argument が NAT ゲートウェイとインターネットゲートウェイのどっちも受け付けちゃうんですね。なので値のバリデーションをして、 NAT ゲートウェイは受け付けないようにするべきというのがこの issue です。

この issue 、私はバリデーションの実装方法に迷ったのと、すでに author が自分でやると言っていたので放っておいてました。しかし今回の勉強会でこの話をしたところ、 [validators.go](https://github.com/terraform-providers/terraform-provider-aws/blob/master/aws/validators.go) というファイルがあり、ここにバリデーション処理が集約されていると教えてもらいました。自分で気付けていなかったことを知ることができてとても有意義な経験でした。

これでプルリクも出せるようになったし、先の「俺がやる」と言ってる人も数か月放置してるから、もうこっちで出しちゃってもいいかなと思ってます。

## 感想

みんなで議論をするような形を想像していたところ、もくもく会に近い雰囲気だったのでちょっと想像とは違いました。が、具体的にコードを踏まえた話が出来たのは楽しかったです。 Terraform ユーザーグループはこの Code Reading と meetup を交互に繰り返す形ですが、いずれもただ前に出た人が発表するのではなく、参加者同士話す場を中心にしているのがとてもいいなと思いました。

ただグループ分けに関してはレベル別とか目的別とかでもいいんじゃないかなーという気はしました。読む対象レポジトリごとのグループ分けだと、メンバー間の意識や目的をなかなか揃えにくく、どうしようかと悩む、迷う時間が少なくなかったです。あるいは個々人で目的を持って読んでいくもくもく会的な感じですよ、と言い切ってしまうか、かなと。

ちなみに読んだだけで終わるのもアレだったので、後日ですが issue 1個解決を図ってみました。定期的に issue を覗いてやれそうなものにチャレンジしていくのも勉強としては良さそうです。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/terraform-providers/terraform-provider-aws/pull/10819" data-iframely-url="//cdn.iframe.ly/X4pbFvR"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>
