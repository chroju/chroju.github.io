+++
title = "SRE NEXT 2020 に行ってきた"
date = 2020-01-28T00:21:52+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://sre-next.dev" data-iframely-url="//cdn.iframe.ly/uyH2l2H"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

SRE NEXT 2020 に行ってきた。

SRE という職種が国内で広まったきっかけは [インフラチーム改め Site Reliability Engineering (SRE) チームになりました - Mercari Engineering Blog](https://tech.mercari.com/entry/2015/11/18/153421) のエントリーだと思っているのだけど、ここから4年と少し。東京とはいえ、 SRE をテーマにカンファレンスが開催される規模になってきたというのはちょっとした驚きもある。実際来場者が何人だったのかは把握していないが、使われていた4つの部屋に入り切らないのではというぐらいの人がいて、実際に SRE をやっている、あるいは社内に SRE チームがあるという人は半数ぐらいだったらしい。

発表はいずれもかなり具体的なものが多く、 SRE 本はみんな読んでいるよね？という前提の上で、あの本をこう解釈して、うちではこうやって運用しているよ、という話が多かった。最後のパネルディスカッションでも「SRE を始めるにあたり、どんなスキルがあればよいか？」というような質問があったのだが、 SRE を定義づけるのはスキルではなくてミッションなのだと思う。デプロイ頻度を上げたとき、トレードオフで劣化してしまいがちな「サイト信頼性」をどう担保するか。そのミッションに共感して携わってさえいれば SRE だと言える。むしろ特定のツールやスキルに固執して、ミッションが曖昧な状態だと SRE とは言い難い。

とはいえもちろんツールだとか、どのような資料を参考にしているのかも気になるところで、各社が実際の運用で使っている OSS やドキュメント類の話も非常に参考になった。具体的に気になったのは以下。各項目末尾の括弧は、その資料やツールの話が出てきたセッションナンバー。

* [Ironies of automation - ScienceDirect](https://www.sciencedirect.com/science/article/pii/0005109883900468) (A0)
* [The ironies of automation… still going strong at 30? | Request PDF](https://www.researchgate.net/publication/231537926_The_ironies_of_automation_still_going_strong_at_30) (A0)
* [Site Reliability Engineering: Measuring and Managing Reliability | Coursera](https://ja.coursera.org/learn/site-reliability-engineering-slos) (C4)
* [Event based SLO](https://docs.datadoghq.com/ja/monitors/service_level_objectives/event/) / [Monitor SLO](https://docs.datadoghq.com/ja/monitors/service_level_objectives/monitor/) (C4)
* [argoproj/argo-rollouts: Progressive Delivery for Kubernetes](https://github.com/argoproj/argo-rollouts) (D5)
* Production Readiness Check by Production-ready Microservices (B7)

ここからは特に印象に残ったセッションを掲載する。すべて載せられればよかったのだが、結構な分量になりそうなので掻い摘んでみる。

## 分散アプリケーションの信頼性観測技術に関する研究

<div style="left: 0; width: 100%; height: 0; position: relative; padding-bottom: 56.1972%;"><iframe src="https://speakerdeck.com/player/058b950f8955432f8263496498a0390a" style="border: 0; top: 0; left: 0; width: 100%; height: 100%; position: absolute;" allowfullscreen scrolling="no" allow="encrypted-media"></iframe></div>

基調講演その1。

多くの SRE は基本的には既存の技術を用いてサイト信頼性の向上に貢献するけれど、より低いレイヤーからそもそも可観測性を高めるにはどうしたらいいか、レイテンシを狭めるにはどうしたらいいかというお話。自分はこの先このレイヤーで仕事をすることはなさそうに思っているけど興味深く聴けた。レイテンシ最小化のために、フォグコンピューティングのように小規模なデータセンターが点在する形になる、という方向性は、 [AWS Local Zones](https://aws.amazon.com/jp/about-aws/global-infrastructure/localzones/) などですでに実現しつつもあるのだろうと思う。

## 40000 コンテナを動かす SRE チームに至るまでの道

<div class="iframely-embed"><div class="iframely-responsive" style="padding-bottom: 52.5%; padding-top: 120px;"><a href="https://techblog.yahoo.co.jp/entry/20191222793763/" data-iframely-url="//cdn.iframe.ly/ypciDNM"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

Yahoo! のような大規模なサービス企業になると、インフラチームは Private PaaS を動かして社内の開発者へ「サービス提供」する形になる。それが 40000 のコンテナで提供されているとのこと。

顧客ロイヤルティの指標である Net Promoter Score を社内に対して調査しているというあたりが面白かった。他にも社外ではなくて社内に対して SLA を定義しているという話もあった。 DevOps 以来の考え方として、アプリチームとインフラチームはなるべく境界をなくすべきというのが是のように思い込んできたけど、逆に明確な境界を引いて、 AWS の責任共有モデルよろしく、両者の責任範囲を限定してしまう方式もありなのだな、というのが気付きだった。

## 成長を続ける広告配信プラットフォームのモニタリングを改善してきた話

<div style="left: 0; width: 100%; height: 0; position: relative; padding-bottom: 56.1972%;"><iframe src="https://speakerdeck.com/player/7b9b2ed526bd4247acf0517295cdd6d1" style="border: 0; top: 0; left: 0; width: 100%; height: 100%; position: absolute;" allowfullscreen scrolling="no" allow="encrypted-media"></iframe></div>

偽陽性のアラートを減らす、そのためにアラートの整理を定期的に実施するべきであるという2点と、実際に Kubernetes 環境をどのようなツールで監視しているかの話。特に Kubernetes の監視については現在目下検討中なので参考になった。 influxDB + Telegraf + Grafana （俗に言う TIG Stack ）と New Relic とのこと。

## delyにおける安定性とアジリティ両立に向けたアプローチ

<div style="left: 0; width: 100%; height: 0; position: relative; padding-bottom: 56.1972%;"><iframe src="https://speakerdeck.com/player/5d3d1b565ce54370a2b99b59fadd200f" style="border: 0; top: 0; left: 0; width: 100%; height: 100%; position: absolute;" allowfullscreen scrolling="no" allow="encrypted-media"></iframe></div>

SRE のミッションを「プロダクト開発の速度を **安全に** 高める」ことと定義して、それを如何に成し遂げていくかという話。一般的にはエラーバジェットを用いることになるのだけど、実際のところはバジェットを使い切ったときに新規デプロイを中止するのは現実的ではなかったり、導入が難しい側面がある。では、他に解決するべき、プロダクト開発速度を落とす要因はないのだろうか？と改めて問い直して、コードやシステムから「想定外の複雑さ」を取り除いていこうという結論に至る。 SRE 本に掲載されたプラクティスをただ愚直に導入するのではなくて、その目的はそもそも何か、その目的を達する手段は他にないだろうか？という良い問い直しでした。

## SRE Practicies in Mercari Microservices

<div style="left: 0; width: 100%; height: 0; position: relative; padding-bottom: 56.1972%;"><iframe src="https://speakerdeck.com/player/1af1bddd18484d61ae524fbaf8dafc4b" style="border: 0; top: 0; left: 0; width: 100%; height: 100%; position: absolute;" allowfullscreen scrolling="no" allow="encrypted-media"></iframe></div>

国内で最初期に SRE チームを発足させていたメルカリさんの SRE プラクティス。具体的な運用方法の話が出てくるので参考にしたいことだらけ。 SLO、CI/CD、On-call、Toil とテーマを分けて話をしてくれたのでとても聞きやすかった。特に SLO の振り返りの話が興味深くて、 SLO のみならず Toil の量や顧客（SRE が信頼性向上施策を提供する相手である、マイクロサービスチームのこと）満足度と絡めて評価するとのこと。例えば SLO が達成されていても、 Toil が多いし顧客満足度も低ければ、その SLO 達成にあまり意味はないということになるので、 SLO を厳しくしてみる。 SLO 達成、 Toil も少ないが、顧客満足度が低いのであれば、顧客が求める SLI は別のところにあるのではないかと考え、 SLI を変えてみる。達成 / 未達成の2択ではなく、その SLO に意味はあるのか？というところも運用を踏まえて振り返る視点は重要だと感じた。
