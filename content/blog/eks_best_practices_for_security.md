+++
title = "EKS Best Practices Guide for Security を読んだ"
date = 2020-10-17T12:57:20+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

[Amazon EKS Best Practices Guide for Security](https://aws.github.io/aws-eks-best-practices/) を読んだ。今年5月に公開された比較的新しい文書で、いわゆる docs.aws.amazon.com の中に収録されておらず、単独で github.io にホストされている。ともすると、 UI からは AWS official な文書なのかわかりにくいのだが、以下の通り、 official でアナウンスされている。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://aws.amazon.com/jp/about-aws/whats-new/2020/05/introducing-amazon-eks-best-practices-guide-for-security/" data-iframely-url="//cdn.iframe.ly/2Hf1Mhp?iframe=card-small"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

EKS と銘打たれている通り、 Kubernetes ではなく EKS にフォーカスした記述は少なくない。例えば暗号化についての項では、 [Nitro](https://aws.amazon.com/jp/about-aws/whats-new/2020/02/announcing-36-percent-faster-ebs-optimized-performance-on-additional-aws-nitro-system-based-amazon-ec2-instances/) におけるトラフィックのデフォルト暗号化に触れていたりする。しかし大半は Kubernetes あるいは Docker そのもののプラクティスになっていて、 EKS に限らずとも、 Kubernetes 使用者にとって学べることは多い。内容は Identity and Access Management に始まり、 Pod や Network 、 Runtime といった各要素のセキュリティプラクティスを俯瞰し、 PCI DSS のようなコンプライアンス関係についても少し記述を割いている、かなり包括的な内容となっている。

すべてオープンソースでの公開となっており、 https://github.com/aws/aws-eks-best-practices から issue や Pull Request を出すこともできる。また、 `for Security` と銘打っている以上、他にも `for XXX` が続くのではないかと期待されるところだが、レポジトリに GitHub Project が設けられており、そこから Performance 、 Reliability 、 Cost Optimization などが計画されていることが垣間見える。つい先日は `for Cluster Autoscaler` が追加された。個人的に、 AWS のドキュメントを読んで組めるのは「とりあえず使える Kubernetes」であり、そこからプラスアルファで行うべきプラクティスは非常に多く、なかなか捉えどころも難しいように感じている。何年か前の状況に置き換えると、 EC2 で nginx と Rails を動かすだけならそれなりに簡単だけど、セキュリティグループや LB をきちんと扱えているか、 Scaling をどうするのかといった非機能的要件になると話が変わってくるようなイメージだ。それがオフィシャルな Best Practices としてまとまり、さらにオープンに編集可能というのは非常に嬉しいことだなと感じている。

以下、自分が読んだ中でメモした箇所をいくつか挙げておく。

* Pod Security
  * コンテナイメージに shell を入れるべきではない
    * `sh` ぐらいは入れていることがあるので、そこまで徹底出来る方が確かに好ましそう
  * Pod Security Policy
    * https://kubernetes.io/docs/concepts/policy/pod-security-policy/
    * root での起動を許可しないなどいくつかルールを定め、そのルールに従った Pod 以外は起動できなくするもの
    * まだ beta だが使ってみたいところ
* Multi-tenancy
  * Namespace を使った Soft multi-tenancy や、 cluster 自体分離する Hard multi-tenancy について説明されている
    * 個人的には Soft で限りなく済ませておきたい気持ちが強い
    * [Kubernetes Multi-Tenancy – A Best Practices Guide | Loft Blog](https://loft.sh/blog/kubernetes-multi-tenancy-best-practices-guide/) あたりも参考に
* Detective Controls
  * audit log の解析や監視
  * 同様に CloudTrail log も
  * 地力で監視するのはどう考えても大変なので自動化して何か考えたいが。。
* Infrastructure Security
  * [aquasecurity/kube-bench: Checks whether Kubernetes is deployed according to security best practices as defined in the CIS Kubernetes Benchmark](https://github.com/aquasecurity/kube-bench)
    * CIS Kubernetes Benchmark に則っているかチェックしてくれるツール
  * Amazon Inspector の活用
* Incident response and forensics
  * 実際にセキュリティインシデントが発生したら、どう対処するか
    * Network Policy を使った通信の遮断
    * 該当 node に対して cordon を実施
    * 問題のある node や pod に label を付与してわかりやすくしてから対処する
    * などなど
* Image Security
  * 大原則として、余計なソフトウェアなどは極力入っていないことが望ましい
    * 可能であれば `FROM scratch` する
  * [wagoodman/dive: A tool for exploring each layer in a docker image](https://github.com/wagoodman/dive) などを使ってイメージを縮小する
  * [projectatomic/dockerfile_lint](https://github.com/projectatomic/dockerfile_lint) を使って Dockerfile に lint をかける

