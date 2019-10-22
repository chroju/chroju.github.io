+++
title = "競技プログラミングを始めてみた"
date = 2018-10-03T22:04:35+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

「[Write Code Every Day](https://johnresig.com/blog/write-code-every-day/)」という有名なプラクティスに関して、なるほどそれは良さそうだなと思う一方、自分のメインとなる職掌がプログラミングというよりはインフラだったり Operation だったりする関係上、日々プライベートでやっていることは必ずしもプログラミングではなくて、本を読みたいときとかドキュメントを漁りたいときというのも少なくないので、どうも必ずしも「毎日コードを書く」というのは自分には合わないのではないかなという気がしていた。

それが最近になって意識が変わって、というのも、先に書いた通り現在の職掌がプログラミングメインではないため、状況によっては数週間ろくにプログラミングっぽいことをしない、ということがザラに発生するわけで、そうすると結構簡単に忘れてしまうというか、いつまで経っても手が慣れないなという感覚がでてきた。逆に言えば仕事でプログラミングを毎日している人は、さらに家でもプログラミング、ということをせずともプログラミングが日常になっているんだろうけど、プログラミングを仕事にしていないからこそ、余暇の時間に手を動かす、毎日コードを書くことを強制することは自分にとって必要なのではないかと思い直した（ただ本音で言えば、インフラと Ops を主戦場としつつももっとプログラミングできる環境に身を置きたい）。

で、問題になるのが「何を書くか」。

以前にも「Write Code Every Day」をしてみよう、と思ったことは無いではなくて、しかしそのときに壁となったのが「何を書くか」だった。 OSS を作るにも常にネタがあるわけじゃなかったりするし、まぁもっと日頃から OSS 触って PR 投げられるポイント見つけろとかそういう話なのかもしれないけど、そういう実践は実践でするとして、「現状書くものを見つけられていない」という課題への解決は別途しなければならない。

そこで競技プログラミングに手を出し始めた。といってもただパズルのように問題を解くだけなので、今のところコンテストに参加したり「競技」はしていない。手を動かす材料として、豊富に問題があるので使えるのではないかと思った。1問を解くのにも30分ぐらい用意すればなんとかなるので、平日時間がなくても頑張れば commit できるというメリットもある。

今登録しているのは以下の2つ。

* [AtCoder](https://atcoder.jp/?lang=ja)
* [AIZU ONLINE JUDGE](http://judge.u-aizu.ac.jp/onlinejudge/index.jsp)

おそらく AtCoder が国内最大手的な立ち位置？なのかなと思っているが、現在メインで書こうとしている Go に対応していなかったので、 AIZU ONLINE JUDGE を Go で解く、というのが今のところメインになっている。慣れてきたら Python で AtCoder の方にももっと参加してみたい。書いたコードを GitHub に commit することで草を生やしていっている。

自分は完全独学でプログラミングをしていて、しかも仕事で学ばせてもらった経験が一切ないのでプログラミングスキルは下の下というあまり嬉しくない自負があり、当然ながら主要なアルゴリズムの実装なんかも押さえてはいないのだが、 AIZU ONLINE JUDGE の問題を見るとそのへんのキャッチアップも多少出来そうな感じがあるので楽しみにしている。

あと、パズル的なプログラミングという点では、30分で解くような単純な問題では無さそうなんだけど、最近出た『問題解決のPythonプログラミング』も面白そうだなと思っている。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873118514/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/41--mqsprXL._SL160_.jpg" alt="問題解決のPythonプログラミング ―数学パズルで鍛えるアルゴリズム的思考" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873118514/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">問題解決のPythonプログラミング ―数学パズルで鍛えるアルゴリズム的思考</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 18.10.03</div></div><div class="amazlet-detail">Srini Devadas <br />オライリージャパン <br />売り上げランキング: 6,804<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873118514/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>
