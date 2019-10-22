+++
title = "『入門 監視』を『ウェブオペレーション』『SRE』と一緒に読もう"
date = 2019-01-31T22:31:19+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873118646/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/41Jlj3e0CDL._SL160_.jpg" alt="入門 監視 ―モダンなモニタリングのためのデザインパターン" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873118646/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">入門 監視 ―モダンなモニタリングのためのデザインパターン</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 19.01.31</div></div><div class="amazlet-detail">Mike Julian <br />オライリージャパン <br />売り上げランキング: 463<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873118646/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

監視という、この業界に携わっていれば誰でも関係したことがあるだろう分野について、まとまった本がこれまでなかったというのは感じていて、一度「監視概論」みたいなエントリーをまとめてみたいと考えていたこともあったのですが、オライリーに先を越されました（何様）。タイトルのインパクトがすごいです。

ただ、「監視オンリー」でまとまった本は確かに思い浮かばないものの、この分野に言及した本が一切なかったというわけではなくて、これまでですと自分は『ウェブオペレーション』と『SRE サイトリライアビリティエンジニアリング』を監視設計の上では参考にしていました。改めて本書と並行して今回この2冊もさらってみたのですが、合わせ技のように使うととてもいいのではないかなぁと思っています。

## 入門 監視

文字通り「監視」という行為自体にフォーカスしきった本という印象を受けました。1章でまずアンチパターンを挙げて、それを踏まえて2章でデザインパターンを解説する。3章では監視した結果をどう扱うのかに関わる、アラート、オンコール、インシデント管理のプロセスに触れて、4章は付随する分野である「統計」の話、5章以降が実際の監視対象別のプラクティスをまとめた各論、という感じです。まずは3章までが大前提なのでとても重要で、5章以降は実際に自分が監視するシステムの構成などに併せて参照すればいい気がしました。ネットワーク機器を監視する上での SNMP への恨みつらみが書かれた9章など、自分としてはめちゃくちゃ頷きながら読みましたが、クラウドファーストな昨今、ネットワーク機器とは無縁な人も多いでしょう。4章の「統計」もとても重要ですが、少し付随的な内容かな、という印象です。

とても名言が多い本で、世の中でなんとなく採用されてきたセオリーっぽいプラクティスを、きちんと理由を裏付けた上でバッサリ切ったりしてくれます。Linux 動かしてるとなんとなく CPU とメモリの使用率と各種 IO で閾値を設けがちですが、必ずしも必要ではないと言ってくれています。これすごいわかる。

> 動かすサービスによっては、元々リソースをたくさん使うものもありますが、それで問題ないのです。 MySQL が継続的に CPU 全部を使っていたとしても、レスポンスタイムが許容範囲に収まっていれば何も問題はありません。これこそが、CPUやメモリ使用率のような低レベルなメトリクスではなく、「動いているか」を基準にアラートを送ることが有益である理由です。

低レベルの監視が情報をもたらしてくれることももちろんありますが、無計画に閾値を仕掛けると、往々にして狼少年にしかならないです。この本では一貫してユーザーに近い側、ビジネス的に必要なサービスレベルを維持できているかという視点で監視をするべきだと訴えています。

他にも監視の設定は100％自動化するべきだとか、Ops以外も含めてチーム全員監視を扱えるスキルを持つべきだとか、昨今有効とされている話を明確に書いてくれています。それだけに我が身を振り返って胸が痛くなる部分も多いです。小説を読んでいて「心がつらい」ことを理由に一度本を閉じる、ということが稀によくあるのですが、技術書でそうなったのは初めてでした。

## ウェブオペレーションとSRE

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873114934/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/51-ThZ6FRfL._SL160_.jpg" alt="ウェブオペレーション ―サイト運用管理の実践テクニック (THEORY/IN/PRACTICE)" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873114934/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">ウェブオペレーション ―サイト運用管理の実践テクニック (THEORY/IN/PRACTICE)</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 19.01.31</div></div><div class="amazlet-detail"><br />オライリージャパン <br />売り上げランキング: 140,197<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873114934/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873117917/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/51Ybz%2B6kIsL._SL160_.jpg" alt="SRE サイトリライアビリティエンジニアリング ―Googleの信頼性を支えるエンジニアリングチーム" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873117917/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">SRE サイトリライアビリティエンジニアリング ―Googleの信頼性を支えるエンジニアリングチーム</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 19.01.31</div></div><div class="amazlet-detail"><br />オライリージャパン <br />売り上げランキング: 23,351<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873117917/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

一方の『ウェブオペレーション』ですが、『入門 監視』より7年前の本であるものの、重なる記載も少なくありません。例えば「自動的に新しいノードやメトリクスを発見する」べきであるとされていたり。

こちらは表題通り「オペレーション」の本なので、あくまでシステム運用をする中で必要となる一要素としての監視、として書かれている面が強いです。『入門 監視』の3章をもっと精緻にしたイメージでしょうか。例えば各コンポーネントの監視を検討する前に、技術的コンポーネントの依存関係を把握する必要があると言及されていたりします。一例としてDNSサーバーが落ちたら、いくらシステム自体は正常でもユーザーはアクセスできないよね、とか。また『入門 監視』と同様、ビジネス的なインパクトの面、つまりサービスが実際使えているかどうかという観点で監視をするべきだとしていますが、その観点についてはより詳細に分類して示しています。

> 確認には5つのレベルがある。可用性（存在しているか）・機能性（動いているか）・品質（うまく動いているか）・状況（あらゆる要件を満たしているか）・信頼性（信頼できるか）だ。

SRE本にも似たことが言えて、こちらは監視自体の言及は第10章ぐらいしかないものの、オンコール対応、SLA、ポストモーテムという、監視を取り巻くプロセスの扱い方については非常に手厚いです。SLAをきちんと設定して、その前提から考えよう、というのは、先の2冊と共通する「ユーザー視点での監視」に繋がる話で、やっぱりどれも同様の思想で書かれている本だな、と感じます。

ウェブオペレーションを生業としている身からすると、システム監視はやはり、あくまでシステム運用の一要素です。ですので監視だけを独立して考えることはあまりなく、全体的な運用プロセスの中に如何にして位置づけるかということをよく考えます。如何に小さなコストで間違いなく的確な監視を行うか、という。そういう観点ではやはり、SRE本や『ウェブオペレーション』に掲載されているようなマクロな観点が不可欠で、一方で『入門 監視』は、実際何をどのように監視すればいいのかという、ミクロな観点で指針を示してくれるように感じました。

