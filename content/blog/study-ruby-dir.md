+++
categories = "ruby"
comments = true
date = "2015-04-14T00:00:00+09:00"
title = "Ruby基礎復習(9) Dirクラス"

+++

『パーフェクトRuby』p.208より。

Dirクラスは基本としてカレントディレクトリ情報を持っていて、それを元としてディレクトリ操作ができる。従って多くの操作を特異メソッドで行うことができる。

```ruby
Dir.pwd # => "/Users/chroju"
Dir.chdir("/tmp")
Dir.pwd # => "/tmp"
Dir.home # => "/Users/chroju"
```

ディレクトリに含まれるファイルは`Dir.entries`で配列として返り、`Dir.foreach`でEnumerableとして返る。また`Dir.glob`により、パターンにマッチするファイルパスを配列で返すこともできる。`Dir.glob`は`Dir[]`と同義である。引数のディレクトリが存在するか確認する場合は`Dir.exists?`を用いる。

```ruby
Dir.entries('.') # => [".", "..", "bar", "foo", "baz"]
Dir.foreach('.') {|d|
  p d
} # => ".", "..", "bar", "foo", "baz"
Dir.glob('ba*') # => ["bar", "baz"]
Dir['ba*'] # => ["bar", "baz"]
Dir.exists?("hoo") # => false
```

ディレクトリの削除、生成等も特異メソッドにて。

```ruby
Dir.mkdir 'foo', 0755 # パーミッション0755でfooディレクトリを生成
Dir.rmdir 'foo' # fooディレクトリを削除するが、対象ディレクトリは空である必要がある
Dir.delete 'foo' # Dir.rmdirと同義
Dir.unlink 'foo' # Dir.rmdirと同義
```

`Dir.open`すると、Dirオブジェクトを取得することができ、インスタンスメソッドによる操作が可能になる。Dirオブジェクトは読み込み位置を持っていて、ディレクトリ内のファイル名を1つずつ読み込ませることができる。

```ruby
dir = Dir.open('.')
dir.path # => "/temp" （現在のファイルパス）
dir.pos # => 0 （現在の読み込み位置）
dir.pos = 1 # 読み込み位置を移動
dir.read # => ".."
dir.rewind # 読み込み位置を先頭に戻す
dir.read # => "."
dir.each {|f| p f} # => ".", "..", "bar", "baz", "foo"
```

