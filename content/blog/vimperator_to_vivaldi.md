+++
date = "2017-02-15T23:30:43+09:00"
description = ""
title = "VimperatorからVivaldi + Vimiumへ乗り換える"

+++

Firefox 51から、Vimperatorの一部機能が使用できなくなる状態が発生した。これについてはGitHub上でFixが進んでいるが、2017-02-15現在だとまだ修正版の公開までには至っていない。

* [Issues · vimperator/vimperator-labs](https://github.com/vimperator/vimperator-labs/issues?utf8=%E2%9C%93&q=is%3Aissue%20FF51)

もう数年間vimpを使っている身として、一時は修正版を待とうかとも思ったのだが、[今年11月からWebExtentionに移行する](http://internet.watch.impress.co.jp/docs/news/1031773.html)際にも同様の混乱が様々ありそうだし、代替策の模索を始めた。

Why Vivaldi ?
----

とはいえ、今の時代に代替となるブラウザはほぼChrome一択になってしまう。ChromeにもVimライクなKey configを実現する[Vimium](http://internet.watch.impress.co.jp/docs/news/1031773.html)があり、触れたこともあるのだが、自分はどうもChromeが苦手で移れずにいた。

一番大きいのがUIをカスタマイズする余地がないこと。例えばFirefoxだと多段タブをTab Mix Plusで実現しているのだが、Chromeだとこういったことはできず、大量のタブを開くとファビコンのみの表示に縮小されてしまう。またアドレスバーが上部で固定されているのも、個人的には邪魔くさい。

そこで[Vivaldi](https://vivaldi.com/)を採用しようと考えた。VivaldiはChromeエクステンションが互換動作するのでVimiumも使える上、UIがかなりフレキシブルにカスタマイズできる。

<a data-flickr-embed="true"  href="https://www.flickr.com/gp/chroju/3ZEy43" title="vivaldi"><img src="https://c1.staticflickr.com/1/298/32875812446_92ae4222dc_z.jpg" width="640" height="452" alt="vivaldi"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

多段タブこそできないものの、タブバーを上部ではなく横に表示することで、ファビコンだけに縮小されることは免れた。アドレスバーも要らないと言えば要らないのだが、SSLの確認用途もあるので下部表示へ変更している。

Vimperator to Vimium
----

まずそもそもなのだが、VimiumではVimperatorの完全な代替には成り得ない。Vimperatorの真髄はjavascriptを介してOSの挙動を骨の髄までコマンド操作に置き換えるところにあったわけだけど、Vimiumでコマンド操作可能なのは、あくまでエクステンション内部で定義されているものに限られる。Vimperatorのような好き勝手はできない。

なのでVimperatorで自分にとってのキラーとなっていた機能だけでも移植を検討した。

### Key mapping

key mappingは自由に替えられるので、自分の`.vimperatorrc`に合わせる形で変更した。

なおctrlキーを交えたマッピングを行う場合、ブラウザデフォルトのショートカットと衝突する恐れがあるが、Vivaldiはショートカット定義を自由に替えられるため、キーバインドを解除すれば衝突しなくなる。

```
unmap d
map d removeTab
unmap T
map b Vomnibar.activateTabSelection
map ;t LinkHints.activateModeToOpenInNewForegroundTab
unmap X
map u restoreTab
map @ togglePinTab
map O Vomnibar.activateEditUrl
map l nextTab
map h previousTab
unmap <c-h>
map <c-h> moveTabLeft
map <c-l> moveTabRight
```

### quick marks

Vimのmarkっぽい機能として、VimperatorではURLにmarkを設定できるquickmarks (qmark) という機能があって重宝していた。例えば`q`にQiitaを設定しておくと、`goq`でカレントタブ、`gnq`で新しいタブにQiitaが開く。

Vimiumでは再現できなかったので、現状Vomnibar（ブックマーク、履歴等からインクリメンタルサーチするランチャー）からブックマークを呼ぶ形で対応している。どうもREADMEを読む限りでは`map X createTab http://www.bbc.com/news`といったキーバインドが可能らしいのだが、なぜか上手くいっていない。

### copy.js

[vimperator-plugins/copy.js at master · vimpr/vimperator-plugins](https://github.com/vimpr/vimperator-plugins/blob/master/copy.js)

Pluginになるが、URLやページタイトルを加工して好きな形でクリップボードへ取り込むコマンドを設定できる、copy.jsというものがあった。

こちらも再現はできなさそうなのだが、ブログ等を書くときにMarkdown形式でのURLコピーがどうしてもほしかったので、Vomnibarからbookmarkletを呼ぶ形で対応している。

### commandBookmarklet.js

[vimperator-plugins/commandBookmarklet.js at master · vimpr/vimperator-plugins](https://github.com/vimpr/vimperator-plugins/blob/master/commandBookmarklet.js)

ブックマークレットをコマンドで呼べるPlugin。そもそもVimiumにはコマンドモードがないので土台無理なわけで、Vomnibarから呼ぶという手段に頼るしか無くなっている。

良くも悪くも、以前コマンドモードでやっていたことは、ブックマークレットで再現してVomnibarからどうにかして呼ぶ、という形でだいたいは回避している。

また一方でVivaldiには「クイックコマンド」という機能があって、デフォルトだとF2を押すとVomnibarにも似たランチャーが起動する。ここからブックマーク、履歴、オープンなタブ、設定項目等をインクリメントに呼び出せるので、Vimiumが無くてもある程度キーボードで操作ができたりする。まぁ、インクリメンタルサーチするより、Vimiumの割り当てコマンドの方がタイプ数は少なくて済むので、あまり使ってはいない。

frustrated
----

以上の設定でなんとなく使えてはいるのだが、不満の話も。

* マスターパスワード設定がないので、あまりパスワードを記憶させたくない。
* Firefox Syncのようなブックマーク、エクステンションの同期機能がない。
* http/https以外のプロトコルで開いているタブ上では、Vimiumが効かない。
* Vimiumは`.vimperatorrc`のような設定の外出しが出来ない。

そもそもにして、Firefoxの先を儚んでいるときに、先が不透明な更なるマイナーブラウザに移るという選択もどうかと思ったが、Vivaldiの開発が終わってしまった暁には大人しくChromeに移ろうと思う。
