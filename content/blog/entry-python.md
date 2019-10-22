+++
date = "2016-03-28T22:29:39+09:00"
description = ""
title = "Pythonに入門している"

+++

## Pythonを学び始める

今年の [行動規範](http://chroju.github.io/blog/2016/01/03/manifesto-2016/) でも書いた通り、Pythonに入門している。きっかけはAWS LambdaがPython対応しており、またAnsibleもPythonで書かれているということで、Pythonの読み書きが出来た方が今後良さそうだなと思うに至った。これまでRubyをよく書いていたけど、Linuxにデフォルトで入っているのはPythonやPerlという現実的な問題もある。

今までにやったこととしては取りあえず本を2冊読んだのと、一昨日は [入門者向けのPythonハンズオン](http://python-nyumon.connpass.com/event/26257/) に行ったりしてみた。基礎文法はだいたいさらって、requestsのようなポピュラーなライブラリは試してみた程度。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873117534/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51SI%2BAszQwL._SL160_.jpg" alt="Pythonチュートリアル 第3版" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873117534/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Pythonチュートリアル 第3版</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 16.03.28</div></div><div class="amazlet-detail">Guido van Rossum <br />オライリージャパン <br />売り上げランキング: 24,079<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873117534/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B00ZR7WZOU/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51moRIhvzhL._SL160_.jpg" alt="Pythonエンジニア養成読本［いまどきの開発ノウハウ満載！］" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B00ZR7WZOU/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Pythonエンジニア養成読本［いまどきの開発ノウハウ満載！］</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 16.03.28</div></div><div class="amazlet-detail">技術評論社 (2015-06-16)<br />売り上げランキング: 42,458<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B00ZR7WZOU/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

なおPythonチュートリアルはつい先日改版が出たのでそっちをリンクしてます。自分が買ったのは先月です（白目）


## Pythonに対する小並感

自分はアプリ屋ではないので言語に対する知見は広くないのだけど、なんとなく感じているのはこんなところ。

* PerlのTMTOWTDIに対して["There should be one"](http://qiita.com/IshitaTakeshi/items/e4145921c8dbf7ba57ef#there-should-be-one---and-preferably-only-one---obvious-way-to-do-it)という考え方が明確で好き。
* 難読な記法というのが今のところあまりない。発想した通りに書いてだいたい動く気がする。
* インデントでブロック形成するのはcoding styleの戦争が起きなくていい。
  * ただし自分はインデント＝スペース2つ派だった。Pythonは4つの方が確かに見やすいけど。
* バージョン2.x vs 3.xの話、外から聞いてはいたけどなにこれ面倒。
* 新参としては3.x学びたいけど、AWS Lambdaが2.7対応だし両方押さえようとしている。
* `pyvenv`の環境の隔離の仕方がシンプルで好き。`pyenv`というのもあって紛らわしいが。
* というか全体的にシンプルなコンセプトで作られている印象。

2.xと3.xの両輪を回さなくてはならないことを除いては、全体的にはシンプルだし書きやすくてよいなという感じがする。インフラ自動化便利ツールもそろそろなにか書いてみたい。

## 新しい言語の学習方法

あと言語学習ではいままで「とりあえず書く」というのを手法にしていたけど、複数言語を学んでみて徐々にわかってきた勘所が2点ある。

### 文法で押さえるべきポイントは決まっている

例えば`elif`か`elsif`か`else if`かとか、false判定されるのはnullなのか`0`なのか`""`なのかとか、複数言語を並行して遣うときに迷うポイントはわりと決まっているので、そこさえ押さえればとりあえず書ける、というのがある気がした。

チートシートを自分用に作るのも漫然と端から文法を並べ立てるのではなく、こういうポイントに限ったものにすると効率がよさそう。

### 読むのも勉強

書くのではなく読むのも勉強。よく言われることではあるけれど、これまであまり意識していなかった。冒頭に挙げた通り、PythonではLambdaとAnsibleという明確にきっかけとなったツールが存在しているので、これらのコードをしばらく読んでものにしてみたいと思う。

あと個人的には最近インフラ界隈でもわりとgolangが話題で気になっているけど、それはまたおいおい（実はgo製OSSを修正して使いたくて、ちょっとだけかじってはいる）。


