+++
categories = ["exhibi", "Ruby on Rails"]
comments = true
date = "2015-08-08T00:00:00+09:00"
title = "Kaminariの実装をしてみた"

+++

久しぶりに稼働させている[ExhiBi](http://chroju.net/exhibi)というサービスの機能を少し更新した。といってもそれほど大した話ではないですが、一応書き留め。

# kaminari

ページネーションでデファクトスタンダード状態であるkaminariを使ってみました。

<iframe class="bookmarklet hatena-embed" src="http://hatenablog.com/embed?url=http%3A%2F%2Fgithub.com%2Famatsuda%2Fkaminari" title="amatsuda/kaminari" style="border:none;display:block;margin:0 0 1.7rem;overflow:hidden;height:155px;width:100%;max-width:100%;"><a href="https://github.com/amatsuda/kaminari" target="_blank">amatsuda/kaminari</a></iframe>

bundlerでインストールすればほぼ設定とかなくても使えます。最初のローンチのときに入れなかったので、viewを結構いじらなくちゃいけなくて大変かなーと思っていたのだけど、そんなことはなかった。主に変更は2点で、まずは`controller`で`#index`のようなリソースを拾ってくるアクションに`.page`をかましてやるようにします。

```ruby
# もともとはExhibition.all.order...
def index
  @exhibitions = Exhibition.page(params[:page]).order("start_date DESC")
end
```

あとは`view`でページネーションを表示するためのヘルパーを1行追加すれば終わり。以下はslimの場合。

```slim
= paginate @exhibitions
```

なお、実装当初は`undefined method 'deep_symbolize_keys'`などというちょっと関係ねーだろこれって感じのエラーが出たりして焦ったのは秘密です。原因は`config/locales/ja.yml`が一切インデントされてなかったことなんですけど、そんなのがここに波及するんですね。。。てかyamlの書き方よくわかってねーわ。

もちろん、1ページあたりの表示数とかページャーの表示の仕方だとか、いろいろ細かく設定はできますが、とりあえずこれだけでページャーは実装されます。あーこりゃデファクトスタンダードになるわなという簡単さ。早く入れればよかった。なお、本当にまだ入れただけなのでCSSとかぜんぜん調整してないです。

# id以外の要素でmodle#showにアクセスする

例えばExhiBiの場合は美術館ごとのページにアクセスするには、これまでmuseums/2みたいなURLになっていたわけですが、カッコ悪いし使い勝手も悪いのでmuseums/motなど、英名でアクセスできるよう変えました。参考にしたのは以下ページ。

<iframe class="bookmarklet hatena-embed" src="http://hatenablog.com/embed?url=http%3A%2F%2Fqiita.com%2Fawakia%2Fitems%2Fc2c790dc51e5b084af10" title="Railsで、URLにIDでなく名前を入力して、アクセスする方法 - Qiita" style="border:none;display:block;margin:0 0 1.7rem;overflow:hidden;height:155px;width:100%;max-width:100%;"><a href="http://qiita.com/awakia/items/c2c790dc51e5b084af10" target="_blank">Railsで、URLにIDでなく名前を入力して、アクセスする方法 - Qiita</a></iframe>

やってることはなんともシンプルで、`Museum.find(n)`で呼んでいたところを`Museum.find_by_name_en_or_id(hoge)`と出来るようにしただけですね。`#to_param`でサービス内のリンクもすべて英名表記URLに変更できています。こういう柔軟さはRailsやっぱりいいですね。

ただ自分の場合ちょっと問題があったのは、これまでテーブルに英名表記のカラムを入れてなかったので、新たに追加する必要がありました。まぁ普通に`bundle exec rake g migration`してから`rake db:migrate`するだけなんですけど、ローカルで開発しているときに何故かこれが通らず、一旦`rake db:migrate:reset`してから改めて打つハメになったりした。このへんの話は以下記事がちょっと詳しかったり。

<iframe class="bookmarklet hatena-embed" src="http://hatenablog.com/embed?url=http%3A%2F%2Feasyramble.com%2Fdifference-bettween-rake-db-migrate-reset.html" title="rake db:reset と rake db:migrate:reset の違い | EasyRamble" style="border:none;display:block;margin:0 0 1.7rem;overflow:hidden;height:155px;width:100%;max-width:100%;"><a href="http://easyramble.com/difference-bettween-rake-db-migrate-reset.html" target="_blank">rake db:reset と rake db:migrate:reset の違い | EasyRamble</a></iframe>

自分はインフラエンジニアなので、Railsを実務で使うってことはほとんどこの先皆無だとは思うんですけど、自己表現手段としてやっぱりRailsぐらい使えておくと良さそうだなと改めて思います。例えばインフラの勉強でサーバー運用してみようとなっても、上で何か動いてないとあんまり勉強にならなかったり。自分がどんなことをしているのか？を外にアッピルする意味では、こういうの1つぐらい持っとくといいのだろうなと思います。yamlの勉強しなきゃとか、今回そういう派生効果もありましたので。近々作れたらもう1個サービス作ってみようと思ってます。


