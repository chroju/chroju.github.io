+++
title = "ブログを Next.js + Vercel に移行した"
date = "2021-01-02T10:19:59+0900"
draft = false
+++

ということで、 feed を購読していただいていた方は `https://chroju.dev/feed.xml` に購読先を変更いただけますと幸いです。移行前のブログが `https://chroju.github.io` 、移行後のブログが `https://chroju.dev/blog` です。この記事までは双方に並行で上げていますが、今月中に以下の移行措置を行う予定でいます。

* 移行前ブログから、移行後ブログへのリダイレクトを設定
* 移行前ブログでの更新は停止
* 移行前ブログの feed 更新も停止

## なぜ Next.js なのか

今回の移行理由は「 [Next.js](https://nextjs.org/) を使ってみたかったから」に尽きる。

僕はインフラエンジニア出身の SRE で、経歴を辿るとサーバーや RDB のチューニングでパフォーマンスを維持することには注力してきたけど、フロント側の知識はほぼまったくと言っていいほどない。でも SRE がサイトの信頼性、具体的にはレスポンスの最適化に責務を負っているのに、フロントを理解していないというのはダメだろうと。静的なものを可能な限り CDN に置く時代において、サーバーのインフラ的なチューニングだけの知識だけでは心許なくなった。

Next.js を選んだのは、昨年後半あたりにその名を周りのフロントエンジニアから聞くことが多くなってきたのが直接的な契機だった。 Next.js は、かつて ZEIT という名前だった Vercel が提供している React.js のフレームワーク。 Vercel 自身が Next.js をデプロイできるプラットフォームを運営していて、 Next.js のコードを置いたレポジトリを連携するだけで、簡単にサイトをビルド、公開できる。

実は React.js + Netlify という組み合わせは昨年少し試してみていたこともあり、 React の知識を応用できそうで入門しやすいかなと感じた。また Server Side Rendering と Static Site Generator 双方の機能を持っているし、開発元の Vercel でデプロイすると、自動的に「サーバーサイド」（実体は AWS Lambda だが）まで構築してくれるというところに面白さを感じた。コンテナやサーバーありきのアーキテクチャの考え方から脱したかったんですよね。ついサーバー側を中心としてサービスを捉えちゃうんだけど、 Next.js だとはじめに javascript ありきで、そこから必要なサーバーサイド側のリソースが生成される形になっている。

ブログは4年間ほど hugo + github.io を使って運営していた。 Next.js を試せれば、対象はなんでもよかったんだけど、どうせなら長くサンドボックスとして使えるようにしようと、 hugo から移行を決めた。 hugo には大きな不満を覚えていたわけではないが、正直裏側をちゃんと理解していなくて、たまに手が届かない部分があったりしたので、フルスクラッチで自分でコード書いてブログ作るってのはありなんじゃない？と思った。

## 技術背景

フルスクラッチでコードを書く羽目になるのを覚悟していたのだが、実際のところは [Create a Next.js App | Learn Next.js](https://nextjs.org/learn/basics/create-nextjs-app) という公式のチュートリアルがズバリ「markdown から ssg でブログを生成するサイト」を作る内容になっていたので、このチュートリアルを完走して出来上がったコードを少し改変するだけでこのブログは出来上がってしまっている。このチュートリアル、かなり親切な内容になっていてわかりやすかったのでおすすめ。

自分で改変した部分で特筆するものとしては、以下の通り。

### RSS の追加

[RSS Feeds in a nextjs site | Logan's Blog](https://logana.dev/blog/rss-feeds-in-a-nextjs-site) を参考とした。 RSS の XML を生成できる [rss - npm](https://www.npmjs.com/package/rss) を使用しており、 npm build 時に一緒に XML も生成している。

<a href="https://gyazo.com/fee34366b43ebac65a962cfc420b3ea7"><img src="https://i.gyazo.com/fee34366b43ebac65a962cfc420b3ea7.png" alt="Image from Gyazo" width="632"/></a>

トラブルとしては、どうも markdown の中に制御文字が紛れてしまっていたようで、上図のように XML にエラーがあるとブラウザから警告が出てしまった。このブラウザ側の警告、 line と column の位置にズレがあるのか、デバッグに苦労した。 W3C が [W3C Feed Validation Service, for Atom and RSS](https://validator.w3.org/feed/) という feed xml の validator を公開していて、こちらを使ったほうがデバッグしやすかった。

### OGP 画像の動的生成

実は Vercel　が [https://og-image.now.sh/](https://og-image.now.sh/) という、 OGP 画像の動的生成サービスを保有している。先のチュートリアルの中では、これを使って OGP 画像を link タグに設定する手順まで含まれている。だが1つ問題があって、このサービスでは日本語のフォントに対応しておらず、日本語のページタイトルだと文字化けしてしまう。

解決策としては、このサービスは OSS で [vercel/og-image: Open Graph Image as a Service - generate cards for Twitter, Facebook, Slack, etc](https://github.com/vercel/og-image) に公開されていて、おまけに Vercel へデプロイ可能になっているので、これを fork して書き換えて自前で運営しちゃえばいい。 [こんな感じ](https://github.com/chroju/og-image/commit/7dda4b605b3b3d8a4d0deace2d03745797c7b6be) で Google Font から Kosugi を import している。また Vercel の無料プランだとメモリは 1024 MB 以下、リージョンは1箇所しか使えないので、そのあたり vercel.json も書き換えてやる必要がある。

チュートリアルでは OGP 最低限の設定しか成されないので、 [The Open Graph protocol](https://ogp.me/) を参考にいくつか追加している。

### Syntax highlight の導入

[Prism](https://prismjs.com/) を使っている。 [highlight.js](https://highlightjs.org/) と迷ったのだが、 Prism のほうが導入が簡単そうかなぁ、という素人の感想。 `useEffect()` で読み込むだけだったので。

Prism はハイライト対象の言語が選択式になっていて、必要なものだけ import して使う形になる。これについては [mAAdhaTTah/babel-plugin-prismjs: A babel plugin to use PrismJS with standard bundlers.](https://github.com/mAAdhaTTah/babel-plugin-prismjs) を使わせてもらった。 Prism の対応言語のみならず、プラグインやテーマも一括して babel で管理できて便利。

```json
{
    "presets": [
        "next/babel"
    ],
    "plugins": [
        [
            "prismjs",
            {
                "languages": [
                    "javascript",
                    "css",
                    "bash",
                    "diff",
                    "docker",
                    "go",
                    "hcl",
                    "json",
                    "markdown",
                    "nginx",
                    "python",
                    "ruby",
                    "typescript",
                    "vim",
                    "yaml"
                ],
                "plugins": [
                    "line-numbers"
                ],
                "theme": "tomorrow",
                "css": true
            }
        ]
    ]
}
```

### ifamely 対応

外部サイトをリンクする際に、ブログカードと言うのだろうか、 OGP から情報を持ってきて見栄えよい表示を実現するのに [ifamely](https://iframely.com/) というサービスを使っている。こういうやつ。

<a href="https://gyazo.com/688003d1a9d81829312ef7c8f3e9f06a"><img src="https://i.gyazo.com/688003d1a9d81829312ef7c8f3e9f06a.png" alt="Image from Gyazo" width="644"/></a>

これが上手く表示できなかった。原因としては、 markdown から生成した HTML を `dangerouslysetinnerhtml` に渡してレンダリングしているのだが、この関数が `dangerously set` と危険性の認識を示しているように、 XSS を防ぐ目的で、渡された script タグを実行しないようにしていること。 ifamely は外部 script の実行が必要になっている。

対処としては [How to inject scripts using dangerouslysetinnerhtml on Client-Side Rendering? | by SunCommander | Medium](https://medium.com/@suncommander/how-to-inject-scripts-using-dangerouslysetinnerhtml-on-client-side-rendering-973037cc06b7) を参考に、 [nfl/react-helmet](https://github.com/nfl/react-helmet) を使って別途必要な script だけ読み込んでいる。ただやり方的にちょっとダーティーだなという気はしている。

### その他

細かくいろいろやっている。

* front matter の扱いが適当で統一されていなかったので YAML で統一した
* fontawesome を導入した
* CSS をちょっと書いた

## 今後

CSS はあんまりこだわりたくないのだが、もう少しだけ頑張る必要がありそう。 `blockquote` だけ表示がおかしい状態になっている。

それ以外は一応動く状態になっているし、明らかに移行前よりレスポンスが良くなった。が、 lighthouse によるとまだまだ全然なので、折りを見て少しずつ良くしていきたいなあと思っている。今更だけど Web の標準に強くなっていきたい。

あと Next.js は概念的にはコンポーネントと props さえわかっていれば OK という感じで飲み込めたのだが、そもそも ES2015 ちゃんとわかってないとか、チュートリアルでは js だったけど TypeScript で書き直してみたいなぁ、などということも考えている。

<a href="https://gyazo.com/a593ac2e3b804f319b56c80a687f3c9b"><img src="https://i.gyazo.com/a593ac2e3b804f319b56c80a687f3c9b.png" alt="Image from Gyazo" width="983"/></a>

