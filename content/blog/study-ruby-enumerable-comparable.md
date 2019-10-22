+++
categories = "Ruby"
comments = true
date = "2015-03-17T00:00:00+09:00"
title = "Ruby基礎復習(4) EnumerableとComparable"

+++

『パーフェクトRuby』p.164より。

一部組み込みクラスは、EnumerableやComparableというモジュールがincludeされている。前者は聞き慣れない英単語だが、"can be counted"の意味らしく、HashやArrayといった一定の集合を表すクラスにincludeされていて、繰り返し処理や要素抽出に関するメソッドを実装する。Comparableはその名の通り比較演算、具体的には`#<=>`の実装であり、NumericやStringにincludeされているらしい。

特に実装されるメソッド数が多いので、Enumerableについてじっくり見てみたい。

## Enumerable

まず繰り返し系。これだけでもかなり。。`#each_cons`のconsって何の意味ですかね。他はだいたい字義からイメージできる動作をしてくれる。あと`#each_with_object`がいまいち飲み込めてない。

```ruby
(1..4).each_cons 2 do |a,b|
  p [a,b]
end # => [1,2] [2,3] [3,4]

(1..4).each_slice 2 do |a,b|
  p [a,b]
end # => [1,2] [3,4]

%(hoge fuga piyo).each_with_index do |value, index|
  p "#{index}: #{value}"
end # => 0: hoge 1: fuga 2: piyo

(1..4).each_with_object([]) {|i, result| result << i*2} # => [2,4,6,8]

(1..4).reverse_each do |i|
  p i
end # => 4,3,2,1

(1..4).cycle {|i| p i} # => 1,2,3,4,1,2... 以下、無限ループ
```

各要素の評価には`#map`と`#collect`。いずれも同じ動作。

```ruby
(1..4).map {|i| i * 3} # => [3, 6, 9, 12]
(1..4).collect {|i| i * 3} # => [3, 6, 9, 12]
```

判定系。`#member?`と`include?`は同義。

```ruby
[1,2,3].all? {|i| i > 1} # => false
[1,2,3].any? {|i| i > 1} # => true
[1,2,3].none? {|i| i > 3} # => true
[1,2,3].one? {|i| i > 1} # => false

%w(hoge fuga piyo).member? "fuga" # => true
%w(hoge fuga piyo).include? "fuga" # => true
```

抽出系。覚えやすいことにgrepがある。`#detect`は条件に当てはまる最初の要素だけ、`#select`はすべてを抽出する。`#find_all`は`#select`と同義。`#reject`は`#select`といわば「逆」の動きをする。`#take`と`#drop`は要素数を指定して先頭から要素抽出orスキップする。あとは語義通りのメソッドがいくつか。

```ruby
%w(hoge fuga piyo).grep(/o/i) # => "hoge", "piyo"
[1,2,"hoge"].grep(String) # => "hoge"

[1,2,3,4].detect {|i| i.even?} # => 2
[1,2,3,4].select {|i| i.even?} # => 2, 4
[1,2,3,4].find_all {|i| i.even?} # => 2, 4
[1,2,3,4].reject {|i| i.even?} # => 1, 3
[1,2,3,4].find_index {|i| i.even?} # => 1

(1..10).take 3 # => [1,2,3]
(1..10).drop 3 # => [4,5,6,7,8,9,10]

(1..10).take_while {|i| i < 3} # => [1,2]
(1..10).drop_while {|i| i < 3} # => [3,4,5,6,7,8,9,10]

(1..10).max # => 10
%(aaa bbbb ccccc).max_by {|s| s.length} # => "ccccc"
(1..10).min # => 1
%(aaa bbbb ccccc).min_by {|s| s.length} # => "aaa"
(1..10).minmax # => [1,10]
%(aaa bbbb ccccc).minmax_by {|s| s.length} # => ["aaa", "ccccc"]

(1..10).first # => 1
(1..10).count # => 10
(1..10).count(2) # => 1
```

`#inject`を使うと全要素を総計するような処理ができる。これを「畳み込み演算」と呼ぶらしい。引数2つを必要とするブロックを受け取り、第一引数が直前のループでの演算結果を持ち、第二引数がその回のループでの要素を取る。あるいはブロックを取らず、`#inject`の引数にシンボルでメソッド名を渡すことで、全要素に対してそのメソッドを適用した結果を得られる。

```ruby
(1..5).inject {|result, i| result + i} # => 15
(1..5).inject(10) {|result, i| result + i} # => 25
(1..5).inject(:+) # => 15
(1..5).inject(:*) # => 120
```

グルーピング。`#group_by`はブロックで評価した戻り値をキーとしたハッシュに要素をグルーピングしてくれる。`#partition`はブロックで評価した真偽値を元に配列でグルーピング。後者の方が使い勝手は良さそうではある。

```ruby
(1..6).group_by {|i| i % 3 } # => {0=>[3,6], 1=>[1,4], 2=>[2,5]}
(1..6).partition {|i| i.even?} # => [[1,3,5], [2,4,6]]
```

一番意味がわからない`#zip`。selfと引数の配列で、同じ添字にあたる要素を使って新しい配列を生成する。どう使うんだろうこれ。。

```ruby
(1..3).zip([4,5,6], [7,8,9]) # => [1,4,7], [2,5,8], [3,6,9]
```

## Comparableとソート

個人的に苦手なのがこの宇宙船演算子とソート周り。まず大前提として、宇宙船演算子はレシーバと引数を比較し、レシーバが大きければ1、小さければ-1、同値であれば0を返す。

```ruby
1 <=> 2 # => -1
1 <=> 0 # => 1
1 <=> 1 # => 0
```

Comparableモジュールをincludeしたクラスで`#<=>`を定義すると、各種演算子による比較のルールを定めることができる。

```ruby
class Person
  include Comparable
  attr_accessor :age

  def initialize(age)
    self.age = age
  end

  def <=>(other)
    age <=> other.age
  end
end

taro = Person.new(21)
hanako = Person.new(32)

taro > hanako # => true
taro == hanako # => false
```

で、Enumerableの`#sort`は要素を宇宙船演算子で比較して結果が正になるよう並び替えていく。要は昇順がデフォルト。ブロックに引き渡すこともでき、ここで任意の比較方法を定義してソートすることもできる。`#sort_by`を使えば宇宙船演算子を使わず、指定のメソッドを使って昇順に並び替えてくれる。メソッド呼び出し回数が`#sort_by`だと1回で済むので、実行速度の面で差が出る可能性がある。

```ruby
takeshi = Person.new(25)
people = [hanako, taro, takeshi]
people.sort # => [taro, takeshi, hanako]
people.sort {|a,b| b <=> a} # => [hanako, takeshi, taro]
people.sort_by {|person| person.age} # => [taro, takeshi, hanako]
```

---

なお、意図的に飛ばしてしまったのだが、あと触れてないEnumerableのメソッドとして`#chunk`周りがある。ちょっと飲み込みきれてないのでまた次回。

## 参考

[Ruby のイテレータ (2) – Enumerable と Comparable モジュール | すぐに忘れる脳みそのためのメモ](http://jutememo.blogspot.jp/2008/03/ruby-2-enumerable.html)

