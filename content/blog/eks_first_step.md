+++
title = "EKS 学び始めに使った資料のまとめ"
date = 2020-03-01T13:15:17+09:00
isCJKLanguage = true
draft = false
+++

EKS を今年はじめぐらいから調べて使い始めているのだが、それにあたって参考にした資料群を一度まとめておく。

## EKS 全体

* [Amazon EKS Workshop :: Amazon EKS Workshop](https://eksworkshop.com/)
* [Kubernetes on AWS/EKSベストプラクティス2019.2 #jawsdays - Speaker Deck](https://speakerdeck.com/mumoshu/eksbesutopurakuteisu2019-dot-2-number-jawsdays)

AWS がオフィシャルで提供する Workshop がハンズオンしながら学べてわかりやすい。ドキュメントを脇に携えつつ、まずはこれの「Beginner」にあるコンテンツを全部通すといい感じになれる。「Intermediate」「Advanced」の内容は人によって要不要が分かれるので、各項で何が学べるのか調べつつ、不要であれば飛ばしてもいいかもしれない。

2つ目に挙げている mumoshu 氏の資料が情報量多くてすごい。EKS を使う上で考えなくてはならない点がかなり網羅されている。この資料を読んで、「何言ってるかわからない」と感じるページが無くなるように学習を進めたりしていた。ただし1年前のものなので、一部内容が古くなっている点は注意。

## EKS on Fargate

* [入門 EKS on Fargate - Qiita](https://qiita.com/mumoshu/items/c9dea2d82a402b4f9c31)
* [EKS for Fargateが出たので社内でファーストインプレッションの情報シェア会をやりました - inductor's blog](https://blog.inductor.me/entry/eks-for-fargate)
* [EKS on Fargate：virtual-kubelet の違い + Network/LB 周りの調査 - @amsy810's Blog](https://amsy810.hateblo.jp/entry/2019/12/04/151642)

ちょうど Fargate が EKS 対応してすぐの時期にあたり、 Fargate を採用するべきか、採用するのであればどのような場面で採用するべきかを考えた。 Fargate って Fargate 以前の EKS と比べてどうなの？という点については前者2つの URL が参考になった。最後のエントリーは Fargate とは何者なのか？ということを知る上で勉強になるのだが、まだ半分ぐらい理解できていない自覚がある。

## EKS 特有の観点

Kubernetes ではなく、 EKS にしか存在しない特有の観点というものがいくつかある。

### IAM Roles for Service Accounts (IRSA)

* [Kubernetes サービスアカウントに対するきめ細やかな IAM ロール割り当ての紹介 | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/introducing-fine-grained-iam-roles-service-accounts/)
* [IAM Roles for Service Accounts を　Terraformで手軽に体験してみる - onsd’s blog](https://onsd.hatenablog.com/entry/2019/09/21/015522)

Kubernetes の権限管理の仕組みである Service Accounts と、 AWS の権限管理サービスである IAM を連携した仕組みが IRSA 。導入が2019年9月と比較的最近であり、資料はまだ少なめな印象がある。また IRSA 登場以前に書かれたエントリーでは、 kube2iam など別のソリューションがベストとされていることもあり、注意したい。現時点では IRSA を基本的には使えばいいと捉えている。

### Amazon VPC CNI Plugin

* [ポッドネットワーキング (CNI) - Amazon EKS](https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/pod-networking.html)
* [aws/amazon-vpc-cni-k8s: Networking plugin repository for pod networking in Kubernetes using Elastic Network Interfaces on AWS](https://github.com/aws/amazon-vpc-cni-k8s)
* [Amazon VPC CNI Plugin for Kubernetes のアップグレード - Amazon EKS](https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/cni-upgrades.html)

EKS には CNI として VPC と連携するためのものがデフォルトインストールされている。あまりこれに特化して解説した資料が見つからなかったのでひたすら公式を読んでいる。 [Calico](https://docs.projectcalico.org/introduction/) の導入方法にも触れられている。

### kubectl

* [\[アップデート\]EKSを使う際にaws-iam-authenticatorが不要になりました! ｜ Developers.IO](https://dev.classmethod.jp/cloud/aws/eks-update-get-token-cmd/)

これも2019年5月と比較的最近のリリースで、 aws-iam-authenticator を勧めるのはすでに old な方法になっている。現状は `aws eks update-kubeconfig` を打つだけで `~/.kube/config` が更新されて kubectl が使えるようになる。シンプルで好き。

### 監視

* [Monitoring your EKS cluster with Datadog | Datadog](https://www.datadoghq.com/ja/blog/eks-monitoring-datadog/)
* [Key metrics for Amazon EKS monitoring | Datadog](https://www.datadoghq.com/ja/blog/eks-cluster-metrics/)

EKS 特有の監視方法やプラクティスは Datadog blog を参考とした。 Datadog はこれに限らず、システム監視について体系的にまとまった記事を量産していていつもお世話になっている。

Kubernetes 自体の監視については [我々は Kubernetes の何を監視すればいいのか？ | はったりエンジニアの備忘録](https://blog.manabusakai.com/2019/08/monitoring-kubernetes/) を読んだりしたが、まだはっきり答えが出せていない。調べているとよく名前を見かける [kubernetes-retired/heapster](https://github.com/kubernetes-retired/heapster#heapster) がすでに Deprecated になっていたり、変化も激しい。

## Kubernetes 全般

### Google Cloud Blog

* [クラウドネイティブ アーキテクチャ、5 つの原則 | Google Cloud Blog](https://cloud.google.com/blog/ja/products/gcp/5-principles-for-cloud-native-architecture-what-it-is-and-how-to-master-it)
* [Kubernetes best practices: mapping external services | Google Cloud Blog](https://cloud.google.com/blog/products/gcp/kubernetes-best-practices-mapping-external-services)
* [Kubernetes best practices: Organizing with Namespaces | Google Cloud Blog](https://cloud.google.com/blog/products/gcp/kubernetes-best-practices-organizing-with-namespaces)

Kubernetes 自体のプラクティスについては、やはり Google のほうが豊富に資料を用意している。特に [Kubernets best practices](https://cloud.google.com/blog/topics/kubernetes-best-practices) の各記事は一読しておいて損はなさそう。どう使えばいいのか迷ったらここを読む感じにしていた。

### 書籍

* [Cloud Native DevOps with Kubernetes](https://learning.oreilly.com/library/view/cloud-native-devops/9781492040750/)
* [Kubernetes Best Practices](https://learning.oreilly.com/library/view/kubernetes-best-practices/9781492056461/)
* [Kubernetes in Action](https://learning.oreilly.com/library/view/kubernetes-in-action/9781617293726/)
* [Kubernetes: Up and Running, 2nd Edition](https://learning.oreilly.com/library/view/kubernetes-up-and/9781492046523/)

いずれも [O'Reilly online learning](https://www.oreilly.com/online-learning/) で読んでいる。全部通読したわけではなくて、何か調べたいことがあったときに逐次辞書のように引いている。特に1番目の『Cloud Native 〜』は Kubernetes の初歩から始まり、 Kubernetes cluster をどのように運用していくのか、カオスエンジニアリングやシークレット管理の話、デプロイまわりなどかなり幅広くまとまっていておすすめ。1つのベンダーにとらわれることなく、各種 OSS や SaaS に少しずつ触れているので、cluster 運用に活用するツールの比較検討を進める端緒として使いやすい。最近日本語版も出ている。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://www.oreilly.co.jp//books/9784873119014/" data-iframely-url="//cdn.iframe.ly/0P3neqA"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

あとデプロイ（CI/CD）まわりもいろいろ読んだと思うのだけど、どれを読んだかちょっと思い出せなくなってしまった。

