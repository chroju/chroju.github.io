+++
categories = "Ruby"
comments = true
date = "2015-03-08T00:00:00+09:00"
title = "Ruby基礎復習(1) 基礎文法"

+++

去年末から今年のはじめにかけてRuby Silver/Goldの再受験無料キャンペーンってのやってて、おーこりゃちょうどいいわーと思って取りあえず受けたら見事に落ちたんですけど、その後再受験申し込み期間あるの忘れてて棒に振るとかよくわからんことやりました。そのままなんとなーくやる気なくなってたけど、さすがにSilverクラスの知識はきちんと押さえるべきだろってことで、しばらく手元の『パーフェクトRuby』使って自分用チートシートっぽくまとめてみます。超基礎なので退屈な記事が続く予定。

今回は文法面で自分がつまずいたポイントまとめる。

## 変数のスコープ

ローカル変数、グローバル変数、インスタンス変数、グローバル変数がまず基本にある。それぞれ文字通りではあり、ローカル変数は最も局所的なスコープ、グローバルはどこからでも参照可能（あまり使わない？）、インスタンス変数は個々のインスタンスに属する変数、クラス変数はクラス間で共有される変数。

```ruby
def display_local
  puts hoge
end

def display_global
  puts $hoge
end

$hoge = "Hello, world!"

display_local # => NameError: undefined local variable or method `hoge' for main:Object
display_global # => "Hello, world!"
```

```ruby
class Hoge
  @@class_var = "Hello, world from class!"
  
  def display_class_var
    puts @@class_var
  end

  attr_accessor :ins_var
end

i = Hoge.new
j = Hoge.new

i.display_class_var # => "Hello, world from class!"
j.display_class_var # => "Hello, world from class!"
i.ins_var = 1
j.ins_var = 2
i.ins_var # => 1
```

しかし改めてattr_accessorというのは便利ですね。

問題はローカル変数とブロック、メソッドとの関係で、わりと理解できてなかった。やりがちだけど、メソッドの中からメソッド外のローカル変数は参照できない。一方でブロックの中からブロック外のローカル変数は**参照できる。**一方でブロック内のみで宣言されている変数は、ブロックローカル変数扱いになり外から参照できない。

```ruby
hoge = "hoge"

def hello_hoge
  puts hoge
end

hello_hoge # => NameError: undefined local variable or method `hoge' for main:Object
```

```ruby
i = 1

3.times do |j|
  i = i + j
  block_local = 'in block'
end

puts i # => 4
puts block_local # => NameError
```

## Rangeクラス

Ruby Silver受けるまで、恥ずかしながら1..10みたいのがクラスだということを知りませんでした。Rangeクラスってのがあるのね。。

```ruby
range1 = 1..4
range2 = 1...4
range1.class # => Range

range1.each do |i|
  puts i
end # => 1,2,3,4

range1.include?(4) # => true
range2.include?(4) # => false
```

## 三項演算子

苦手。ついでに後置if/unlessもよく使うので頭に置いとく。

```ruby
0.zero? ? '0です' : '0じゃないです' # => '0です'
puts '0です' if 0.zero? # => '0です'
```

## rescue

rescue節を複数書いた場合、最初に該当したrescue節で捕捉され、その後のrescue節は捨象される。

```ruby
begin
  raise 'StandardError'
rescue LoadError => e
  puts 'これはloaderrorです'
rescue StandardError => e
  puts 'これはstandarderrorです'
rescue Exception => e
  puts 'これはなにかエラーです'
end # => 'これはstandarderrorです'
```

## 今後のtodo

- Hashの扱い（というかEnumerable）
- Time/Date関連の扱い
- Fileの扱い
- 組み込みクラスの言語仕様再確認（特に破壊的非破壊的のあたり）

まーぶっっちゃけ全部だな。。。。

