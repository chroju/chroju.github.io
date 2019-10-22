+++
title = "Kubernetes に入門してからやってきたことのメモ"
date = 2018-08-19T14:46:59+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

数か月前からちょこちょこと Kubernetes を触っているのだけど、まだエントリーには何も起こしていなかったので、これまでやってみたことをツラツラと書き留めてみる。

なぜ Kubernetes か
----

単純に言ってしまうと「流行っているから」が最初の動機で、 [CoreOSからECSへDockerを移行した · the world as code](https://chroju.github.io/blog/2017/09/26/migrate_coreos_to_ecs/) に書いた ECS の環境から GKE へと移行した。

ただ、使い始めてからは少し印象が違ってきていて、これは単なる「流行り」ではなくて、 AWS が出てきて数年のうちに「 AWS は今後のインフラ環境の主流になる」という空気が醸成されたように、今後は Kubernetes がメインになっていく、まずは k8s に載らないかを検討するような形になっていくんだろうなという感覚になってきた。慣れてくるとわかるけれど、 k8s を運用する場面において物理的なインフラを意識することはほとんどなく、どのコンテナにどれぐらいのリソースを割かせ、どのコンテナとどのコンテナを接続して、計どれだけのコンテナを動かせばいいのか、というのを宣言すれば勝手にイイ感じにやってくれるので、インフラ管理という面でこの上なく楽。ただ、それは裏を返せばこれまでのインフラ概念と、まったく異なる概念の下で環境を運用しなくてはならないという意味でもあり、最初の学習コストは大きく感じる。

もう一点、 k8s が良いのは OSS であるという点で、つまりはクラウド隆盛以降にたびたび懸念されていたベンダーロックインが無い。今は最も簡単に k8s を扱える環境として GKE を使っているけれど、もし何か GKE に懸念が出てきたら Amazon EKS なり自前のオンプレ k8s なりに乗り換えるのも難しくない。なので学習コストは大きく感じると書いたけど、払ったあとの回収は今後数年長いスパンでできると思うし、払う甲斐はあると思う。 ECS よりはおそらく。

学習用「貧者のGKE」もどき
----

先に GKE を使っていると書いたが、具体的な環境としてはなるべく安価に済むように「貧者のGKE」にヒントを得ている。「貧者のGKE」は [貧者の GKE / 無料枠だけでクラスタを作ろう](https://qiita.com/apstndb/items/788f705e71e7660967a6) から引用させてもらった。

> 特に注目なのは US リージョンに限るが GCE f1-micro 1インスタンス, 30 GB の HDD が永続で無料なことだろう。GKE は5ノードまではマスタの課金はなく、ノードは GCE ノードとして課金されるので、この恩恵が受けられるはずだ。

残念ながら自分が動かしたいのは [influxDB](https://docs.influxdata.com/influxdb/v1.6/) で、こやつがそれなりにメモリを食うために f1-micro は使えず、次点の g1-small を使っている。これは無料ではないが、 us-central1 かつプリエンプティブであれば $5.11/month （2018-08-19 時点）で使えるのでまぁまぁ安い。プリエンプティブいいですね。個人用途なら十分だし、料金は通常の3分の1程度なので最高。

また他にも、 GKE を使うとデフォルトで作成される Google Cloud Load Balancing がそれなりに高いので、自前で nginx を使ってロードバランシングする、という節約術もあるらしい。自分の場合そこまではしていなくて、 g1-small プリエンプティブ2台構成で月額4000円程度になっている。もう少し下げたい、という気も確かにする。

* [安価なGKE（k8s）クラスタを作って趣味開発に活用する - えいのうにっき](https://blog.a-know.me/entry/2018/06/17/220222)
* [GKEでなるべく安くKubernetesクラスタを作成してPrometheus-+-Grafanaを使ってみる-Part2-Ingress編](https://kter.jp/kubernetes/2018/03/01/GKEでなるべく安くKubernetesクラスタを作成してPrometheus-+-Grafanaを使ってみる-Part2-Ingress編.html)

kompose
----

ECS からの移行には [kompose](https://github.com/kubernetes/kompose) を用いた。 kompose は Docker compose の YAML を k8s のマニフェストファイルに変換してくれるツールで、しかも Kubernetes が提供しているという最高のやつ。自分は ECS の環境を Docker compose のファイルで動かしていたので、 kompose によって楽に移行ができた。

kompose は本当に簡単で、正直最初は生成されたファイルをただ `kubectl apply -f hoge.yml` するだけで何もわからぬままに環境構築ができてしまって、逆に戸惑ったぐらいだった。今動かしているマニフェストファイルは GKE クラスタ構築用の Terraform ファイルと合わせて GitHub に上げてあるけれど、 kompose で生成した時点から多少いじってはあるが、そこまで大きく変えてもいない。

* [chroju/gke_sandbox: private GKE sandbox manifest files and terraform files](https://github.com/chroju/gke_sandbox)

学習リソース
----

基本的には [Kubernetes Engine ドキュメント  |  Kubernetes Engine  |  Google Cloud](https://cloud.google.com/kubernetes-engine/docs/) を見ているが、とりあえず1冊まとまっててザザッと概念的なものを見渡せるものが欲しかったので、オライリーが出している『入門 Kubernetes』をさっと読んだりもした。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873118409/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/41HRQrBzfOL._SL160_.jpg" alt="入門 Kubernetes" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873118409/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">入門 Kubernetes</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 18.08.19</div></div><div class="amazlet-detail">Kelsey Hightower Brendan Burns Joe Beda <br />オライリージャパン <br />売り上げランキング: 22,683<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873118409/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

この本は Pod, ReplicaSet, DaemonSet, Deployment といった、 Kubernetes をとりまく概念を1章ずつ割いて個別に解説してくれるので、各リソース概念がどのような働きをしているのか、またリソース同士がどういった関係性を持っているのかを整理するのにとても役立った。 Kubernetes はとにかく独自の概念が多い、というかほとんどが独自概念で構成されているツールなので、まずは個々の用語をきちんと抑えること、コンテナを動かすために何をどう設定すればよくて、その設定をデプロイしたときにどのリソースが生成されて、どのように動作しているのか、というところを早いうちに把握した方がいいと思う。これは AWS を触り始めた当初の感覚に近かった。 Kubernetes はかなりアップデートも速いので、いつまでこの本が有効性を持っていられるのかはわからないが、現時点では最初の一歩として通読しておくには良い本だと思う。

現状と今後
----

とりあえず Kubernetes 回りで触ったのはこんなところ。現状は g1-small 2台のクラスタ上で、 influxDB と Grafana のコンテナを1つずつ動かしているだけの状態。今後やってみたい、やろうと思っていることとしては以下の通り。

* 監視をする
  * Prometheus はさすがに大げさ過ぎる気がするが、リソースをそれほど食わないならやってみたい
  * 難しければ Mackerel あたりでなんとかする
* Tasks を使ってジョブを動かしてみる
* AWS Lambda で動かしているものを k8s へ持ってきて、運用上のメリデメなど比較している

個人的には今のとこ AWS で頑張って Serverless するより k8s 環境上で常駐プロセスもイベントドリブンなジョブも動かせるようにした方が管理しやすいんじゃないかなぁという感覚を持っているけど、一概に言える話でもないと思うので、どういうときにどれを使うのがベターかもっと掘り下げていきたい。無論、 VM やベアメタルにもまだ出番はあると思っている。


