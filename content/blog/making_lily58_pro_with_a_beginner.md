+++
title = "電子工作初心者が Lily58 Pro を買ってから作って持ち運ぶまで"
date = 2019-04-27T12:41:43+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

[前回の記事](https://chroju.github.io/blog/2019/04/25/how_i_learned_to_stop_worrying_and_love_the_original_keyboards/) を Twitter に載せたところ予想外に RT と fav をちょいちょいいただきまして、もしその流れで「製作編」を楽しみにしていた方がいたらとても申し訳ないなと思っていて、何分前回書いた通り私は電子工作ビギナーもいいところで、今回もだいぶ危なっかしい手順踏みつつもなぜか完成してしまったぐらいの感覚でいるので、これから書くことは参考にはならないかと思います。というか参考にせず別のもっときちんとした方の教えを乞うてください、と予防線を張った上で、初心者が見よう見真似こんな感じでやってみたよ、という体験談として読んでいただければと。

前提を再度書いておきますが、中学校の授業以外でハンダ付けしたことがない超ビギナーが Lily58 Pro という自作キーボードを組み立てたお話です。このエントリーも Lily58 Pro で書きました。

## 買ったもの

お買い物ですが、キーボードキットは遊舎工房さんの実店舗、はんだ付け関連の工具は Amazon とダイソー（？！）を使いました。

### キーボードキット

Lily58 Pro は必要なものがキットになった状態で売られていますので、それを買います。私はロープロファイルである Choc 用のものを買いましたが、 Cherry MX 軸用のバージョンもあります。基盤は共通で、キーソケットを変更することでどちらにも対応するようなキットになっています（一度キーソケットをはんだ付けしたら変更はできないです）。

* [Lily58 Pro | 遊舎工房](https://yushakobo.jp/shop/lily58-pro/)

他に必要なものはキースイッチ、キーキャップ、左右のキーボードを結ぶ [TRRSケーブル](https://yushakobo.jp/shop/trrs_cable/) 、パソコンと接続するための micro USB ケーブルです。いずれも遊舎工房さんに置いていて、店員さんが必要なものをピックアップしてくれたので助かりました。

キースイッチは、現在遊舎工房さんに取り扱いがあるのは赤軸（リニア）、茶軸（タクタイル）、白軸（クリッキー）の3種類で、私が行ったときには赤軸が在庫切れになっており、白軸はオフィスで使うには適さないため茶軸としました。結果的に快適に使えているので、他の軸に替える必要もなさそうです。荷重はいずれも 50g ですが、もっと重いものが欲しい場合には海外通販になりますが、 NovelKeys などで購入できます。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://novelkeys.xyz/products/novelkeys-x-kailh-low-profile-heavys" data-iframely-url="//cdn.iframe.ly/ZiLjTit?iframe=card-small"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

## 工具

Amazon で以下のものを購入しました。はんだごては温度調節機能があったほうがよいという話だったので、それを満たす上で高すぎないものとしています。作業マットは正直よくわからなかったものの、難燃性っぽいものを買っています。少しゴムの匂いが強くてしんどかったです。ボンドガン（グルーガン）については後述します。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B006MQD7M4/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/41lybXoY2YL._SL160_.jpg" alt="白光 ダイヤル式温度制御はんだこて FX600" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B006MQD7M4/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">白光 ダイヤル式温度制御はんだこて FX600</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 19.04.27</div></div><div class="amazlet-detail">白光(HAKKO) (2012-01-18)<br />売り上げランキング: 145<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B006MQD7M4/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B0016V7JOC/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/41ay2mKLMQL._SL160_.jpg" alt="goot はんだこて台 ST-11" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B0016V7JOC/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">goot はんだこて台 ST-11</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 19.04.27</div></div><div class="amazlet-detail">太洋電機産業(goot) <br />売り上げランキング: 343<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B0016V7JOC/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B002L6HJ9G/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/319e2DQ2dEL._SL160_.jpg" alt="エンジニア 卓上導電マット A4サイズ 230×330×2mm ZCM-05" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B002L6HJ9G/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">エンジニア 卓上導電マット A4サイズ 230×330×2mm ZCM-05</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 19.04.27</div></div><div class="amazlet-detail">エンジニア(ENGINEER) <br />売り上げランキング: 16,687<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B002L6HJ9G/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B001PR1KPG/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/51zS%2BBizlfL._SL160_.jpg" alt="goot はんだ吸取り線 CP-2015" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B001PR1KPG/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">goot はんだ吸取り線 CP-2015</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 19.04.27</div></div><div class="amazlet-detail">太洋電機産業(goot) <br />売り上げランキング: 2,543<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B001PR1KPG/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B003EILCG6/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/41FvMv7Rs1L._SL160_.jpg" alt="SK11 ボンドガン ピタガン 木材 紙 皮革 プラスチック用 GM-100" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B003EILCG6/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">SK11 ボンドガン ピタガン 木材 紙 皮革 プラスチック用 GM-100</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 19.04.27</div></div><div class="amazlet-detail">SK11(エスケー11) <br />売り上げランキング: 3,044<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B003EILCG6/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

はんだは、これがいいのかどうかわかんないんですけど、ダイソーにもあるという話を聞いて行ってみたら本当にあったので、それを使っちゃいました。練習用にだけ安いのを取りあえず使おうという魂胆だったんですが、練習しているうちに「意外になんとかなりそう？」という気持ちになり、そのまま本番でも使ってしまいました。はんだの良し悪しは自分にはわからないですけど、100均で本当によかったのかなというのは若干不安です。ちなみに 1.0mm 径を使っていますが、細かい部品もあるので 0.8mm 径のほうが使いやすかっただろうなと思ってます。

<a href="https://gyazo.com/699cae5af37726f228c13880c8a2f80f"><img src="https://i.gyazo.com/699cae5af37726f228c13880c8a2f80f.png" alt="Image from Gyazo" width="600"/></a>

またこれ以外に、ピンセットとプラスドライバーは家にあるもの（何年か前にミニ四駆やったときに買った）を使っています。 Lily58 Pro はリード線を切るような機会はないため、ニッパーは不要です。

## はんだ付け

ぶっつけ本番はさすがに嫌だったので、はんだ付け練習キットのようなものがあればと思い Amazon で探したのですが、そこまで親切に（例えば説明用冊子が付いているとか）なっているものは見つけられず、コンデンサーや抵抗器がじゃらじゃら突っ込んであるセットがいくつかあったので、その中から適当なものを選びました。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B00ODZOMHK/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/511Lqo5RHZL._SL160_.jpg" alt="基板 半田 付け 練習 キット 部品 付 5 セット 組み" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B00ODZOMHK/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">基板 半田 付け 練習 キット 部品 付 5 セット 組み</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 19.04.27</div></div><div class="amazlet-detail">nobrand <br />売り上げランキング: 125,367<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B00ODZOMHK/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

ネットでいくつか資料を読んで、基板に適当に何度かはんだ付けを試しました。どれぐらいはんだを流し込めばいいのか、多くは 1〜2 mm と書かれているのですが目測でいまいちよくわからないし、感覚を掴むまで少し苦労しました。とりあえず盛り盛りにする必要はないししても意味はないということと、はんだを流し終えて離したあとも1, 2秒程度はこてを当てている必要があり、長く当てすぎてもよろしくないということを学びました。中学の頃にはんだが白くくすんだようになることが多かったんですが、その理由が「熱し過ぎによる酸化」であることを初めて知るなどしました。

参考にした資料は以下のものです。

* [理想のはんだ付け | はんだ付けテクニックを学ぼう！ | \[HAKKO\]](http://handa-craft.hakko.com/support/good-soldering.html)
* [ハンダ付けなんて簡単だ！ ※PDF](http://mightyohm.com/files/soldercomic/translations/FullSolderComic_JP.pdf)
* [シャドー半田　動画 - YouTube](https://www.youtube.com/watch?v=wo5O6kP6SBU)
* [はんだ付けの詳細.m2p - YouTube](https://www.youtube.com/watch?v=ZA-ehWjRfYM)

## 組み立て

そして組み立てなのですが、なんかですね、はんだ付け練習してたらフロー状態に入ってしまったというか、なんかもうこのままイケるのでは？？？？という謎の自信と早く作りたいという欲求で頭が満たされてしまい、ろくに写真も撮らずにガリガリ進めてしまったので製作工程の様子とかほぼ写真ないんですよね。無事に組み上がったからいいけど、はんだ付け練習したその日によく組み上げたな自分とは思ってます。使っているうちにボロが出るかもしれない。。。

基本的にはビルドガイドがありますので、それに沿ってやるだけではあります。なお、このレポジトリの中に Pro ではない Lily58 のビルドガイドも入ってますので、間違えないように注意が必要です。 Qiita にログを残してくれている方もいたので、そちらの記事も合わせて参考にしました。

* [Lily58/buildguide_jp.md at master · kata0510/Lily58](https://github.com/kata0510/Lily58/blob/master/Pro/Doc/buildguide_jp.md)
* [ゼロから始める自作キーボード Lily58Pro編 - Qiita](https://qiita.com/ebi_fry306/items/28d3d47ea74e0dc42484)

つまずいたポイントとしては最初から少しつまずきまして、ダイオードに向きがあるということをはじめは飲み込めませんでした。暗い写真しか残ってなかったので説明しづらいですが、この下の写真の、両端に端子が付いた四角い小さな部品がダイオードなわけですが、小さい上に黒い表面にグレーの線で向きが示されているので、最初はそれを目視できず何分か悩みました。完全に電子工作初心者丸出しです。視力に自信がなければルーペがあってもいいかと思います。

<a href="https://gyazo.com/3893851c7e5590eb4c543b26dba076c1"><img src="https://i.gyazo.com/3893851c7e5590eb4c543b26dba076c1.png" alt="Image from Gyazo" width="600"/></a>

あとは「ジャンパ」という単語の意味がわからなかったり（はんだで複数の端子を繋げることみたいです）。 OLED 取り付けの手順はオプション故か端折られていたので、以下の記事を参考にさせてもらいました。

* [電子工作初心者がおくる自作キーボード制作ガイド【Helix】　前編](http://learningoctopus.com/helix_keybord_buildguide1)

### Pro Micro の固定

1つビルドガイドにない手順として、先の Qiita 記事に言及がある、 Pro Micro の micro USB 端子固定作業を追加で行いました。固定は記事をそのまんま参考にしてグルーガンを使いましたが、普通の強力接着剤でも良いような気がしています。不安だからと盛りすぎると、他のパーツに干渉して組み立てが難しくなるので注意です。自分は少しだけやすりで削る羽目になりました。

同じパーツをいくつもはんだ付けしていくので途中集中力も切れかけましたが、休憩を入れながら5〜6時間ほどで組み立てはおわりました。


## ファームウェアの書き込み

組み上がったらファームウェアを自分で書き込む必要があります。多くの自作キーボードでは [qmk/qmk_firmware: keyboard controller firmware for Atmel AVR and ARM USB families](https://github.com/qmk/qmk_firmware) というものを使っているようで、 Lily58 Pro の場合もこれを使います。コマンドとしてはレポジトリを `git clone` してきて `cd` し、以下を打つだけです（前提として必要になるライブラリを `brew install` しておかなくてはならないので、それについては qmk_firmware のマニュアルを参照してください）。

```bash
$ make lily58/rev1:default
$ make lily58/rev1:default:avrdude
```

最初のコマンドでファームウェアをビルドし、2つ目のコマンドで書き込みます。従って2つ目のコマンドを打つ際にはキーボードを接続してある必要があります。2つ目のコマンドを打つと、以下のように reset 待ちになるので、キーボードのリセットボタンを押せばファームウェアが書き込まれます。左右それぞれで書き込み作業を行う必要があります。

<a href="https://gyazo.com/471b930c2bf43614c6f84f609d021b92"><img src="https://i.gyazo.com/471b930c2bf43614c6f84f609d021b92.png" alt="Image from Gyazo" width="600"/></a>

### キーマップ

qmk_firmware の中にキーマップを定義しているファイルがあるので、これを書き換えることでキーマップを変更できます。ファイルは `keyboards/lily58/keymaps/default` の中にあるので、これをコピーします。

```bash
$ cp -R keyboards/lily58/keymaps/{default,chroju}
```

中に `keymaps.c` があるので、これを書き換えれば OK です。ソフトウェアエンジニアであれば、中を覗けば察しはつくと思います。指定できるキーコードは [Keycodes - QMK Firmware](https://docs.qmk.fm/#/keycodes) を参考にします。私が大きく変更した点としては、 `Delete` をフルキーボードのように右上に配置したのと、 Lower のときに 1 を F1 、 2 を F2 という形でわかりやすいように割り当てたあたりでしょうか。記号キーについてはまだ模索しています。

ビルドと書き込みについては、先のコマンドの `default` をコピー後のディレクトリ名に替えるだけです。

```bash
$ make lily58/rev1:chroju
$ make lily58/rev1:chroju:avrdude
```

### OLED

<a href="https://gyazo.com/d5ae8514c92841e9bf6c119cae575162"><img src="https://i.gyazo.com/d5ae8514c92841e9bf6c119cae575162.png" alt="Image from Gyazo" width="450"/></a>

OLED ですが、デフォルトだと入力したキーがそのまま表示されるようになっており、パスワード入力中など困りそうだったので、少し表示する内容を変更しました。 [Lily58 Proのディスプレイ表示(OLED)を改造してみる - エンジニアの醤油漬け](http://ubansi.hatenablog.com/entry/2019/03/21/223613) を大いに参考にさせていただき、1分あたりのタイプ数をタイプスピードとして表示するようにしています。C言語は初めて書いたんですが、 Pro Micro というか Pro Micro が互換性を持つ [Arduino が sprintf で float の表示に対応していないこと](https://stackoverflow.com/questions/27651012/arduino-sprintf-float-not-formatting) を知らず、1時間ぐらいハマったりしました。

```c
#include <stdio.h>
#include "lily58.h"

char typespeed_msg[64];
uint32_t type_count = 0;

void set_typespeed(void){
    type_count++;

    uint32_t uptime_millsec = timer_read32();
    uint32_t minutes = uptime_millsec / 60000;
    if (minutes == 0) {
      minutes = 1;
    }
    float type_speed = (float)type_count / minutes;

    char str_type_speed[12];
    dtostrf(type_speed, 6, 2, str_type_speed);

    snprintf(typespeed_msg, sizeof(typespeed_msg), "Speed: %s keys/m", str_type_speed);
}

const char *read_typespeed(void) {
  return typespeed_msg;
}
```

また右側の OLED は [HelixのOLED表示を簡単にカスタマイズするサービスを作った - Qiita](https://qiita.com/guri3/items/844675b637c88515a989) を使ってカスタマイズし、黒地に白で表示してカッコよさそうなもの、というところでパッと思い浮かんだロゴを表示してます。 UNDERTALE は2周しただけでそこまで思い入れがあるわけでもないので、いいアイデアが浮かべばまた変更します。こういうカスタムができるので OLED 付きのキーボードにしたのは正解でした。本当は日付とかも表示したいんですけど、 Arduino がクロック持っていないので仕方ないとこですね。。

<a href="https://gyazo.com/33cdc50c077aa3a2797c6221ce7a7b51"><img src="https://i.gyazo.com/33cdc50c077aa3a2797c6221ce7a7b51.png" alt="Image from Gyazo" width="450"/></a>


## 完成

<a href="https://gyazo.com/5258d45614fee3f2a9db76d908b960f9"><img src="https://i.gyazo.com/5258d45614fee3f2a9db76d908b960f9.png" alt="Image from Gyazo" width="600"/></a>

ちゃんと動かない可能性は多少覚悟していたんですが、思ったよりあっさりと動いてほっとしました。何日か使って仕事にも使ってみましたが、いまのところ特に問題はないです。というか打ち心地もよくて素晴らしいです。めちゃくちゃ気に入ってます。キー数が減ったのでタイポはまだ多く、慣れが必要だと感じています。

<a href="https://gyazo.com/56691d0cc3be6a1a4844b87b8b55fa2c"><img src="https://i.gyazo.com/56691d0cc3be6a1a4844b87b8b55fa2c.png" alt="Image from Gyazo" width="600"/></a>

<a href="https://gyazo.com/67c3fa0eec3a7cb4d3fe42c0ee618882"><img src="https://i.gyazo.com/67c3fa0eec3a7cb4d3fe42c0ee618882.png" alt="Image from Gyazo" width="600"/></a>

Barocco MD600 と比べるとだいぶ薄くなりました。ところで左の親指のところにまさかの Caps Lock がハマっていますが、 2U の無刻印キーキャップを持っていないだけで、実際はスペースキーです。

<a href="https://gyazo.com/fc40548d466b0b452e8116a4755c6d31"><img src="https://i.gyazo.com/fc40548d466b0b452e8116a4755c6d31.png" alt="Image from Gyazo" width="600"/></a>

持ち運びには[無印良品のナイロンブック型ポーチ](https://www.muji.net/store/cmdty/detail/4549738743835)を使っています。コードを収納できるポケットもあり、メッシュポケットに片側を入れられるので、2つのキーボードが擦れあってアクリルが傷つく心配もなく、 Lily58 のために作られたのではないかと思うぐらいピッタリでびっくりしました。

以上、ビルドログでした。なかなか作業は大変でしたが、仕上がったとき、実際動いたときの満足感は最高に気持ちよかったですし、出来上がりにもとても満足しています。もう1個、2個と作りたいかと言うとどうだろうなーという感じではあるんですけど。
