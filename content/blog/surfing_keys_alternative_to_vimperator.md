+++
title = "cVim から SurfingKeys へ移行した"
date = 2020-03-13T09:25:32+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

ブラウザをキーボードだけで操作するツールが好きだ。かつては Vim like なキーバインドをもたらしてくれる Firefox 向けの Vimperator を愛用していたが、その開発停止後は Chromium 拡張機能の「cVim」を Vivaldi 上で長らく使っていた。しかし残念ながらこちらも開発が停滞しており、先日 Chromium の仕様変更に伴い、ついに看過できない動作上の不具合が起きてしまった。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/1995eaton/chromium-vim/issues/726" data-iframely-url="//cdn.iframe.ly/ZsDRvm3"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

`Hint-a-Hint` と呼ばれるコア機能がある。 `f` を押下するとページ内の各リンクにユニークなアルファベットが割り振られ、そのアルファベットを押下するとそのリンク先へ遷移できる（下図参照）。キーボードだけでのブラウジングを行う上で欠かせない機能なのだが、これが使えなくなってしまった。

<a href="https://gyazo.com/5a1764e7f9dbe36f6a7a7ee77898cbb5"><img src="https://i.gyazo.com/5a1764e7f9dbe36f6a7a7ee77898cbb5.png" alt="Image from Gyazo" width="600"/></a>

その後有志が fork で修正バージョンを公開したり、 cVim 自体の開発引き継ぎを表明する方が現れたりもしているが、先行きが不透明であるため [SurfingKeys](https://github.com/brookhong/Surfingkeys) という別の拡張へ乗り換えることにした。

## SurfingKeys

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://chrome.google.com/webstore/detail/surfingkeys/gfbliohnnapiefjpjlpjnehglfpaknnc" data-iframely-url="//cdn.iframe.ly/7o3UxEU"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

名前に「Vim」と入っていないためか今までノーマークだった。 cVim の開発停滞を危惧する以下の issue の中で代替候補として挙げられており、それで初めて知った。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/1995eaton/chromium-vim/issues/723" data-iframely-url="//cdn.iframe.ly/sjGRH1V"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

知名度の高い代替としては [Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb) なども存在するが、自分の中でキラーとなっていた以下機能をいずれも搭載していなかった。逆に言えば、探した中では SurfingKeys がこれらの機能を唯一網羅していた。

### Emacs Keybind

Vim じゃねーのかという話なのだが、 `<input type="text">` なフォーム上で、 bash などで使える文字列編集のショートカットの話である。例えば `Ctrl-w` で直前の単語削除、 `Ctrl-a` で先頭までカーソル移動など。これが Vimperator にも cVim にも搭載されていて便利だったのだが、よくよく考えると Vim とは何の関係もないので、他の Vim like key bind 系の拡張には搭載されていなかった。

あるいはこの機能だけ他の拡張を使ってもいいのだが、それも見つからなかった。なんなら cVim からこの部分だけ抜き出して独自拡張作ろうかと思った（けど挫折した）ぐらいには依存している。

### JavaScript への keymap 設定

任意の JavaScript 無名関数へ keymap を設定し、詰まるところブックマークレットをキーボードで呼び出すというもの。ブックマークレットというのも死語になった印象があるが、 Pocket にページを保存するときなどによく使う。

正直なところ、一番のコアはこれではないかという思いがある。 JavaScript を書いてそれに自在な keymap ができるのであれば、実質的にあらゆるブラウザ操作に自ら Keymap が可能ということになる。 Vimium はこのあたり「行儀がよい」という言い方でいいのか、すでに Vimium 内で搭載されている機能に対して、別の Keymap を割り当てるということしかできない。

### 設定の外部化

キーマッピングツールは自分で独自のキーマップを設定できるようになっているものが多い。 Vimperator はローカルのファイルを、 cVim は GitHub Gist の URL を指定することで、外部ファイルから設定を読めるようになっていた。これと同等のものが欲しかった。

## 設定

ということで当然ながらカスタマイズしつつ使っているのだが、そのうち目星そうなものについて書いていく。主に Vimperator や cVim に存在していた機能を再現したものが多い。

設定は GitHub Gist に書いたものを読み込ませる機能があり、それを活用している。 URL を指定する際には Gist の `raw` の URL を指定しなくてはならない点に注意が要る。リンクは [こちら](https://gist.github.com/chroju/2118c2193fb9892d95b9686eb95189d2) 。

### `p`, `P` による URL ペースト

Vimp, cVim から引き継いだ機能。 `p` や `P` を押下したとき、クリップボードに URL が含まれていればその URL に遷移させる。文字列に `http` が含まれなければ検索結果を表示するようにしている。

```javascript
// paste URL
mapkey('p', 'Open URL in clipboard', function() {
    Clipboard.read(function(response) {
        var markInfo = {
            scrollLeft: 0,
            scrollTop: 0
        };
        markInfo.tab = {
            tabbed: false,
            active: false
        };
        if (response.data.indexOf("http") == 0) {
            markInfo.url = "https://www.qwant.com/?r=JP&sr=ja&l=en_gb&h=0&s=1&a=1&b=0&vt=0&hc=1&smartNews=1&smartSocial=1&theme=1&i=1&donation=1&q=" + encodeURIComponent(response.data);
        } else {
            markInfo.url = response.data;
        }
        RUNTIME("openLink", markInfo)
    });
});
mapkey('P', 'Open clipboard URL in new tab', function() {
    Clipboard.read(function(response) {
        var markInfo = {
            scrollLeft: 0,
            scrollTop: 0
        };
        markInfo.tab = {
            tabbed: true,
            active: true
        };
        if (response.data.indexOf("http") == 0) {
            markInfo.url = "https://www.qwant.com/?q=" + encodeURIComponent(response.data);
        } else {
            markInfo.url = response.data;
        }
        RUNTIME("openLink", markInfo)
    });
});
```

### Quick mark

もともとは Vim の mark を意識した Vimperator の機能だったと記憶している。任意の URL にアルファベット1文字（例えば amazon.co.jp に `a` ）を割り当てておいて、 `goa` で現在のタブに、 `gna` で新しいタブにその URL を開いてくれる。つまりはブックマークを素早く呼び出すものである。

これは実装されている方のブログがあったので、それをそのまま使わせていただいた。ただ最近はよく使うウェブサービスを全部 [Station](https://getstation.com/) に載せるようにしているため、ブックマーク的によく行くページというのが GitHub ぐらいしかない状況にはなっていると今回改めて気付いた（ GitHub は複数のページを同時に開きたい場合が多く、1サービス1タブが基本の Station 上だと不便）。

<div class="iframely-embed"><div class="iframely-responsive" style="padding-bottom: 75%; padding-top: 120px;"><a href="https://fewlight.net/20200225/" data-iframely-url="//cdn.iframe.ly/pDLSUTj"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

### ブックマークレット

以下の書き方で JavaScript の無名関数にキーをマッピングできる。

```javascript
mapkey('<Key>', '<Description>', function(){
    // some code
});
```

登録しているものは先述の Pocket 登録のほか、 Amazon の URL から様々なクエリ文字列を削ぎ落として綺麗にするためのもの、 markdown 等特定形式での URL コピーなどいろいろ。

### theme

ominibar と呼ばれるコマンド入力用のバーが実装されているのだが、その CSS を好きにカスタムできる。デフォルトが白いのだがダークな感じがいいな、と探していたところ、カラーテーマ Dracula にインスパイアされたものが見つかったので、使わせてもらっている。

https://gist.github.com/emraher/2c071182ce0f04f3c69f6680de335029

## 機能

ところでこの SurfingKeys 、恐ろしく多機能らしく全部は使いこなせていない。例えば Markdown をクリップボードに入れた状態で特定のキーを押すと HTML プレビューしてくれる機能、自動スクロールしながらページ全体のスクリーンショットを撮ってくれる機能などがあるらしい。が、そこまでは使えていなくて、 Vimperator や cVim でやっていたことが引き継げればいいかなという感覚で使っている。

