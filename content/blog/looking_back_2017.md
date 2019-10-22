+++
title = "2017年総括 - 計算機科学と向き合う"
date = 2017-12-29T21:43:07+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

停滞
----

今年は停滞していたというか、新しいことにあまり手を出さなかったように思う。

仕事を振り返ると、昨年末から今年の初め頃にだいぶテンション下がる出来事があって、しかもその後その状況を尻拭いしなくてはならなくなったりして、上半期はかなり長いことメンタルがアレだった。その頃やっていたのは、状況改善のために様々なOSSを導入したり、業務フローを改善するためのツールを書いたりすることで、生産的は生産的だったのかもしれないけど、なんだか不本意だなという思いがずっと強かった。扱ってたのはこのあたり。

* Amazon ECS (ECS CLI)
* Terraform
* influxDB
* Grafana
* Apex

なんだかツールを使う、取り入れるというところに注力してしまって、あんまり自分で手を動かして何か書くとか、自分自身が持っている技術に依存した仕事ができなかったなという気持ちが強い。メンタルがアレになった時期が長かったことで、インプットが停滞した感じもあって、どうもよろしくなかった。

計算機科学と向き合う
----

でも別に本当に何もしてなかったかというと、実際には何かしらはもちろんやっていた。あるPython製のCLIツールを社内用に作る機会があり、結構規模が大きかったので、これを期にと思い『オブジェクト指向設計実践ガイド』を読み、オブジェクト指向で書くとはどういうことなのか学び直したりもした。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/477418361X/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/51-TCt0H4UL._SL160_.jpg" alt="オブジェクト指向設計実践ガイド ~Rubyでわかる 進化しつづける柔軟なアプリケーションの育て方" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/477418361X/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">オブジェクト指向設計実践ガイド ~Rubyでわかる 進化しつづける柔軟なアプリケーションの育て方</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 17.12.29</div></div><div class="amazlet-detail">Sandi Metz <br />技術評論社 <br />売り上げランキング: 10,225<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/477418361X/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

自分はコンピュータ・サイエンスの学位を持っていなくて、独学と仕事での知識が中心になっているので、体系だった計算機科学の知識を持たないことはずっと気にかかっている。プログラムをどう書くと上手い感じになるのか、という点についてもそうで、特にこの点に関しては、プログラマーではない（職歴はインフラエンジニアとops方面のみ）故に弱いなと感じていた。オブジェクト指向の概念は知っていたが、この本を読んで初めて具体的な設計に落とし込めるようになった気がする。この本は本当に読んでよかった。

他にも、これはたまたまなのか、今年渋川よしきさんの著書で『[Goならわかるシステムプログラミング](https://www.amazon.co.jp/dp/4908686033/)』と『[Real World HTTP](https://www.amazon.co.jp/dp/4873118042/)』を買った。いずれもCSの基礎に近い内容を丁寧に追えるよな内容になっていて、まだ読み切れてはいないけど、しっかり力を付けたいと思う。

あと、友人が30歳近くになって大学院に進み、アカデミックの方向を目指し始めたというのにも影響されて、やっぱり学位はどこかで取っておきたい気持ちが強くなった。今年が「ツールを使う」年だった中で、そうじゃなくて作る側、技術を持った側に深く進みたいなと思い始めた。

GitHubと仲良くする
----

これは今度別のエントリーで詳しく書くつもりだけど、今年は少しGitHubとも仲良くできた。具体的には、OSSへプルリクを送ってマージしてもらう経験を初めてした。

対象は業務でも使っていたOSSなんだけど、会社では自分のGitHubアカウントを使ったりはできないので、プライベートの時間を使って開発した。なので社内の誰も知らないけど、自分が書いたコードが今社内の業務に使われていることになっていて、それはシンプルに嬉しい経験だった。

でもなかなかプルリク、出せるものでもなかったりして、来年はもっと仲良くしたい。やっぱりこれは別エントリーで書く。

インフラエンジニアは死ななかった
----

今年は『[SRE サイトリライアビリティエンジニアリング](https://www.amazon.co.jp/dp/4873117917/)』や『[Infrastructure as Code](https://www.amazon.co.jp/dp/4873117968/)』の刊行があって、インフラエンジニアが今後どうすべきかというロールモデルが示されたように感じている。

結果としてインフラエンジニアは死ななかった。というか、求められるのがコードを書いて環境全体をオーケストレートしたり、モニタリングやオペレーションを円滑化するミドルウェアを作ったりというところに変化してきていて、低レイヤーに対するより深い知識が求められるようになった。

DockerやAnsibleといった最近のインフラ周りのツール、あるいはこのエントリーの冒頭に挙げたようなツールは、使おうと思えば誰でも使える。でも、それをより効果的に使うためには、AnsibleにしたってDRYに書く必要があるとか、そういうソフトウェア開発のノウハウが必要になってくる。今年は「使う」年になってしまったけど、来年はより深く「知る」「作る」年にしたい。インプットとアウトプットのスピードを高めるのと、もうとにかくなんでもいいからコードを書いていく。数が大事。
