+++
date = "2016-03-17T22:09:45+09:00"
description = ""
title = "Personal Knowledge Base 2"

+++

年初に[Personal Knowledge Base · the world as code](http://chroju.github.io/blog/2016/01/24/personal-knowledge-base/)という記事を上げて、メモや知識の管理をする環境作りを進めていたのだけど、最近ようやく固まってきた。結論としては **[Trello](https://trello.com/)** と **[gollum](https://github.com/gollum/gollum)** を使っている。

Trello
----

近年よく名前を訊く、Kanban形式でのビジュアライズされたタスク管理を可能とするツール。タスク管理向けなので当初は目を向けてなかったのだけど、よくよく冷静に考えてみるとメモ管理にかなり適してそうだったので採用。

結果として、タスクに限らず、数多の情報を整理するツールとしてとても使いやすい。ポイントはいくつか。

* メモがカードの形で表示されて、パラパラと繰って一覧できる。
* メモにラベルを付けると色で表示されるので視認しやすい。
* 全文検索が可能。
* エクスポート機能あり（json）。
* descriptionをMarkdownで書くことができる。
* Android、iOSいずれもアプリあり。IFTTTも対応。

単なるテキストメモを保存する用途であればEvernoteの上位互換だと感じる。何よりも画面全体にメモを並べることができる一覧性の高さがいい。

今の自分は[PoIC](http://pileofindexcards.org/wiki/index.php?title=%E3%83%A1%E3%82%A4%E3%83%B3%E3%83%9A%E3%83%BC%E3%82%B8)のような使い方をしていて、とにかくメモを書き溜めては記録、発見、参照の3つのリストに取りあえず分けて、暇なときにつらつら眺めたりしている。分類の仕方はまだ模索中なので、今後変わるかもしれない。とにかく柔軟に使えるのがいい。

* [「Trello」というアプリがおもしろい - iPhoneと本と数学となんやかんやと](http://d.hatena.ne.jp/choiyaki/20140920/1411170874)
* [Using Trello for Your Personal Productivity System | Victor Savkin](http://victorsavkin.com/post/94468744151/using-trello-for-your-personal-productivity-system)

GTDは「高度」の管理用といわゆるToDoの管理用に2つボードを設けて使ってみている。プライベートのタスクだけなのでそれほど厳密な期限管理などは必要ないし、これで十分。

gollum
----

散発的な思いつきをTrelloに入れる一方、体系的な知識管理はgollumを使う。GitHub Wikiの機能だけが単独でオープンソース化されているもので、さくらクラウドの2万円クーポンがあったのでとりあえずサーバー1台立ててホストしている。

技術的なメモ書き、読書メモ、あとは趣味で行く美術展の記録などはすべてここに溜めている。Wikiだと散逸的にページを作ってしまいがちなので、トップから最大2階層までの作成と定め、1階層目は各技術ジャンルのページ、2階層目に詳細記事として配置した。こうして体系立てたメモ環境を作ってみると、自分のスキルマップが出来上がっていくようで面白い。

gollumを建てるのに、技術的に難しいことはほとんどない。中身はSinatraとgitなのでカスタマイズもしやすく、とりあえず安易な認証機能ぐらいは追加してみた。作成した記事は個別にMarkdownファイルになってgollumのディレクトリ直下に直置きされるのだが、これはディレクトリを切って`git submodule`としてGitHub上に上げ、個別管理したいかなと思っている。

ナレッジ管理の必要性
----

ナレッジ管理が必要である、という潮流は昨今高まっているような気はしていて、Qiitaやesa.ioの登場あたりから特にそういう話はよく聞く気がする。

<iframe src="//www.slideshare.net/slideshow/embed_code/key/2R3Nk0tCAKPUnY" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/takoratta/ss-59111661" title="情報共有から始めるチーム開発とキャリア戦略" target="_blank">情報共有から始めるチーム開発とキャリア戦略</a> </strong> from <strong><a target="_blank" href="//www.slideshare.net/takoratta">Takuya Oikawa</a></strong> </div>

個人であれ組織であれ、我々の仕事は（まぁ他の職種も同じだとは思うが）ナレッジを溜めて活用していくことにあるので、こういう取り組みは何がしか進めるべきだろうと思う。上記スライドにもあるように、暗黙知を形式化していくことで自分内でも、社内やコミュニティ内でも知識を記憶、伝達してさらに深めることが可能になる。

とはいえ昨今はツールの乱立はあって、ブログとQiitaの使い分けだったり、個人的なメモをどうするかだったり、やっぱり迷うことも多い。そこはある程度自分なりの使い方を定めておかないと、後々散逸したメモの山に途方に暮れたりはしそう。あと、単純に良いツールがあったとしても、メモする習慣をつけておかないと意味がないし、どちらかといえばそっちが大事なんではという気もする。些細なことでも漫然と調べず、記録するクセをこの2ツールで付けていこうと思う。

以下、他に比較検討したツール群を載せておく。

### [FAQT](https://faqt.co/)

* 比較した中ではだいぶ惹かれた。一時はこれにしようかと思った。
* 明確にKnowledge baseを唄ったサービス。Markdownで書いたメモがカード形式で表示できる。
* Markdownプレビューが結構好みだし、外観はとてもよかった。
* まだ立ち上がったばかりで、将来性はちょっと不安。
* 全文検索の不在が決め手になり不採用。

### Simplenote

* 定番メモサービス。
* Markdown対応がほぼ皆無なので不採用。

### [Quiver](http://happenapps.com/#quiver)

* 最近少し話題になったMac用ノートアプリ。
* タグとノートブックで分類するEvernoteっぽいMarkdownノート。
* データファイルをDropboxに置いてクラウド同期が可能。
* 外観がクールだし、結構使い勝手はよかった。
* とはいえMacでしか使えないので断念（持ち歩きPCがLinuxなので）


参考
----

* [The Personal Knowledge Management Saga: #1 — The Personal Knowledge Management Saga — Medium](https://medium.com/the-personal-knowledge-management-saga/the-personal-knowledge-management-saga-part-1-ae9bdc575ded#.9xvxjvkkz)
* [Ask HN: What do you use to organize your knowledge? | Hacker News](https://news.ycombinator.com/item?id=7697050)
* [Ask HN: How do you manage/organize information and knowledge in your life? | Hacker News](https://news.ycombinator.com/item?id=8806950)
* [The Sad State of Personal Knowledgebases](http://marcusvorwaller.com/blog/2015/12/14/personal-knowledgebases/)
