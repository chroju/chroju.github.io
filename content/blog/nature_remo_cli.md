+++
title = "Nature Remo の CLI ツールをつくった"
date = 2018-11-03T21:32:37+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

[Nature Remo](https://nature.global/) を導入してから半年ぐらい経って、非常に便利に使っているのだけど、「リモコンを探さなくてもスマホか Google Home に話しかけるかすればいい」というのも作業中などはちょっと面倒に思えてきて、ITエンジニアなのだし、ターミナルから操作できたら一番いいよねという結論に至り、作ってみた。以前、 [Nature Remo API で遊んだ](https://chroju.github.io/blog/2018/06/11/play_with_nature_remo/) というエントリーを書いたが、当時は Get 系の API を叩くのみで、実際にシグナルを送ることはしておらず、今回初めて挑戦した。

* [chroju/nature-remo-cli: Unofficial command line Interface for Nature Remo](https://github.com/chroju/nature-remo-cli)

使い方
----

https://home.nature.global/ から自分の Nature Remo のアクセストークンを発行すれば、それを使って誰でも扱えるようなものにしている。インストールは `go get` か、先の GitHub レポジトリの「Releases」からバイナリを落とすかの2パターンを用意している。コマンドを使えるようになったら、まず `remo init` コマンドを叩いて、アクセストークンを読み込ませる。

```sh
$ remo init
Nature Remo OAuth Token:
<Input your token>
Initializing ...
Successfully initialized.
```

正しいトークンを与えれば、このように初期化処理が成功して、あとは自由に使えるようになる。シグナルを遅らせるときは家電 (appliance) とシグナルの名前を指定する必要があるのだけど、使用できる家電名とシグナル名は `remo list` コマンドで一覧できる。うちの場合はこんな感じ。

```sh
$ remo list
ライト オフ
ライト オン
ライト 暗い
ライト 明るい
ライト 白い
ライト 暖かい
ライト 全灯
tv オン
tv 入力切替
tv 1
tv 2
tv 3
tv 4
tv 5
tv 6
tv 7
tv 8
tv 9
tv 10
tv 11
tv 12
tv 音量上
tv 音量下
```

ここから任意のものを選んで、 `remo send` で実行する。

```sh
$ remo send tv オン
Success.
```

動作仕様
----

Nature Remo のシグナル送信用 API は、当該の signal ID を与えて実行するようになっているのだけど、 signal ID は Nature Remo の内部的な値であって、例えばスマホ用のアプリでは表に出るものではない。取得するには API を叩く必要があるのだが、シグナルを飛ばすたびに signal ID を API で持ってくるのも非効率なので、 `remo init` を実行した時に、　`$HOME/.config/remo` に YAML 形式で書き出すようにしている。

```yaml
credential:
  token: <YOUR TOKEN>
appliances:
- name: ライト
  id: abcdefgh-1234-ijkl-5678-mnopqrstuvwx
  signals:
  - id: abcdefgh-1234-ijkl-5678-mnopqrstuvwx
    name: オン
    image: ico_foo
  - id: abcdefgh-1234-ijkl-5678-mnopqrstuvwx
    name: オフ
    image: ico_bar
```

`remo list` はここから全家電とシグナルの `name` を読み込んで表示している仕組み。また `remo send` も同様に、このファイルから指定した家電名、シグナル名に該当する signal ID を探してきて、その ID で API を実行している。

つまりは `remo send` は実際 Nature Remo に設定している家電名、シグナル名を必要としているわけではなく、この YAML ファイル上に書かれた名前を必要としているので、 YAML の中身を自由に書き換えることで、 `remo send` に与える引数も変えることができる。家電名やシグナル名はスマホのアプリで設定するものなので、多くの人は日本語で名付けると思うのだけど、これをコマンドラインで実行するとなると、日本語というのは扱いづらい。なので YAML を書き換えて、例えば先の「ライト」「オン」を「light」「on」に書き換えて使うことができる。

元に戻したい場合や、新しい家電を Nature Remo に追加した場合は、 `remo sync` コマンドで Nature Remo の最新状態と YAML を同期できる。その際は日本語から英語に手動で書き換えた箇所も復元されてしまうわけだけど、将来的に解消できたらしたいと思っている。

今後
----

まだ実装していない機能としてエアコンの操作がある。

Nature Remo は「赤外線信号の送信を代替する IoT 機器」なわけだけど、エアコンとそれ以外の家電では内部での扱い方が異なる。多くの家電では、もともとのリモコンから学習した赤外線信号をシンプルに送るだけなのだが、エアコンの場合は温度、風量、風向といった設定セットを Nature Remo 側で作って、それを赤外線で送るような形になっている。なのでエアコン用シグナルの送信は API も個別に用意されていて、そちらはまだ実装ができていない。寒くなる前にはなんとかしたい。あとはセンサー情報を取得して、現在の気温や湿度を表示する機能も実装したい。

具体的な技術的背景とかは、また別のエントリーに書こうと思う。


