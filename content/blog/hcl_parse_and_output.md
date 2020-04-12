+++
title = "HCL をパースして、構造を組み替えて再出力する"
date = 2020-04-11T18:24:00+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

Terraform などで使われる、 JSON 互換の HCL (Hashicorp Configuration Language) というデータフォーマットがある。 HCL で書かれた設定をパースすることについてはいくつかエントリーを見かけるのだが、 HCL を出力するほうについてはあまり見かけないので書いてみる。

## tfmodule

事の発端としては tfmodule という CLI ツールを作ったことによる。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/chroju/tfmodule" data-iframely-url="//cdn.iframe.ly/j7JrQh7"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

Terraform module を使うときは、 README などを読んで必要な変数を確認し、それに応じて設定を書いていく流れが一般的である。しかし何分これが面倒だったので、一発で module の構造をパースして、テンプレートを吐き出してくれるようなものを作れないかと考えた。

例えばこんな `variable` と `output` を定義している module があったとする。

```hcl
variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "instance_counts" {
  type        = number
  description = "Number of instances to create"
  default     = 2
}

output "instance_arns" {
  value = aws_instance.instance.*.arn
}
```

これに対して tfmodule は以下のようなテンプレートを出力する。

```hcl
module "instances" {
  source = "./modules/instances"

  // EC2 instance type
  // type: string
  instance_type = "t3.micro"
  // Number of instances to create
  // type: number
  instance_counts = 2
}

output "instances_instance_arns" {
  value = module.instances.instance_arns
}
```

処理としては HCL をパースして構造を読み取り、 module の形に再構成して出力をしている。このツールを作る中で、 HCL の出力に関して知見を得ることができた。

## HCL のデータ構造

HCL をパースするには、まず HCL の構造を理解する必要がある。これについては、今回は Terraform における HCL を解析するので、 [Syntax - Configuration Language - Terraform by HashiCorp](https://www.terraform.io/docs/configuration/syntax.html) を読むと早い。正確には、このページに書かれているのは「 Terraform における HCL の使い方」でしかないので、 HCL 自体の言語仕様を知る場合には  [hcl/spec.md at hcl2 · hashicorp/hcl](https://github.com/hashicorp/hcl/blob/hcl2/hclsyntax/spec.md) を読んだほうがよい。ちなみに Read the Docs に https://buildmedia.readthedocs.org/media/pdf/hcl/guide/hcl.pdf という URL で PDF のホワイトペーパーも置かれているのだが、こちらは一部内容が古い部分がある。

ざっくり、  HCL は `Arguments` と `Blocks` という2種類のデータ構造から構成される。

```hcl
image_id = "abc123"
```

これが `Arguments` 。いわゆる key value の形を取る。

```hcl
resource "aws_instance" "example" {
  ami = "abc123"

  network_interface {
    # ...
  }
}
```

これが `Blocks` 。 `{}` によって複数の要素を囲った形を取る。冒頭、上記で `resource` と書かれた部分は `type` と呼ばれ、その block の種別を表す。それに続くダブルクォートで囲われた2つの文字列は `label` と呼ばれ、 block を一意に識別する役割を持つ。 label の数は type ごとに定義することができ、 Terraform であれば resource の label は2つ、 variable や output の label は1つと定義されている。

block の `{}` で囲われた部分は body に当たる。そして body は中に attribute と block を内包することができる。また、ファイル全体も body と呼ばれる。 HCL のデータ構造は、このような入れ子構造になっている。

```
File
└── Body
    ├── Attribute
    ├── Attribute
    └── Block
        └── Body
            ├── Attribute
            └── Block
                └── ...
```

## hclsimple / hclparse

HCL を扱うには、本家 Hashicorp が公開している [github.com/hashicorp/hcl/v2](https://pkg.go.dev/mod/github.com/hashicorp/hcl/v2) を使うのが常道である。このライブラリには、さらに用途別でいくつかのサブパッケージが含まれている。

パースをする際には hclsimple や hclparse を使うことができる。最も直感的に扱いやすいのは hclsimple で、 Go の `json.Marshal()` のように、 hcl を構造体へ変換できる。以下は [hclsimple package · go.dev](https://pkg.go.dev/github.com/hashicorp/hcl/v2@v2.3.0/hclsimple?tab=doc) からの抜粋。

```hcl
type Config struct {
	Foo string `hcl:"foo"`
	Baz string `hcl:"baz"`
}

const exampleConfig = `
	foo = "bar"
	baz = "boop"
	`

var config Config
err := hclsimple.Decode(
	"example.hcl", []byte(exampleConfig),
	nil, &config,
)
if err != nil {
	log.Fatalf("Failed to load configuration: %s", err)
}
fmt.Printf("Configuration is %v\n", config)
```

しかし、この方法は HCL の構造が予想可能な場合にしか使えない。不特定の構造が予期される場合には、 hclparse を使うことにより、 `hcl.File` という組み込みの構造体へ変換できる。一般的にパースだけの用途であれば、この2つを使えば十分と考えている。

## hclwrite

tfmodule では hclwrite というサブパッケージを用いている。名前通り、これは HCL の出力に主眼を置いたサブパッケージになっている。先の `hclsimple.Decode()` が `json.Marshal()` と似ているので、 `json.Unmarshal()` にあたるメソッドが存在すれば嬉しいのだが、残念ながらそういった便利な機能は備わっていない。

hclwrite による HCL の出力はかなり愚直な方法を取る。以下のように、先程示した HCL のデータ構造を、頭から順に作っていくような形になる。

```go
f := hclwrite.NewEmptyFile()

rootBody := f.Body()
moduleBlock := rootBody.AppendNewBlock("module", []string{m.Name})
moduleBody := moduleBlock.Body()

moduleBody.SetAttributeValue("source", cty.StringVal(m.Source))
moduleBody.AppendNewline()

for _, v := range *m.Variables {
        if isNoDefaults && !reflect.DeepEqual(v.Default, hclwrite.TokensForValue(cty.StringVal(""))) {
                continue
        }
        moduleBody.AppendUnstructuredTokens(v.generateComment())
        moduleBody.SetAttributeRaw(v.Name, v.Default)
}
```

`hclwrite.NewEmptyFile()` で返る `hclwrite.File` に、順に要素を詰め込んでいく。その後 `hclwrite.File.Bytes()` を呼ぶと、いわゆる `terraform fmt` が実行された状態の、整形された HCL が出力される。

### SetAttributeXXX

上に示したように、 `SetAttributeXXX()` というメソッドで attribute をセットできるのだが、 key は単純に string を渡せばいい一方、 value についてはそうではなく、種別にいくつかのメソッドが用意されている。

最もよく使うのは `SetAttributeValue()` で、これは value として [github.com/zcolconf/go-cty](https://pkg.go.dev/github.com/zclconf/go-cty) の `cty.Value` を取る。 cty をあんまり理解できていないのだが、 HCL が内部で利用している型システムで、 `cty.StringVal()` で文字列型、 `cty.BoolVal()` で真偽値型の `cty.Value` が返るようになっている。

また、Terraform では `var.example` のようなリテラルを使うことがあるが、これは `SetAttributeTraversal()` で埋め込むことができる。主にはこの2つのいずれかを使うことになる。もう1つ `SetAttributeRaw()` というものがあり、これは `hclwrite.Tokens` という、いわばバイト列をそのまま埋め込んだような構造体を引数に取ることができる。要するに「なんでもあり」なのだが、それ故に godoc には「出来れば `SetAttributeValue()` か `SetAttributeTraversal()` を使うように」と書かれている。

### AppendUnstructuredTokens

HCL に attribute でも block でもない要素を埋め込みたいときがある。つまるところコメントなのだが、これについてはコメント埋め込み用のメソッドが hclwrite に見つからなかったので、 `AppendUnstructuredTokens()` というメソッドを使っている。

その名の通り構造化されていない `hclwrite.Tokens` を直接追加するメソッドで、コメントの追加は以下のように実装している。

```go
...
moduleBody.AppendUnstructuredTokens(v.generateComment())
...
func (v *Variable) generateComment() hclwrite.Tokens {
        tokens := hclwrite.Tokens{
                {
                        Type:  hclsyntax.TokenSlash,
                        Bytes: []byte("//"),
                },
                {
                        Type:  hclsyntax.TokenIdent,
                        Bytes: []byte(v.Description),
                },
                {
                        Type:  hclsyntax.TokenNewline,
                        Bytes: []byte("\n"),
                },
                {
                        Type:  hclsyntax.TokenSlash,
                        Bytes: []byte("//"),
                },
                {
                        Type:  hclsyntax.TokenIdent,
                        Bytes: []byte("type:"),
                },
        }
        tokens = append(tokens, v.Type...)
        tokens = append(tokens, &hclwrite.Token{
                Type:  hclsyntax.TokenNewline,
                Bytes: []byte("\n"),
        })
        return tokens
}
```

`hclwrite.Tokens` はバイト列のようなものと先程書いたが、正確には `hclwrite.Token` の slice である。ではこの `hclwrite.Token` とは何なのか、 godoc から抜粋する。

```go
type Token struct {
	Type  hclsyntax.TokenType
	Bytes []byte

	// We record the number of spaces before each token so that we can
	// reproduce the exact layout of the original file when we're making
	// surgical changes in-place. When _new_ code is created it will always
	// be in the canonical style, but we preserve layout of existing code.
	SpacesBefore int
}
```

バイト列、と書いたように、ここに `Bytes` でリテラルが埋め込まれる。 `Type` はそのリテラルの種類を示しており、例えばリテラルがドットであれば `hclsyntax.TokenDot` 、スラッシュであれば `hclsyntax.TokenSlash` といったものが用意されている。

## tfmodule での実装

hclwrite にも HCL をパースするためのメソッドが存在しているので、 hclwrite だけを使っている。

```go
src, err := ioutil.ReadFile(path)
if err != nil {
        return err
}

file, diags := hclwrite.ParseConfig(src, path, hcl.InitialPos)
if diags.HasErrors() {
        return diags
}

body := file.Body()
for _, block := range body.Blocks() {
        switch block.Type() {
        case "variable":
                variables = append(variables, parseVariable(block))
        case "output":
                outputs = append(outputs, parseOutput(block))
        case "resource":
                resources = append(resources, parseResource(block))
        }
}
```

## 参考となる OSS

長々書いてきたが、正直まだきちんと hashicorp/hcl を理解できたとは思っておらず、もう少し楽な実装がありそうな気がしている。ただ、なかなか実装例を見かけることが少ない。 [shuaibiyy/awesome-terraform](https://github.com/shuaibiyy/awesome-terraform) で Terraform 関連のツールをいくつか見てみたりもしたのだが、特に hclwrite を使っているものは見つけられなかった。今のところ参考になりそうなのは2つほど。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/apparentlymart/terraform-clean-syntax" data-iframely-url="//cdn.iframe.ly/DbBZSM2"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

Terraform の開発に関わっている apparentlymart 氏の個人レポジトリ。 `terraform fmt` のように、 HCL を Terraform 0.12 の書式で整形し直してくれるコマンドラインツールで、がっつり hclwrite を使っている。 tfmodule での実装は、かなりこれを参考にさせてもらった。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/hashicorp/terraform-config-inspect" data-iframely-url="//cdn.iframe.ly/6Cg0Jow"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

この記事を書く中で見つけた、 tfmodule と似た terraform module の解析ツール。 Hashicorp の org 内にあるのだが、今まで気付いていなかった。 hclwrite は使っていないが、 terraform module をどのように解析しているか、という点で学べる点がありそうだった。
