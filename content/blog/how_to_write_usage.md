+++
title = "Usage の書き方について標準仕様を探る"
date = 2019-02-19T21:52:03+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

仕事柄オペレーション作業で使う小さなコマンドラインツールを作ることはよくありますが、地味に悩むのが `-h` オプションを使ったときに表示される「Usage」の書き方だったりします。こういうやつ。

```sh
usage: git [--version] [--help] [-c name=value]
           [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
           [-p|--paginate|--no-pager] [--no-replace-objects] [--bare]
           [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]
           <command> [<args>]
```

この括弧の種類と使い方がよくわかっていなくて、どこかで定められた標準があるんであればそれを使いたいなと思い色々調べてみたメモです。

## en.wikipedia

いきなり Wikipedia かよというところではありますが、英語版 Wikipedia に [Usage message](https://en.wikipedia.org/wiki/Usage_message) という項目があって、複数の問題点があるとか指摘が入っていますが参考にはなる内容で、ここに書き方が載っています。以下引用。

```sh
Usage: program [-aDde] [-f | -g] [-n number] [-b b_arg | -c c_arg] req1 req2 [opt1 [opt2]]
```

`-aDde` が引数を取らないオプションで `-n` は取るオプション、 `-f` と `-g` は排他、 `-b`と `-c` は引数を取ってかつ排他、括弧が付いていない `req1` と `req2` は必須オプションで、 `opt2` は `opt1` と一緒に使う必要がある、ということのようです。わかりやすい。ちなみに NetBSD のコーディングスタイルを元にしているとのこと。個人的にはよく見かける書式な気がしますし、これでFAではとも思います。いきなり結論に至りました。

このページ他にも面白いことはいろいろ書いてあって、個人的に気になったのが、この Wikipedia のページで面白かったのが一番下にある「Anti-patterns」というものです。「要出典」扱いになっているので、いずれ消えるかもしれないですが引用してみます。

> A properly written command line program will print a succinct error message that describes the exact error made by the caller rather than printing the usage statement and requiring the user to figure out what the mistake was.

要はエラーメッセージ代わりに「Usage」を出すべきではないという話で、 Usage は `-h` などで明示的に呼ばれたときに限り、 stdout に流せと言っています。これ結構悩むところで、最近のコマンドツールで間違った使い方をしたときに Usage を出してくれるものって実際よくありますし（git もそうですね）、それはそれで親切な気もするんですよね。で、その場合の Usage はあくまでエラーメッセージの一環として表示していて、ユーザーが意図した結果ではないわけで、パイプやリダイレクトに流れてしまっても困るので、自分としては stderr に出すべきかなという思いがあります。 en.wikipedia に書かれた主張もよくわかるんですが、実際どうするべきなんでしょうね。ここもどこかに推奨が書かれてるなら読んでみたい。

## POSIX

他にも探してみますと、 Open Group のページに POSIX.1-2017 での定義が書かれています。

[Utility Conventions](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html#tag_12_01)

ほぼ先程の NetBSD のコーディングスタイルと同一です。なのでやっぱりこれでよさそう。

## docopt

一方で少し毛色の違う定義を書いているのが docopt です。

[docopt—language for description of command-line interfaces](http://docopt.org/)

引数処理を1つずつ実装しなくとも、一定の定義に則った Usage の文章を書くと、それに基づいて引数処理を勝手にやってくれるという便利なライブラリです。いくつかの言語で実装がありますが、 Python で比較的よく見かける気が。

では docopt の Usage 書式を見てみましょうとなるわけですが、これが "docopt is based on conventions that have been used for decades in help messages and man pages for describing a program's interface." と書かれてはいるものの、若干見慣れない定義のように感じます。

```sh
Usage:
  naval_fate ship new <name>...
  naval_fate ship <name> move <x> <y> [--speed=<kn>]
  naval_fate ship shoot <x> <y>
  naval_fate mine (set|remove) <x> <y> [--moored|--drifting]
  naval_fate -h | --help
  naval_fate --version
```

先の NetBSD や POSIX の定義と異なるのは `<>` や `()` が使われているあたりで、前者は使う位置が決まっている引数、後者は必須引数を表すそうです。必須の引数は1行目の `new` のような括弧の使わないものがそうではないかという気もしますが、上記の4つ目の例のように排他かつ必須の場合など、少しパターンの異なる場合に、必須であることを明示したい意図で使うとかですが若干飲み込みづらくよくわかりませんでした。

位置引数を表す `<>` については見覚えがあります。上記の例だと1番最初のもの、 `ship <name> new` じゃなくて `ship new <name>` で位置が固定なのだと、要は `ship new` サブコマンドの引数として `name` を渡すってわけですよね。昨今このようにサブコマンドを繋げて使うタイプのコマンドが増えてきたので、それへの対応として生み出された書式と捉えられます。Terraform なんかがそうですけど、例えば以下の Usage で `<>` が使われていて、この場合はサブコマンドを先に置いて、オプションなどがある場合はサブコマンドの後に使えという意味になるわけです。


```sh
Usage: terraform state <subcommand> [options] [args]
```

サブコマンドは「1つのことを上手くやる」という、『UNIXという考え方』に記載のあるUNIX哲学と反していないかと言う意見もありますし、従来 UNIX/Linux にビルトインで実装されてきたコマンドでは想定されていなかった範囲に思います。そこを補完する、現代的な多機能コマンドツールを実装する際に、 docopt の定義は有用かもしれません。

参考: [サブコマンドはUNIX哲学と相反していないのか | おそらくはそれさえも平凡な日々](http://www.songmu.jp/riji/entry/2017-08-27-subcommand.html)

基本的には NetBSD や POSIX の定義に則り、サブコマンドが存在するようなリッチなコマンドを実装する場合には docopt を参考にしてみるとバランスが取れそうです。

