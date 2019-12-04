+++
title = "Terraform meetup tokyo#3 に参加した"
date = 2019-12-04T21:43:01+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

[Terraform meetup tokyo#3](https://terraform-jp.connpass.com/event/153286/) に参加してきました。今回「Blog枠」という形で参加させてもらったので、そのノルマも兼ねて書いています。

## Terrraforrm meetup tokyo について

Terraform ユーザーグループによるイベントは月1回開催されており、この meetup と source code reading が交互に行われます。 meetup は今回が3回目の開催で、自分は前回に続き2回目の参加でした。

LT や発表枠ももちろんあるのですが、この meetup で特徴的なのは World Cafe だと思います。 World Cafe の定義について、詳しくは [ワールド・カフェとは？ | ワールド・カフェ・ネット](http://world-cafe.net/about/) に譲りますが、 meetup ではランダムな最大6人グループで自由に議論する時間が30分×2回設けられています。 Terraform はまだ枯れきったソフトウェアとは言い難く、ベストプラクティスの模索が常に行われているような状況なので、ユーザー間でユースケースを共有し合えるこのような試みは、非常に有意義に感じています。

## イベントレポート

以下、簡単に今回のレポートです。

### スポンサー枠: Terraform Enterprise を導入して Terrform v0.10 から v0.12 に上げた話 / sudoyu

<iframe src="//www.slideshare.net/slideshow/embed_code/key/93ZBaBpaIVY4Pg" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/RecruitLifestyle/journey-to-terraform-enterprise-with-upgrading-v010-to-v012" title="Journey to Terraform Enterprise with upgrading v0.10 to v0.12" target="_blank">Journey to Terraform Enterprise with upgrading v0.10 to v0.12</a> </strong> from <strong><a href="https://www.slideshare.net/RecruitLifestyle" target="_blank">Recruit Lifestyle Co., Ltd.</a></strong> </div>

Terraform Enterprise の導入レポートでした。現在だと Terraform Cloud も同様の機能を持っていると認識していますが、社内のコード管理に IP アクセス制限をした GitHub Enterprise を用いており、その制約上 Cloud は導入が難しかったとのこと。気になるのは金銭面ですが、「 Terraform スペシャリストを雇うより安いと判断した」という言葉が印象的でした。

### LT1: terraform vs cdk / oracle

<div style="left: 0; width: 100%; height: 0; position: relative; padding-bottom: 56.25%; padding-top: 30px;"><iframe src="https://docs.google.com/presentation/d/1jXCZ-MnT9-x7etUGdeN62GuK2GmF1XAT99s5PlYiiIY/preview?usp=embed_googleplus" style="border: 0; top: 0; left: 0; width: 100%; height: 100%; position: absolute;" allowfullscreen scrolling="no" allow="encrypted-media"></iframe></div>

最近新たに AWS コード化界隈に参戦した cdk と Terraform の比較の話です。 Terraform で言う hoge が cdk では fuga に対応する、というようなことがまとめられているので、概念理解の助けになりました。まだ cdk は触ったことがないので、触ってみたいところ。

### LT2: GitHub Actions で Terraform を plan/apply してみた / dehio3

<div style="left: 0; width: 100%; height: 0; position: relative; padding-bottom: 56.1972%;"><iframe src="https://speakerdeck.com/player/2518a2eee62840c992a05b474dd217b7" style="border: 0; top: 0; left: 0; width: 100%; height: 100%; position: absolute;" allowfullscreen scrolling="no" allow="encrypted-media"></iframe></div>

GitHub Actions の workflow はすでに公式で [hashicorp/terraform-github-actions: Terraform GitHub Actions](https://github.com/hashicorp/terraform-github-actions) が公開されています。プルリクをトリガーして plan した結果をコメントに貼ってくれる、王道な workflow を簡単に導入できちゃうのがいいですね。

### LT3: Deep Dive HCL / Keke

<div style="left: 0; width: 100%; height: 0; position: relative; padding-bottom: 56.1972%;"><iframe src="https://speakerdeck.com/player/d77bdadfea614f7583e92530cd202297" style="border: 0; top: 0; left: 0; width: 100%; height: 100%; position: absolute;" allowfullscreen scrolling="no" allow="encrypted-media"></iframe></div>

Terraform の tf ファイルを記述する際には HCL と呼ばれる言語（書式？）が使われますが、その構造や仕様について説明された LT でした。私も HCL のパースなどに使える [hashicorp/hcl](https://github.com/hashicorp/hcl) は少し読んだことがありますが、 [仕様のホワイトペーパー](https://buildmedia.readthedocs.org/media/pdf/hcl/guide/hcl.pdf) が公開されていることは知りませんでした。後で読んでおきたい。

### LT4: インフラ実装をUMLで設計する / Toshihiko Nozaki

<div style="left: 0; width: 100%; height: 0; position: relative; padding-bottom: 56.1972%;"><iframe src="https://speakerdeck.com/player/b167fd6b61534447b4e18c4b4473f5c6" style="border: 0; top: 0; left: 0; width: 100%; height: 100%; position: absolute;" allowfullscreen scrolling="no" allow="encrypted-media"></iframe></div>

Infrastructure as Code に関しても、きちんと UML を書いてコンポーネント分割して書こうというお話でした。このあたりの話はすごく興味があります。Kief Morris『Infrastructure as Code』でも、 Robert C. Martin『Clean Code』を挙げた上で、「インフラストラクチャのコーダーにも、ソフトウェアデベロッパと同じくらい重要なテーマだ」と書かれています（p.184）し、メンテしやすいコードを書くことは追求していきたい。

### LT5: 各環境とRoot Module(tfstate)・workspaceの対応付けパターンを比較してみた / k_bigwheel

<div style="left: 0; width: 100%; height: 0; position: relative; padding-bottom: 56.25%; padding-top: 30px;"><iframe src="https://docs.google.com/presentation/d/1N1GBk72OBgBtz5cYRmR22OqD3N8NIlZIgkGCSdRuPlg/preview?usp=embed_googleplus" style="border: 0; top: 0; left: 0; width: 100%; height: 100%; position: absolute;" allowfullscreen scrolling="no" allow="encrypted-media"></iframe></div>

開発、検証、本番環境で tfstate を分けることが多いと思いますが、その際に module や workspace をどう使って分割するべきか、というお話。各パターンのメリデメを細かくまとめられた資料が印象的でした。この手の話は空中戦になりやすかったりもするので、きちんと「書いて考える」ことが重要だなーと気付かされました。

### World Cafe

World Cafe では Terraform をこれから社内へ導入していきたい方、 GCP で使っている方や AWS で使っている方など、様々なバックグラウンドを持った方とお話ができました。出た話題を簡単にピックアップしておきます。

* CloudFormation や Ansible と比較した Terraform の訴求ポイントはどこか？
* provider のバージョンアップへの追随はどうしているか？
* 社内で認知度が低い場合、どう広めていったらよいか？
* Terraform Cloud をすでに利用しているか？
* Terraform レポジトリのディレクトリ構成はどんな感じ？

### Additional LT: 突撃！隣の Terraform / chaspy

<div style="left: 0; width: 100%; height: 0; position: relative; padding-bottom: 74.9296%;"><iframe src="https://speakerdeck.com/player/3ff8a8e594124b9188ff028b59531bfa" style="border: 0; top: 0; left: 0; width: 100%; height: 100%; position: absolute;" allowfullscreen scrolling="no" allow="encrypted-media"></iframe></div>

ここまででメインは終了ということで私は帰ってしまったのですが、その後の延長線で追加 LT があったらしいです。内容は「突撃！隣の Terraform」ということで、 Kyash とメルカリで実際どのように Terraform のディレクトリ構成を切っているか見に行った話だったようです。これは聞いてみたかった。。。

## Impression

前回も今回もそうでしたが、 Terraform のファイルやディレクトリをどう構成していくかという点で悩んでいる人が結構多いという印象を受けました。ていうか私自身がそうです。そういう状況を踏まえても、やっぱり World Cafe で直接情報交換ができるというのはすごく嬉しい機会だなと改めて感じました。次回以降いらっしゃる方は、何か話したいネタ、聞きたいネタを用意してくると捗ると思います。

最後になりましたが、運営いただいた主催者の方々、フード提供いただいた HashiCorp さん、ありがとうございました。
