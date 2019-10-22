+++
categories = "ansible vps linux"
comments = true
date = "2015-07-20T00:00:00+09:00"
title = "AnsibleとDigitalOceanでどこでも使える開発環境を作る"

+++

個人開発環境としては自宅にiMac 2010Mid、モバイルでVAIO Pro 11に入れたArch Linuxを使っているのだが、メインとしてはiMacの方を利用していて、デプロイしたりなんだりは自宅からしか出来ない状態にある。じゃあVAIOに移せばいいやんとも思うのだが、こちらも会社PC（なぜかこちらもVAIO Pro 11）と二重になってしまうので始終持ち歩きたくはなく、平日フラフラしてるときにサッとbash入りたいなみたいのが出来ずにいた。

結論としてVPSを開発環境として扱い、最悪iPad miniからいつでもSSH接続してbash叩けるだけでも幸せかなというところに至った。これまで[http://chroju.net](http://chroju.net)をさくらVPSで運営していたので、特に考えずさくらをもう1台追加したりもしたのだが、ちょっと調べてみると[DigitalOcean](https://www.digitalocean.com/)が最近流行りつつあるようだったので、他社サービスも使ってみると面白そうだってことで新規契約してみた。

## DigitalOcean

すでに他所で言われてはいるが、利点としてはこんなところかと思う。

* 月額課金ではなく時間課金なので、使いたいだけ払えばOK
* 安い
* アプリケーションやSSH鍵が最初から組み込まれたイメージを作れる
* REST APIでだいたいのVPS操作ができる

要するに使いたいときに使いたい環境をバチコンと作れちゃうというのが一番のメリットなので、今回のような永続的に使う開発環境より、一時的なテストなんかに使った方が良いのだと思う。とはいえ時間課金上限が月あたりで定められており、現状最安プランだと月5ドルが上限になっていたりもするので、永続的にマシンを上げておく分にも安いのは確か。なお、課金はイメージを作った時点で開始されるので、不要なマシンはhaltではなくdestroyしておく必要がある。まぁ無料のスナップショット機能もあるから、リカバリできると思えばdestroyしてしまうこともそこまで難しくはないかなと。

REST API提供ということで、CLIから落としたり上げたり壊したりなんだりも全部できるのだが、だったらひょっとして誰かがアプリとか作ってんじゃねーかなと思ったら、やっぱりすでにあった。

<div class="bookmarklet bookmarklet-gp" itemscope itemtype="http://schema.org/MobileApplication" style="clear:both;min-height:165px;width:100%;max-width:468px;overflow:hidden;padding:12px;border:1px solid;border-color:#eaeaea #ddd #d0d0d0;-moz-box-sizing:border-box;box-sizing:border-box;border-radius:5px;"><dl class="bookmarklet-gp-info" style="margin:0;"><dt class="bookmarklet-gp-title" style="border-bottom:1px solid;border-color:#eaeaea #ddd #d0d0d0;font-weight:bold;margin:0 0 .5em 0;padding:0 0 .5em 0;"><img alt="Google play" class="favicon" style="vertical-align:middle;border:0;" src="//ssl.gstatic.com/android/market_images/web/favicon.ico" /> <span itemprop="name">DigitalOcean Swimmer Android</span></dt><dd class="bookmarklet-gp-desc" style="font-size:.9em;margin:0;"><div class="bookmarklet-gp-thumb" style="float:left;"><img src="https://lh3.ggpht.com/HXBZyHdspPh5MFgaC-rOXAZIZc8D9uM4KrQsL-gqoB1_9ZuBhthaWYLRoYJYNUY9Ytg=w300" alt="DigitalOcean Swimmer Android" itemprop="image" style="height:120px;width:120px;max-width:100%;vertical-align:middle;border:0;margin:0 1em 0 0;"></div><div class="supplier" itemscope itemtype="http://schema.org/Organization">制作: <span itemprop="name">Hannoun Yassir</span></div><div class="review" itemtype="http://schema.org/AggregateRating" itemscope itemprop="aggregateRating">評価: <span itemprop="ratingValue">4.4</span> / 5段階中</div><div class="price" itemtype="http://schema.org/Offer" itemscope itemprop="offers">価格: <meta itemprop="price" content="0">無料<small> (2015/7/11 時点)</small><br /></div><a href="https://play.google.com/store/apps/details?id=com.yassirh.digitalocean&hl=ja" target="_blank" title="DigitalOcean Swimmer Android" itemprop="url" style="float:right;"><img src="//dl.dropboxusercontent.com/u/540358/ja_generic_rgb_wo_45.png" alt="ダウンロード" style="border:0;display:inline-block;height:auto;vertical-align: middle;"/></a><small>posted by: <a target="_blank" href="http://hayashikejinan.com/?p=818">AndroidHTML v3.1</a></small></dd></dl></div>

このアプリさえあればGUI操作はほぼ全部できる。

ちなみにこんなことでハマる人はほとんどいないだろうと思うが、自分がハマったポイントとして`authorized_keys`の件がある。Digital OceanではあらかじめWeb GUIで公開鍵を上げておき、VPSをcreateするときに最初から任意の鍵を入れておくことができるのだが、当初は`root`以外のユーザーがいないため、当然ながら`authorized_keys`のパスも`/root/.ssh/`配下となる。構築用には別のユーザーを設けることになると思うが、その際には`authorized_keys`を`/home/user`配下へ持ってきて、アクセス権の適切な設定などもしなくてはssh接続できないので注意。

## Ansibleによる初期構築

巷ではVagrantと連携して、`vagrant up`でDigitalOceanにマシンを上げるのが流行ってるらしい。

* [vagrantではじめるクラウド開発環境（DigitalOcean編） - Qiita](http://qiita.com/msykiino/items/d45cab7f520a3288862a)
* [VagrantとSSDなVPS(Digital Ocean)で1時間1円の使い捨て高速サーバ環境を構築する - Glide Note - グライドノート](http://blog.glidenote.com/blog/2013/12/05/digital-ocean-with-vagrant/)

とはいえ自分は冒頭に書いた通り、最悪iPad miniでもいいので外から繋ぐという運用をしたかったので、Vagrantからの起動は使えない。なので初期構築には最近学び始めたAnsibleを使ってみた。

インフラ管理系のツール、使ったことがあるのはChefぐらいで、Puppetは概念だけ知ってはいるが、Ansibleの特色はやはりハードルの低さ、学習コストの低さだと思う。エージェントレス、`knife`のような特殊なコマンドもほとんど覚える必要がなく、`ansible-playbook`コマンドさえ覚えておけばとりあえずなんとかなってしまう。

* エージェントレスなのでpipで手元のマシンにansibleを入れればすぐ使える。
* 設定はyamlによるplaybookに書き出すので、文法も比較的容易。
* 1個1個のタスクは定められたモジュールを用いて書くことになるが、やりたいことを公式Docsの[Module Index](http://docs.ansible.com/modules_by_category.html)で探ればわりとなんとかなる。
* ディレクトリ掘ったり`knife`みたいなコマンドいっぱい覚えなくても、とりあえずyaml1つとコマンド1つあれば始められる。

pip経由でのインストールが必要なので非pythonista的には若干戸惑いもありましたが、学習コストの低さはハンパないのでインストールから1時間もあれば一旦サーバー建てられました。ノウハウもQiitaはじめ随所に落ちてはいるけれど、正直公式ドキュメントがかなり充実していて、[YAMLのシンタックスガイド](http://docs.ansible.com/YAMLSyntax.html)まで付いていたりするので、下手にググってやるよりもドキュメントちゃんと読んだ方がいいと思う。まぁ、Ansibleにかぎらずなんだってそうではあるが。ただ、複数台管理だとかアプリのデプロイだとかをやろうとすると当然ディレクトリ構成も複雑になって、既存のプラクティスが必要になってくるので、あくまで「導入の学習コストが低い」という感じだが。

書いたPlaybookはとりあえずGitHubに上げた。[こちら](http://akiyoko.hatenablog.jp/entry/2013/12/16/020529)を参考に、いわゆるVPS作るときの初期設定だけまとめている。ただしわりと俺用（dotfiles引っ張ってきたりとか）。Ansibleについてはまた別の記事でまとめようと思う。

[chroju/ansible](https://github.com/chroju/ansible)

## iPadからのSSH接続

クライアントソフトがいろいろあるのは知っていたが、ここまでのレベルと思わんかったなーというのが[Prompt2](https://panic.com/jp/prompt/)。

<a data-flickr-embed="true" href="https://www.flickr.com/photos/chroju/19822940536" title="prompt_with_digitalocean"><img src="https://farm1.staticflickr.com/541/19822940536_5f6201ca53_z.jpg" width="640" height="480" alt="prompt_with_digitalocean"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

vim-lightlineもきちんと表示してくれるし日本語も可だし、外付けキーボードの煩わしささえ考慮しなければかなり快適である。当然ながら鍵認証も使えるし、ぶっちゃけWindowsのラップトップ持ち歩くぐらいならこっちの方がSSHはストレスないんじゃないかというぐらい。つないでちょこちょこっと使えればいいかなぐらいの思いだったが、嬉しい誤算だった。さすがに有料ではあるけど。

おかげさまで場所を選ばず開発環境につながるようになったので、ちょっと試したいツールがTLに上がってきたりしたらおもむろにiPadを取り出して試したりとかできる。すぐ復元したいのであれば、先のAndroidアプリで予めスナップショットを取ったりもできるし、楽すぎて笑える。

