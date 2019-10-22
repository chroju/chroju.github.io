+++
title = "競技プログラミングで Write Code Every Day を2か月続けてみて"
date = 2018-11-18T15:22:00+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

<a href="https://gyazo.com/31e59ad19ef31d2cf70eefff1313ddcf"><img src="https://i.gyazo.com/31e59ad19ef31d2cf70eefff1313ddcf.png" alt="Image from Gyazo" width="600"/></a>

「[競技プログラミングを始めてみた](https://chroju.github.io/blog/2018/10/03/competitive_programming/)」というエントリーを10月頭に書いて、だいたい2か月ぐらい毎日草を生やしてきたので、ここらで少し振り返ってみる。草は一部 [nature-remo-cli](https://github.com/chroju/nature-remo-cli) などで生やしたものもあるが、ほぼ「[Aizu Online Judge](https://onlinejudge.u-aizu.ac.jp/home)」で生やしている状況。

## Pros

### スムーズにプログラムが書けるようにはなってきた

始めたときのエントリーで書いた通り、自分は現在の職務だとプログラミングやスクリプティングをしない日もよくあるので、下手すれば1週間とか2週間とかプログラミングというものに触れず、いつまで経っても覚えが悪い、なんてこともあったのだが、さすがに毎日書いていると覚えが早いし忘れることもない。よく使う文法や関数はすぐ覚えるし、プログラミングに要する時間自体が徐々に短くなってきたように思う。

### アルゴリズムやデータ構造に関する学習にもなっている

アルゴリズムやデータ構造をまともに体系的に学ぶ機会を設けてこなかったのだが、「Aizu Online Judge』には各種ソートアルゴリズムや基本的なデータ構造、ユークリッドの互除法などの数学的アルゴリズムを使う問題が豊富にあるので、それらを学ぶ機会に恵まれることとなった。さすがに主要なソートアルゴリズムぐらいは IPA の試験などを通じて知ってはいたけれども、全部が全部実装経験があるわけでもないので、この機会に学び直せてとても楽しい。

## Cons

### 模範解答がない

「Aizu Online Judge」特有の話ではあるが、模範解答が存在してはいない。他のユーザーの回答がパブリックになっていればそれを見ることはできるが、模範的なものになっているとは限らないのでヒントにしかならない。各種主要なアルゴリズムを実装するにあたって、「ぼくが考えた最強のあるごりずむ」で解いてもおそらく意味はなくて、代表的な実装を把握はしておきたいところなので、副読本として『アルゴリズム・クイックリファレンス』を購入した。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873117852/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/51gNHECLgTL._SL160_.jpg" alt="アルゴリズムクイックリファレンス 第2版" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873117852/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">アルゴリズムクイックリファレンス 第2版</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 18.11.18</div></div><div class="amazlet-detail">George T. Heineman Gary Pollice Stanley Selkow <br />オライリージャパン <br />売り上げランキング: 160,999<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873117852/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

ちなみに「Aizu Online Judge」公式の解説本も売っているらしいのだけど、目的はこの競技プログラミングを解くことというよりは、それを通じてアルゴリズムを学ぶことであるので、汎用的っぽいオライリーのほうを買った。

### ものを調べたり本を読んだりする時間が減った

Write Code Every Day が第一優先になった結果、 commit を伴わない作業の優先度が相対的に下がった。1日1commitするのに、少なくとも 30分/day は費やしている。すると平日はなかなか他のことに時間を割くのも難しかったりして、 commit に繋がらない何かを調べる作業とか、本を読んだりする時間がめっきり減ってしまった。

Write Code Every Day は、ことプログラミングの習慣化をするにはとても良いプラクティスだと思う。何より成果が可視化されるのでわかりやすいし、草が続いていくと、これを絶やさないようにしたいというモチベーションがどんどんと湧いてくる。ただ「草を生やす」ことで可視化をしてしまうと、成果の出し方が「コードを書いて commit して GitHub に push する」という手段に縛られてしまうのは良くも悪くもだなと感じている。ITに携わる人間として、日々力をつけるのに必要な研鑽はそれだけに限らない。なので、例えば自分の場合はこのブログの元になっている markdown も GitHub で管理しているが、そこに commit することも成果として OK ということにすることにした。あるいは何かを調べる作業にしても、その調べた結果を単に「ふむふむ」と頭の中に留めるのではなくて、実際に簡単なコードで実装する習慣を作れば commit に繋げられるかもしれない。

### 競技プログラミングだけで満足していていいのか

もともと Write Code Every Day のネタとして競技プログラミングを始めたのは、他にネタを持っていない日が多かったからなのだけど、現状競技プログラミングがメインになりすぎてしまっている。競技プログラミングはどうしても問題を書くためのコード、つまりは手続き型で書けばOKな場合がほとんどなので、 Go で何かツールを作るときにはどういうプラクティスに則ればいいのかとか、そういったより実践的な知識を学ぶ機会がない。なにか題材になるような OSS を育てるとか、他の OSS に対して Pull Request を飛ばすとか、そういうことも週に1〜2日でも構わないので組み入れられるように切り替えたい。そしてそのためには、書くネタを探すという別の習慣付けが必要だなと感じている。

----

ざっとこんな感じで、習慣的にプログラミングする時間を設けることができるようになったのはいいんだけど、そればかりしているわけにもいかないからどうしようかなというところ。日頃からネタを探す習慣をつけたくて、年内はインプットの方法を見直すことを進めていこうと思っている。

