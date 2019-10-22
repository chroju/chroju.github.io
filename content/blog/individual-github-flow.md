+++
categories = "Git Github 開発環境"
comments = true
date = "2015-10-04T00:00:00+09:00"
title = "個人開発環境にGithub Flowを適用する"

+++

Github、[joinしたのは2013年](https://github.com/chroju)で作ったものは軒並みちゃんと突っ込んではいるんだけど、単に一区切りついたらadd => commit => pushしているだけでちゃんと使っていなかったので、個人開発ではあるがGithub Flowを取り入れてみた。

# What is Github flow ?

Githubを用いた開発作業を進めるにあたっての指針みたいなものです。基本的にはmasterブランチ上では作業せず、作業工程ごとにブランチ作って、終わったらプルリクしてmasterにマージしてもらうことでデプロイとしましょうね、というものだと理解している。至ってシンプルではあるけど、これを取り入れるだけで従来やっちゃってた「masterで作業してるのでデプロイしても動かないレポジトリがGithub上にある」みたいな状態が防げて良さそうだと思った。

ちなみにGit-flowというのもあるようだけど、こちらは全然別個のツールらしく理解していない。Git-flowの問題解決としてGithub Flowが提唱されたようだが、そもそも開発工程の制御のためだけにツールを追加したくはないなと思ったのでGithub Flowを採用した。

Github Flowの理解にはこの文章が良さそう。なお、dotfilesのような大した更新のないレポジトリにはさすがに適用していない。

[GitHub Flow (Japanese translation)](https://gist.github.com/Gab-km/3705015)

# 実際の開発工程

あくまでGithub Flowに沿う形という程度なので、そのままそっくり適用できてはないとは思うが。

## 開発開始

ブランチを切る。ブランチ名は機能追加等の開発要件であれば`dev_hoge`、バグフィックスであれば`hotfix_hoge`とする。

```bash
$ git checkout -b dev_hoge
```

## 開発中

普通であればレビューを依頼するタイミングなど、開発の切りがついたところで`push`していくのだろうが、分散して開発しているわけではないので、1日の開発が終わる段階で`push`している。そもそも開発に使っている環境が複数あるので、Github上のdevelopブランチも常に最新化していつどこでも`fetch`可能にしたいなという思いがある。従来はDropboxで各環境間の同期を取っていたが、プラグインの有無やbundleなどで度々不具合もあったので改めた。

```bash
$ git add -A
$ git commit -m "
...
$ git push origin dev_hoge
```

`git add .`ではなく`-A`なのは、そちらじゃないと`git rm`したファイル等が含まれないと[こちらの記事](http://qiita.com/otukutun/items/9feb513c596418e94fc6)に書いてあったゆえ。


## 開発終了

開発が終わり、masterへのマージを必要とする段階に来たらプルリクを出す。プルリクって別のコミッターからしか不可なのかと思っていたが、自分のレポジトリに自分で出すことも可能だったのでそうしている。本来であればテストツール等走らせるべきではあるのだろうが、今のところはプルリクに対して特にレビュー等なく（自分のコードだし）そのままマージしている。

後述するがバグや開発課題の管理にはGithub issueを用いているので、マージの際はissueのナンバーをコメントに入れている。これでGithub上のリンクとして働いてくれるので便利。

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/chroju/21903884486/" title="スクリーンショット 2015-10-04 14.19.25"><img src="https://farm1.staticflickr.com/735/21903884486_cae2057f70_z.jpg" width="640" height="576" alt="スクリーンショット 2015-10-04 14.19.25"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

参考：[Gitコミットメッセージの7大原則 - rochefort's blog](http://rochefort.hatenablog.com/entry/2015/09/05/090000)

## マージ後

作業ブランチを消して、ローカルのmasterを最新化する。

マージには`git merge`を使用し、`git rebase`は使わないことにしている。そもそも`rebase`完全に理解してないというのもあるが、要するに歴史改変にあたるような操作があまり好めないというのが強い。個人の開発においては作業ブランチの変更中にmasterに更新が入ることは少ないので、このやり方でおそらく不都合はしないと思っている。

```bash
$ git checkout master
$ git branch -a
$ git branch -d dev_hoge
$ git push --delete origin dev_hoge
$ git fetch
$ git marge origin/master
```

参考
[GitのRebaseによるBranchの運用 ｜ Developers.IO](http://dev.classmethod.jp/tool/git/development-flow-with-branch-and-rebase-by-git/)
[git pull と git pull –rebase の違いって？図を交えて説明します！ | KRAY Inc](http://kray.jp/blog/git-pull-rebase/)

## コンフリクトした場合

`git ls-files -u`でコンフリクトしたファイルが一覧化されるとのことなので、確認の上で開いて直す。もしローカルかリモートのいずれかを全面採用するのであれば、`git checkout`の`--ours`と`--theirs`オプションを使う。

```
git ls-files -u
git checkout --ours hoge
git checkout --theris hoge
```

参考：[Gitでコンフリクトした時のための備忘録 - アジャイルSEを目指すブログ](http://d.hatena.ne.jp/sinsoku/20110831/1314720280)

## リモートのmasterがローカルより先に行っている場合

ローカル環境が複数あるので、このような場合は多々ありえる。そういうときは基本的にはmergeすればいいだけではあるが。masterはリモートレポジトリの最新化が原則となるので、コンフリクトした場合は99%リモートを優先させる。

```
git show-branch --all --color
git fetch origin
git diff origin/master
git merge origin/master
```

参考：[gitのリモートリポジトリの更新を確認する - Qiita](http://qiita.com/yuyuchu3333/items/a30387bdd6a0afc1185c)

## バグ、開発課題の発生

先に少し触れたが、開発すべきTODOはすべてGithub issueで管理することにした。今までどうしていたかというと特に管理はしておらず、思いつくままに開発してしまっていたのだが、これでGithubに開発に必要なものはすべて集約できるのではないかと思う。個人でのGithub issue運営には下記の記事を参考にさせてもらっているが、特に難しいことはせず、タスク管理ツールのような形で使っている。

参考：[一人で使えるGithub Issue](http://azu.github.io/slide/udonjs/github-issue.html#3)


# 覚えられない

Github Flowは便利なのだが、Gitのコマンド体系がどうにも覚えづらくて仕方がない。どうにもならんのでaliasを駆使してなるべく覚える内容を少なくしようと努めているが、あとは慣れるしかないのかなぁと。Githubのコマンドは本当に多い。体系自体を学ぶのであれば[Pro Git](https://progit-ja.github.io/)がわかりやすく、epubの配布もあるのでKindleでいつでも読めて最高なのだが、数多あるコマンドを網羅しようとか思うとこれだけではつらい。Qiitaでまとめ記事が上がるたびに覗いてみて、今の自分のキャパで使えそうなのをつまみ食いしていく形で覚えればいいのかなと思っている。

今のalias設定はこんなの。

```
[alias]
  a  = add
  aa = add --all
  br = branch
  bra = branch -a
  brd = branch -d
  co = checkout
  cob = checkout -b
  coo = checkout --ours
  cot = checkout --theirs
  cl = clone
  clr = clone --recursive
  cm = commit
  cmm = commit -m
  d  = diff
  f  = fetch
  lg = log
  lga = log --graph --decorate --online
  lgp = log -p
  mg = merge
  mgn = merge --no-ff
  ps = push
  psd = push --delete origin
  pso = push origin
  psm = push origin master
  pl = pull
  s  = status -s
  sb = status -s --branch
  ss = status
  sh = show
  sba = show-branch --all
```

# 今後

やりたいこととしてはCI。Circle CIとかと連動させて自動テストしたりというところまで組み込めたら、個人開発としてだいぶ理想的な状態かなと思う。そのままデプロイまで自動化できれば最高か。またGitの理解がやはりどうにも覚束ない部分があり、まだまだ使いこなせているとは言いがたいので、aliasをカンペ代わりに育てつつ、ガンガン覚えていきたい。特にミスったときの`reset`系コマンドがあまりに多くてなぁ……。

# その他参考記事

* [見えないチカラ: 【翻訳】Gitをボトムアップから理解する](http://keijinsonyaban.blogspot.jp/2011/05/git.html?m=1)
* [Gitコマンドラインショートカット | プログラミング | POSTD](http://postd.cc/git-command-line-shortcuts/)
* [.gitconfigに設定してるaliasなどのまとめ - ( ꒪⌓꒪) ゆるよろ日記](http://yuroyoro.hatenablog.com/entry/20101008/1286531851)
* [図で分かるgit-mergeの--ff, --no-ff, --squashの違い - アジャイルSEを目指すブログ](http://d.hatena.ne.jp/sinsoku/20111025/1319497900)


