+++
title = "CUI 開発環境 2019 - tmux, fzf, ghq, Starship, aws-vault, etc"
date = 2019-11-17T12:45:58+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

[パラレルワーカー兼大学生になることになった · the world as code](https://chroju.github.io/blog/2019/06/14/become_parallel_worker_and_university_student/) で書いた新しい職場に入って、実はエンジニア人生9年目にして初めて macOS をメインで与えられる職場に入りまして。今まで全部 Windows だったというなかなか自分でも信じがたい事実（まぁ Linux で VM 立ち上げてその中で作業したりコーディングしてたりもしたけど）。それで macOS だと常に zsh 開いておけるし（ Windows でもできなくはないが）、シェルで生活する時間が大幅に増えたので、これを期にと CUI の開発環境を整えたので一旦まとめておく。ざっくり以下の技術あたりを使っているので順に書く。

* tmux
* fzf
* ghq
* Starship
* aws-vault

tmux
----

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/tmux/tmux" data-iframely-url="//cdn.iframe.ly/grp31K2"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

4年ぐらい前に一度入門したものの、 iTerm2 のタブと画面分割があれば別にいいかなという感じで使わなくなっていたのを改めて使い始めた。きっかけになった理由は実はだいぶ些細で、 macOS の全画面表示ってメニューバーを隠してしまうので時間がわからないのが困って、ステータスバーに時刻を表示したくなったというところ。実際使い始めてみるとセッションを作って長くかかるコマンドを裏で実行させたままデタッチして別のことやる、みたいなのがなかなか便利で手放せなくなりつつはある。

以前使っていた tmux.conf を引っ張り出してはみたが、 powerline 周りの設定は忘れているし、学習コストかけたくもなかったので外部プラグインへの依存はやめた。 tmux デフォルトのステータスバーを使って時刻などは表示している。

<a href="https://gyazo.com/094ef9703c2af0f99d811193548d57b8"><img src="https://i.gyazo.com/094ef9703c2af0f99d811193548d57b8.png" alt="Image from Gyazo" width="795"/></a>

fzf + ghq
---------

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/junegunn/fzf" data-iframely-url="//cdn.iframe.ly/6Emgp7l"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

fzf は以前から興味はあったけど使ってなくて、というか動作原理がよくわかっていなかったのだが、ちゃんと使ってみたらすごく便利だった。

複数行のテキストを標準入力から突っ込むと、曖昧検索ができる TUI が開き、そこで検索をして1つ結果を選択すると、その文字列を吐き出すという、日本語で書くとこういう動作をする。例えば git のブランチ切り替えだとか、複数のファイルから1つ選んで開くとか、そういう「多くの選択肢から絞りたい」操作をするのに役立つ。まぁ見たほうが早いと思う。

<a href="https://gyazo.com/69ddc6d8e70ddc5ae4ea83c26bd9cd4c"><img src="https://i.gyazo.com/69ddc6d8e70ddc5ae4ea83c26bd9cd4c.gif" alt="Image from Gyazo" width="1000"/></a>

こういう感じ。ただ、手でこういう風に `fzf` コマンドをわざわざ打つのではなくて、基本的な使い方としてはよく使うコマンドを関数として定義して `.zshrc` などに書いておいて、必要に応じて呼び出すという形を取る。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/motemen/ghq" data-iframely-url="//cdn.iframe.ly/kzGagrT"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

これと組み合わせて使うとすごく良いのが ghq 。ローカルに置く git レポジトリを管理してくれるツールで、 `.gitconfig` に以下のように root となる場所を書いた上で `ghq get chroju/chroju.github.io`  と打つと root 配下に `git clone` してくれる。そして `ghq list` で、 root 配下に置かれた git レポジトリの一覧をずらっと出力してくれる。つまり fzf と組み合わせるとこういう関数が書けるということ。これがだいぶ快適で1日100回ぐらい打ってる。

```bash
fghq() {
  local dir
  # fzf-tmux は tmux で検索用 TUI をペイン分割して表示してくれるコマンド
  dir=$(ghq list > /dev/null | fzf-tmux --reverse +m) &&
    cd $(ghq root)/$dir
}
```

他にも fzf はアイディア次第でいろんなことができそう。例えば AWS CLI と組み合わせて、 `ec2 describe-instances`  結果を食わせてインスタンス停止するとか、よくやるオペレーションを関数化しておいても便利かなと。

### ghq と GOPATH

余談的な話。自分は Go を書く機会が多い。で、 Go のレポジトリは最近状況が変わってきてはいるけれど、 `$GOPATH ` で指定したディレクトリを root として、 `$GOPATH/src/github.com/chroju/...` という具合の場所に置かれるというのがスタンダードになっている。

Go とそれ以外のコードでレポジトリの置き場が替わるのも嫌なので、自分は `$GOPATH/src` にあたるディレクトリを ghq の root として設定している。幸い Go も ghq も `github.com/chroju/chroju.github.io` という形でディレクトリを掘って clone してくるので、この設定によって Go でも非 Go でも気にせず同様の構成でディレクトリが管理できている。

このあたりは以下のエントリにインスパイアされている。

<div class="iframely-embed"><div class="iframely-responsive" style="padding-bottom: 75%; padding-top: 120px;"><a href="https://songmu.jp/riji/entry/2019-03-28-go-modules.html" data-iframely-url="//cdn.iframe.ly/K36hOoI"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

Starship
--------

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="http://starship.rs/" data-iframely-url="//cdn.iframe.ly/bxOEBO2"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

プロンプトをいい感じにしてくれる Rust 製のツール。スクショは tmux のときに貼ったものを参照。

以前までは zsh のプロンプト設定を自分で書いていたんだけど、あんまり可読性のいい記法ではないし、しばらく経つと書き方を忘れてしまうので外部ツールに頼って楽をすることにした。 Starship が良いのはシェル依存ではないので、仮に今後 Fish に移りたくなってもそのまま持っていけるということ。 `brew install` して `eval "$(starship init zsh)"` したらその瞬間からプロンプトがいい感じになる。

設定も豊富でよい。デフォルトの状態で git 関係の表示、ディレクトリ表示はやってくれるし、カレントディレクトリに `go.mod` があれば Go のバージョン、 `requirements.txt` があれば Python のバージョンを表示してくれる。設定の追加もできて、自分の場合は `AWS_PROFILE` を設定していたらそれを表示するようにしている。基本的には使わない環境変数だけど、たまに動作確認などでセットしたまま忘れてたりするので、事故防止になっていい感じ。

powerline font を求められることだけ面倒なんだけど、たぶん設定変更して絵文字を使わないようにしてやればそれも要らなくなる気がする。

aws-vault
---------

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/99designs/aws-vault" data-iframely-url="//cdn.iframe.ly/o7Vzpd3"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

macOS の Keychain と連携して AWS API のアクセスキーを管理してくれるツール。別の AWS アカウントへ switch する `assume role` 操作がすごく楽になるのでそれで使っている。以下は README からの引用だけど、 `~/.aws/config` をこんな風に書いて `aws-vault exec prod-readonly -- aws ec2 describe-instances` という具合に実行すると、これで switch ができる。

```ini
[profile jonsmith]
region = us-east-1

[profile prod-readonly]
region=us-east-1
role_arn = arn:aws:iam::111111111111:role/ReadOnly
source_profile = jonsmith
```

重宝するのは、これで Terraform も assume role での実行ができること。以前 [Terraform で AWS assume role が使用できない場合がある · the world as code](https://chroju.github.io/blog/2018/12/10/terraform_with_aws_assume_role/) で書いたとおり、基本的に Terraform は assume role に対応できていないので、この方法を使うのが一番ラクだと思う。

Conclusion
----------

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/chroju/dotfiles" data-iframely-url="//cdn.iframe.ly/NGvxAWO"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

今書いたような設定は全部 dotfiles としてレポジトリにまとめているので、コードで見てもらったほうが早いのかも知れないです。 Ansible 流して会社 macOS の設定が数分で終わったときにはやるやんけ自分ってちょっと思いました。


