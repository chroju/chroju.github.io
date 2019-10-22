+++
categories = "Windows, 情報／タスク管理"
comments = true
date = "2015-07-04T00:00:00+09:00"
title = "Windows開発環境を整える話と、メモアプリとして最強であるwasaviの話"

+++

職場のWindows PC、いろいろと開発用に整備を進めてはいるが、やはりWindowsだとツラミある。

Chocolatey
---

Windowsでのパッケージ管理。不可欠かというとそうでもないとは思うのだが、アップデート含め一括管理が可能なので、精神衛生上良さそうだという意味で使ってみている。どうでもいいが名前がかわいい。

インストール自体はPowershellからワンライナーを叩くだけなので難しくはないのだが、よくわからないエラーで止まることが多くて、現状使い切れてない。Proxyの設定はしたし、powershellの権限も`RemoteSigned`にしたのだけど、何がいけないのか。。。

```
 Unable to index into an object of type System.IO.FileInfo.
 発生場所 C:\ProgramData\chocolatey\helpers\functions\Write-ChocolateyFailure.ps
 1:24 文字:8
 +   throw <<<<  "$failureMessage"
     + CategoryInfo          : OperationStopped: (Unable to index...em.IO.FileI
    nfo.:String) []、RuntimeException
     + FullyQualifiedErrorId : Unable to index into an object of type System.IO
    .FileInfo.
The install of clover was NOT successful.
Error while running 'C:\ProgramData\chocolatey\lib\Clover\tools\chocolateyInstall.ps1'.
 See log for details.
```

### 参考

[windowsの開発環境は一瞬で整うwith chocolatey - Qiita](http://qiita.com/himinato/items/11f4dc9a23afebbc242c)

コンソール
---

cmdだと貧弱貧弱ゥ！なので、とか、bashコマンド試し打ちしたい場合が多いとか、そういう理由でコンソールは入れ直す。

Gitを入れると自動的にGit bashが入るので、コマンド環境としてはこれを使っている。ターミナルアプリは最近ちょっと話題になっていたのでConEmuを入れてみた。もちろんChocolateyで。

- Font charsetを「Shiftjis」に設定
- フォントは[Ricty Diminished](http://github.com/yascentur/RictyDiminished)を利用
- lsで日本語が化けるので`~/.bashrc`に`alias ls='ls --show-control-chars --colors'`を設定

### 参考

[ConEmuの初期設定(日本語表示環境を構築) - Diary on wind @astra.dat](http://astra.digi2.jp/a/e/setup-conemu-as-japanese-cmd.html)
[Ruby - 【無理】WindowsのコンソールでUnicodeを使いたい - Qiita](http://qiita.com/ironsand/items/ec0675644a55a69855d6)

Windowsで開発する場合の最大のネックは、CLIの貧弱さ以上にcp932にあると思うの。

AutoHotkey
---

キーバインド変えたいことが多いので愛用。とりあえず`<ESC>`と間違えて隣の`F1`押してヘルプ出てしまうことが多いので、`F1`は潰している。

```autohotkey
F1::Return
```

あとOutlookの使い勝手があまり好きではないので、配布されていたGmailライクなキーバインドを実現する設定を使わせていただいている。しかしOutlook2013、差出人名の表示がやたらでかかったり、フォルダのツリー表示が文字だけ（アイコンとかツリーを表す罫線がない）になっていて見づらかったり、UI面で難がありすぎる。。。

### 参考

[GmailKeys for Outlook 2013 - Scripts and Functions - AutoHotkey Community](http://www.autohotkey.com/board/topic/102227-gmailkeys-for-outlook-2013/)

メモアプリ
---

技術的なことをやってるとどうしてもメモを取る必要性が出てくるのだが、いろんなところに書き散らしていると後から見返せないのでそれなりの整理はしておきたいと常々思う。

元々は自宅だとDropbox + QFixHowm(Vim)、会社だと（あまり技術的な話が多くなかったので＆クラウド系アプリは使えなかったので）別個の環境で同様にQFixHowmを使っていたのだが、比較的技術的なノウハウをとりためることも増えたので、可能なら自宅からも参照できるメモ環境を会社でも作りたいなと思い直している。

個人的に理想としているのはこんな感じ。

* クラウド同期が取れる、可能ならDropboxがいい
* 全文検索ができる
* （可能なら）vimキーバインドが使える
* （可能なら）Markdownプレビューができる

いろいろ検証はしてみたが、どれもしっくり来ていない。なんかないものか。

### Kobito

* Markdownエディタとしては優秀。ハイライトも綺麗。
* vimモードがあってそこそこ快適。若干表示がズレることがあるが、設定いじれば修正は可能かも。
* クラウド同期はできない。あとファイル実体見れないのがなんとなく気持ち悪い。

### Evernote

* Markdownエディタとしては論外。
* アカウントは持っているが、すでにプライベートメモがどっさり入ってるので会社で開きにくい。

### GistBox

* Markdownエディタではないし、フォーム入力なので編集は貧弱。
* GitHub経由で同期取れる点は魅力。
* Gistはスニペット置き場のイメージが強く、文章の保存はしっくりこない。

### Wri.pe

* 今のところ最良と思われる。
* フォーム入力型の編集にはなってしまうが、[Wasavi](https://github.com/akahuku/wasavi)使うことでVimっぽくできる。
* ログインすれば自宅からでもメモは見られるので一応同期可能。
* Dropbox連携はあるが、あくまでバックアップをzipでストックさせるだけなので、家ではVimで編集します、とかはスムーズにできなくて微妙。

### Cirrus Editor

* Dropbox内のtxtファイルをブラウザで直接編集できるのは今のところこれぐらいしか見つからない。
* 新規ファイルの追加ができないので、メモ環境としては使えない。

ひとまずWri.pe使ってますけどだいぶ辛さあります。今日日はやっぱりKobito使ってるエンジニアが多いんだろうか。あるいはメモなんていらない？ うーん。。。

**……と思ってたらWasaviがDropbox連携機能もってた！！！**

<iframe class="bookmarklet hatena-embed" src="http://hatenablog.com/embed?url=http%3A%2F%2Fappsweets.net%2Fwasavi%2F" title="wasavi - appsweets akahuku labs." style="border:none;display:block;margin:0 0 1.7rem;overflow:hidden;height:155px;width:100%;max-width:100%;"><a href="http://appsweets.net/wasavi/" target="_blank">wasavi - appsweets akahuku labs.</a></iframe>

- 連携すると`:write`や`:edit`がWasavi上で使えるようになる。
  - つまりWri.peをWasaviで編集していて、Dropboxにツッコみたくなったら`:write hoge.txt`すればよい。
  - 逆にDropboxのテキストをWri.peに持ってきたければ`:edit fuga.txt`とすればよい。
- さらに`http://qasavi.appsweets.net`につなぐと単独でWasaviをブラウザエディタとして使える。Dropboxのオンラインエディタになる。

ヤバイだろうこれ。。。highlightはさすがに無理とか、Dropbox使えると言っても`ls`は使えないのでファイラとしては微妙とか、そういうのはもろもろあるとは言え、Dropboxのファイルを直接ブラウザ上でVimライクな編集できるってのは恐ろしく便利。単なるVimのエミュレートに留まらず、ブラウザとDropboxのシームレスな連携ができるという点が肝だと思う。Dropboxで書きためていたブログの下書きを、はてなブログの編集画面上で直接呼び出すこともできるわけだ。ちなみにGoogle DriveとOne Note連携もあるので、そちらがお好みであればそちらでも。

これまでぜんぜん見たこともないソフトだったけど、これだいぶいいものなのでは？？？

その他アプリケーション
---

* [Clover](http://www.forest.impress.co.jp/library/software/clover/) エクスプローラーのタブ化
* chrome全盛になりつつある気はするが、Vimp使いたくてFirefox
* VirtualBoxにVagrantはもはや定番
* Outlookの予定表使いづらすぎて辛いんだけど、Exchangeと同期できるアプリでなんか良い代替ないッスか。。。

