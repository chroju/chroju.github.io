+++
categories = "ruby"
comments = true
date = "2015-04-24T00:00:00+09:00"
title = "Ruby基礎学習(10) Mix-in"

+++

Mix-inの話と、それに似たもろもろ。他に詳しい記事があるので、これを読んでおけばいいような気はした。

## 参考
* [requireとincludeとextendとmodule_function(1) : As Sloth As Possible](http://faultier.blog.jp/archives/1220074.html)
* [requireとincludeとextendとmodule_function(2) : As Sloth As Possible](http://faultier.blog.jp/archives/1220088.html)

## require

* Kernelモジュールのモジュール関数。
* 引数に与えたRubyライブラリを1回ロード、というか実行する。
* 使う場面としてはgemだとか自作のライブラリ（クラス）を読み込むときに指定する。
* 指定した引数は$LOAD_PATHに探しに行き、カレントディレクトリは含まれないため、パスの指定には少し注意が必要。
* 同じファイルを複数回requireしようとしても、1回しか読み込まない。

## load

* Kernelモジュールのモジュール関数。
* requireと同様に外部ライブラリを実行するが、同じファイルを何度でも読み込める。
* requireは拡張子の自動補完を行うが、loadは行わない。

## include

* Moduleクラスのインスタンスメソッド。
* Moduleを引数に取り、メソッドや定数といった対象Moduleの性質を取り込む。
* ArrayやHashがEnumerableの性質を持っているのはincludeしていることによるもの。
* 継承とは異なるが、メソッドの探索対象としてはスーパークラスよりincludeされたModuleの方が先になる。
* 同じモジュールを複数回読み込もうとしても、2回目以降は無視される。
* Rubyは多重継承を認めていないが、その代わりの機能を果たすという位置付けらしい。

## extend

* Objectクラスのインスタンスメソッド。
* 引数に取ったModuleのメソッドを特異メソッドとして取り込める。

