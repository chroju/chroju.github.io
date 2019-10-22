+++
categories = "ruby"
comments = true
date = "2015-04-06T00:00:00+09:00"
title = "Ruby基礎復習(7) Timeクラス"

+++

『パーフェクトRuby』p.190より。

`Time#now`か`Time#new`で現在時刻が取得可能。

```ruby
now = Time.now # => 2015-03-16 23:25:32 +0900
new = Time.new # => 2015-03-16 23:25:32 +0900

now.zone # => "JST"
now.getutc # => 2015-03-16 14:25:32 UTC
now.utc
now.zone # => "UTC"
```

現在時刻以外のTimeオブジェクトを生成するには`Time#at`でUNIX秒を引数に指定するか、`Time#utc`か`Time#local`で直接時刻を指定する。

```ruby
Time.at(0) # => 1970-01-01 09:00:00 +0900
Time.utc(2015, 1, 1, 2, 30, 40, 100) # => 2015-01-01 02:30:40 UTC (最後の100はマイクロ秒)
Time.local(2015, 1, 1, 2, 30, 40, 100) # => 2015-01-01 02:30:40 +0900
```

`#to_i`、`#to_f`、`#to_r`の戻り値はUNIX秒。`#to_s`で文字列表現が返る。`#to_a`は秒、分、時、日、月、年、曜日、その年の通算日数、夏時間の真偽判定、タイムゾーンの配列を返す。なお、この配列フォーマットを展開して`Time#utc`や`Time#local`の引数として与えることもできる。

```ruby
now.to_i # => 1426515932
now.to_f # => 1426515932.978824
now.to_r # => (178314491622353/125000)
now.to_s # => "2015-03-16 23:25:32 +0900"
now.to_a # => [32, 25, 23, 16, 3, 2015, 1, 75, false, "JST"]
```

`#to_s`の戻り値は上記フォーマットの固定だが、任意のフォーマットで文字列表現を得たい場合は`#strftime`を使う。使えるフォーマット文字列は[公式ドキュメント](http://docs.ruby-lang.org/ja/1.9.3/class/Time.html)参照で。

```ruby
now.strftime("今日は%Y年%m月%d日、今は%H時%M分を%S秒過ぎたところです。") # => "今日は2015年3月16日、今は23時25分を32秒過ぎたところです。"
```

逆に文字列表現からTimeオブジェクトを得たい場合は`#strptime`が使える。

## 参照

* [Ruby - 日本語表記の日時をTimeオブジェクトに変換（Time.strptimeメソッド） - Qiita](http://qiita.com/riocampos/items/de59263ac4e991a98f49)

その他もろもろの出力。

```ruby
now.year # => 2015
now.month # => 3
now.day # => 16
now.hour # => 23
now.min # => 25
now.sec # => 32
now.nsec # => 978824000 (ナノ秒)
now.wday # => 1 (曜日は日曜を0としてカウント)
now.yday # => 75 (年初からの日数)
```

曜日やサマータイム(DST)については疑問符のメソッドで真偽判定できる。

```ruby
now.dst? # => false
now.sunday? # => false
now.monday? # => true
```

Timeオブジェクト同士の比較についてはナノ秒まで判定されるので、そのあたりに注意とのこと。以下のようなことがあり得る。

```ruby
now = Time.now # => 2015-03-16 23:25:32 +0900
new = Time.new # => 2015-03-16 23:25:32 +0900

now == new # => false
```

整数を与えることによる加算減算は秒として取り扱われる。Timeオブジェクト同士の減算も可能。その場合は差分の秒数が浮動小数点数で返る。

```ruby
now = Time.now # => 2015-03-16 23:25:32 +0900

now + 1 # => 2015-03-16 23:25:33 +0900
now - 1 # => 2015-03-16 23:25:31 +0900
```

なお時間や日時を扱うクラスには他に`Date`や`DateTime`もあるが、組み込みのライブラリはこの`Time`だけ。どれを使えばええんや？ってのは、探してみたら大変詳しいQiitaを見つけたんでそっちに譲ります。

## 参考

* [RubyとRailsにおけるTime, Date, DateTime, TimeWithZoneの違い - Qiita](http://qiita.com/jnchito/items/cae89ee43c30f5d6fa2c)

