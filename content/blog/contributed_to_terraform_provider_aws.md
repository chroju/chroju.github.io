+++
title = "buildersconを契機にOSS活動始めてterraform-provider-awsにcontributeできた"
date = 2018-07-10T21:02:20+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

やったぜ。

<a href="https://gyazo.com/e7f876b113acd42992052cc2c1fafa5f"><img src="https://i.gyazo.com/e7f876b113acd42992052cc2c1fafa5f.png" alt="Image from Gyazo" width="849"/></a>

[Fix the difference between aws_waf_byte_match_set and aws_wafregional_byte_match_set by chroju · Pull Request #5043 · terraform-providers/terraform-provider-aws](https://github.com/terraform-providers/terraform-provider-aws/pull/5043)

Terraform は最近、その本体と各APIを叩く Provider でレポジトリが分離されているんだけど、そのうちの AWS のやつに Contribute した。別にそこまで大した内容の commit でも無いんだけど、なんか嬉しいのでここに至るまでをエントリ起こしておく。

builderscon tokyo 2017 が契機
----

そもそも自分は専門領域インフラなので、プログラミングは本業というわけではなく、まぁそういう言い訳でガッツリプログラミングするような機会からは逃げてたと言えば逃げてきてたし、 OSS 活動はやってみたい思いはあったけどなんか無理だろうなって感じでやらずにいた。 GitHub はもっぱら自分のコードのバックアップ用途というか。

そんな意識を替えた、小さくてもいいからなんか Contribute できないか頑張ってみよっかと思ったのは昨年の [builderscon tokyo 2017](https://builderscon.io/tokyo/2017) で聴いたこの発表だった。

<iframe src="//www.slideshare.net/slideshow/embed_code/key/lQIyp731TQqOoF" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/shigemk2/oss-78585757" title="Oss貢献超入門" target="_blank">Oss貢献超入門</a> </strong> from <strong><a href="https://www.slideshare.net/shigemk2" target="_blank">Michihito Shigemura</a></strong> </div>

コード読まずに GitHub に近づかずに OSS 貢献ができるかって言ったらできないわけで、わかんなくてもいいから取りあえず読むとか、ドキュメントの修正だって貢献は貢献だって話だとか、何かしらやれることからやれたらええやんけの始めの一歩をものすごい勢いで押してくれたスライド。わかんないからとか実力がないからという理由で遠ざけてたら一生かかってもできるわきゃないので、じゃあ取りあえず、もう少し GitHub と仲良くするか、とこの頃から思うようになった。昨今はインフラエンジニアだからコード書きませんってのも無いよねって流れだし、どうにかしたかった。

GitHub と仲良くする
----

手始めに始めたのはこのあたりのこと。

* GitHub で気になったレポジトリにはスターをつけたり Watch したりして動向を追ってみる
* GitHub で気になったエンジニアをフォローしてみる（いまだに誰をフォローしたらいいかよくわかってなくてあんまり出来てはない）
* フォローと Watch による通知はひとり slack に流して継続的に追う
* OSS を使ってて疑問に思う挙動があったら、ググるんじゃなくて docs とソースを読む
* GitHub トレンドを見に行く、メールでのトレンド通知も有効化する

GitHub に触る機会、レポジトリを見に行く機会をとにかく増やしたのと、気になる挙動を自分でソースを追いかけてみることを心がけた。前者については、世の中本当にいろんなもの公開している人がいるなと知るきっかけになって良かったし、知れると自分でも何か作れないかとか考えるようになった。 GitHub トレンドは案外なんと言うのか、 markdown で書かれたドキュメントだけのレポジトリとかが上位に入っていることも多くて、そんなに頻繁には見なくなってしまったけど。とはいえ自分が初めて Pull Request 出してマージしてもらったのも、ドキュメント系のレポジトリではあった。

[Update README-ja.md by chroju · Pull Request #91 · zeeshanu/learn-regex](https://github.com/zeeshanu/learn-regex/pull/91)

正規表現について簡潔に学べるドキュメントで、日本語訳が一部こなれてなかったのと、英語原本の更新に追いついていなかったので更新した、というだけの PR 。コード書いてねーじゃんという感じだが、そういうのにこだわらず、取りあえずまずは GitHub と仲良くしたかったので、ハードルの低いことからやってみた。

コードを書いて Contribute したのは、 terraforming が初めてだと思う。

[Add failover attributes to Route53 record. by chroju · Pull Request #357 · dtan4/terraforming](https://github.com/dtan4/terraforming/pull/357)

Terraform はよく使っているので、既存リソースの terraform 化ができる terraforming もよく使うのだが、このときは Terraform の方の更新に追いついてない部分に使っていて気付いたので PR した。以前なら誰かが更新してくれるのを待つか諦めるかしていたと思うが、 terraforming であれば数多の AWS リソースそれぞれに対して似たようなコードが存在しているようなツールなので、他のリソース向けに書かれたコードを参考にすれば書けそうだなと思い、手をつけた。コード書いてマージしてもらうのは初めてでめちゃくちゃビビってたのだが、あっさり "LGTM" もらえてびっくりした記憶がある。

terraform-provider-aws への Contribute
----

で、その後もいくつか PR 送ったり、それが難しくてもコードに原因がありそうだなという当たりがついたら issue を投げたりしてきた。 influxDB のバグを直してもらえたのが結構嬉しかった。

冒頭に挙げた今回のマージは Terraform の実質本体みたいなところへのマージで、これまでで一番「やったぜ」という感覚があった。 AWS WAF という文字通りマネージドな WAF サービスがあって、これはリージョンを意識しないグローバルな設定とリージョン別の設定に分かれているんだけど、 API もこれに合わせて AWS WAF, AWS WAFRegional の2種類がある。ただ双方で用意されているメソッドやパラメーターはほぼ同じになっているんだけど、 Terraform では一方のパラメーターは複数形の名前で、もう一方が単数形という微妙な差異が一部で見られる状態になっていた。元の API にはそういう差異はなく、混乱の元になりそうだったので PR した。

最初はパラメーターの名前替えるだけなのでそれほど難しくはなかろうと思い、単数形と複数形の差異全部直すで〜という雑な内容を取りあえず WIP の状態で PR を投げたのだが、すぐにレビューで「パラメーターの名前を替える場合は、古い方のパラメーターも Deprecated で残しておかなくてはならない」とか「君はこれ単数形に統一してくれたけど、複数形の方がよくない？」とか言われて、「うわ深く考えずに PR 投げてもーた……レビュー反映して差異全部直したらとんでもない修正量になるやんけ。。。やっぱまずは1箇所だけ直す形に改めるわ申し訳ねぇ🙏💦」という返信をめっちゃ冷や汗かきながら送ることになった。これを温かく受け止めてもらえたので、なんとかマージまで漕ぎつけられた。

そもそも Terraform が書かれている Go を学び始めたのも今年の春先ぐらいだったので、それがまぁパラメーター名の変更という内容ではあれ、この1,2年頻繁に使っていたツールに貢献する形まで辿り着いたのはガッツポーズものであった。

やってみるとなんとかなる
----

去年の8月から、OSS活動と胸を張って言えるほどではないとはいえそこそこ続けてきて、思うのは案外なんとかなるなということであり、去年見たあのスライドの内容はマジで正しかったなということだ。

いまだに英語については自信がないけど、これまで「お前何言ってんだかわからんのだが？？」とは言われたことがないので、なんとか通じているっぽい。 Google 翻訳様様である。 Contribute するにあたり、膨大なソースコードを全行読む必要はなくて、「これを直したいな」というきっかけからまず当たりを付けてソースを読み、その周辺から徐々に全体へ読んでいくことで、動きは掴める。あと Terraform のような大規模な OSS だと Developer Guide が充実しているので、そちらも併せて読むことでだいぶ理解が捗るし、普段使っているツールがどう動いているのかを知る機会にもなるので一石三鳥ぐらいメリットがあった。あと他の PR とか読めば、どんな感じで書けばいいかとか、どんなコミットメッセージがいいかはわかる。

何かやってみたいけど何したらわかんないなというとき、まずは近付いてみるというのがいいんだと思う。近づき、情報を得て考えることを習慣にしていくうちに、だんだんとリズムが掴めてくる。あとは変に自分でハードル作らずに、小さくてもしょっぱくてもいいから PR 出してみれば、思ったよりもすんなりとマージしてもらえたりする。んで Contributor のマークが付くと、それが転職アッピルになりますぜとかそういうの抜きにして純粋に嬉しい。

builderscon は名前の通り「 builder 」のイベントなわけで、そこに行った甲斐あって builder っぽいことをほそぼそとではあるが始められた。[今年](https://builderscon.io/)もめっちゃ楽しみにしてる。


