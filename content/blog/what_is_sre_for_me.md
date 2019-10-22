+++
title = "SRE になって3か月目に考える、 SRE とは何か、如何に実践すべきか"
date = 2019-09-18T23:22:43+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

[パラレルワーカー兼大学生になることになった · the world as code](https://chroju.github.io/blog/2019/06/14/become_parallel_worker_and_university_student/) というエントリーで SRE の立場でやっていくということを書いて、実際働き始めて3か月近くが経過した。インフラ系の運用専門のエンジニアから SRE という立場に変わって実際のところ何が変わったのか、今後何をするべきなのかということを、ここで改めてまとめておきたい。

## 改めて SRE を定義する

SRE の職種で転職活動をしていたとき、カジュアル面接で「SREとはなんだと思うか？」と聞かれたことがあった。そのときには「ソフトウェアエンジニアリングを用いてシステム運用を行うこと」と応えているが、今から考えると「半分正解」ぐらいの応えだったように思っている。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873117917/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/51Ybz%2B6kIsL._SL160_.jpg" alt="SRE サイトリライアビリティエンジニアリング ―Googleの信頼性を支えるエンジニアリングチーム" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873117917/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">SRE サイトリライアビリティエンジニアリング ―Googleの信頼性を支えるエンジニアリングチーム</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 19.09.21</div></div><div class="amazlet-detail"><br />オライリージャパン <br />売り上げランキング: 79,446<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873117917/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

定義は原典から引くべきだと思うので、『SRE book』を確認してみると、第1章にまずこのように書かれている。

> SREとは、ソフトウェアエンジニアに運用チームの設計を依頼したときにできあがるものです。

> SREは、これまで運用チームが行ってきたことをソフトウェアの専門性を持つエンジニアが行い、エンジニアが人手による管理を自動化するソフトウェアを設計し実装する能力を持ち、それをいとわないということから成り立っています。

やはり運用とソフトウェアエンジニアリングを結びつける内容が書かれていて、先に挙げた私の回答が間違っているわけではない。「半分正解」と書いたのは、それではなぜソフトウェアエンジニアリングを運用業務に持ち込まなくてはならないのか、という部分まで押さえていなかったからだ。

> 常にエンジニアリングを行っていなければ、運用にまつわる負荷が増大し続け、負荷についていくためだけでもチームにはさらに多くの人数が必要になります。最終的には、運用に注力する旧来のグループは、サービスのサイズに比例して大きくなってしまいます。

つまり、サービスの拡大に比例して増大していく運用負荷を抑えるという目的に対して、ソフトウェアエンジニアリングによるレバレッジを利かせることによって対応する職種、それが「SREの定義」に対する完全な答えになると考えている。ソフトウェアエンジニアリングを用いることは SRE の一側面であることは確かだが、あくまでそれは手段である。 SRE の目的は、その職種名自体が表しているように、サービスの信頼性を維持することであって、そのための効率的手段としてソフトウェアエンジニアリングが位置づけられる。

また「信頼性」という言葉も定義しておかなくてはならなさそうだが、ここでは SRE book の謝辞 注釈にある、以下の文を引いておく。

> ここでは、信頼性とは「［システムが］求められる機能を、定められた条件の下で、定められた期間にわたり、障害を起こすことなく実行する確率」です。

## インフラエンジニアと SRE

ソフトウェアエンジニアが運用を担うということがことさらに強調されているということは、これまでシステム運用を担ってきたのはソフトウェアエンジニアではないということになる。海外での実情や職種の分かれ方はよく知らないが、日本ではインフラエンジニアが運用を兼ねる場合が多かったように思う。その後近年の SRE ブームも手伝って、インフラチームと呼ばれていた部署を SRE に改組する企業が増えてきた。国内での SRE ブームに火を点けた、 SRE という職種を初めて広めたのはメルカリだと思っているのだが、同社でも SRE チームはインフラチームから発展したものだった。

<iframe src="https://hatenablog-parts.com/embed?url=https%3A%2F%2Ftech.mercari.com%2Fentry%2F2015%2F11%2F18%2F153421" style="border: 0; width: 100%; height: 190px;" allowfullscreen scrolling="no"></iframe>

しかし SRE がソフトウェアエンジニアリングを生業とする集団であるとするならば、インフラエンジニアがそのまま「今日から SRE になります」と言って簡単になれるものではない。 SRE はインフラエンジニアが単純に次世代型へ移行したものではない。ソフトウェアエンジニア、インフラエンジニアという、技術領域を元にした職種の分類ではなく、 SRE は信頼性という責任領域を後ろ盾とした職種になる。そこで必要とされる技術はソフトウェアエンジニアリングはもちろん、信頼性を担保する上ではインフラ部分への理解も欠かせず、非常に手広いものになる。

SRE のブームが来る少し前に Infrastructure as Code のブームが始まり、インフラエンジニアもコードを書けなくてはならないという風潮は出来上がっていた。ただ、 Infrastructure as Code で実際に書くものは多くの場合 YAML や HCL といった定義ファイルであり、ソフトウェア開発に至るわけではない。「運用」という側面で一致しているとはいえ、インフラエンジニアから SRE への移行は、それなりに大きなハードルを乗り越えるジョブチェンジになる。

## エラーバジェットとトイルバジェットから始める SRE の実践

僕もインフラエンジニアから SRE へ移った身だし、正直なところ現段階でソフトウェアエンジニアリングが得意だと言い切れもしないのだが、ではそういったエンジニアが SRE をやることが無意味かと言えば、そうも思わない。ソフトウェアエンジニアリングを主戦場としてこなかった人間が SRE を実践することにももちろん意味はあると思っている。

冒頭で書いたようにソフトウェアエンジニアリングは SRE に求められる「半分」の側面であり、もう「半分」はサービスの信頼性確保という大目的の部分である。 SRE ではこれを「エラーバジェット」という考え方を導入することにより実現している。100％の可用性を闇雲に目指すのではなく、そのサービスに必要な可用性を SLO として定めた上で、その可用性目標を1から引いた値をエラーバジェットとして設けることにより、バジェットが満たされるまではリスクを取ってサービス開発しても良いものとして運営する。これにより、ただただ「守る」ことを考える従来の運用メソッドとは異なり、サービス開発のベロシティとサービスの信頼性確保という両輪のバランスを、明確な数値目標によって確保できる。株式会社はてなで SRE に従事していた yuuki 氏は、これを「サイト信頼性を制御する」と表現していた。

<iframe src="https://hatenablog-parts.com/embed?url=https%3A%2F%2Fblog.yuuk.io%2Fentry%2F2019%2Fthinking-sre" style="border: 0; width: 100%; height: 190px;" allowfullscreen scrolling="no"></iframe>

手段としてソフトウェアエンジニアリングを高いレベルでこなすことができないとしても、まずこの考え方を導入し、信頼性の「制御」に責任を持ったチームとして SRE を設置することは意義があると考えている。特にサービスの拡大、成長が著しく見込まれている場合には、エラーバジェットという考え方がもたらす効用は大きい。

また、もうひとつ SRE の責務として重要な点として、サービス拡大に伴って増加する運用業務、いわゆる「トイル」の抑制が存在する。サービスが急激に拡大する際に足を引っ張りがちなのが、この信頼性確保と、トイルの増大という2点になる。SRE book において、 Google は「トイルを業務量全体の50%に抑える」という目標値を提示しているが、Google が公開しているもう1冊の SRE 関連書籍『[The Site Reliability Workbook](https://landing.google.com/sre/books/)』では、これをエラーバジェットに対して「トイルバジェット」と呼んでいる。

Workbook では「class DevOps implements SRE」という言葉も出てくる。 DevOps は、すばやくリリースを行いたい開発担当者と、システムの可用性を守りたい運用担当者を対立関係に置くのではなく、両者を協力させていこうという、少々曖昧な部分のある一種の運動だったが、 SRE はこれにエラーバジェットとトイルバジェットという概念を持ち込むことで、両者の協力状況を可視化した。まずはこれを、自社の運用の現場に持ち込んでみることから始めてみてもいいのではないだろうか。まずは自社のサービスにとって、必要な「信頼性」とは具体的にどのような値であり、どの程度の数値を目標にするべきか SLO を考えなくてはならない。シンプルにサービスの稼働率だけ確保できればいいのかもしれないし、レスポンスタイムが一定値以下であることが求められるかもしれない。その数値も99.9%なのか、もうひとつ9を増やすべきなのか、あるいは繁忙期と閑散期、日中と夜間で目標を変えるべきなのかなど、考えることは山のようにある。そしてそれをどう測定するのか。レスポンスタイムはトップページだけで考えていいのか、全リクエストなのか、平均値なのか、パーセンタイルで考えるのか。トイルの計測はより難しいと感じていて、どの仕事をトイルと分類して、どのように所要時間を測るのかを決めなければならない。

ここでは SLO の策定と、それに基づく「測定」から SRE の実践を始めることを書いたが、 SRE を如何に実践していくかについては、 Google が[チェックリスト](https://cloud.google.com/blog/ja/products/gcp/how-to-start-and-assess-your-sre-journey/)を公開している。


このチェックリスト内でもやはり、 SLO の策定はいの一番に上げられている。 SLO 策定 → 計測の開始 → 計測結果を踏まえた問題改善 というサイクルがあってこそ、 SRE は効果的に問題解決に当たれるのではないだろうか。

## 自分のキャリアと SRE

とはいえソフトウェアエンジニアリングを得意としていないことに甘んじ続けるわけにもいかない。特にトイルを抑制するには、手作業を自動化したり、システムが自律的に動作するようにしたりする上で、何かしらソフトウェアを書く機会というのはほぼ確実に生まれてくる。

SRE としてやっていくにあたって、自分には何が足りないのか。自分のキャリアを改めて振り返ると、専門性を持っていると言えるのは以下の領域と考えている。

* システム監視と復旧手順の作成
* ドキュメンテーション
* Infrastructure as Code
* 種々の自動化

### アーキテクチャの知識の必要性

これまで2社務めてくるなかで、構築よりも運用よりのエンジニアとして仕事に従事してきたがために、特にシステムの監視設計と実装、アラートを受信したときの対応手順、復旧手順の作成や、それらのドキュメンテーションといった部分に多く時間を割いてきた。しかしこれらはリアクティブな対応であって、 SRE の文脈ではトイルに分類される部分が多い。そもそも障害を起こさない、あるいは障害が起きても自律的にシステムが復旧するようなアーキテクチャを考えることが、 SRE には求められるはずだ。自分にはそれが圧倒的に足りていない。マイクロサービスアーキテクチャの知識はほぼゼロに等しいし、システムの自律的な動作において不可欠な技術になりつつある Kubernetes にもそれほど詳しくはない。 AWS のマネージドサービスを用いてある程度可用性の高い仕組みを整えることはできるが、まだまだ知らないことも多い。

### ソフトウェアエンジニアリングの知識の必要性

またトイルの抑制にあたる業務もやってこなかったわけではなく、特に Terraform や Ansible を用いた Infrastructure as Code の導入や、手作業を AWS Lambda や自前のコマンドラインツールを用いて自動化していくことにも務めてきた。これらの経験はそのまま SRE としても役立つはずだし、実際この3か月の間でも、いくつか自動化の仕組みを整えてきた。これに関しては今後も継続的に伸ばしていきたい。

ただ、改めて思うのは Infrastracture as Code の効果的な実践が難しいということ。 IaC は何が嬉しいのかと言えば、サービスがスケールしたときに、一度コード化したリソースであれば瞬時に環境を準備できるという点が上げられる。しかしその利点を享受するには、再利用性の高いコードを書く必要がある。 Terraform には module 、 Ansible には role という形で、コードをパッケージ化して再利用するための仕組みが用意されている。これを上手く作っていかなくては、新たなサービスや環境が必要なときに、また一からコードを書かねばならず、結局のところ手作業でインフラを構築したほうが早いという結論になりかねない。これでは IaC はトイルと化してしまう。

SRE はソフトウェアエンジニアによるシステム運用の方法論だが、それは直接的にソフトウェアエンジニアリングを行うことを想定しているのみならず、ソフトウェアエンジニアリングの知識が、トイルの抑制のための自動化などに役立つという意味でもあると考えている。100回実行が見込まれる作業Aを自動化することはもちろん意味がある。しかしより意味のある自動化コードとは、それが作業A'や作業A''にも応用できるものである。そのためには業務を適切に抽象化する必要がある。これはソフトウェアエンジニアリングの方法論に近しい。例えば単一責任原則を知っていれば、より変更に強い Terraform module が書けるかもしれない。

### 問題発見の技術

もう1つ、これまで重視してこなかったが今後重要になるだろうと考えているのが「問題発見」の技術。トイルの抑制、信頼性の確保、いずれも的確にそれらを阻害している要因 = 問題をあぶり出して対処することが求められる。つまりは問題発見の技術である。安宅和人の『イシューからはじめよ』において、ただ闇雲に問題解決に当たり、大量の仕事をこなすことで目的を達成しようとする行為は「犬の道」と呼ばれている。ここではより生産性の高い問題 = イシューを見つけた上で仕事に当たることの重要性が説かれている。

> 「限界まで働く」「労働時間で勝負する」というのは、ここでいうレイバラーの思想であり、この考えでいる限り、「圧倒的に生産性が高い人」にはなれない。冒頭で書いたとおり「同じ労力・時間でどれだけ多くのアウトプットを出せるか」というのが生産性の定義なのだ。

トイルの抑制を目指す SRE にもこの考え方は必要だ。先に書いたことにも重なるが、闇雲に自動化をしたり、何か改善を加えたりするのではなく、いま本当に必要な自動化や改善はどれなのかを正しく見極めていく必要がある。 SLO の策定と計測も、対処するべき問題を正しく見極めるためのメソッドの1つと言える。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4862760856/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/513RqLSIjYL._SL160_.jpg" alt="イシューからはじめよ――知的生産の「シンプルな本質」" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4862760856/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">イシューからはじめよ――知的生産の「シンプルな本質」</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 19.09.21</div></div><div class="amazlet-detail">安宅和人 <br />英治出版 (2010-11-24)<br />売り上げランキング: 197<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4862760856/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>


## Conclusion

以上、自分が SRE としてやっていくにあたり、大きく3点の学びを進めていきたい。

* アーキテクチャの知識の獲得
* ソフトウェアエンジニアリングの知識の獲得
* 問題発見の技術の獲得

差し当たっては読みたい本がいくつか上げられたので読んでいこうと思う。ただアーキテクチャの知識という点についてはしっくりくる本が見つかっていない。『[大規模サービス技術入門](https://www.amazon.co.jp/dp/4774143073)』など非常に良い本ではあるのだが、さすがに古くなっている部分もあり、この本の現代版がほしいなと思っているところ。 ISUCON の過去問なども有益ではないかと考えている。ほか2点に関しては以下の本を候補としている。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4048930656/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/51LkcwTMC8L._SL160_.jpg" alt="Clean Architecture 達人に学ぶソフトウェアの構造と設計" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4048930656/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Clean Architecture 達人に学ぶソフトウェアの構造と設計</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 19.09.21</div></div><div class="amazlet-detail">Robert C.Martin <br />KADOKAWA (2018-07-27)<br />売り上げランキング: 4,607<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4048930656/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>


<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4532318092/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/512JtXCrx%2BL._SL160_.jpg" alt="良い戦略、悪い戦略" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4532318092/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">良い戦略、悪い戦略</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 19.09.21</div></div><div class="amazlet-detail">リチャード・P・ルメルト <br />日本経済新聞出版社 <br />売り上げランキング: 29,863<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4532318092/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

3点の中に実際のソフトウェアエンジニアリング、コーディングを入れなかったのは自分でもちょっとおもしろいなと思うのだが、どちらかと言うとソフトウェアエンジニアリングを効果的に行うための方法論のほうが今は重要だと考える故ではある。もちろんソフトウェアエンジニアリングも並行して進めるべきだとは考えていて、 GitHub で Terraform 関係など、 issue に対して PR を投げたり、自分なりのツールを書いたりしていきたい。

考えれば考えるほど難易度が高くて気が遠くなりそうな職種なのだが、それだけ挑戦しがいもあるので、食らいついていきたい。
