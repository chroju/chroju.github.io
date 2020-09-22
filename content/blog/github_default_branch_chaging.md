+++
title = "GitHub default branch を意識しなくて済むようにする"
date = 2020-09-21T19:25:32+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

<div class="iframely-embed"><div class="iframely-responsive" style="padding-bottom: 52.5095%; padding-top: 120px;"><a href="https://github.blog/changelog/2020-08-26-set-the-default-branch-for-newly-created-repositories/" data-iframely-url="//cdn.iframe.ly/yt7u8pA"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

10月1日より、 GitHub で新規レポジトリの default branch が `main` に変更される。この設定はオプトアウト可能であり、ユーザーや organization それぞれで必要に応じてあらかじめ設定しておく必要があるわけだが、みなさま確認はお済みだろうか。

default branch 名として `master` を使うことの是非の話はさておき、今後は default branch がレポジトリによって多種多様になる可能性が高い。これまでは何も考えず `git switch master` を打っていた操作が、レポジトリごとに「main だっけなんだっけ」みたいな思考を挟まなくてはならないのはさすがに面倒である。ということで、 default branch を少なくともローカルでは意識しない生活を送ることにした。

## default branch をコマンドで取得する

端的に結論から言えば、 `git symbolic-ref --short refs/remotes/origin/HEAD` を打てばよい。

```bash
$ git symbolic-ref --short refs/remotes/origin/HEAD
origin/master
```

具体的にこれは何をしているかと言えば、 `.git/refs/remotes/origin/HEAD` から情報を取得している。 `.git/refs` は git レポジトリ内の各種参照情報が格納されたディレクトリであり、その中でも `.git/refs/remotes` には追跡ブランチの情報が格納されている。例えば追跡ブランチ `origin/hoge` が存在すれば `.git/refs/remotes/origin/hoge` ファイルが存在し、その内容は `origin/hoge` の最新 commit hash となっている。 `.git/refs/remotes/origin/HEAD` はリモートリポジトリの HEAD が参照するブランチの情報が格納されており、つまるところここから default branch が取得できる。

ファイルを直に `cat` しても値は取得できるが、安全性を鑑みて `.git/refs` 配下を触る場合は `git symbolic-ref` コマンドを使うことが推奨されている。このあたり、詳しくは以下の記事を参照した。 Git に関してはこの git book を読めばだいたい解決すると認識している。

参照 : [Git - Gitの参照](https://git-scm.com/book/ja/v2/Git%E3%81%AE%E5%86%85%E5%81%B4-Git%E3%81%AE%E5%8F%82%E7%85%A7)

## default branch へ switch するサブコマンドをつくる

default branch の取得方法がわかったので、あとは好きにこれを使えばいいのだが、僕の場合は `git switch master` が一番よくつかうコマンドだったので、これを改め、 `git default` コマンドで default branch へ switch できるようにした。

git には、 PATH が通った場所に `git-hoge` の命名規則に沿ったコマンドがある場合、 `git hoge` のサブコマンド形式で実行できるようになるという性質がある（参考 : [gitのサブコマンドを自分で作る - blog.ton-up.net](https://blog.ton-up.net/2013/12/12/git-subcommand/)）。これを利用して、 `/usr/local/bin/git-default` に以下のスクリプトを書いて保存した。

```bash
#!/bin/bash
git switch $(git symbolic-ref --short refs/remotes/origin/HEAD | cut -f 2 -d '/')
```

`origin/master` という慣れ親しんだものが絶対ではなくなる、と知ったときにはかなり同様したが、まぁ結局のところ名前なんて飾りであるとも思うし、意識しなくて済むものは意識しない形にどんどん持って行こうと思う。

## 追記 2020-09-22) default branch 変更の手順

そもそもの default branch 変更の手順だが、 `branch -m` コマンドで master からブランチ名を変更した上で、 `push -u origin HEAD` した後、 GitHub 側で repository settings から設定変更を行うことになる。

```bash
$ git branch -m master main
$ git push -u origin HEAD
```

ただ、 `.git/refs/remotes/origin/HEAD` は `git clone` した際に確定してしまっており、この手順を行っても自動的に GitHub の設定に追従することはない。 `symbolic-ref` コマンドで別途編集してやる必要がある。

```bash
$ git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main
```

また、 `git init` した際の default branch については、 `.gitconfig` で global に設定できる。

```ini
[init]
  templatedir = ~/.gittemplates
  defaultBranch = main
```

default branch 変更に関しては、 github/renaming で guidance が公開されているので、こちらも合わせて参照したい。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/github/renaming" data-iframely-url="//cdn.iframe.ly/GDo9Tyb"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>
