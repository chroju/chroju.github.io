+++
categories = "Ruby"
comments = true
date = "2015-03-18T00:00:00+09:00"
title = "Ruby基礎復習(5) 配列(Array)"

+++

『パーフェクトRuby』p.171より。

まずは配列の生成をいくつか。`#new(a,b)`で生成したとき、各要素は同じオブジェクトとなるので注意。またブロックで受け取ると、インデックスを引数としてブロック内の処理を実行した結果が値となる。

```ruby
a1 = Array.new(3,1) # => [1, 1, 1]
a2 = Array.new(3, "hoge") # => ["hoge", "hoge", "hoge"]
a3 = ["hoge", "fuga", "piyo"] # => ["hoge", "fuga", "piyo"]
a4 = Array.new(3) {|i| i * 5} # => [0, 5, 10]

a2[0] << "fuga"
p a2 # => ["hogefuga", "hogefuga", "hogefuga"]
```

基本的な操作系メソッド。演算子メソッドは直感的でほんといいなーと思う。なお、`#<<`は`#concat`と同義。`#==`と`#eql?`も同義。

```ruby
array = ["hoge", "fuga", "piyo"]

array.length # => 3
array.size # => 3
array.empty? # => false
array.include?("fuga") # => true

p array * 3 # => ["hoge", "fuga", "piyo", "hoge", "fuga", "piyo", "hoge", "fuga", "piyo"]
p array + [1, 2] # => ["hoge", "fuga", "piyo", 1, 2]
p array - ["hoge", "piyo"] # => ["fuga"]
p array & ["piyo"] # => ["piyo"]
array << "hogehoge" # => ["hoge", "fuga", "piyo", "hogehoge"]
array2 = ["hoge", "fuga", "piyo"]
array3 = ["hoge", "fuga", "piyo", "hogehoge"]
array == array2 # => false
array == array3 # => true
```

要素の取り出し。`#[a, b]`が添字aから長さbの配列を取り出すのに対し、`#values_at(a, b)`が添字a, bの要素を取り出して配列を作る、という点が異なるのが注意かも。

また範囲外の添字を指定したときの振る舞いだが、`#[]`がnilを返すのに対し、第一引数のみの`#fetch`はIndexErrorを返す。`#fetch`に第二引数を指定すると、範囲外を呼び出したときに第二引数を返すようになる。

`#sample`はランダム抽出。

```ruby
array = (1..5).to_a

array[1] # => 2
array[-1] # => 5
array[1, 3] # => [2, 3, 4]
array[2..4] # => [3, 4, 5]

array.values_at(3) # => 4
array.values_at(0, 3, 4) # => [1, 4, 5]

array.fetch(5) # => IndexError
array[5] # => nil
array.fetch(5, "error") # => "error"

array.first # => 1
array.last # => 5
array.last(2) # => [4, 5]

array.sample # => 3
```

要素の追加削除。添字を使って普通に要素の入れ替えはできるのだが、面白いのはレンジにない添字を指定してもOutOfBounds扱いにはならず、足りない箇所はnilを埋めて補完してくれること。`#insert`は第一引数をインデックスとする要素の直前に、第二引数以降の要素を挿入する。あと`#fill`は全要素を同じオブジェクトで埋め込む。

```ruby
array = (1..5).to_a

array[1] = 0 # => [1, 0, 3, 4, 5]
array[8] = 10 # => [1, 0, 3, 4, 5, nil, nil, nil, 10]

array.push(3) # => [1, 0, 3, 4, 5, nil, nil, nil, 10, 3]
array.pop # => 3
p array # => [1, 0, 3, 4, 5, nil, nil, nil, 10]

array.shift # => [0, 3, 4, 5, nil, nil, nil, 10]
array.unshift(1) # => [1, 0, 3, 4, 5, nil, nil, nil, 10]

array.insert(2, "a", "b") # => [1, 0, "a", "b", 3, 4, 5, nil, nil, nil, 10]

array.fill(0) # => [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
array.clear # => []
p array # => []
```

要素の選択周り。ブロック内の処理でtrueとなった要素について、`#select`では抽出、`#reject`では削除を行う。いずれも破壊的／非破壊的の別があり。`#keep_if`は`#select!`と同様の動作をするが、削除する要素がなかった場合に`#select!`がnilを返す一方で、`#keep_if`がレシーバをそのまま返すという違いがある。`#delete_if`についても同様。ブロック内での評価ではなく、単純に特定の値と等しい要素を削除したい場合は`#delete`が使える。これは破壊的。`#delete_at`は添字による指定で削除する。

```ruby
array = (1..5).to_a
array.select {|i| i.even? } # => [2, 4]
p array # => [1, 2, 3, 4, 5]
array.select! {|i| i.even? } # => [2, 4]
p array # => [2, 4]

array = (1..5).to_a
array.reject {|i| i.even? } # => [1, 3, 5]
p array # => [1, 2, 3, 4, 5]
array.reject! {|i| i.even? } # => [1, 3, 5]
p array # => [1, 3, 5]

array = [2, 4, 6]
array.select! {|i| i.even? } # => nil
array.keep_if {|i| i.even? } # => [2, 4, 6]
array.reject! {|i| i.odd? } # => nil
array.delete_if {|i| i.odd? } # => [2, 4, 6]

array.delete 4 # => [2, 6]
array.delete_at 1 # => [2]
```

同様に要素の切り出しでは`#slice`というメソッドもあるが、引数の与え方で動作が変わってくる。Integerの引数1つを与えると、そのインデックスにある要素を返す。範囲外の場合はnilが返る。Integerの引数2つでは、第一引数のインデックスより、第二引数の個数分要素を切り出して返す。Rangeを引数とすると、その範囲のインデックスにあたる要素を返す。

またいずれの場合でも`!`による破壊的メソッドがあるが、ここでは戻り値となる要素が配列より削除される。

```ruby
a = [2, 4, 6, 9]
a.slice(1) # => 4
a.slice(1, 4) # => [4, 6, 9]
a.slice(1..2) # => [4, 6]

a.slice(2) # => 6
p a # => [2, 4, 9]
a.slice(0..1) # => [2, 4]
p a # => [9]
```

整形。`#compact`はnilを要素から除外する。`#uniq`は重複した要素を除外。`#reverse`は要素の順序を逆にする。`#flatten`は多次元配列を1次元に変換する。いずれも`!`を付けることで破壊的になる。また`#sort!`や`#map!`といった破壊的要素を使うことで、実行結果により自身を更新できる。

```ruby
a = [5, 3, nil, 3, nil, 9, 1, [4, 3]]
a.compact! # => [5, 3, 3, 9, 1, [4, 3]]
a.uniq! # => [5, 3, 9, 1, [4, 3]]
a.reverse! # => [[4, 3], 1, 9, 3, 5]
a.flatten! # => [4, 3, 1, 9, 3, 5]
a.sort! # => [1, 3, 3, 4, 5, 7, 9]
a.map! {|i| i * 2 } # => [2, 6, 6, 8, 10, 14, 18]
```

複製。`#dup`は内容のみを複製する（浅いコピー）のに対し、`#clone`はfrozen等の情報も複製する。

```ruby
a = [1, 2, 3].freeze
a[0] = 5 # => RuntimeError

b = a.dup
b[0] = 5 # => [5, 2, 3]

c = a.clone
c[0] = 5 # => RuntimeError
```

若干変わったものを最後にいくつか。`#transpose`は多次元配列を行列とみなして、行と列の入れ替えを行う。破壊的メソッドはない。`#bsearch`はソートされている配列に対して使用し、二分探索で最初に見つかった要素を返す。`#join`は各要素を連結した値を返す。引数にセパレータを渡すことも可。`#shuffle`は配列をランダムにシャッフルする。

```ruby
a = [[1, 2], [3, 4]]
a.transpose # => [[1, 3], [2, 4]]

a = [0, 3, 5, 7, 9]
a.bsearch {|i| i > 2 } # => 3

a.join # => "03579"
a.join("-") # => "0-3-5-7-9"

a.shuffle!
p a # => [5, 9, 0, 3, 7]
```

