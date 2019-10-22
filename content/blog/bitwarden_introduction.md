+++
title = "パスワード管理サービスを Bitwarden でセルフホストする"
date = 2019-08-18T10:51:15+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

パスワード管理と言えば 1Password や Lastpass あたりのクラウドサービスが人気だと思うのだが、どうにも第三者の運営するサービスに機密情報を預けるというのが苦手で、長らくオープンソースのファイル保存型パスワードマネージャーである [KeePass](https://keepass.info/) を使ってきた。これは保存したパスワードなどはファイルに書き出されて暗号化されるという形を取るので、そのファイルを Dropbox に置くことでマルチデバイスでの同期を図っている（Dropbox に預けるのは OK で 1Password は NG というのは理屈に合わないというのはわかっている）。

そこに来て、最近始めた仕事でかなり　BYOD というべきか、会社の PC からでも家の PC から（要するにリモートワーク）でも会社で使っているサービスにログインして仕事をする、というスタイルが求められる場合が増えた。従って会社と家の PC でパスワードを共有したいのだが、会社の PC に私用で使っている Dropbox をインストールするのも気が引けるなどして、いい機会だしということで　KeePass に代わるサービスを探すことにした。使い始めたのは Bitwarden 。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://bitwarden.com/" data-iframely-url="//cdn.iframe.ly/Uz1WxyJ"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

基本的には 1Password と同様にクラウドでパスワード管理してくれるサービスなのだが、パスワード管理サーバーのソースが GitHub で公開されており、サーバーをセルフホストして使うことができるようになっている。よってクラウド型パスワードマネージャーのメリットである「どの端末からでもインターネットに繋がればパスワードを取得できる」というメリットは享受しつつ、第三者にパスワードを預けるという形を回避できる。

## Bitwarden サーバーの Deploy

デプロイ方法は公式にやり方が書いてあるので難しくない。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://help.bitwarden.com/article/install-on-premise/" data-iframely-url="//cdn.iframe.ly/Pb7prLy"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

プロセス1つ上げればいいのかと軽く考えていたのが、 Docker コンテナ6個上げる必要があるのはちょっと予想していなかったが、 `docker-compose` コマンドでサクッと上げられるので手間は少なかった。サーバーはコンテナ6個と言うことでミニマムなものを使うわけにもいかず、 AWS EC2 の t3.small を1台手配している。従ってコスト的には全然美味しくなくて、ぼちぼちリザーブドインスタンスを買うつもりでいる。当初は VULTR で立てていたのだが、セキュリティに関して安物のサーバーを使うのも微妙だし、後述する各種運用のことを考えると使い勝手に懸念もあったので EC2 へ移した。

また https を使うために Let's Encrypt が組み込まれており、証明書も作成できるのだが、そのために独自ドメインが必要になる。やはりコスト的には全然旨味はない。

## Bitwarden サーバーの運用

### 監視

停まると困るので Mackerel で死活監視している。まだ運用開始から1か月ちょっとなので落ちたことはないが、 EC2 だしたまに落ちる可能性は考慮するべきとは思っている。

### セキュリティ

当然ながらセキュリティが気になるところなのだが、自宅だけから使うわけでもないので、 80/443 ポートの全開放は致し方なしというところ。それ以外のポートはすべて閉じている。メンテナンスのために ssh したくなる機会はあるが、 AWS Systems Manager を使うことにして、穴は閉じた。

<div class="iframely-embed"><div class="iframely-responsive" style="padding-bottom: 52.5%; padding-top: 120px;"><a href="https://dev.classmethod.jp/cloud/aws/session-manager-launches-tunneling-support-for-ssh-and-scp/" data-iframely-url="//cdn.iframe.ly/flrSldZ"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

マスターパスワードはかなり長めにして、もちろん2段階認証をかけている。併せて Mackerel のログ監視を使って、400番のエラーが出た場合は Slack に通知させるようにした。挙動を見たところ、パスワードや2段階認証の誤りで弾かれた場合には 400 を返すらしいのだが、パスワード認証を終えて2段階認証をこれから行う、という場合でも400が出るようで、自分がログインするときにも通知されてしまってはいる。今の所已む無しと言うことで許容した。

<a href="https://gyazo.com/4991a63e46cec9238e77f575d7a31deb"><img src="https://i.gyazo.com/4991a63e46cec9238e77f575d7a31deb.png" alt="Image from Gyazo" width="952"/></a>

ポート開放の話は、自分が使いたいときだけ Slack からスラッシュコマンドで穴を開ける、というようなやり方もできそうだし、検討はしたい。

### バックアップ

Bitwarden のドキュメントにバックアップするべきファイルの情報は書かれているが、横着して AWS Backup で日次バックアップを EBS まるごと取得している。

## 使い勝手

肝心の使い勝手の面は、今のところ満足している。 KeePass をはじめ各種類似ツールがエクスポートした情報を読めるようになっているので、移行は一瞬で済んだ。

ツールは各 OS 向けのデスクトップアプリ、各モバイルアプリ、 Chrome 拡張、コマンドラインツールと豊富に用意されているが、デスクトップに関しては Chrome 拡張だけで事足りている感じ。パスワードに URL を紐つけて登録しておくと、そのドメインのサイトにアクセスした際、自動でサジェストしてくれたり、上手くいけば自動入力までやってくれるのでストレスが少ない。

<a href="https://gyazo.com/0e43ed5b79ff92b0848c686ee17550a4"><img src="https://i.gyazo.com/0e43ed5b79ff92b0848c686ee17550a4.png" alt="Image from Gyazo" width="597"/></a>

なんかプレミアム会員 $10.00/年 を買ってコード入れて機能開放すると、 YubiKey 使った2段階認証とかも使えるようになるらしくて、それはそれで興味がある。が、有償でやるまでもなーーとか考えたり、いやでも t3.small 常時稼働させてるならもう $10.00/年 ぐらい誤差じゃん、、、という気もして、ちょっと悩んでる。
