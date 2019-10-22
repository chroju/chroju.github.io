+++
categories = "serverspec"
comments = true
date = "2015-12-31T00:00:00+09:00"
title = "Serverspecファーストインプレッション"

+++

秋ぐらいから個人開発で試してみて、最近業務でも使えないかとServerspecで試行錯誤している。はじめに言っておくと使用感もコンセプトもとてもしっくりきていて満足している一方で、技術的なハードルはAnsible等より上かもなと思っている。

## サーバー構成の「仕様書」代わりとして

自分は当初Ansibleで構築したサーバーのあくまでテストツールとして使っていて、「こういう設定にしたい」という頭の中の設計書をAnsible playbooksとServerspecに同時に落とし込み、テストが通ることを確認していた。が、実際にじゃあこれを業務内でどう使おうかとワークフローを考えてみると、仕様書的な使い方がメインになりそうな気がしている。

Serverspecによるテストを実行するのはどういったタイミングか。構築完了時点での確認に用いるのは然り。その後サーバー設定を変更したときには、その内容をServerspecにも反映して再度テストを行うはず。つまりサーバーの仕様、設定の変更にServerspecは追従していく。逆に言えば任意のタイミングで仕掛けたServerspecがエラーを吐くことで、不意のサーバー設定変更を検知できる。サーバーの「正」とされる状態を管理する仕様書の代替として、Serverspecが活用できる気がしている。

中には[cronで監視チックに実行させている例](http://blog.kenjiskywalker.org/blog/2013/09/20/serverspec-with-cron/)もあるようだが、それもアリかなと思う。

## 導入は簡単だが探求にはRubyスキル必須

Ansibleが実質的にはYAMLを書くだけで使えてしまい、内部実装に用いられているPythonの知識をほとんど必要としないのに対し、Serverspecは徐ろにRubyスキルを必要とする。

例えば私が初めて書いた`spec_helper.rb`はこんな感じで、公式のtipsを反映したものとはいえ、デフォルト通りでは使っていない。

```ruby
require 'serverspec'
require 'yaml'

properties = YAML.load_file('properties.yml')

host = ENV['TARGET_HOST']
set_property properties[host]

set :backend, :exec
```

実際のテスト用のタスクを生成するのもRakefileである。もちろんデフォルトのままでも使えるには使えるのだが、ちょっと凝ったことをしようと思うとRubyが読み書きできていなくては難しい。これは「Rubyにより実装されたインフラテストツール」と理解するより、「RSpecをインフラテストに使えるよう拡張したもの」と捉えた方が正しいように思う。

自分は元々Rubyがある程度書けるものの、RSpecが理解しきれていないので、もう少し勉強しなくてはならなさそう。

## 国産OSSであるアドバンテージ

Serverspecの何より大きなアドバンテージはここではないのか。開発者も国内にいらっしゃるので、Rebuild.fmで直接声が聴けるし、解説本もいち早くO'Reilly Japanから発行されている。特にオライリー本発刊時のRebuild.fmは本自体の補完にもなる内容で、開発コンセプトなどがよく理解できるので聴いておきたい。

[Rebuild: 75: Book Driven Development (gosukenator)](http://rebuild.fm/75/)

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873117097/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51P6qVOPALL._SL160_.jpg" alt="Serverspec" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873117097/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Serverspec</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 15.12.31</div></div><div class="amazlet-detail">宮下 剛輔 <br />オライリージャパン <br />売り上げランキング: 213,793<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873117097/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

結論として先述のようにRSpecの拡張的な位置付けであり、その他Infra as Code関連のツールと比べても実装が薄いことから、取り回しがしやすく、今後も継続して使いやすいのではないかと思う。[Infrataster](https://github.com/ryotarai/infrataster)とも組み合わせられれば、よりテストの質は増しそう。

