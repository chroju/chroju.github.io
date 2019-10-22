+++
title = "AWS Parameter Store をターミナルから操作する Parade を作った"
date = 2019-10-14T08:23:39+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/chroju/parade" data-iframely-url="//cdn.iframe.ly/v9brQHK"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

[AWS Systems Manager のパラメータストア](https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/systems-manager-parameter-store.html) をよく使っている。例えば Git で管理ができない秘匿情報を SecureString の形で保存しておいたり、 Infrastructure as Code を実行する際、 Terraform で構築したリソースの設定値を Ansible に橋渡しをするために使ったり、各種ツールやアプリケーションで参照したい設定値の保管場所として便利に使うことができる。

欠点として、今どんな値が格納されていたか？　どんなキー名で格納されていたか？を確認したいときの操作が若干面倒というのがあった。マネジメントコンソールではキーの一覧から、目当てのキーをクリックしてページ遷移しなければ値を見ることができない。またキーを検索する場合も、完全一致か前方一致での検索しかできず、目的のキーをなかなか探せないことが多かった。まぁ AWS CLI を `grep` などと組み合わせてうまいこと使うのが解なのだろうとは思うのだけど、手を動かす題材としても良さそうだったので、 go で CLI ツールを作って対処することにした。

## Parade

<script id="asciicast-ST2F5vAVnk5998C0KtkH6f5GN" src="https://asciinema.org/a/ST2F5vAVnk5998C0KtkH6f5GN.js" async></script>

名前にあまり意味はない。パラメータストアなので "para" の付く英単語がいいなと適当に探して命名した。みんな OSS の名前ってどうやって決めてるのか教えてほしい。

シンプルに値を読み書きすることだけ、もっと言えば読むことだけが目的だったので、機能は少ない。コマンド体系は redis-cli を参考にしていて、 `keys`, `get`, `set`, `del` の4つのサブコマンドから成る。先述の通り、キーの検索が面倒というのが発端になっているので、特に `get` を強化した。何もオプションを与えなければ `get hoge` でキー名 "hoge" がある場合に限り値を出力するけれど、キー名の記憶が曖昧な場合などは `--ambiguous` あるいは `-a` オプションを付ければ部分一致するキー名をすべて拾ってきてくれる。このとき、一致箇所を赤字で表示するようこだわってみた。また `SecureString` にも対応していて、自身に復号の権限さえあれば、 `-d` オプションで復号した値を出力することもできる。

逆に `set` で値を登録するときは、任意のキーIDを指定した暗号化ができない（デフォルトのキーでの暗号化は可能）など、機能は現状最小限になっている。本当に手元でサクッとパラメーターを確認することを意図したツールにしている。

### 類似ツール

似たところだと [segmentio/chamber](https://github.com/segmentio/chamber) が挙げられると思う。が、 chamber はあくまでシークレットマネージャーツールであることが主眼に置かれており、そのバックエンドとしてパラメータストアが使えるだけなので、パラメータストアの読み書き自体を目的とした parade とはちょっと軸足が違うかな、と思っている。

## 使用技術

いくつか初めて使う技術を盛り込めたのでよかった。

### aws-sdk-go

AWS 関連のスクリプトを書く際は Python の boto3 を使うことが多く、今回 aws-sdk-go はほぼ初めてちゃんと使う機会になった。ドキュメントは [AWS Documentation](https://docs.aws.amazon.com/sdk-for-go/api/) として公開されてもいるが、個人的には [GoDoc](https://godoc.org/github.com/aws/aws-sdk-go) のほうが慣れもあって読みやすかった。

またユニットテスト用の mock が用意されているのが嬉しい。 Parade ではパラメータストアへのアクセス部分で以下のようなコードを書いている。

```go
type SSMManager struct {
	svc ssmiface.SSMAPI
}

func New() (*SSMManager, error) {
	sess := session.Must(session.NewSession())
	svc := ssm.New(sess)

	return &SSMManager{
		svc: svc,
	}, nil
}

func (s *SSMManager) GetParameter(query string, withDecryption bool) (*ssm.Parameter, error) {
	params := &ssm.GetParameterInput{
		Name:           aws.String(query),
		WithDecryption: aws.Bool(withDecryption),
	}

	resp, err := s.svc.GetParameter(params)
	if err != nil {
		return nil, err
	}

	return resp.Parameter, nil
}
```

最初に定義した構造体 `SSMManager` に埋め込んでいる [ssmiface.SSMAPI](https://github.com/aws/aws-sdk-go/blob/master/service/ssm/ssmiface/interface.go) が、各 API を呼ぶメソッドを実装した Interface になっているため、ダミー値を返すメソッドを書いた mock を用意することで、ユニットテストができるようになっている。

```go
type mockSSMClient struct {
	ssmiface.SSMAPI
}

func NewMock() *SSMManager {
	svc := &mockSSMClient{}

	return &SSMManager{
		svc: svc,
	}
}

func (m *mockSSMClient) GetParameter(i *ssm.GetParameterInput) (*ssm.GetParameterOutput, error) {
    return &ssm.GetParameterOutput{Parameter: p}, nil
}
```

### spf13/cobra

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/spf13/cobra" data-iframely-url="//cdn.iframe.ly/htWhmVD"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

Go のコマンドラインツールを作るためのパッケージの1つ。競合として [urfave/cli](https://github.com/urfave/cli) や [mitchellh/cli](https://github.com/mitchellh/cli) もあるが、 cobra が現時点で最もスター数が多く、用例も多いのかなと勝手に思っている。作成者が Docker, Google, MongoDB あたりに関わっているゲキヤバな人であることもあってか、 [kubectl](https://kubernetes.io/docs/reference/kubectl/) や [Istio](https://istio.io/) などでも使われている。

使ってみた感想としてはなんでも出来る、そしてサクッと書ける良いツールではあった。が、サブコマンドのテストが書きづらい。というのも、以下のように　`&cobra.Command` で変数として定義する方式を取るから。

```go
var versionCmd = &cobra.Command{
  Use:   "version",
  Short: "Print the version number of Hugo",
  Long:  `All software has versions. This is Hugo's`,
  Run: func(cmd *cobra.Command, args []string) {
    fmt.Println("Hugo Static Site Generator v0.9 -- HEAD")
  },
}

func init() {
  rootCmd.AddCommand(versionCmd)
}
```

この点を気にする人は多いようで、検索するとワークアラウンドはいろいろと出てくる。

* [Testing a Cobra CLI in Go - Brad Cypert](https://www.bradcypert.com/testing-a-cobra-cli-in-go/)
* [Cobra の使い方とテスト — プログラミング言語 Go | text.Baldanders.info](https://text.baldanders.info/golang/using-and-testing-cobra/)
* [go - Cobra + Viper Golang How to test subcommands? - Stack Overflow](https://stackoverflow.com/questions/35827147/cobra-viper-golang-how-to-test-subcommands)

またコードを見るとわかる通り、サブコマンドが `error` を「戻さない」のも感覚的に慣れなかった。 `cobra.Command.Run` ではなく `cobra.Command.RunE` を使うと `error` を戻せるのだが、試しに戻したところ勝手に Usage をまるっと出力されてしまって、出力しないようにするにはどうしたらいいのか探すのが面倒になって諦めた。なんでも出来るツールはその分内部がブラックボックスにはなりやすいわけで、個人的には薄い実装のほうが好みなのだと思う。

### GitHub Actions

Pull Request を発行したときの `golint` やテストの実行と、 tag を切ったときのバイナリ生成と GitHub Release への添付を GitHub Actions で書いている。初めて書いてみたけど正直まだ感覚がつかめていない。このブログを生成する hugo の実行を今 CircleCI にまかせているので、それを GitHub Actions へ移すときにもう一度学んでみて記事にしようと思っている。

GitHub Release へのバイナリ添付には [goreleaser](https://github.com/goreleaser/goreleaser) を使った。すでに GitHub Actions で使うための Action を公開してくれているので、めちゃくちゃ便利に扱えて感動した。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/marketplace/actions/goreleaser-action" data-iframely-url="//cdn.iframe.ly/ETQo0Jh"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

