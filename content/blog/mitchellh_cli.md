+++
title = "HashiCorp ファン必須科目である mitchellh/cli を履修する"
date = 2019-03-27T23:00:00+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

## mitchellh/cli について

Go にはコマンドラインツールを書くのに役立つフレームワークが数多くありますが、今回はググってもあんまり日本語情報が出ず、また godoc に example も少なくて掴みどころが難しい、 [mitchell/cli](https://github.com/mitchellh/cli) に触れてみます。正直、有名どころの [urfave/cli](https://github.com/urfave/cli) や [alecthomas/kingpin](https://github.com/alecthomas/kingpin) に比べて使い勝手が良いとは言いづらいフレームワークだと感じていますが、 mitchellh氏のレポジトリにあることからもわかる通り、 Terraform 等の HashiCorp OSS 群で使われているフレームワークということで、あえて学んでみました。

なお、ただ実装を読むだけではつまらないですし、せっかくなら使ってみたかったので、現在拙作の [nature-remo-cli](https://github.com/chroju/nature-remo-cli) 内でも活用しています。実例として良ければご参照ください。

## 基本

まずはとにかく README.md にある example コードを見てみます。

```go
package main

import (
	"log"
	"os"

	"github.com/mitchellh/cli"
)

func main() {
	c := cli.NewCLI("app", "1.0.0")
	c.Args = os.Args[1:]
	c.Commands = map[string]cli.CommandFactory{
		"foo": fooCommandFactory,
		"bar": barCommandFactory,
	}

	exitStatus, err := c.Run()
	if err != nil {
		log.Println(err)
	}

	os.Exit(exitStatus)
}
```

`mitchellh/cli` は基本的にサブコマンドのあるコマンドを実装するためのツールです。 `c.Commands` にセットしている `map[string]cli.CommandFactory` がサブコマンドの定義箇所で、キーになっている文字列をサブコマンドとして実行されたとき、その値の `CommandFactory` が実行される、という形を取ります。ではこの `cli.CommandFactory` は何者かと言うと、以下のように `cli.Command` と `error` を返す関数として定義されています。

```go
type CommandFactory func() (Command, error)
```

従って上記の example のような変数で `CommandFactory` を返す形ではなく、ここで無名関数を定義してしまう形も可能です。具体的なところだと Terraform の実装 (https://github.com/hashicorp/terraform/blob/master/commands.go#L80-L85) などを見るとイメージが掴みやすいと思います。私はこちらの書き方のほうが明示的で好みです。この Terraform の実装では `error` にあたる返り値として決め打ちで `nil` を返していますが、私も同様に実装しています。あんまりここで `nil` 以外の値を返すパターンが思いつきません。

## cli.Command の実装

次に、先の `CommandFactory` が返していた `cli.Command` の実装を見てみます。 `cli.Command` は `help`, `Run`, `Synopsis` の3つのメソッドを必要とする interface です。

```go
type Command interface {
	Help() string
	Run(args []string) int
	Synopsis() string
}
```

`Synopsis()` は、サブコマンド無しでコマンド実行したときに出力される、そのサブコマンドの使い方を記した50字程度の注釈を返すよう設定します。 例として nature-remo-cli を使ってみると、こんな感じで表示されます。

```
Available commands are:
    aircon    Control Air Conditionar
    init      Initialize remo with your OAuth token
    signal    Control Signals
    sync      Sync local config with your latest one
```

`Help()` はそのままの意味で、 `-h` や `--help` を付けて実行した場合に返す内容を設定します。よくある Usage の自動生成のような機能はありませんので、愚直にヒアドキュメントなどで書いていく必要があります。

`Run()` で実行したい処理を書いていきます。1つ注意したいのが、返り値として渡せるのが `int` 型、つまりはリターンコードのみであり、 `error` インターフェースや、エラーメッセージを含めた `string` などは返せないという点です。従ってエラーの処理やエラーメッセージの出力は、 `Run()` の中ですべて済ませる必要があります。

### cli.Command 内での出力処理

ではエラーメッセージをどのように出力するかですが、 `cli.Command` の中に `cli.Ui` を埋め込んで活用するのが一般的です。

```go
type HogeCommand struct {
	UI cli.Ui
}

func (c *HogeCommand) Run(args []string) int {
	c.UI.Output("Normal Message")
	c.UI.Error("Error Message")

	return 0
}
```

`c.UI.Output()` は標準出力に、 `c.UI.Error()` は標準エラー出力にいい感じに吐いてくれます。他にも対話式にユーザーの入力を待ってくれる `Ask()` や、さらにはユーザー入力を隠してくれるので秘密情報を入力させるのに便利な `AskSecret()` といった便利なメソッドも `cli.Ui` に用意されています。

さて、 `fmt.Println()` などを使わず `cli.Ui` をわざわざ使うと何が嬉しいのかと言えば、お察しのとおりかと思いますが一つにはテストが書きやすくなる面があります。 `cli.MockUi` という、標準出力先と標準エラー出力先にあたる buffer を有した構造体があるので、テストのときにはこれを使うことで出力のチェックができます。この点については Vault での実装 (https://github.com/hashicorp/vault/blob/df18871704fe869e9be45b542a6b1eb2fe46c293/command/audit_disable_test.go) などが参考になるかと思います。他にも `cli.Ui` を満たす構造体がいくつか用意されていて、ほしい機能があれば追加できるようになっており、例えば `cli.ColoredUi` は出力の色指定ができるので非常に便利です。ANSI エスケープシーケンスの8色を指定するための定数も[用意されています](https://godoc.org/github.com/mitchellh/cli#pkg-variables) ので、簡単にターミナルへ色付きの出力をすることができます。

## 極めてシンプルな CLI ツール

ざっくりここまでの説明で主要な使い方は網羅しました。説明を省いたものとして AutoComplete の支援機能などがありますが、せいぜいがそんなもので、非常に薄い実装のフレームワークになっています。他のコマンドラインフレームワークによくある機能はほとんどなく、オプションの処理すら担ってくれません（`-h` や `--version` はデフォルトで対応していますが、それだけです。nature-remo-cli では spf13/pflag を合わせて使う形にしました）。さすがにちょっと不親切というか、あくまで HashiCorp で使うための最低限の機能だけを実装したものなのかな、という感触があります。

ただ一方では、サブコマンドごとに `cli.Command` を満たす構造体を別々に実装する、つまりはコードがサブコマンド単位で強制的に分かれる形になるので、コードの可読性は高い状態を保てるように感じています。 [Terraform のコマンド実装](https://github.com/hashicorp/terraform/tree/master/command) など、一度でも Terraform を使ったことがある人が見れば、すぐに知りたい実装がどこにあるのか見通せるようなファイル構成になっています。したがって冒頭にも書いた通り、 HashiCorp のツールをよく使う人であれば、知っておいて損はないのではないかなと思っています。

