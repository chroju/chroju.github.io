+++
title = "HashiCorp が Terraform state 用 remote storage を出すらしい"
date = 2018-10-29T20:49:07+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

先週 HashiCorp のイベント [HashiConf '18'](https://www.hashiconf.com/) がサンフランシスコで開かれていて、そこで発表された内容をつらつら追っていたのだけど、2つほど気になったのでメモしておこうと思う。ちなみに HashiCorp ツールは Terraform をとてもよく使っていて、それ以外だと Vault と Packer を多少使っているぐらいという感じで、ほぼ Terraform のことにしか興味がない状態。

## Google Cloud Shell から実行可能になった

可能になった、といっても自分が育てている任意の tf ファイルを持っていってどうこうするというわけではなくて、 HashiCorp が用意している example をボタンポチッとで Google Cloud Shell 内に持っていって、チュートリアル的に実行できるようになったという話。

とりあえず Terraform を試してみるにも、まずインストールして、ドキュメント見ながら tf ファイルを書いて、認証情報持ってきて、そこからようやく実行という感じで手数が多いと言えば多かったのかもしれなくて、それがブラウザからすぐお試し可能になった。すでに Terraform ドキュメントのいくつかにボタンが用意されていて、例えば [google_compute_router](https://www.terraform.io/docs/providers/google/r/compute_router.html) に表示されていたりする。これをポチッとすると、 Google Cloud Shell が開いて、そのまま example を実行できる。試してみたけど、確かに最初の一歩を覚えるにはいいかもしれない。

<a href="https://gyazo.com/fe7f226c0d8db7ee849b85cce85f02e8"><img src="https://i.gyazo.com/fe7f226c0d8db7ee849b85cce85f02e8.png" alt="Image from Gyazo" width="600"/></a>

## Terraform state を保存する場所を HashiCorp が用意してくれる

表題の件に移るが、 Terraform の state file はクラウド上に単一のものを保存して、実行者間で共有しましょうというのは自明だと思うけど、それをじゃあどこに置くのかというのはユーザーの裁量に任されていた。おそらく Amazon S3 など、管理対象クラウドサービスにあるストレージが選ばれている気がするけれど、これを HashiCorp が無料で用意してくれるらしい。しかも無料。

> * No limits on users
> * No limits on workspaces
> * Encryption provided by HashiCorp Vault
> * Per-operation locking

ちょっと上手い話すぎませんかねぇとも思うけど、 Docker が Docker Hub を提供しているようなものと考えると頷ける気もする。正直 S3 で事足りている感はあるし、 S3 で実現可能なバージョニングなどの機能が入るのかはわからないけれど、使い勝手によっては検討したい。今年中にベータ版がオープンするそうで、 [Wishlist](https://app.terraform.io/signup) への登録受付がすでに始まっているので、興味がある人は登録してみるといいと思う。

関連して、これはすでに Terraform Enterprise で始まっているみたい（使ったこと無いのでよく知らない）けど、 plan や apply のコマンドを手元で実行するのではなく、 remote で実行するための環境を無料でも制限付きで開放するようだ。個人的な懸念として、手元のコンソールで terraform apply を実行するのは面倒に感じることは確かにあって、 tf ファイルが大きくなってくると数十分待たされることも少なくないし、実行結果を残すのが一手間いるし、実行者が複数いる場合には、個々の環境にインストールされている Terraform にバージョン差異が生まれてしまって上手く実行できない、なんてのもあり得る。解決策として CI を使って実行させたりもしているけれど、環境構築の手間はある。それを解決できる、シンプルに Terraform を実行するためだけのサービスがローンチされるのはわりと嬉しい気がする。

## Tool から Workflow へ

HashiConf '18 のレポートの中で、 HashiCorp の Tao の中に "workflows, not technologies.”というのがあると触れられているけれど、今回の Terraform 周りのリリースはまさにそれで、従来は単に便利な OSS を配っている企業という印象が強かった HashiCorp が、その実行基盤まで用意してくれるようになってきた。クラウドリソースの定義さえ書いてもらえれば、その管理とか実行とかのワークフローはマネージドなサービスに全部任せられますよというのは良い流れだと思うし、 Ansible が GUI の管理ツールである Ansible Tower をプッシュしている流れにも似たものを感じる。自分は CircleCI とか使えば間に合うんじゃないかなと思ったりもするのだが、運用管理に特化したツール、サービスが充実してくると、そのあたりに厳しい大企業など、マスに広がりやすくなるように思う。 Terraform は好きなツールなので、裾野が広がりやすくなる動きは応援したい。

あと Terraform 0.12 と HCL2 もそろそろクルーーー？な感じで期待している。HCL は GitHub Actions でも採用が決まったので、なんか汎用的に使われていく未来もあるかもですね。その他 HashiCorp '18 の情報は以下のブログエントリーなど参照で。

* [HashiCorp Product Announcements at HashiConf 2018](https://www.hashicorp.com/blog/hashicorp-product-announcements-at-hashiconf-2018)
* [Terraform Collaboration for Everyone](https://www.hashicorp.com/blog/terraform-collaboration-for-everyone)
* [Kickstart Terraform on GCP with Google Cloud Shell](https://www.hashicorp.com/blog/kickstart-terraform-on-gcp-with-google-cloud-shell)

