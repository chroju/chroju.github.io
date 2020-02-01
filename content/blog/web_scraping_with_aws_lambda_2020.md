+++
title = "AWS Lambda による Web Scraping プラクティス in 2020"
date = 2020-02-01T14:24:52+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

久しぶりに AWS Lambda 上でスクレイピング処理を実装しようとしたところ、 PhantomJS 開発終了以来あんまりスクレイピングしていなかったこともあり、勝手がまったくわからなくなっており、いろいろ調べたので書いておく。

なお、あくまでデータ取得のための簡単なスクレイピングであり、 E2E テストのような複雑なシナリオが想定される用途でも適用可能なプラクティスではないと思われる。また筆者が使いたい言語は第一に Go で第二が Python である。

## スクレイピング用ライブラリは主に2種類

スクレイピングに活用できるライブラリは各言語様々あると思われるが、ざっくり2種類に大別できると考えている。

* 直接 HTTP アクセスするライブラリ
* Headless ブラウザを使うライブラリ

外部のツールに依存せず、ライブラリの機能だけで HTTP アクセスや DOM の解析を行うものが前者。そのライブラリさえ import すれば使うことができるので、基本的にはこの手のものを使うほうが楽だと思われる。ただしブラウザの機能を再現しているわけではなく、生の HTML をそのままダウンロードするだけなので、凝ったことはできない可能性がある。

凝ったこととはなんぞと言えば、例えばブラウザ表示した画面のスクリーンショットを撮りたい、 JS で動的に DOM 生成されるページをうんにゃらしたい、といった場合がある。こういった用途では Headless ブラウザを使うことになる。

## 直接 HTTP アクセスするライブラリ

個人的には [PuerkitoBio/goquery](https://github.com/PuerkitoBio/goquery) を使うことが多い。 README から例を抜粋するが、 CSS クラスタの記法で取得する要素を指定できるのが好き。

```go
  // Find the review items
  doc.Find(".sidebar-reviews article .content-block").Each(func(i int, s *goquery.Selection) {
    // For each item found, get the band and title
    band := s.Find("a").Text()
    title := s.Find("i").Text()
    fmt.Printf("Review %d: %s - %s\n", i, band, title)
  })
```

ライブラリを import すればいいだけなので、ビルドなども特別なことはない。

## Headless ブラウザを使うライブラリ

Headless ブラウザを操作するフレームワークとしては [Selenium](https://selenium.dev/) が有名。各種メジャーな言語で実装があるのだが、残念ながら Go に対応した公式のパッケージは提供されていない。そのため Python で使うことにしている。

Selenium を使うときはライブラリのインポートだけではなく、実際にウェブアクセスするための Headless ブラウザと、 Selenium がブラウザ操作するための [WebDriver](https://www.w3.org/TR/webdriver/) も Lambda のデプロイパッケージに含める必要がある。

### Headless ブラウザと WebDriver

Headless Chrome を使いたいところなのだが、そのまま AWS Lambda のランタイム上で使えるわけではない。各種 FaaS ランタイム向けに Headless Chromium をビルドした serverless-chrome というプロジェクトがあるので、これを使わせてもらう。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/adieuadieu/serverless-chrome" data-iframely-url="//cdn.iframe.ly/J2IgAjY"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

WebDriver には Chrome (Chromium) 向けの ChromeDriver を [Downloads - ChromeDriver - WebDriver for Chrome](https://chromedriver.chromium.org/downloads) からダウンロードして使う。

注意しなければならないのは、 Selenium, serverless-chrome, ChromeDriver の三者で compatible な version の組み合わせが決まっているということ。任意のバージョンを好きに組み合わせて動くわけではない。現状 serverless-chrome のドキュメントがこれをアップデートしきれていないようで、以下の issue に有志が稼働確認した組み合わせを書き込んでいるのが見受けられるので参考にしている。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/adieuadieu/serverless-chrome/issues/133" data-iframely-url="//cdn.iframe.ly/ycgUfPu"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

本記事執筆時点において、最新の serverless-chrome を使った Selenium for Python との compatible な組み合わせが検証済みになっていない。そのため新し目の API が使えない、ということがしばしばある。例えば自分が経験したものとしては、 `element.screenshot_as_png()` が利用できず、要素単位でのスクリーンショットが取得できなかった。代替策として、 [Can't get the screenshot of the current element · Issue #2898 · SeleniumHQ/selenium](https://github.com/SeleniumHQ/selenium/issues/2898) に記載のある、要素の座標から PIL でページスクリーンショットを切り取る方式を使っている。

### Lambda layer を使った Headless ブラウザ等のデプロイ

Lambda にはデプロイパッケージサイズに 50 MB の制限があるので、 Headless ブラウザと chromedriver は Lambda layer を用いてデプロイし、 Function 本体のデプロイパッケージから分離する。

Lambda layer にデプロイしたファイルは、 Lambda 実行時に `/opt` 配下に展開されるので、それに合わせて Selenium からパスを指定して読み込む。自分の場合は以下の Makefile で Lambda layer 向けの zip パッケージを作成しているが、この場合は `/opt/bin` 配下に `chromedriver` と `chromium` が配置されることになる。

```make
layer_headless_chrome/bin:
	mkdir -p layer_headless_chrome/bin

layer_headless_chrome/bin/headless-chromium: layer_headless_chrome/bin
	wget https://github.com/adieuadieu/serverless-chrome/releases/download/v1.0.0-37/stable-headless-chromium-amazonlinux-2017-03.zip -O chromium.zip
	unzip chromium.zip
	mv headless-chromium layer_headless_chrome/bin/
	rm chromium.zip

layer_headless_chrome/bin/chromedriver: layer_headless_chrome/bin
	wget https://chromedriver.storage.googleapis.com/2.37/chromedriver_linux64.zip -O chromedriver.zip
	unzip chromedriver.zip
	mv chromedriver layer_headless_chrome/bin/
	rm chromedriver.zip
```

Selenium を使うときは、割愛した書き方をするとこういう感じ。

```python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

options = Options()
options.binary_location = "/opt/bin/chromium"
driver = webdriver.Chrome(chrome_options=options, executable_path="/opt/bin/chromedriver")
```

### 日本語フォントの内包

特にスクリーンショットを撮りたい場合、 Lambda のランタイムには日本語フォントが存在しないため、デプロイパッケージに含めてやらなければ文字化けする。

これはそう面倒な問題でもなく、通常 Linux では `$HOME/.fonts` にフォントファイルを置けば読んでくれるので、デプロイパッケージを zip するときに `.fonts` 配下へ使いたいフォントファイルを置いておけばよい。僕は IPA フォントを使っているので、 Makefile だとこういう感じ。

```make
.fonts:
	mkdir .fonts

.fonts/ipaexg.ttf .fonts/ipaexm.ttf: .fonts
	curl https://ipafont.ipa.go.jp/IPAexfont/IPAexfont00401.zip -o IPAexfont.zip
	unzip IPAexfont.zip
	mv ./IPAexfont00401/*.ttf ./.fonts/
	rm -rf ./IPAexfont00401
	rm IPAexfont.zip
```

### Serverless Framework によるデプロイ

Lambda layer と Function を個別にデプロイするのは面倒なので、 Serverless Framework を遣う。先に書いた Makefile の例に倣い、 `./layer_headless_chrome` 配下に Headless ブラウザと chromedriver が置かれているものとして、以下のようなサンプルになる。

```yaml
functions:
  sample_function:
    handler: sample_function.lambda_handler
    layers:
        - { Ref: HeadlessChromeLambdaLayer }
    role: LambdaBasicExecution
    package:
      include:
        - '.fonts/**'

layers:
  headlessChrome:
	path: layer_headless_chrome
```
