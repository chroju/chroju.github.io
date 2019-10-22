+++
title = "『Effective DevOps』と『エンジニアリング組織論への招待』を読んだ"
date = 2018-05-13T19:35:05+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

ITエンジニア組織における組織論について書かれた本が同時期に2冊出ていたので、それぞれ読んでみた。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774196053/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/51zMvVL4MeL._SL160_.jpg" alt="エンジニアリング組織論への招待 ~不確実性に向き合う思考と組織のリファクタリング" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774196053/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">エンジニアリング組織論への招待 ~不確実性に向き合う思考と組織のリファクタリング</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 18.05.13</div></div><div class="amazlet-detail">広木 大地 <br />技術評論社 <br />売り上げランキング: 1,031<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774196053/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>


<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873118352/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/51hSE7AENQL._SL160_.jpg" alt="Effective DevOps ―4本柱による持続可能な組織文化の育て方" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873118352/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Effective DevOps ―4本柱による持続可能な組織文化の育て方</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 18.05.13</div></div><div class="amazlet-detail">Jennifer Davis Ryn Daniels <br />オライリージャパン <br />売り上げランキング: 8,495<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873118352/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

## エンジニアと社会学

頻繁に引用されるトム・デマルコの言葉に、以下のものがある。

> 実際のところ、ソフトウェア開発上の問題の多くは、技術的というより社会学的なものである。（トム・デマルコ, ティモシー・リスター『ピープルウェア』）

実際コンピュータの世界にそこそこの年数身を置いていると、この言葉に対して徐々に実感が伴ってくる。技術的な解というのは、この情報過多の時代、すでに誰かがどこかへ書き記してくれていることが少なくないし、単純に技術的な妥当性だけを突き詰めれば、理想的なシステムの形は自ずと定まってくる。でもその解が実際に適用できるとは限らない場合が多い。それは予算的な都合であったり、社内の開発プロセス的に困難があったり、社内に反対勢力がいたり、もっとシンプルに技術者のレベルが追いついていないということもあり得る。技術的に楽しいことをただやっていればよかった若い時代を抜けて、徐々に自分のやりたいことをやろうとして、壁にぶつかるようになり、人はマネジメントという路線を意識せざるを得なくなるのだろうな、などと最近よく思う。

とても脱線した話をすると、自称理系による安直な「文系批判」というのが自分は非常に苦手だ。上記のようなことを考えたとき、自然科学的な課題を解決するにあたっても、社会科学的なアプローチが必要とされる場面は多いからだ。理系文系というのは二項対立ではないし、どちらか一方だけに特化することが、必ずしも高い生産性につながるわけではない。この2冊の書籍が出るあたりからして、昨今は社会科学の必要性というのも強く意識されるようになってきているのだとは思うが。

## Effective DevOps

DevOpsとは何か？と言われると、それは特定のツールではなくて、開発と運用、引いてはそれ以外のチームも含めたスムーズな連携によるシステム運営文化を指す、というのはわかるのだが、正直バクっとしてとらえどころのない言葉だなとは長年思っている。

その点この本がすごいのは、そのとらえどころのない「文化」面に着目して、具体的実践を300ページ以上もの分量で書いていること。「ツール」の章もあるにはあるが、技術的な話ではなくツールの選定方法や、ツールが文化に対して与える影響について書かれている。もちろんこの本に書かれたことが唯一無二の正解ではない、というのは文中でも断られているが、DevOpsとはどうあるべきか、という疑問への最適解に近いものが集まっているように感じた。とにかくボリューミー。

本書は先の「ツール」の他に、主に「コラボレーション」「アフィニティ」「スケーリング」という計4つの章に分かれている。コラボレーションは複数人の協力の方法について、アフィニティはチーム間の関係構築について、スケーリングは組織の成長や縮小の観点について述べており、これはそのまま組織の成熟プロセスに該当しそうなので、各々の組織の状態に合わせて参照していけばよさそう。

## エンジニアリング組織論への招待

こちらの本はDevOpsよりもう一歩手前というか、そもそも会社組織においてエンジニアリングを行うにあたり、何が問題として存在していて、それを如何にして解決すればよいのかという、そもそも論に焦点が当たっている。 [「エンジニアリング組織論への招待」はいろんな立場の人に読んで欲しい - $shibayu36->blog;](http://blog.shibayu36.org/entry/2018/03/27/193000) という書評記事も読ませてもらったが、IT組織内の「いろんな立場」を超えて、IT以外の現場ですら役立ちそうに思える。

本書は副題通り、エンジニアリングの目的を不確実性＝定まっていないこと、わからないこと、乱雑な状態を効率よく解消していくことにあると定める。この定義がすごくしっくりきて、例えば本書の中でも触れられているアジャイル開発などは、不確実性を反復して徐々に徐々に削減していくプロセスと捉えられる。

この「不確実性の解消」という言葉で全体をまとめたことで、とても見通しの良い1冊になっているし、エンジニアリングに従事するにあたり、我々は一体何をしているのか？という日々の迷いにも指針を与えられた気分になる。そして不確実性へ向き合うにあたり、自分が最も感銘を受けたのは以下の一文。

> 難しいのは、問題を正しく認知することです。(p.33)

そう、まさにそれである。問題解決のための技術導入をしたところで、その技術が解決するべき問題を解決してくれなくては意味がない。本書では「問題の正しい認知」のために、認知バイアスの解消などが解説され、そして具体的な組織における不確実性を、通信（コミュニケーション）、方法（スケジュールの見積）などいくつかの側面から紹介している。

## 正しい問題解決のための組織をつくる

組織的な課題にぶつかったとき、2冊は補完的に使えるように思う。『エンジニアリング組織論への招待』は、組織の問題をまず正しく認知することに活用できる。『Effective DevOps』はその問題を実際解決するにあたり、DevOpsという観点から、組織をどういう方向へ変えていけばいいかを示してくれる。

自分はまだ実際にマネジメントの立場にいるわけではないので、まずは自らの認知をリファクタリングし、問題発見と解決のスキルを上げることから始めていきたい。
