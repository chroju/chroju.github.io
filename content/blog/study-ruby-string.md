+++
categories = "Ruby"
comments = true
date = "2015-03-15T00:00:00+09:00"
title = "Ruby基礎復習(2) Stringクラス"

+++

パーフェクトRuby p.148から学習。文字列ことStringクラス。

まずは基本操作系。

```ruby
s = "hoge"
s.empty? # => false
s.length # => 4
s.size # => 4
s.bitesize # => 8
s.include?("og") => true
```

演算子での操作。

```ruby
'hoge' + 'fuga' # => 'hogefuga'
'hoge' * 3 => 'hogehogehoge'
```

破壊的な文字列の追加。

```ruby
s = "hoge"
s << "fuga" # => "hogefuga"
s.concat("piyo") # => "hogefugapiyo"
```

切り出し。

```ruby
s = "hogefuga"
s.slice(3) # => "e"
s.slice(2,5) # => "gefu"
s.slice(-4,2) # => "fu"
s.slice(2..5) # => "gefu"
```

`#slice`を使わず、以下記法でも同等。

```ruby
s = "hogefuga"
s[3] # => "e"
s[2,5] # => "gefu"
s[-4,2] # => "fu"
s[2..5] # => "gefu"
s[//]
```

文字列の整形に関するメソッドいろいろ。特に`#chop`と`#chomp`とか紛らわしいとよく言われる。英単語の意味するところとしてchop＝刻むってことで1文字削除されるのはわかるが、そこにmが足されると改行コードの削除になるのはなぜなんだろう。。。あと`#squeeze`なんかは使う場面がいまいち想像できない。

なお、ここにあるメソッドはすべて非破壊的。末尾に`!`を付けることで破壊的操作になる。

```ruby
s = " aaa "
s.strip # => "aaa"
s.rstrip # => " aaa"
s.lstrip # => "aaa "

s = "aaa\n\n"
s.chomp # => "aaa\n"
s = "abcd"
s.chop # => "abc"

s = "aaaabbbbcccc"
s.squeeze # => "abc"
s.squeeze('ab') # => "abccc"

"ABC".downcase # => "abc"
"def".upcase # => "DEF"
"Abc".swapcase # => "aBC"
"tITle".capitalize # => "Title"

"abc".reverse # => "cba"
```

置換。第一引数で検索を行い、ヒットした箇所を第二引数で置換するか、あるいはブロックに引き渡して操作、という建て付けのよう。`#sub`だと最初に一致したもののみ、`#gsub`だとヒットしたすべての箇所が置換される。これも破壊的、非破壊的の2種類あり。

```ruby
"aaaa".sub("a","b") # => "baaa"
"24-1-365".gsub(/[0-9]+/) {|str| str.to_i.succ} # => 25-2-366
```

配列への変換。`#split`で第一引数に指定した文字をセパレータとした分割が可能。第二引数には分割最大数が指定できる。また1文字ずつ操作したい場合は`#each_char`が使える。ブロックへの引き渡しも可能。似たところで`#each_byte`もある。

```ruby
str = "Alice, Bob, Charlie"

str.split(",") # => ["Alice", "Bob", "Charlie"]
"Alice".each_char.to_a # => ["A","l","i","c","e"]
```

