+++
date = "2016-12-17T12:43:17+09:00"
description = ""
title = "エンジニアの問題解決力とは何か"

+++

今年度、特に下半期からいわゆる技術的負債の返済、特にDevOps方面におけるプロセス改善に深く携わるようになった。これまで依頼ベースの対応や、プロジェクトベースの仕事をすることが多く、要は「何をやるか」がある程度決まっていたわけだけど、改善系の業務は問題を見つけ、解決策、しかも場当たり的なものではなくてボトルネックを閉めるような策を講じていく必要があるということで、これまでと違う視点で仕事をする必要が出てきた。そこで何冊か「問題解決」にフォーカスした本を読んだ結果をまとめてみる。

問題とはなにか
----

そもそも「問題」って何なのか。[細谷功『問題解決のジレンマ』](https://www.amazon.co.jp/dp/4492557415)によれば、問題とは「事実と解釈の乖離」だという。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4492557415/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51HZRQOWU6L._SL160_.jpg" alt="問題解決のジレンマ: イグノランスマネジメント:無知の力" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4492557415/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">問題解決のジレンマ: イグノランスマネジメント:無知の力</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 16.12.17</div></div><div class="amazlet-detail">細谷 功 <br />東洋経済新報社 <br />売り上げランキング: 112,865<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4492557415/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

客観的な「事実」があり、その関係性や論理構造を規定する「解釈」がある。事実というのは客観的なものなので変化することは少ないが、解釈は時代や文化によって在り方を変える。つまりは古くなってくるわけで、それによって事実と解釈が乖離を起こすことにより、問題が発生する。

システム運用という自身の立場で考えれば、例えばベンチャー企業においては「小規模なシステム」かつ「少人数の精鋭社員」という「事実」下では、「スピードが重要でドキュメントを書かずとも運用は可能」という「解釈」が成り立ちうる。これが年数が経過して「大規模なシステム」かつ「新卒等も含めばらつきのある社員」という事実に変わってくると、先の解釈通りにドキュメントなしでは運用が難しくなったりするわけで、事実と解釈の乖離が起きた状態が発生していることになる。

問題を見つけるために
----

人は日常的には己の「解釈」の枠組みの中で生きている。知識が増えるほど、自分の知る範囲内での最適化＝問題解決を図ろうとするようになるが、根本的な問題解決をするには、そもそもその「解釈」の範囲の外に問題がある、つまり自分の「解釈」がすでに形骸化している、ということを見つける必要がある。『問題解決のジレンマ』では、これをラムズフェルドがかつて言及した[Unknown unknowns（未知の未知）](https://ja.wikipedia.org/wiki/%E7%9F%A5%E3%82%89%E3%82%8C%E3%81%A6%E3%81%84%E3%82%8B%E3%81%A8%E7%9F%A5%E3%82%89%E3%82%8C%E3%81%A6%E3%81%84%E3%82%8B%E3%81%93%E3%81%A8%E3%81%8C%E3%81%82%E3%82%8B)という言葉で説明している。

とはいえそれは容易な話ではない。たいていの人間は自身の知識、先入観を抽象化して物事を考えるということを、簡単には実践できていないように思う。

自分がそもそも「わかっていない」ということを「わかっていない」ことに気付くには、安直に言ってしまえば視野を広げていくしかない。『問題解決のジレンマ』で挙げているのは「フレームワークの導入」で、物事を一般的なフレームワークに当てはめて考えれば、どの分野に対して視点が足りていないのかを探る手がかりになる。

また「知識がある」という状態がそもそもの「未知の未知」を見つける足枷になるわけだから、知識をリセットする、知識をフローとして扱って、不要になったら捨てていくようなプロセスがいいのではという。これは外山滋比古も「忘却の力」という形で扱っている概念だ。エンジニアは技術職だが、一つの技術領域にこだわりすぎると時代の潮目についていけなくなったりするので、この点は一理ある。

あるいは『SOFT SKILLS』の「学習」の項において、学習すべき事項を見つけるために勧めていたのが、「わからないことをメモしておく」ことだった。学習すべき事項というのは要は「問題」なわけで、これも問題発見には応用できるのだと思う。まぁ地道で「そりゃそうだろ」という話ではあるのだが、日頃見つかる小さな問題をスルーせずに、都度確実に書き留めておくことは必要と思う。そして個別の問題それぞれに対応するのではなく、ある程度蓄積された複数の小さな問題を並べて「ボトルネックは何か？」と考えていくことで、対応すべき大きな問題が見つかるのではないか。

問題を解決していく過程
----

見つけた問題を解決する過程については[安宅和人『イシューからはじめよ』](https://www.amazon.co.jp/dp/4862760856)に詳しいが、内容としては要するにデカルトの『方法序説』に近い、一般的な科学的方法論だ。問題を見つけたら、それを解決可能な小さな単位に分解し、単純かつ具体的な観測から抽象へと認識を進め、全体の論理が沿うように再構成していく。GTDにおいても、目的と求めるべき結果を最初に定めて、その間に必要なタスクをブレインストーミングしていく「ナチュラルプランニング」という方法論があるが、どこか似通っている。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4862760856/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/41Xo9o1l0sL._SL160_.jpg" alt="イシューからはじめよ―知的生産の「シンプルな本質」" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4862760856/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">イシューからはじめよ―知的生産の「シンプルな本質」</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 16.12.17</div></div><div class="amazlet-detail">安宅和人 <br />英治出版 <br />売り上げランキング: 1,168<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4862760856/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>


ある問題を端緒として改善活動を始めたとして、どうもエンジニアとしての性なのか、当初の目的からズレて技術的な面白さを求めてしまったりすることはよくある。サーバーのデプロイスピードが遅いことを発端として改善を始め、じゃあクラウドを使って改善しようという話になったが、どのクラウドサービスを使えばいいのかと言った別の問題で時間をかけてしまったり、結局手作業でEC2インスタンスを作っているのでオンプレのときとスピードが変わらない、みたいな話はありがちだ。問題から解決策への筋道が論理的な整合性を保っているかは、常に確認が必要になる。

この点は自分が特に出来ていないところで、プライベートで何か勉強を始めたはいいが、何を求めて始めたのかを忘れてしまって、細かいつまずきポイントでずっとハマったままになったりしていることが少なくない。

具体的実践
----

以上のような検討から、具体的にいろいろと実践してみようと思う。

* 「わからないことメモ」をすすめる。よく使っている小さめのメモ帳があるので、それに1ページ1項目で「わからないこと」を記述して、週末に見直してみる。
* 何か勉強を始めたり、問題解決にあたるときは、個人契約しているesa.ioでノートを1つ作る。
  * まず問題を1文で書き表す。それを出発点として、ぶれないことを心がける。
  * 調査の過程、問題解決を図るプロセスもすべて記録していく。常に全体の整合性が取れていることを確認しながらすすめる。
  * 最終的に「解決」まで至ったノートは、ブログやQiitaに投稿して公開する。
    * 実はこのエントリーもその方法に則ってesa.io上で昇華させた。
* あまり特定の「技術」にこだわらない。
  * そもそも問題解決やビジネス的な成功という「目的」があり、それを達成するための手段が「技術」なのであって、それが何を採用するかこだわるのは本質ではない。
  * 技術への固執は「未知の未知」を見えにくくする。多様な技術に対して寛容な理解を心がけることで、常に必要な技術へキャッチアップできるような気がする。
  * 一方で低レイヤーの知識や、コンピュータ史への造詣は深める。先に挙げた「フレームワーク」にあたるのがこのような基礎分野だと思うので、基礎を固めることで現在の技術潮流をメタに判断できるようになる。

特に最後の「特定の技術にこだわらない」は重要だと思っていて、自分はどうしてもクールな技術、なんだかカッコよさそうなものがあると簡単に心惹かれてしまい、技術が目的になってしまう。もちろん、使っていて気持ちのいい技術を選択するのも大事なのだが、結局はどの技術もツールに過ぎないわけで、自社の「問題解決」に適切なハンマーなのかという点は念頭におきたいし、またその目的に適うならどんな技術だってクールと思うべきなんだろうと思う。

自分は謙遜せずに言えば頭の回転が速い方なので、どうしても考えすぎてしまう、頭の中でぐるぐる物事を捏ね繰り回してしまう傾向にあり、それを解消する意味でも「きちんとesa.io上で論理展開する」というのは良いだろうと思っている。『考えない練習』という本も、考え過ぎを抑制する助けになりそうなので読んでみたい。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4094087001/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51y1EO0eUOL._SL160_.jpg" alt="考えない練習 (小学館文庫)" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4094087001/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">考えない練習 (小学館文庫)</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 16.12.17</div></div><div class="amazlet-detail">小池 龍之介 <br />小学館 (2012-03-06)<br />売り上げランキング: 5,008<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4094087001/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

また、ここまでは個人的な実践の話が多かったが、実際に職務上の問題解決を行うにはチームを巻き込む必要がある。人を動かす、チームの中で振る舞っていく方法論については、また別の課題としていきたい。
