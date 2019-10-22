+++
title = "fluentd 1.0 でログの欠損を防ぐ"
date = 2018-08-13T22:29:26+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

ようやく fluentd v1.0 を最近触り始めている。極力ログを欠損させない形の設定がしたくて、 v0.12 の頃だと [fluentdでログが欠損する可能性を考える - sonots:blog](http://blog.livedoor.jp/sonots/archives/44690980.html) を参考にさせてもらっていたのだが、 v1.0 だとパラメーターが変更されている部分が多く、改めてどう設定するべきかを考えてみた。

## 前提 : 考慮するべきログ欠損ポイント

まず前提として、 fluentd を使っていてログの欠損が発生し得るポイントを並べておく。以下、ログの送出元を forwarder 、集約先を aggregator と呼ぶ。

先の sonots 氏のエントリーを元に整理すると、基本的には aggregator 自身、もしくは forwarder - aggregator 間のネットワークに何らかのトラブルがあり、 fluentd が正常にログを送れなかった場合への対処が必要となる。 aggregator との通信に問題が起きると、 forwarder は aggregator への通信を自動的にリトライしつつ、その間徐々に buffer が蓄積されることになり、これが欠損に繋がり得る。

* aggregator への通信が中途で途絶する
* aggregator への送信リトライ回数が上限に達する
* buffer が増えすぎてファイルディスクリプタの上限に達する
* buffer の保存量が上限に達する

また buffer type が memory の場合は、サーバートラブル時に欠損する可能性が高いため、 file buffer を用いることは前提とする。

## 具体的対処

### aggregator への通信途絶への対処

* 変更なし ( require_ack_response true )

v0.12 から存在する `require_ack_response` が v1.0 でも使用できる。これを設定すると、 aggregator が input plugin の処理を完了してから ack を返してくれるようになり、 forwarder での buffer 削除はその後で行われるようになるため、通信や処理が途絶してもログは失われない（ forwarder に残る）。

### リトライ回数の上限

* v0.12 : disable_retry_limit true
* v1.0 : retry_forever true

設定値の名前が変更になった。また従来は `<match>` directive に書いていたが、 v1.0 では `<buffer>` directive に書く必要がある。

### ファイルディスクリプタの上限

これは fluentd の機能ではなく、 OS側の `ulimit` の設定の話にはなるが、 65535 まで引き上げておくことは v1.0 でも推奨されている。

* [Before Installing Fluentd | Fluentd](https://docs.fluentd.org/v1.0/articles/before-install)

ただし、 fluentd を systemd 下で動作させる場合は、 unit ファイルに ulimit の設定がデフォルトで入っているため、別途OSの設定を変える必要はなくなった。

なおファイルディスクリプタに関しては、 `flush_interval` が過度に短く設定されている場合、 queued chunk が増えすぎてファイルディスクリプタを使いすぎる可能性があるため、 `queued_chunks_limit_size` という設定も用意されている。ただ、そこまで `flush_interval` を短くしすぎない方が、サーバー負荷の観点からも良いのではないかなとは思うし、個人的にはこの観点は気にしていない。

### buffer の保存量の上限

* v0.12 : buffer_chunk_limit * buffer_queue_limit
* v1.0 : total_limit_size

v0.12 では chunk 1つあたりの最大サイズを示す `buffer_chunk_limit` と、 chunk の最大保存数を示す `buffer_queue_limit` を掛け合わせた値が buffer の上限だったが、 v1.0 ではこれをまとめて `total_limit_size` で設定できるようになった。書き込み中のバッファのサイズまで考慮されているらしい（参考 : [fluentdmeetup2016summerにいってきた - smallpalace's blog](http://smallpalace.hatenablog.com/entry/2016/06/02/123724)）。そしてファイルバッファの場合、このデフォルト値が64GBに設定されているので、多くの場合は十分かと思う。

と、いう感じでイケそうな気がしているが、何かおかしい部分があったらツッコミが欲しいです。 v1.0 は buffer 周りの設定が `<buffer>` に切り出せるようになったので、そのあたりスッキリ見やすくなっていいですね。
