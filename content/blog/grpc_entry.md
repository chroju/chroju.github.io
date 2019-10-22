+++
title = "gRPC ちょっと理解した"
date = 2019-06-21T17:05:00+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

[gRPC](https://grpc.io/) に入門した。favicon のマスコット？めっちゃかわいいですね。。

きっかけは [3rd Party tool をきっかけに Terraform のソースコードを少し嗜んだ話 · the world as code](https://chroju.github.io/blog/2019/05/14/read_terraform_source_code/) という記事で触れたように、 Terraform 0.12 で Terraform Core と Provider が gRPC で通信するようになったため。知ってなてくは Terraform を使えないわけでも Provider を書けないわけでもないのだが、昨今よく聴く単語だし、 microservices などにも必要な要素技術なので入門してみた。

## 教材

ちょうど WEB+DB PRESS の最新号で特集されていたので、主にこれを使った。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4297105330/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/51SCTYcyT%2BL._SL160_.jpg" alt="WEB+DB PRESS Vol.110" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4297105330/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">WEB+DB PRESS Vol.110</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 19.06.21</div></div><div class="amazlet-detail">藤村 大介 森田 リーナ 渡邉 祐一 市原 創 板倉 広明 高橋 征義 笹田 耕一 大原 壯太 新倉 涼太 末永 恭正 久保田 祐史 牧 大輔 東 邦之 星 北斗 池田 拓司 竹馬 光太郎 はまちや2 竹原 八谷 賢 <br />技術評論社 <br />売り上げランキング: 13,606<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4297105330/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

あとは公式のドキュメント。英語で簡単な Tutorial が書かれているほか、 gRPC のレポジトリ内にある [examples](https://github.com/grpc/grpc/tree/master/examples) というフォルダに言語別の実装例が書かれていて参考になった。

## 学んだこと

### 写経

gRPC とは何か、などとここで改めてまとめても仕方ない感があるので、それについては割愛する。 WEB+DB PRESS を読もう。

当該号の特集では、 gRPC の4種類の通信方式（Unary, Server streaming, Client streaming, Bidirectional streaming）それぞれの簡単な実装サンプルと、実践例として gRPC を用いたタスク管理サービスの作り方が掲載されており、これを適宜写経しながら進めた。コードはいずれも GitHub で公開されている。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/vvatanabe/go-grpc-basics" data-iframely-url="//cdn.iframe.ly/DAemZsu"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/vvatanabe/go-grpc-microservices" data-iframely-url="//cdn.iframe.ly/3VubC7c"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

### Ruby での再実装

単に写すだけというのもつまらないので、ちょっとした応用もやってみた。 gRPC には遣り取りするデータのシリアライズフォーマットを定義した Protocol Buffers (protobuf) を元として、サーバ / クライアントの実装を様々な言語で生成することができるという特徴がある。そこで、誌面のサンプルはサーバ / クライアントともに Go で書かれていたが、クライアント側を Ruby で書いてみることにした。

対象にしたのは Server streaming gRPC のサンプルコード。主に公式の [Ruby 向け Tutorial](https://grpc.io/docs/quickstart/ruby/) を見つつ、先の examples 内の実際のコードも見ながら進めたが、以下の記事も参考にした。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://qiita.com/yururit/items/bc7c0eda63d5fa30289a" data-iframely-url="//cdn.iframe.ly/NJ6kcAY"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

まず、必要な gRPC 関連の gem をインストール。

```bash
$ gem install grpc
$ gem install grpc-tools
```

続いて protobuf から Ruby 用のクライアントコードを生成しようと思ったのだが、サンプルコードでは protobuf の package が `file` という名前で定義されており、これをそのまま Ruby のコードに変換すると、 File class と衝突する形になってしまった。そのため package 名を `filedl` という名前に変更してからコード生成を実行している。ネーミングセンスは気にしないことにした。なお、このコマンドは元のサンプルコードの `downloader` というフォルダ内に `ruby` フォルダを掘り、その中で実行している。

```bash
$ mkdir lib
$ grpc_tools_ruby_protoc -I ../proto --ruby_out=lib --grpc_out=lib ../proto/filedl.proto
```

Ruby のコードは以下のようになった。元々の Go によるサンプルコード（[go-grpc-basics/main.go at master · vvatanabe/go-grpc-basics](https://github.com/vvatanabe/go-grpc-basics/blob/master/downloader/client/main.go)）とだいたい同じ動きをするようにしている。

```ruby
this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'filedl_services_pb'

def main
    stub = Filedl::FileService::Stub.new('localhost:50051', :this_channel_is_insecure)
    filename = ARGV[0]
    resps = stub.download(Filedl::FileRequest.new(name: filename))
    blob = ""
    resps.each do |r|
        blob << r.data
    end

    p "done " + blob.size.to_s(10) + " bytes"

    file = File.open(filename,"w")
    file.puts blob
    file.close
end

main
```

これで `ruby client.rb test` などと実行することで無事に動作が確認できた。異なる言語間でシリアライズされたデータの遣り取りがだいぶ簡単に実装できてなるほどねぇという感じはした。あと Ruby を3年ぶりぐらいに書いたのでところどころ文法にビビったりした。 `<<` 演算子とか。

成果物はすべて [chroju/learning_grpc](https://github.com/chroju/learning_grpc) に上げておいた。

## Terraform と gRPC

一通りドキュメントを見てはみたが、正直そんなにガッツリ gRPC 使ってどうこうみたいなことは書いていないような気がする。 RPC 使ってますよ（これは Terraform 0.11 以前から同様）という話と、 "Although technically possible to write a plugin in another language, almost all Terraform plugins are written in Go." という一文が [Writing Custom Providers - Guides - Terraform by HashiCorp](https://www.terraform.io/docs/extend/writing-custom-providers.html) にあるぐらい。将来的に Go 以外でも書けるようにするんですかね。どうなんですかね。

コードで言えば [terraform/docs/plugin-protocol · hashicorp/terraform](https://github.com/hashicorp/terraform/tree/c7058eaa52435e2c603319d194f903261ccfdc1f/docs/plugin-protocol) に protobuf の定義ファイルがある。また、 Provider は `terraform/plugin` の `Serve` という関数を `main.go` に書く必要があり、この関数が Terraform Core に Provider を渡しているようなのだが、 [この実装](https://github.com/hashicorp/terraform/blob/ba6e243bd97fda935f903da0d420e5ed94e35c9e/plugin/serve.go#L56-L83) を見ると、現時点では gRPC 向けに既存のメソッドを変換したりする処理が入っているみたい。 Provider を書く際には、 gRPC を意識する必要は基本的にはなさそう。


