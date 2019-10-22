+++
date = "2016-02-18T20:51:20+09:00"
description = ""
tags = ["blog"]
title = "ブログをHugoに移行した"

+++

すでに流行りは一巡しているような気もするが、Hugoを導入してみた。もともと自宅iMacにOctopressを置いてブログ作業はしていたのだが、外でもブログ更新ぐらいできた方がいいなぁと考え、クラウド上の開発用端末にレポジトリ移しちゃおうということになり、じゃあついでだからと移行してみた。Go自体は最近使っているオープンソースがそれであったという試しがあり、すでに導入は終えていた（ただし書けない）。

随所で語られているように移行自体は大したものではなく、Markdownでいずれも互換性があるし、Front MatterもYAML形式であれば同一。Hugoレポジトリの`content/post`配下に記事ファイルを突っ込めば移行としてはおしまい。多少の差異については以下の記事が詳しい。

[OctopressからHugoへ移行した | SOTA](http://deeeet.com/writing/2014/12/25/hugo/)

ただ自分の場合はパーマリンクを前ブログから保てていない。というのも、Octopressで使っていた記事ファイル名が`YYYY-MM-DD-foobar.markdown`の形だったのに対し、今回は記事のパーマリンクを`config.toml`で以下のように設定してしまっている。

```toml
[permalinks]
    post = "/blog/:year/:month/:day/:filename/"
```

従って`/blog/YYYY/MM/DD/YYYY-MM-DD-foobar/`という歪なパーマリンクになってしまっている記事がいくつかある。ほとんどの記事は`foobar.markdown`に直したのだが、はてなブログ時代から移植した記事は`YYYY-MM-DD-post.markdown`という適当なパーマリンクにしていたので、一括して直すことができなかった。時間を見てこれらも意味のあるURLに直すつもり。

記事を公開する流れは以下のようになる。

```bash
# 記事作成
$ hugo new post/title.md
$ vi content/post/title.md
# ビルド
$ hugo
# commit
$ cd public
$ git add .
$ git commit -m "new post"
$ git push origin master
```

`hugo`コマンドでビルドすると`public`フォルダにサイト構成全体が吐かれるので、それをそのまま`git push`して終わり。ただ実際にバージョン管理したいのは`public`というより、設定ファイルや元のMarkdownが詰まったHugoのレポジトリ全体ではないかという気もするので、後々以下の記事のようにレポジトリ全体で`git push`してCIでビルドさせる形に変えたいと思う。

[HugoとCircleCIでGitHub PagesにBlogを公開してみた - Hori Blog](http://hori-ryota.com/blog/create-blog-with-hugo-and-circleci/)

なおテーマはとても悩みどころで、しばらくコロコロ変わるかもしれない。というか自分でカスタマイズしたいけどCSSなんて今更書けるのか。。。

## （追記 2016-02-22 23:50）

フィードのファイルパスがデフォルトだと`index.xml`になってしまうので、Octopressから変更がないよう`atom.xml`に直した。`config.toml`で指定ができる。

```toml
rssuri = "atom.xml"
```

参考：[What is {{ .RSSlink }}, exactly? - support - Hugo Discussion](https://discuss.gohugo.io/t/what-is-rsslink-exactly/1195/2)

## その他参考記事

* [HUGOを使ってサイトを立ち上げる方法 - Qiita](http://qiita.com/syui/items/869538099551f24acbbf)
* [Hugo - Hosting on GitHub Pages](https://gohugo.io/tutorials/github-pages-blog/)
