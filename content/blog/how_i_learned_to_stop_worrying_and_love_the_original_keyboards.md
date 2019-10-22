+++
title = "Lily58 Pro または私は如何にして市販品を探すのをやめて分割キーボードを自作するようになったか"
date = 2019-04-25T18:00:00+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

## 2019-05-04 追記

本文内で「Ergonomic 配列」という言葉を用いていましたが、より正確には「Column Staggered 配列」という言葉が当てはまりそうなので修正しました。上下が揃った「格子配列」の状態から、各キー列が上下に少しズレて指の長さに合うようになっている配列をこう呼ぶようです。

参考: [ASCII.jp：人はなぜキーボードを自作するのか？　“キーボー道”への誘い (5/6)｜KTUの自作キーボー道](https://ascii.jp/elem/000/001/609/1609599/index-5.html)

## tl;dr

* 分割キーボードは市販品の選択肢がない
* 従って自作キーボードに手を出す気はなかったが手を出すことになった
* Lily58 Pro がかわいい

## Introduction

昨今、キーボードの自作が流行っているのは知ってはいるものの、手を出す気は先日までさらさらなかったんですね。というのも自分は手先が器用ではないというのが大きいところで。最後にはんだごてを使ったのは中学生の「技術」の授業ですが、四苦八苦して作った懐中電灯がうんともすんとも言わなくてだいぶしょんぼりした記憶があります。なのでやりたくはないしやれるとも思わなかったし、練習すればできるとしても、今の自分がそこに労力かけるのはちょっと違うかなみたいな気持ちがありました。

と言っているところからの即落ち2コマみたいでアレなんですが、先週末に [Lily58 Pro](https://yushakobo.jp/shop/lily58-pro/) を購入、構築して使い始めました。めちゃくちゃかわいいですね？？

<blockquote class="instagram-media" data-instgrm-captioned data-instgrm-permalink="https://www.instagram.com/p/BwmRdowgVD2/" data-instgrm-version="12" style=" background:#FFF; border:0; border-radius:3px; box-shadow:0 0 1px 0 rgba(0,0,0,0.5),0 1px 10px 0 rgba(0,0,0,0.15); margin: 1px; max-width:540px; min-width:326px; padding:0; width:99.375%; width:-webkit-calc(100% - 2px); width:calc(100% - 2px);"><div style="padding:16px;"> <a href="https://www.instagram.com/p/BwmRdowgVD2/" style=" background:#FFFFFF; line-height:0; padding:0 0; text-align:center; text-decoration:none; width:100%;" target="_blank"> <div style=" display: flex; flex-direction: row; align-items: center;"> <div style="background-color: #F4F4F4; border-radius: 50%; flex-grow: 0; height: 40px; margin-right: 14px; width: 40px;"></div> <div style="display: flex; flex-direction: column; flex-grow: 1; justify-content: center;"> <div style=" background-color: #F4F4F4; border-radius: 4px; flex-grow: 0; height: 14px; margin-bottom: 6px; width: 100px;"></div> <div style=" background-color: #F4F4F4; border-radius: 4px; flex-grow: 0; height: 14px; width: 60px;"></div></div></div><div style="padding: 19% 0;"></div> <div style="display:block; height:50px; margin:0 auto 12px; width:50px;"><svg width="50px" height="50px" viewBox="0 0 60 60" version="1.1" xmlns="https://www.w3.org/2000/svg" xmlns:xlink="https://www.w3.org/1999/xlink"><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g transform="translate(-511.000000, -20.000000)" fill="#000000"><g><path d="M556.869,30.41 C554.814,30.41 553.148,32.076 553.148,34.131 C553.148,36.186 554.814,37.852 556.869,37.852 C558.924,37.852 560.59,36.186 560.59,34.131 C560.59,32.076 558.924,30.41 556.869,30.41 M541,60.657 C535.114,60.657 530.342,55.887 530.342,50 C530.342,44.114 535.114,39.342 541,39.342 C546.887,39.342 551.658,44.114 551.658,50 C551.658,55.887 546.887,60.657 541,60.657 M541,33.886 C532.1,33.886 524.886,41.1 524.886,50 C524.886,58.899 532.1,66.113 541,66.113 C549.9,66.113 557.115,58.899 557.115,50 C557.115,41.1 549.9,33.886 541,33.886 M565.378,62.101 C565.244,65.022 564.756,66.606 564.346,67.663 C563.803,69.06 563.154,70.057 562.106,71.106 C561.058,72.155 560.06,72.803 558.662,73.347 C557.607,73.757 556.021,74.244 553.102,74.378 C549.944,74.521 548.997,74.552 541,74.552 C533.003,74.552 532.056,74.521 528.898,74.378 C525.979,74.244 524.393,73.757 523.338,73.347 C521.94,72.803 520.942,72.155 519.894,71.106 C518.846,70.057 518.197,69.06 517.654,67.663 C517.244,66.606 516.755,65.022 516.623,62.101 C516.479,58.943 516.448,57.996 516.448,50 C516.448,42.003 516.479,41.056 516.623,37.899 C516.755,34.978 517.244,33.391 517.654,32.338 C518.197,30.938 518.846,29.942 519.894,28.894 C520.942,27.846 521.94,27.196 523.338,26.654 C524.393,26.244 525.979,25.756 528.898,25.623 C532.057,25.479 533.004,25.448 541,25.448 C548.997,25.448 549.943,25.479 553.102,25.623 C556.021,25.756 557.607,26.244 558.662,26.654 C560.06,27.196 561.058,27.846 562.106,28.894 C563.154,29.942 563.803,30.938 564.346,32.338 C564.756,33.391 565.244,34.978 565.378,37.899 C565.522,41.056 565.552,42.003 565.552,50 C565.552,57.996 565.522,58.943 565.378,62.101 M570.82,37.631 C570.674,34.438 570.167,32.258 569.425,30.349 C568.659,28.377 567.633,26.702 565.965,25.035 C564.297,23.368 562.623,22.342 560.652,21.575 C558.743,20.834 556.562,20.326 553.369,20.18 C550.169,20.033 549.148,20 541,20 C532.853,20 531.831,20.033 528.631,20.18 C525.438,20.326 523.257,20.834 521.349,21.575 C519.376,22.342 517.703,23.368 516.035,25.035 C514.368,26.702 513.342,28.377 512.574,30.349 C511.834,32.258 511.326,34.438 511.181,37.631 C511.035,40.831 511,41.851 511,50 C511,58.147 511.035,59.17 511.181,62.369 C511.326,65.562 511.834,67.743 512.574,69.651 C513.342,71.625 514.368,73.296 516.035,74.965 C517.703,76.634 519.376,77.658 521.349,78.425 C523.257,79.167 525.438,79.673 528.631,79.82 C531.831,79.965 532.853,80.001 541,80.001 C549.148,80.001 550.169,79.965 553.369,79.82 C556.562,79.673 558.743,79.167 560.652,78.425 C562.623,77.658 564.297,76.634 565.965,74.965 C567.633,73.296 568.659,71.625 569.425,69.651 C570.167,67.743 570.674,65.562 570.82,62.369 C570.966,59.17 571,58.147 571,50 C571,41.851 570.966,40.831 570.82,37.631"></path></g></g></g></svg></div><div style="padding-top: 8px;"> <div style=" color:#3897f0; font-family:Arial,sans-serif; font-size:14px; font-style:normal; font-weight:550; line-height:18px;"> View this post on Instagram</div></div><div style="padding: 12.5% 0;"></div> <div style="display: flex; flex-direction: row; margin-bottom: 14px; align-items: center;"><div> <div style="background-color: #F4F4F4; border-radius: 50%; height: 12.5px; width: 12.5px; transform: translateX(0px) translateY(7px);"></div> <div style="background-color: #F4F4F4; height: 12.5px; transform: rotate(-45deg) translateX(3px) translateY(1px); width: 12.5px; flex-grow: 0; margin-right: 14px; margin-left: 2px;"></div> <div style="background-color: #F4F4F4; border-radius: 50%; height: 12.5px; width: 12.5px; transform: translateX(9px) translateY(-18px);"></div></div><div style="margin-left: 8px;"> <div style=" background-color: #F4F4F4; border-radius: 50%; flex-grow: 0; height: 20px; width: 20px;"></div> <div style=" width: 0; height: 0; border-top: 2px solid transparent; border-left: 6px solid #f4f4f4; border-bottom: 2px solid transparent; transform: translateX(16px) translateY(-4px) rotate(30deg)"></div></div><div style="margin-left: auto;"> <div style=" width: 0px; border-top: 8px solid #F4F4F4; border-right: 8px solid transparent; transform: translateY(16px);"></div> <div style=" background-color: #F4F4F4; flex-grow: 0; height: 12px; width: 16px; transform: translateY(-4px);"></div> <div style=" width: 0; height: 0; border-top: 8px solid #F4F4F4; border-left: 8px solid transparent; transform: translateY(-4px) translateX(8px);"></div></div></div></a> <p style=" margin:8px 0 0 0; padding:0 4px;"> <a href="https://www.instagram.com/p/BwmRdowgVD2/" style=" color:#000; font-family:Arial,sans-serif; font-size:14px; font-style:normal; font-weight:normal; line-height:17px; text-decoration:none; word-wrap:break-word;" target="_blank">17年ぶりぐらいの半田付けだけど無事に Lily58 Pro 組み上がったんだがめちゃくちゃ可愛くないこれ？？？</a></p> <p style=" color:#c9c8cd; font-family:Arial,sans-serif; font-size:14px; line-height:17px; margin-bottom:0; margin-top:8px; overflow:hidden; padding:8px 0 7px; text-align:center; text-overflow:ellipsis; white-space:nowrap;">@<a href="https://www.instagram.com/chroju/" style=" color:#c9c8cd; font-family:Arial,sans-serif; font-size:14px; font-style:normal; font-weight:normal; line-height:17px;" target="_blank"> chroju</a>がシェアした投稿 - <time style=" font-family:Arial,sans-serif; font-size:14px; line-height:17px;" datetime="2019-04-23T12:26:54+00:00">2019年 4月月23日午前5時26分PDT</time></p></div></blockquote> <script async src="//www.instagram.com/embed.js"></script>

どうしてこうなったのかという話を書きます。

## 分割キーボード Lover のジレンマ

私はここ数年、メインのキーボードは Barocco MD600 を使っていました。数年前、 ErgoDox が話題になった少し後ぐらいに、 HHKB サイズで分割可能なキーボードということで話題をさらった機種です。

<a data-flickr-embed="true"  href="https://www.flickr.com/gp/chroju/hY667o" title="Baroccoとどいた"><img src="https://c1.staticflickr.com/1/579/31813875193_36398a3d15.jpg" width="500" height="500" alt="Baroccoとどいた"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

使い始めてまだ2年ほどで全然現役ですし、使い心地にもかなり満足していたのですが、最近になって「キーボードを持ち運びたい」というニーズが（自分の中で）出てきました。 MD600 は HHKB サイズということでギリギリ持ち運べなくもないのですが、積極的に持ち運びたいかというとそんなこともなく、可能であればもう少し小さいものがほしいというのが正直なところでした。

というわけで持ち運び用キーボードを探し始めたのですが、 MD600 にすっかり身体が慣れてしまったために、条件として「分割」が必須になります。「分割しない」という手はもう選べません。使ってみるとわかるんですが、分割キーボードの使い心地に慣れると、たとえ HHKB だろうと RealForce だろうと色あせてきます。大事なのはキータッチじゃなくて身体全体の姿勢だったんだなという悟りを開くわけです。なので私は「分割キーボード」というのは素晴らしいガジェットだと評価していますが、他人に勧めることはしません。戻れなくなります。

そしてここで壁にあたるのですが、市販品の分割キーボードは残念ながら選択肢が多くはないのが実情です。小さくて分割、というところだと、現在まず候補に上がるのは Barocco シリーズの新機種 MD650L かと思います。ロープロファイルに変更することで MD600 と比べてさらに薄くなった品で、というか「持ち運べる」「市販品の」分割キーボードはほぼこれ一択じゃないでしょうか。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B07FK74QY5/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/11NGjsnBsJL._SL160_.jpg" alt="Mistel BAROCCO MD650L 分離式 メカニカルキーボード 英語配列 Cherry ML Switch ML1A 採用 アイボリー/グレー MD650L-LUSMGAB1" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B07FK74QY5/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Mistel BAROCCO MD650L 分離式 メカニカルキーボード 英語配列 Cherry ML Switch ML1A 採用 アイボリー/グレー MD650L-LUSMGAB1</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 19.04.25</div></div><div class="amazlet-detail">MiSTEL (2018-02-27)<br />売り上げランキング: 4,353<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B07FK74QY5/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

ネックだったのはキースイッチに Cherry ML を使っているという点で、どうもこれが調べた限りだとわりと評判悪いみたいです。とはいえ「自分には合う」という可能性もあるので、触って確認できればよかったんですが、ツクモなど秋葉原で数店舗を巡ってみても実機を置いているところはなく、評判が微妙っぽい機種を触らずに買うという勇気も出なくて泣く泣く諦めました。

これ以外にも [Kinesis Freestyle](https://www.amazon.co.jp/dp/B00CPYH6FQ) など、分割キーボードの選択肢自体は無くはないものの、持ち運び可能なサイズという条件を満たすものは見つけられませんでした。かろうじて [Ultimate Hacking Keyboard](https://ultimatehackingkeyboard.com/) がありますが、サイズ感は MD600 とあんまり変わらないように見受けられます。そもそもにして、 MD600 の発売から2年以上を経てもなお、分割キーボードを製造、販売しているメーカーは多くありません。ウェブで IT エンジニアの動向に触れていると、分割キーボードが今の主流であるかのように感覚が麻痺ってきますが、どう考えてもそんなことはなくて、あくまでカルト的な人気なわけですね。他には「HHKBを2台横に並べる」といった剛の者が選ぶ道もありますが、さすがにちょっとそれは遠慮しておきました。

## 自作という選択

まぁ、というわけで「ないから作るか」という結論に至ります。おそらく、昨今自作キーボードに手を出している方の中には同じ動機の方が少なくないんじゃないでしょうか。というのも、国内で販売されている自作キーボードキットには、分割タイプが結構多いです。例えばもっともポピュラーであろう Helix や、 Ergodox のような配列の iris があります。

* [Helix キーボードキット | 遊舎工房](https://yushakobo.jp/shop/helix-keyboard-kit/)
* [Iris Keyboard - PCBs for Split Ergonomic Keyboard – Keebio](https://keeb.io/products/iris-keyboard-split-ergonomic-keyboard?variant=8034004860958)

昨年末話題になった freee さん社内の自作キーボード事情に関する記事でも、人気トップ2がこの2種でした。

<iframe src="https://hatenablog-parts.com/embed?url=https%3A%2F%2Fdevelopers.freee.co.jp%2Fentry%2Fkeyboards-2018" style="border: 0; width: 100%; height: 190px;" allowfullscreen scrolling="no" allow="autoplay; encrypted-media"></iframe>

市販品の選択肢が非常に限られていたのに対して、自作界隈では分割キーボードがよりどりみどりです。はじめのうちは気になる機種をいくつか試しに眺めているだけでしたが、魅力的なものが非常に多く、なんとか頑張れば自作でイケるんじゃないかという思いが強くなりました。ただ、一方で先の freee さんのエントリーにおいても上手く作れない方の話が載っていたりして、不安があったのも事実です。 DIY だと市販のキーボードより安くなりそうに思えるところですが、実際のところ自作キーボードキットは1万円以上のオーダーで売られているので、別に金銭面でのメリットがあるわけではありません。1万数千円のキットを買って、はんだ付けに失敗して使えなくなったらまぁショックですよね。


## Lily58 Pro

冒頭に書いたとおり、最終的に Lily58 Pro を選びましたが、私の条件は以下でした。

* Low Profile
* キー数は60前後
* 可能であれば ~~Ergonomic 配列~~ Column Staggered 配列
* OLED あり

持ち運びを前提に考えているため、より薄型を実現できるロープロファイルがまず必須条件です。その点、当然キー数も抑えればそれだけ小型になりますが、数字キーすら排除したいわゆる 40% キーボードは使いこなせる自信がなかったので選択肢から外しました。分割じゃないですけど、 VORTEX CORE とかちいさかわいくて好きなんですけどね。


<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B075FWF9RW/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/412H6dZvqUL._SL160_.jpg" alt="VORTEX CORE メカニカルミニキーボード 英語US配列 47キー Cherry MX 赤軸 VTG47REDBEG" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B075FWF9RW/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">VORTEX CORE メカニカルミニキーボード 英語US配列 47キー Cherry MX 赤軸 VTG47REDBEG</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 19.04.25</div></div><div class="amazlet-detail">ヴォーテックス (Vortex) (2017-09-07)<br />売り上げランキング: 12,716<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B075FWF9RW/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

~~Ergonomic 配列~~ Column Staggered 配列と書いていますが、より正確に言えば親指にキーが多く配置されているものです。 Helix のような完全な格子配列ではなく、 Ergodox 系の親指用のキーが少し飛び出て配置されている感じ。 OLED というのは Helix にも付いている、マイコンボード（ProMicro）の上に付けた 32 x 128 の小さなディスプレイで、キーボードの情報やなにか画像を表示したりして遊ぶことができます。まぁこれは完全に好みです。せっかくなら遊べるほうがいいなと。

それら条件すべてに合致したのが Lily58 Pro でした。先の iris などもとてもよかったんですが、 Lily58 はちょうど遊舎工房さんに在庫があるということだったので、実店舗できちんと確かめながらパーツを買えそうだったというのもあり、それにしました。キースイッチがはめ込み式で、後から別のスイッチへ変更することもできるようになっているのも魅力でした。私が遊舎工房に行ったときはちょうど目当てだった Kalih Low Profile Choc の赤軸が在庫切れだったんですが、「取りあえず他の軸を買って、あとから赤に替えることもできますよ！」と店員さんに教えてもらいました。完全に沼という感じがします。ちなみに茶軸にしました。

<a href="https://gyazo.com/c38ce1ac5a855d063c9a3d81af3c10b8"><img src="https://i.gyazo.com/c38ce1ac5a855d063c9a3d81af3c10b8.jpg" alt="Image from Gyazo" width="400"/></a>

その後事前の心配もどこへやら、5時間ほどで無事に組み上げることができたのですが、そのあたりの「製作編」についてはまた別エントリーで書こうかなと思います。

