+++
categories = "ruby"
comments = true
date = "2015-04-10T00:00:00+09:00"
title = "Ruby基礎復習(8) Fileクラス"

+++

『パーフェクトRuby』p.196より。わりと苦手な分野。

まずはファイルをひらく。`#open`して変数に格納してもいいし、ブロックを引き渡して処理させることもできる。後者の場合は処理が終わると自動でクローズしてくれるので、こっちの方が楽っぽい。`#read`はファイルの内容全体を読み込む一方、`#gets`を使うと1行ずつ読み込むことができる。あるいは`#each_line`や`#each_char`といったメソッドも。

```ruby
file = File.open('example.txt')
p file.read # example.txtの内容を表示
file.close

File.open 'example.txt' do |file|
  p file.read
end

File.read('example.txt')

File.open 'example.txt' do |file|
  while line = file.gets
    p line
  end
end

File.open 'example.txt' do |file|
  f.each_line do |line|
    p line
  end
end
```

書き込むときは`#open`の第二引数にファイルを開くモードを指定する。デフォルトは`'r'`、すなわち読み込みモードで、他は以下の通り。基本は`r`が読み込み、`w`が書き込み、`a`が追記で、`+`を付けると読み書き両用モードになる。また`b`を後置するとバイナリモードで開かれる。

| r  | 読み込みモード         | 
| r+ | 読み書き両用モード（読み書き位置は先頭から）       | 
| w  | 上書き書き込みモード   | 
| w+ | 新規作成して読み書き両用モード | 
| a  | 追記書き込みモード       | 
| a+ | 追記読み書き両用モード（読み込み位置は先頭から、書き込みは追記形式）  | 

```ruby
File.open 'example.txt', 'w' do |f|
  f.write 'hoge'
end
```

もっと単純に`#write`メソッドだけでも書き込み可能。

```ruby
File.write 'example.txt', 'fuga'
```

先のファイルを開くモードの話の中で「読み込み位置は先頭から」という表現があったが、IOオブジェクトではファイル内の今どこを読み／書きしているかというアクセス位置が存在する。`#gets`では1行ずつ読み込みを行ったように、読み／書きを行うことでアクセス位置は進んでいく。先頭まで戻りたい場合は`#rewind`を使う。また`#seek`メソッドは第二引数に定数で指定した基準位置より、第一引数の整数分アクセス位置を移動させることができる。`#pos`は絶対的にアクセス位置を指定して動かせる。

```ruby
File.open 'example.txt' do |f|
  f.puts
  f.rewind # 先頭位置まで戻る

  f.seek 10 # 先頭から10進む
  f.seek -10, IO::SEEK_END # 末尾（SEEK_END）から10戻った位置に移動

  f.pos = 25 # 先頭から25バイト目に移動
  f.pos # => 25
end
```

文字のエンコーディングについては、「外部」と「内部」という概念を持つ。外部はファイルのエンコーディング情報であり、内部はRuby上で処理する際のエンコーディング情報。例えばEUC-JPのファイルをutf-8で変換して取り扱い、書き込みはEUC-JPで、といったことができる。エンコーディングの設定には`#set_encoding`メソッドを使う。引数を1つだけ取る場合は外部エンコーディングを設定し、2つ取る場合は第一引数が外部、第二引数が内部を設定する。あるいは`File#open`するときに、読み書きモードと一緒にエンコーディングも指定することができる。

```ruby
File.open 'example.txt' do |f|
  f.set_encoding('utf-8') # 外部エンコーディングをutf-8に設定

  f.set_encoding('utf-8', 'EUC-JP') # 外部エンコーディングをutf-8、内部エンコーディングをEUC-JPに設定
  f.set_encoding('utf-8:EUC-JP') # 外部エンコーディングをutf-8、内部エンコーディングをEUC-JPに設定
end

File.open 'example.txt', 'r:utf-8:EUC-JP' do |f|
  p f.external_encoding # => "utf-8"
  p f.internal_encoding # => "EUC-JP"
end
```

ファイルのロックには`#flock`メソッドを利用する。ロックのモードは[ここに記載の定数](http://docs.ruby-lang.org/ja/1.9.3/method/File/i/flock.html)を使って指定するのだが、主に`File::LOCK_EX`が排他ロックであることを覚えとけばいいような気も。

```ruby
File.open 'example.txt', 'w' do |f|
  f.flock File::LOCK_EX
end
```

その他、ファイル情報取得系のメソッドをつらつらと。これらはファイルオブジェクトから取得するだけではなく、`File.atime(filename)`の形で`File`クラスのクラスメソッドでも呼び出すことができる。

```ruby
File.open 'example.txt' do |f|
  f.atime # 最終アクセス日時
  f.ctime # 最終変更日時
  f.mtime # 最終更新日時

  f.size # ファイルサイズ

  f.ftype # ファイルタイプ 以下真偽判定メソッドも有り
  f.file?
  f.directory?
  f.symlink?

  f.writable? # => false
  f.readable? # => true
  f.executable? # => false

  f.owned? # => false (自身がファイル所有者か？)
  f.gid # ファイル所有者のGID
  f.uid # ファイル所有者のUID
end
```

ファイル操作系。

```ruby
# ファイル名変更、ファイル移動
File.rename 'hoge', 'fuga'
File.rename 'hoge', 'dir/hoge'

# ファイル削除
File.unlink 'hoge'

# シンボリックリンク作成
File.symlink 'target', 'link'

# ハードリンク作成
File.link 'target', 'link'

# ファイルモード変更
File.chmod 0600, 'filename'

# 所有者、グループの変更
File.chown 100, 100, 'filename'
```

ファイルパスに関するもろもろ。

```ruby
# ファイルのあるディレクトリパスの取得
File.dirname("etc/sample.txt") # => "/etc"

# 第一引数に与えたファイルパスに対する、ファイル名の取得。第二引数でsuffix指定。
File.basename("etc/sample.txt") # => "sample.txt"
File.basename("etc/sample.txt", ".txt") # => "sample"

# 拡張子の取得
File.extname("etc/sample.txt") # => ".txt"

# ファイルパスの連結（引数は可変長）
File.join("/usr/local", "bin/ruby") # => "/usr/local/bin/ruby"

# ファイルパスからdirnameとbasenameを取得し配列生成
File.split("/usr/local/bin/ruby") # => ["/usr/local/bin", "ruby"]

# 絶対パスの展開
File.expand_path("~") # => "/home/chroju"
File.expand_path("filename", "~") # => "/home/chroju/filename"

# absolute_pathでは~を展開しない
File.absolute_path("~") # => "/home/chroju/~"
```

Dirクラスも触れたいのだが、長くなるので一旦ここまで。

