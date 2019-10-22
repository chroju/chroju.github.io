+++
title = "Netlify Functions と Go で動的なウェブページを作る"
date = 2019-06-10T17:43:55+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

5年間ぐらい chroju.net というドメインを取って自分のプロフィールを掲載していて、裏側では AWS の Serverless な仕組みがいろいろ動いていたりしたのだけど、先日 chroju.dev というドメインを取ったのでそちらにプロフィールを載せ替え、仕組みも Netlify Functions に変更した。

## 従来の仕組み

従来の仕組みは以下の Qiita のエントリーにまとめていた。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://qiita.com/chroju/items/827dbb9e820f41820e14" data-iframely-url="//cdn.iframe.ly/XTWFfEE"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

やりたかったのは、プロフィールの中に自分のブログの最新記事リストを自動的に埋め込むこと。紆余曲折を経て、あらかじめ jinja2 でテンプレートを作っておき、ブログの更新を RSS と IFTTT 経由で hook して Lambda を叩いて、その Lambda がテンプレートから html を生成して S3 に設置、という形をこのときは取っている。つまり動的チックだが、実際にアクセスが来るのは静的な HTML ではある。ページ内に書いてある通り、各サービスの仕様がその後変わっているので、現時点でこのメカニズムを採用するのはモダンではなくなっている。

なお、 chroju.net のドメインはもう失効したが、このページ自体はまだ生きている。気まぐれに消すと思うので、動いていなくてもあしからず。

https://chroju-profile.s3-ap-northeast-1.amazonaws.com/index.html

## 今回の仕組み

シンプルに、 URL へアクセスがあったときにサーバーサイド（実際にはサーバーレスだけど）で RSS から最新記事のタイトルとリンクを読み込んで、テンプレートに埋め込んで HTML を返す、というメカニズムに変えることにした。

[Netlify Functions](https://www.netlify.com/docs/functions/) はコードを書いた GitHub レポジトリと連携を設定すると、それを自動的に AWS Lambda にデプロイして URL から実行できるようにしてくれる仕組み。つまり Lambda と API Gateway の設定を面倒見る必要なく、コードを書くことだけに集中ができる。基本的には API を作ったりするのが主な用途だと思うけど、もちろん `text/html` を返しても良いので、今回はそれを利用している。言語は JavaScript と Go が使えるが、自分のスキルを鑑みて Go にした。

## 実装

HTML のテンプレートには Go の標準ライブラリの `html/template` を使った。また RSS の読み込みとパースには https://github.com/mmcdole/gofeed を利用している。最新のコードは https://github.com/chroju/portfolio に置いている。

```go
package main

import (
	"bytes"
	"html/template"
	"io"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/mmcdole/gofeed"
)

func handler(request events.APIGatewayProxyRequest) (*events.APIGatewayProxyResponse, error) {
	fp := gofeed.NewParser()

	feed, _ := fp.ParseURL("https://chroju.github.io/atom.xml")
	ghitems := feed.Items[:3]
	feed, _ = fp.ParseURL("https://chroju.hatenablog.jp/feed")
	hbitems := feed.Items[:3]

	tmpl := template.Must(template.New("index.html").Parse(htmlTemplate))
	buf := new(bytes.Buffer)
	w := io.Writer(buf)

	err := tmpl.ExecuteTemplate(w, "base", struct {
		GitHubIOEntries   []*gofeed.Item
		HatenaBlogEntries []*gofeed.Item
	}{
		GitHubIOEntries:   ghitems,
		HatenaBlogEntries: hbitems,
	})
	if err != nil {
		log.Fatal(err)
	}

	return &events.APIGatewayProxyResponse{
		StatusCode: 200,
		Body:       string(buf.Bytes()),
	}, nil
}

func main() {
	lambda.Start(handler)
}
```

先述の通り裏側は AWS Lambda なので、 Lambda の書き方に沿うことになる。 Lambda の実行時に呼び出す関数は handler と呼ばれる。この handler は特に API Gateway から呼ばれることになるので、 API Gateway とやり取りするために `*events.APIGatewayProxyRequest` を受け取り、 `*events.APIGatewayProxyResponse` を返すように実装する必要がある。今回はそのなかで html を Response Body に入れて返している。

テンプレートは行数も多くなるので、本来であれば別ファイルに切り出したいところなのだが、 Netlify Functions でコード以外のファイルを一緒にデプロイする方法がわからなかった。そのため今はテンプレート全行を定数に代入する形でべた書きしている（上述のコードの中では省略した）。

あとは build 用のコマンドを Makefile に書いておく。これで `functions` というフォルダ内にバイナリが置かれることになる。

```make
build:
	export GO111MODULE=on
	go get ./...
	go build -o functions/profile ./...
```

設定したコマンドと、バイナリの在り処を `netlify.toml` に書き、このレポジトリを Netlify Functions に連携することで、レポジトリの push を検知して自動的に build してデプロイしてくれるようになる。とても手軽。

```toml
[build]
    command = "make build"
    functios = "./functions"
```

## misc

コード以外の設定をいくつか。

### Font Awesome

SNS のアイコンを表示するために何年かぶりに Font Awesome を触ったところ、設定方法が替わっていたように思うのだが、以前の記憶が曖昧ではある。従来は CDN 上の CSS を `link` タグで直接読み込む形を取っていたと思うのだが、現状この形式は推奨されておらず、ユーザー登録すると個別の ID が払い出され、その ID に紐ついた js を読み込んで使う、という形になったらしい。

管理画面上で使用するプランや、 Web Font か SVG かの選択などを行えるようになっているので、おそらくそれを反映して、 js が適した css を動的に読み込むようになっているのだと思われる。 Font Awesome がバージョンアップした場合にも自動的に latest を読み込んでくれるようなので、メンテナンスの手間は減って便利になっている。

### DNS

chroju.dev は Google Domains で取得したが、 Netlify Functions を使うにあたって Netlify の Managed DNS を使うと CDN を噛ませて速くしてくれるみたいな話だったので、名前解決は Netlify にまかせている。

<div class="iframely-embed"><div class="iframely-responsive" style="padding-bottom: 53.5714%; padding-top: 120px;"><a href="https://www.netlify.com/docs/dns/" data-iframely-url="//cdn.iframe.ly/CpY94NE"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

残念ながら API がまだ無いようで、 chroju.net の時代は Route53 に乗せて API 経由でゴニョゴニョしていたことが出来なくなってしまったのでどうしようかな、という課題が残された。まだ Beta 扱いのようではあり、今後に期待したい。

### Redirect

Netlify Functions はカスタムドメインは使用できるものの、個々の Function を実行するパスの自由度はなくて、デフォルトだと `/.netlify/functions/` 配下に置かれる。しかし https://chroju.dev へアクセスが来たときに Functions を実行して返したいわけなので、 `netlify.toml` でリダイレクトを設定した。 200 で返すことにより、ユーザーのアドレスバーには https://chroju.dev/ が表示されたままでリダイレクトさせることができている。

```toml
[[redirects]]
    from = "/"
    to = "/.netlify/functions/profile"
    status = 200
```

### go mod

今回初めて go mod を利用したけど便利だった。利用にあたっては公式のドキュメントと以下のエントリーを参考にした。

* [最近のGo Modulesプラクティス ~ ghqユーザーの場合も添えて | おそらくはそれさえも平凡な日々](https://songmu.jp/riji/entry/2019-03-28-go-modules.html)

## Conclusion

すごく簡単に AWS Lambda と API Gateway が使えて楽しかった。対応言語が Go と JS だけなど制約もあるが、単発で動かす Lambda とエンドポイントがほしいだけの場合であれば、 AWS ではなく Netlify Functions でデプロイしたほうがいろいろと不便がなさそう。
