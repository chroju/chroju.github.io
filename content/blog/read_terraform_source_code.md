+++
title = "3rd Party tool をきっかけに Terraform のソースコードを少し嗜んだ話"
date = 2019-05-14T20:30:00+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

## tl;dr

今回あんまりまとまった話でもなくて、いろいろ調べていたら手元のメモがだいぶ長くなったのでせっかくだし公開してみよう、程度のものです。正直文章化が上手くできているとも思えなくて、読みにくいと思いますしスルー推奨です。一応3行でまとめておきます。

* terraformer に issue を上げたら Terraform の内部実装に絡めた返答をもらったが、すぐに理解できなかった。
* そこで terraformer と Terraform のコードリーディングをしてみて、その過程を書いてみた。
* Terraform 内で使われている gRPC の勉強が必要とか、コードリーディングの効率を上げたいといった課題も見つかり、良い機会になった。

## terraformer

terraformer というツールをご存知でしょうか。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/GoogleCloudPlatform/terraformer" data-iframely-url="//cdn.iframe.ly/xqCkI2w"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

既存のクラウドリソースの状態を読み解き、 tf ファイルと tfstate ファイルを生成してくれるツールです。同様のツールとしては [dtan4/terraforming](https://github.com/dtan4/terraforming) が著名で、 terraformer の README.md 内でも言及があるほどですが、この2つにはそこそこ差異が見られます。

まず機能面においては、 terraforming が指定したリソースの tf ファイル、 tfstate ファイル相当の情報を愚直に標準出力に出す、非常にシンプルな実装をしているのに対し、 terraformer は tf ファイルと tfstate ファイルを同時生成するほか、 `provider.tf` や、`terraform apply` したときに動的に生成される、インスタンス ID のような computed な値を出力するための `outputs.tf` まで生成してくれる至れり尽くせりなツールになっています。また、例えば `terraformer import aws --resources=route53` を実行すると Route53 に関するすべての情報を取得する、つまり `aws_route53_zone` と `aws_route53_record` 双方が生成される形になります。先のコマンドで生成されるファイルは以下のとおりです。

```bash
$ tree
.
├── outputs.tf
├── provider.tf
├── route53_record.tf
├── route53_zone.tf
└── terraform.tfstate

0 directories, 5 files
```

そして実装面でもだいぶアプローチが異なるのですが、それについては最後に触れようと思います。

## 発端となった issue

本題に入りますが、 先日 Route53 Records の `import` を terraformer で行ったところ、エイリアスレコードに関してちょっとした問題が起きたため、 issue を上げました。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/GoogleCloudPlatform/terraformer/issues/65" data-iframely-url="//cdn.iframe.ly/sGSrfal"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

何を言っているかというと、 Route53 の DNS Record には当然ながら TTL の設定ができるのですが、そのレコードがエイリアスレコードである場合は TTL の設定ができない（Terraform 的な言い方をすると、2つの要素が競合 = Confilict した状態）はずなのに、 terraformer は `ttl = "0"` として設定を入れてしまっている、という話です。この状態で `terraform plan` を実行すると、競合する要素が定義されているよ、というエラーになります。

これに対して開発者の sergeylanzman 氏が返答してきたのが、以下の文です。

> It's know issue(#25) terraformer can't get today details about each field.

これだけではいまいちわからなかったので、ここで言及されている [#25](https://github.com/GoogleCloudPlatform/terraformer/issues/25) の issue を引用してみると、このような内容になっています。

> Today terraformer use terraform.ResourceProvider interface for get ProviderSchema with Attributes.
> In other interface we can get more Attributes from providers(like deprecation options)
> Need use schema.Schema from github.com/hashicorp/terraform/helper/schema

どうも terraformer が使っている terraform 側の interface の都合が絡んでいるようです。現在は `terraform.ResourceProvider` を使っているが、これを `schema.Schema` に変更したほうが、より詳細な情報を取得できる、という内容に読み取れます。私は Terraform の動作、ソースコードを広く把握できているわけではないので、この返答をもらっても飲み込むことができず、ソースコードにあたってみることにしました。

## terraformer と Terraform を読み解く

まず terraformer の動作原理を少し確認しました。 import コマンドの実装部分は [terraformer/cmd/import.go](https://github.com/GoogleCloudPlatform/terraformer/blob/master/cmd/import.go) 内の `func Import()` にあります。ここではコマンドのオプション `--resources` で与えられたリソース名（Route53, S3 など）に対し、 for 文でそれぞれ以下のような処理が実行されています。

```go
		err = provider.InitService(service)
		if err != nil {
			return err
		}
		err = provider.GetService().InitResources()
		if err != nil {
			return err
		}

		if len(options.Filter) != 0 {
			provider.GetService().ParseFilter(options.Filter)
			provider.GetService().CleanupWithFilter()
		}

		refreshedResources, err := terraform_utils.RefreshResources(provider.GetService().GetResources(), provider.GetName(), provider.GetConfig())
		if err != nil {
			return err
		}
		provider.GetService().SetResources(refreshedResources)
```

見たところ `provider.InitService()` で各サービス（Route53など）に対する初期化処理を行い、さらに `provider.GetService().InitResources()` で、各サービス内の個別リソース（Route53 Record や Zone など）に対する初期化を行い、その上で `terraform_utils.RefreshResoures()` というメソッドを呼ぶ、と何段階かを経ているのが読み取れます。ここの `provider` とはいわゆる Terraform Provider ではなく、 terraformer 内の `terraform_utils.ProviderGenerator` という interface を指しており、AWS、GCP等の各 Provider 向けにこれを実装しています。例えば AWS に関しては [terraformer/providers/aws/aws_provider.go](https://github.com/GoogleCloudPlatform/terraformer/blob/master/providers/aws/aws_provider.go) 内の `AWSProvider` が該当し、この中に `func InitService()` が定義されています。`InitService` で行われる処理は文字通り初期化処理で、例えば terraformer はすべての AWS サービスに対応しているわけではないので、ここで対応非対応の判定を行っていたりするようです。

続いて `provider.GetService().InitResources()` ですが、 Route53 の場合は [terraformer/providers/aws/route53.go](https://github.com/GoogleCloudPlatform/terraformer/blob/master/providers/aws/route53.go) で定義されており、まずホストゾーンの情報をすべて取得してから、各ホストゾーンに対してレコード情報の取得を行う、という実装になっています。以下に、レコード情報を取得する部分を担っているメソッドである `createRecordsResources()` のソースを引用してみます。

```go
func (Route53Generator) createRecordsResources(svc *route53.Route53, zoneID string) []terraform_utils.Resource {
	resources := []terraform_utils.Resource{}
	listParams := &route53.ListResourceRecordSetsInput{
		HostedZoneId: aws.String(zoneID),
	}
	recordSet, err := svc.ListResourceRecordSets(listParams)
	for _, record := range recordSet.ResourceRecordSets {

		resources = append(resources, terraform_utils.NewResource(
			fmt.Sprintf("%s_%s_%s", zoneID, aws.StringValue(record.Name), aws.StringValue(record.Type)),
			fmt.Sprintf("%s_%s_%s", zoneID, aws.StringValue(record.Name), aws.StringValue(record.Type)),
			"aws_route53_record",
			"aws",
			map[string]string{
				"name":    aws.StringValue(record.Name),
				"zone_id": zoneID,
				"type":    aws.StringValue(record.Type),
			},
			route53AllowEmptyValues,
			route53AdditionalFields,
		))
	}
	if err != nil {
		log.Println(err)
		return []terraform_utils.Resource{}
	}
	return resources
}
```

AWS の API を呼んで、実際に情報を取得しているのがここの6行目の箇所で、取得した list を格納した `recordSet` 変数に対して `for` を回し、必要な情報を格納した `resources` 変数を返り値として戻す、という構成になっています。しかし `resources` に情報を格納するコードを読んでみると、 API から取得した情報を格納しているのは14行目からの `map[string]string` を作っている箇所だけで、 name, zone_id, type という3つの要素しか格納されていません。これでは Route53 Record の情報としては当然ながら不足しています。

どうもこれを補うのが `terraform_utils.RefreshResources()` の箇所と見受けられます。「見受けられます」とぼかした書き方をしましたが、すみません、ここから先はちょっと追いきれませんでした。ここからいくつかのメソッドを呼び出す過程があり、長くなりそうなので説明は省きますが、ここで最終的に `terraform.ResourceProvider` に行き着くことができます。 goroutine を使って並行に `terraform.ResourceProvider.Refresh()` というメソッドを呼んでいるようです。

追いきれなかったのは、この `Refresh()` メソッドが何をやっているのかわからなかったためです。以下に [terraform/resource_provider.go at master · hashicorp/terraform](https://github.com/hashicorp/terraform/blob/master/plugin/resource_provider.go) から引用します。

```go
func (p *ResourceProvider) Refresh(
	info *terraform.InstanceInfo,
	s *terraform.InstanceState) (*terraform.InstanceState, error) {
	var resp ResourceProviderRefreshResponse
	args := &ResourceProviderRefreshArgs{
		Info:  info,
		State: s,
	}

	err := p.Client.Call("Plugin.Refresh", args, &resp)
	if err != nil {
		return nil, err
	}
	if resp.Error != nil {
		err = resp.Error
	}

	return resp.State, err
}
```

`p.Client.Call` という箇所がありますが、この `Client` というのは RPC Client です。 Terraform は本体とプロバイダ間の通信に RPC を用いているのですが、私自身 RPC 周りの知識が一切ないため、今回はここでストップと相成りました。ただ、ある程度の推測は可能です。この `Refresh()` メソッドの戻り値である `terraform.InstanceState` は [terraform/state.go at master · hashicorp/terraform](https://github.com/hashicorp/terraform/blob/master/terraform/state.go) で定義されており、この構造体の中にある `Attributes` というフィールドが `Attributes are basic information about the resource` とドキュメントされています。ここから推測するに、 terraformer の import 処理は、 `terraform.ResourceProvider.Refresh()` により `terraform.InstanceState` としてクラウドリソースの情報を取得している、と考えてよさそうです。

だいぶ回り道をしてようやく本題に戻りますが、

> Today terraformer use terraform.ResourceProvider interface for get ProviderSchema with Attributes.
> In other interface we can get more Attributes from providers(like deprecation options)
> Need use schema.Schema from github.com/hashicorp/terraform/helper/schema

この1行目については、これまでの過程で確認できました。3行目で、これに代わって使うべきとされている `schema.Schema` を見てみようと思いますが、これについては Terraform の [Developer 向けガイド](https://www.terraform.io/docs/extend/schemas/index.html) を見たほうがわかりやすそうでした。

```go
// Provider returns a terraform.ResourceProvider.
func Provider() terraform.ResourceProvider {
    // Example Provider requires an API Token.
    // The Email is optional
    return &schema.Provider{
        Schema: map[string]*schema.Schema{
            "api_token": {
                Type:        schema.TypeString,
                Required:    true,
            },
            "email": {
                Type:        schema.TypeString,
                Optional:    true,
                Default:     "",
            },
        },
    }
}
```

このように、 `schema.Schema` は Terraform の Provider や Resource などの形式を定義する際に用いる構造体で、その要素が Required なのかオプションなのか、また他の要素と競合し得るのか、といった詳細な情報を持たせることができるものです。一方、現状 terraformer が使用している `terraform.InstanceState.Attributes` は単に Terraform Resource の要素をキーバリュー形式で格納した map に過ぎず、各要素がどのような意味を持つのかまで判断する材料にはなりません。そのため `schema.Schema` を使う形に変更すれば、私が指摘した Route53 Record で競合してしまっていた要素の検出も実装することができる、という、そういう意図だったようです。

## terraformer の実装を解釈する

今見てきたように、 terraformer の import は以下のような実装となっています。

1. 対象のクラウドサービスの API を呼び出し、 import 対象である resource の ID など、最低限の情報だけをまず読み込む。
1. 取得した ID 等を元に、 Terraform Provider から `terraform.ResourceProvider.Refresh()` を呼ぶことで、 import に必要なすべての情報を取得する。

これは terraforming のアプローチとは大きく異なります。というのも、 terraforming はクラウドサービスの API を呼び、最初から必要なすべての情報を取得して書き出す実装となっているからです。 terraformer があえて処理を2段階に分けたのは、 Terraform resource はクラウドサービス側の仕様変更に伴って内実が頻繁に変わる可能性があるため、 Terraform resource の定義に関する処理を Terraform Provider 側へ任せる意図があったと思われます。 Terraform resource として必要な情報を取得する処理は Terraform Provider に任せてしまうことで、 terraformer は最初の初期化処理と、 tf, tfstate ファイルを書き出す処理に集中することができており、これは疎結合で良い実装だなと感じました。ただ、一方で Terraform Provider をあらかじめダウンロードしておく必要があったり、処理が増えるために少々動作が遅いと感じることがあったり、というデメリットも見られます。

## Conclusion

今回、サードパーティツールが直接 Terraform や Terraform Provider のコードを呼び出していたため、それをきっかけとして Terraform に対する理解を深める良い機会になりました。ただ知識不足によりすべてが読み解けたわけでもなかったため、特に RPC については勉強してみようかと思っています。ちょうど Terraform 0.12 から gRPC を用いた実装に変更されますが、 gRPC と言えば昨今の microservices を追う上でも欠かせないプロトコルのようですので、その意味でも押さえておきたいところです。

また今回コードリーディングには VSCode を使って頑張って検索したり F12 で定義ジャンプしたりしていたのですが、もっと効率の良いやり方がありそうだなという気もしてます。1日作業になってしまったので、もう少しコードリーディングには慣れていきたいです。

