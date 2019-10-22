+++
title = "VSCode と TeX で大学のレポートを書く"
date = 2019-06-24T16:57:55+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

大学のレポートを書くにあたって、約10年前に文系大学に通っていた頃は Google Docs を使っていたので、今回もそれでいいかと考えていたのだが、情報系のレポートということで数式を買いたりする必要もあり、 Google Docs だと何かと不便だった。そこで理系が数式を書くのに使うと聞いたことある TeX なるものを使えるのではないかと思い、まったく知らないところから調べて使ってみた。

## TeX とは

正直 TeX が何なのかがわかっていない。調べると「組版システム」と出てくるのだが、システムという単語が多義的すぎてよくわからない。言語の名前なのか TeX 記法で書いたテキストを PDF などに変換するソフトウェアなのか何なのか。

取りあえず理解しているのは元々の TeX はオープンソースであり様々な拡張（ディストリビューション）が出ており、そのうち1つに LaTeX と呼ばれるより手軽に扱える実装があること。日本語対応の TeX, LaTeX もまた拡張の1つという形であったこと、程度。

## クラウドの TeX エディタ

始めは Google Docs からの乗り換え検討という形だったので、クラウドエディタがあればいいと発想していた。探してみたところ、2つほど見つかった。

* [Cloud LaTeX | Build your own LaTeX environment, in seconds](https://cloudlatex.io/)
* [Overleaf, Online LaTeX Editor](https://www.overleaf.com/)

Cloud LaTeX は国内のポスドク向け就転職サイトを運営するアカリクという会社が管理していて、使っている学生も多いように見受けられた。一方の Overleaf は海外のサービスだが、やりようによっては日本語も使えるらしい。

しかしよくよく考えると Visual Studio Code で書きたいし、普通に手元で書いて GitHub で管理すればええやんという結論になって、いずれも採用を見送った。

## Visual Studio Code の TeX 環境構築

### MacTex のインストール

macOS の場合は MacTeX というものがあるので Homebrew Cask でインストールする。

```bash
$ brew cask intall mactex
```

MacTeX は TeX Live というディストリビューションを含んだ macOS 向けの GUI などの集合らしい。ということで TeX Live としての初期設定を行う必要がある。まず、各種コマンド群に対して PATH を通す。

```bash
$ export PATH=$PATH:/usr/local/texlive/2019/bin/x86_64-darwin
```

続いて TeX Live 内の各種パッケージを管理する `tlmgr` コマンドで、 TeX Live を最新にアップデートしておく。

```bash
$ sudo tlmgr update --self --all
```

これで使えるようになった。 TeX ファイルをコンパイルするには `ptex2pdf` コマンドを使えばいい。

```bash
$ ptex2pdf -l example.tex
```

### VSCode の設定

拡張機能 LaTeX Workshop を使う。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/James-Yu/LaTeX-Workshop" data-iframely-url="//cdn.iframe.ly/Wze91sK"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

デフォルトの状態でもシンタックスハイライトやサジェストの機能が使えるが、 VSCode 内でコンパイルしたりするには `settings.json` にコンパイル用のコマンドを記入したりする必要がある。自分の場合は以下のように設定している。

```json
"latex-workshop.latex.tools": [
    {
        "name": "ptex2pdf",
        "command": "ptex2pdf",
        "args": [
            "-l",
            "-ot",
            "-kanji=utf8 -synctex=1",
            "%DOC%"
        ]
    }
],
"latex-workshop.latex.recipes": [
    {
        "name": "ptex2pdf",
        "tools": [
            "ptex2pdf"
        ]
    }
],
"latex-workshop.message.log.show": true,
"latex-workshop.message.badbox.show": true,
"latex-workshop.latex.autoClean.run": "onBuilt",
"latex-workshop.latex.autoBuild.run": "onFileChange",
"latex-workshop.view.pdf.viewer": "tab",
```

ビルド用のコマンドを定義するのは `latex-workshop.latex.tools` と `latex-workshop.latex.recipes` の部分。 `tools` で実行するコマンドを定義する。VSCode のコマンドから呼べるのが `recipe` と呼ばれ、 recipe と tools を紐つけるための設定が `latex-workshop.latex.recipes` になる。ここでは tools と recipes いずれも同じ名前にしてしまったのでわかりづらいが、 VSCode のコマンドパレットで `ptex2pdf` という recipes を実行すると、 tools の `ptex2pdf` で定義したコマンドが実行される、という形になる。

コマンドは先述の通り `ptex2pdf` で、 `-l` は LaTeX フォーマットを使うことを明示するオプション、　`-kanji=utf8` は漢字を使う上で必要なオプション、 `-synctex=1` は TeX のエディタと PDF ビューアを一緒に開いているとき、相互に位置ジャンプできるようにしてくれるらしい。 `-kanji` と `-synctex` は TeX の追加オプションなので、これらを使うために `-ot` が必要になる。 

その他の設定は [Wiki](https://github.com/James-Yu/LaTeX-Workshop/wiki/Compile) を見ればわかるが、順に以下の意味。

* エラーメッセージがエディタ内に表示されるようになる
* エラーメッセージが「問題」パネルに表示されるようになる
* TeX のコンパイル時に自動生成される `.aux` ファイルなどをビルド時に自動削除する
* ファイルに変更を加えたときに自動でコンパイルする
* TeX からコンパイルした PDF を VSCode のタブで表示する

これでこんな感じで PDF プレビューを見ながらレポートが書けるようになった。

<a href="https://gyazo.com/3b01c439a1899793741277dead1f3f5f"><img src="https://i.gyazo.com/3b01c439a1899793741277dead1f3f5f.png" alt="Image from Gyazo" width="1184"/></a>

左側のメニューに「TeX」アイコンも追加されるので、ここから各種コマンドを実行することもできる。コンパイルが上手くいかなかった場合はここから `Terminate current compilation` を実行すれば、コンパイルを一旦中止できる。

### GitHub での管理

TeX ファイルは GitHub のプライベートレポジトリで管理している。これはまぁ、普通に管理するだけなので難しいことはない。

ワープロソフトを使っていると、印刷したときに正しく表示できるよう装飾面にも気を遣わなくてはならなくて面倒だったんだけど、 TeX だとマークアップさえしておけばいい感じの見た目にしてくれるので、本文を書くことに集中できてとてもいい。数式を書くための組版システム、という位置付けだとは思うが、文系でも使って利があるものだと思う。
