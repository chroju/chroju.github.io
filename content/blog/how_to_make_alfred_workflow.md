+++
title = "Alfred は「黒い窓」を使わなくなってからが本番"
date = 2020-12-16T18:29:31+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

前回のエントリー [Terraform Cloud を Alfred や CLI から操作する | the world as code](https://chroju.github.io/blog/2020/12/05/terraform_cloud_with_alfred/) の中で、 Alfred Workflow の話に触れたので、改めて書いてみる。

## Alfred Workflow とは何か

Alfred というと黒い小さな入力フィールドがスッと出てきて、そこで色んなものをインクリメンタルサーチできるもの、というイメージが強いけれど、実際のところそれだけにはとどまらない。 Alfred Workflow をざっくり言えば、あるアクションを `trigger` し、 `input` を行い、それを受けて何らかの `action` を実行し、 `output` を出す、という4段階の流れを組み合わせることで、様々なツールを実現するもの、ということになる。

例えば trigger には `Hotkey` というものがある。読んで字のごとく、任意のキーバインドで workflow を起動する場合に使う。そして input には `Launch Apps/Files` というアプリやファイルを起動できるものがある。この2つを組み合わせてみる。

<a href="https://gyazo.com/e044827d8c15416085e2ee05254ed435"><img src="https://i.gyazo.com/e044827d8c15416085e2ee05254ed435.png" alt="Image from Gyazo" width="375"/></a>

これで `Command + Shift + g` を押すと Gyazo が起動する workflow が出来た。 OS 標準のスクリーンショットを撮るのと似た感覚で、3つのキーを押すだけで簡単に Gyazo が起動できる。

このように、 Alfred で出来ることは「黒い窓」でやることだけに縛られないし、何かを検索してフィルタリングすることも必須ではない。組み合わせ次第で非常に多くの効率化が実現できる。

## Hotkey の有効活用

Hotkey を使った例をもう1つ挙げる。

Alfred Workflow は export が可能になっていて、ウェブ上で広く公開されている Workflow がいくつもある。そのうちのひとつ、 [Div](https://www.packal.org/workflow/div) を重宝している。

<a href="https://gyazo.com/eb633b0877674babf5064207a8fa1c92"><img src="https://i.gyazo.com/eb633b0877674babf5064207a8fa1c92.gif" alt="Image from Gyazo" width="600"/></a>

同種のツールだと有償の [Magnet](https://apps.apple.com/jp/app/magnet-%E3%83%9E%E3%82%B0%E3%83%8D%E3%83%83%E3%83%88/id441258766?mt=12) が有名かもしれない。ウィンドウを画面の右半分、左下4分の1などにスナップさせてくれるツールで、 Magnet と異なるのは Alfred からのコマンド操作になるという点。

使い方は Alfred に `div 800 600` とウィンドウサイズを絶対的に指定してもいいし、右半分であれば `div right` といったコマンドも用意されている。そしてこの Workflow 、コマンドに対して Hotkey を割り振れるよう、あらかじめ blank の領域が用意されている。

<a href="https://gyazo.com/fb13d8f6fbdae70144b5e87dc13c37b8"><img src="https://i.gyazo.com/fb13d8f6fbdae70144b5e87dc13c37b8.png" alt="Image from Gyazo" width="504"/></a>

僕は `Command + Shift` と矢印キーの組み合わせで、最大化したり左右半分に寄せたりできるように組んでいる。この Hotkey はグローバルなキーバインドになるので、他のアプリケーションと重複しないよう、3キー程度の組み合わせにするのが無難だと思う。

## webhook を飛ばす

最後にもう1つ、 Hotkey 以外での使い方も紹介する。

僕はタスクやメモに [Dynalist](https://dynalist.io) というアウトライナー、要はツリー構造のエディタを使っている。

この Dynalist に inbox という機能がある。ツリーのある階層を inbox に指定すると、特定の webhook に投げた文字列がすべてその階層直下に保存されるというもので、例えば fav した Tweet を投げ込むフローを組んだりだとか、いろいろ応用ができる。

日頃仕事や勉強中に、わざわざ Dynalist を開いてメモするのは面倒なので、これも Alfred から投げられるようにしている。

<a href="https://gyazo.com/50ebf792cd4459f42bb839516d996793"><img src="https://i.gyazo.com/50ebf792cd4459f42bb839516d996793.png" alt="Image from Gyazo" width="600"/></a>

Hotkey を trigger にしているが、その次の `Keyword` と書かれているのは input に当たり、要するところ、これがあの「黒い窓」を使った入力ということになる。この設定では Hotkey でもこの Workflow は起動するし、 input の上部に書かれた `di` というキーワードを Alfred に打つことでも起動する。

「黒い窓」の入力を受けて、次の `Run Script` が action に当たる。自由に bash コマンドを実行できる。

<a href="https://gyazo.com/1596fadbdeec9b0e8d357e31b3f19946"><img src="https://i.gyazo.com/1596fadbdeec9b0e8d357e31b3f19946.png" alt="Image from Gyazo" width="600"/></a>

ここで入力を `{query}` として受けて、 webhook を飛ばしている。

最後の `Post Notification` と書かれているのが output に当たり、 macOS の通知に curl の実行結果を表示させている。

## Conclusion

ということで、結構いろんなことができる。ここで挙げた以外にも `trigger` , `input` , `action` , `output` には様々な種類があるし、それらを組み合わせることのできる `utilities` というものも存在する。まぁ、スクリプトが実行できる時点で何でもありではある。

ちなみにいわゆるよくある「黒い窓」で検索をするやつ、あれは `Script Filter` という input に該当する。 `Script Filter` の中で bash や python などのスクリプトを書き、決まった形式の JSON を出力するようにすると、あの検索が発動する。なので前回エントリーのように、動的に検索対象を引っ張ってくることもできるし、固定的な値から検索したいのであれば、 JSON を cat するだけでも OK だ。 HTTP status code の一覧を検索できるようにしたら便利かな、とか今は考えている。
