+++
categories = "event aws"
comments = true
date = "2016-01-30T00:00:00+09:00"
title = "Ops JAWS#3に行ってきた"

+++

その名の通り運用管理系の話題を中心としたAWSユーザーグループです。ハンズオンもあるということで行ってきた。

メインとなったのはconfig rulesのハンズオン。

<iframe src="//www.slideshare.net/slideshow/embed_code/key/g0o2kIUtI0yKmw" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/okochang/opsjaws-20160128" title="OpsJAWS 20160128" target="_blank">OpsJAWS 20160128</a> </strong> from <strong><a href="//www.slideshare.net/okochang" target="_blank">hideaki yanase</a></strong> </div>

AWSリソース、使っているうちに無秩序になっていき、ルールの統一がはかれなくなったり、全体像が見えづらくなったりということはありがちですが、config rulesを使ってもうシステム的に制御しちゃいましょうというテーマ。例えばCloudTrailが有効化されていない場合にアラートを上げる、とか。監視結果が変化すると、それをトリガーにLambdaをinvokeしたりもできるので、それこそなんでもできる感じ。

やってみて気付いたけど、やっぱり自分は運用が好きなのかもしれない。システムによって、本来不確かであったり信用性に劣っていたりするはずの人間の動作を制御する、というのが好きなんだろうなと。SEやってた頃は運用の制御はExcel資料が元になることが多くて、それ自体は特に楽しくなかったのだけど、システム的に作りこんでいくのはわくわくする。これはいい気付きだったし、次回も是非参加してみたい。

問題としてはやはり、Lambda Functionを書くのにpythonかnode.jsを使う必要がある（いまさらJavaってのもなぁ）ので、次回参加するのであればそれまでにpythonをある程度やっておかねばなぁというところ。

その他、昨年とてもおもしろく読ませていただいたSDの特集『なぜ「運用でカバー」がダメなのか』を書かれた運用設計ラボの波多野氏がいらっしゃっていたりして、個人的にはテンション上がったりもしました。「運用でカバー」をググるとトップに出てくる、なんだか好評を得てしまった拙記事はこちら（あえて移行前ブログを貼るアレ）。

[Software Design 2015年2月号『なぜ「運用でカバー」がダメなのか』読了 - そのねこが学ぶとき](http://chroju89.hatenablog.jp/entry/2015/02/11/164926)

