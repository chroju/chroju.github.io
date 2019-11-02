+++
title = "Terraformer が import した resource は不要な属性を含む場合がある"
date = 2019-11-02T16:58:17+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

小ネタです。

以前このブログの [3rd Party tool をきっかけに Terraform のソースコードを少し嗜んだ話 · the world as code](https://chroju.github.io/blog/2019/05/14/read_terraform_source_code/) というエントリーでも取り上げた [terraformer](https://github.com/GoogleCloudPlatform/terraformer) 。既存のクラウドリソースを元に terraform file を作成してくれる便利ツールなのだが、時に必要ない属性値を resource に含んだファイルを作ることがある。

```hcl
resource "aws_s3_bucket" "tfer--chroju-002E-net" {
  acl            = "private"
  arn            = "arn:aws:s3:::chroju.net"
  bucket         = "chroju.net"
  force_destroy  = "false"
  hosted_zone_id = "XXXXXXXXXXXXXX"
  region         = "ap-northeast-1"
  request_payer  = "BucketOwner"

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }

  website {
    index_document = "index.html"
  }

  website_domain   = "s3-website-ap-northeast-1.amazonaws"
  website_endpoint = "chroju.net.s3-website-ap-northeast-1.amazonaws.com"
}
```

例えばこれは自分の S3 バケットを import してみた実際の結果（一部マスクあり）なのだけど、いくつか不要な値を含んでいる。具体的には `arn` , `website_domain` , `website_endpoint` の3点。ドキュメント [AWS: aws_s3_bucket - Terraform by HashiCorp](https://www.terraform.io/docs/providers/aws/r/s3_bucket.html) を見るとわかるが、これらは `Attributes References` 、つまり他の resource から参照可能な属性であって設定に必要な値ではない。

ではこれは余計な値でバグなのではないか、と思いたくなるところなのだけど、面白いのはこのまま `terraform` コマンドを打ってもエラーにはならないということ。以下、試しに ARN を `hogefuga` という値に変更して `terraform apply` して、その後再度 `plan` で結果を確認してみたサンプルを貼る。

<script id="asciicast-2HP4t3MJhnhogQj1QgubaHydG" src="https://asciinema.org/a/2HP4t3MJhnhogQj1QgubaHydG.js" async></script>

ARN は AWS 側が一定の法則に則って自動採番する ID であり、当然ながらユーザーが任意で変更はできない。それなのに `plan` の結果として ARN の変更は予告され、そして `apply` も通ってしまうのが面白い。しかし `apply` 後に `plan` を実行すると、依然差分として表示はされるので、実際に `apply` が通ったわけではない。当たり前だけど、ちょっと挙動としては不安にもなる。

ちなみにこの状態から ARN を削除してみても、 `terraform plan` の結果は `No Changes` になり、 ARN が削除されるようなことはない（そりゃそうなんだが）。そのため Terraformer の import 結果に不要な値が含まれていたら、運用上の混乱を避ける意味でも、手で削除してしまうのが無難ではある。

## 原因

ではなぜこのような挙動になるのかだが、原因は Terraform の実装にある。

Terraform の各 resource にどのような attributes を含むかは、 `&schema.Resource.Schema` に `map` の形で定義されている。 AWS S3 の場合は [terraform-provider-aws/resource_aws_s3_bucket.go at master · terraform-providers/terraform-provider-aws](https://github.com/terraform-providers/terraform-provider-aws/blob/master/aws/resource_aws_s3_bucket.go) で、冒頭だけ抜き出すとこのような形。

```go
		Schema: map[string]*schema.Schema{
			"bucket": {
				Type:          schema.TypeString,
				Optional:      true,
				Computed:      true,
				ForceNew:      true,
				ConflictsWith: []string{"bucket_prefix"},
				ValidateFunc:  validation.StringLenBetween(0, 63),
			},
			"bucket_prefix": {
				Type:          schema.TypeString,
				Optional:      true,
				ForceNew:      true,
				ConflictsWith: []string{"bucket"},
				ValidateFunc:  validation.StringLenBetween(0, 63-resource.UniqueIDSuffixLength),
            },
```

そしてここに並列で `Attributes References` に含まれる値も並んでいる。どれが `Arguments` （設定値）でどれが `Attributes` なのかを識別できるような箇所はない。そのため resource の中に `Attributes` にあたる値を書き入れても、エラーにはならない。

また Terraformer を使用した際の挙動としては、 Terraform の `refresh` コマンドに相当するメソッドを呼び出す形になる。 `refresh` といえば現在のクラウドリソースの状態を取得して、 tfstate を書き換えるというもの。 tfstate 側には `Attributes` に相当する値も含まれているため、 `refresh` を呼ぶ形だと `Attributes` も一緒に読み込んでくる形になる。だから Terraformer が作成する tf ファイルには、 `Attributes` が含まれるということになる。

現状、先述の通り Terraform の実装として `Arguments` と `Attributes` を識別する方法がないため Terraformer がこのような挙動をするのはやむを得ないと考えている。 Terraformer は Terraform の API を効率よく活用することで、個々のクラウドリソースの API を最小限にしか知る必要がない形で実装されている。各値が `Attributes` かどうかという情報は Terraform 側が持つべきであって、 Terraformer に実装させる必要はないだろう。幸い、見てきた通り `Attributes` を含めても Terraform はエラーにならないので、割り切ることもできなくはない。

## Impression

以上、トリビアに近い小ネタを書いてみた。きっかけは実際に terraformer を使っていてこの挙動に気づいたことなのだけど、もうすぐ [Terraform Source Code Reading#3 - connpass](https://terraform-jp.connpass.com/event/150359/) というイベントに参加することもあり、少し Terraform のコードを読む機会が欲しかった形。このイベント、それなりにレベル高いことやろうとしてるので、生きて帰れるのかむちゃくちゃ不安。
