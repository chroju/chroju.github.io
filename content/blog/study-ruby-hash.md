+++
categories = "Ruby"
comments = true
date = "2015-04-05T00:00:00+09:00"
title = "Ruby基礎復習(6) Hash"

+++

『パーフェクトRuby』p.179より。

まず基本的なとこで。

```ruby
hash = {hoge: 1, fuga: 2}

hash.each do |key, val|
  p "#{key}: #{val}"
end # => "hoge: 1", "fuga: 2"

hash.each_key do |key|
  p key
end # => "hoge", "fuga"

hash.each_value do |val|
  p val
end # => "1", "2"

hash[:hoge] = 3
p hash # => {hoge: 3, fuga: 2}
hash[:piyo] = 4
p hash # => {hoge: 3, fuga: 2, piyo: 4}

hash.delete(:piyo)
hash # => {hoge: 3, fuga: 2}

hash.empty? # => false
hash.length # => 2
```

ハッシュの生成は`Hash[]`により偶数個の引数から行うこともできる。

```ruby
ary = ["hoge", 1, "fuga", 2]
Hash[*ary] # => {hoge: 1, fuga: 2}

ary = [["hoge", 1], ["fuga", 2]]
Hash[ary] # => {hoge: 1, fuga: 2}
```

Arrayクラスと同様の`#select`、`#reject`、`#keep_if`、`#delete_if`操作が可能。

```ruby
hash = {hoge: 1, fuga: 2, piyo: 3}

hash.select {|key, val| val.even? } # => {fuga: 2}
p hash # => {hoge: 1, fuga: 2, piyo: 3}
hash.select! {|key, val| val.even? } # => {fuga: 2}
p hash # => {fuga: 2}

hash = {hoge: 1, fuga: 2, piyo: 3}

hash.reject {|key, val| val.even? } # => {hoge: 1, piyo: 3}
p hash # => {hoge: 1, fuga: 2, piyo: 3}
hash.reject! {|key, val| val.even? } # => {hoge: 1, piyo: 3}
p hash # => {hoge: 1, piyo: 3}

hash.select! {|key, val| val.even? } # => nil
hash.keep_if {|key, val| val.even? } # => {hoge: 1, piyo: 3}
hash.reject! {|key, val| val.even? } # => nil
hash.delete_if {|key, val| val.even? } # => {hoge: 1, piyo: 3}
```

Hashの統合は`Hash#merge`を用いる。キーが重複する場合は、引数で渡されたハッシュの値で上書きされる。ブロックを引き渡している場合は、キー重複時の処理をブロックの中で定義できる。破壊的操作である`Hash#merge!`は`Hash#update`とも書くことが出来る。

```ruby
a = {hoge: 1, fuga: 2}
b = {hoge: 3, piyo: 4}
a.merge(b) # => {hoge: 3, fuga: 2, piyo: 4}
p a # => {hoge: 1, fuga: 2}

a.merge!(b) {|key, a_val, b_val|
  a_val + b_val
} # => {hoge: 4, fuga: 2, piyo: 4}
p a # => {hoge: 4, fuga: 2, piyo: 4}
```

キーと値の取得に関して。特に特定キーの存在確認については、`Hash#has_key?`を用いる。通常の`Hash[]`による呼び出しだと、値が存在しない場合でもnilが返ってきてしまい、値がnilなのか、それとも存在していないのか区別がつかないため。あるいは`Hash#fetch`を用いれば、値が存在しない場合の返り値を指定できる。

```ruby
hash = {hoge: 1, fuga: 2, piyo: 3, hogehoge: nil}

hash.keys # => [:hoge, :fuga, :piyo]
hash.key(2) # => :fuga

hash.values # => [1, 2, 3]
hash.values_at(:fuga) # => [2]
hash.values_at(:fuga, :piyo) # => [2, 3]

hash[:hogehoge] # => nil
hash[:foo] # => nil
hash.has_key?(:foo) # => false
# 以下すべてhas_key?と同義
hash.member?(:foo)
hash.include?(:foo)
hash.key?(:foo)

hash.fetch(:foo) # => nil
hash.fetch(:foo, "error") # => "error"
hash.fetch(:foo){|key| "#{key} not exists"} # => "foo not exists"

hash.has_value?(3) # => true
hash.value?(3) # => true
```

Hashにはデフォルト値の概念があり、`Hash#new`の引数に与えた値が、存在しないキーを参照したときの返り値となる（デフォルトはnil）。ここで指定した値はすべて同一オブジェクトであり、破壊的操作をする場合などは注意が必要。また`Hash#default=`や`Hash#default_proc=`により、既存のHashオブジェクトに対してもデフォルト値の変更が可能。

```ruby
hash = Hash.new("null")
hash[:foo] # => "null"

hash.default = "undefined"
hash[:foo] # => "undefined"
default = hash.default
default.reverse!
hash[:foo] # => "denifednu"

hash.default_proc = ->(hash, key) {"Key: #{key} not exists"}
hash[:foo] # => "Key: foo not exists"
```

ハッシュ変換系のメソッド。

```ruby
hash = {hoge: 1, fuga: 2}

hash.invert # => {1: hoge, 2: fuga}
hash.to_a # => [[:hoge, 1], [:fuga, 2]]
hash.sort # => [[:fuga, 2], [:hoge, 1]]
```

