+++
title = "CircleCI 2.0でhugoのブログ生成を自動化する"
date = 2017-12-18T10:15:06+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

このブログは [hugo](https://gohugo.io/) で生成している。生成過程を自動化したくて、[CircleCI](https://circleci.com/)へ任せることにしようと思ったところ、そういえばCircleCI 2.0をまだ触っていないことに気付いたので、2.0で自動化した。

## 設定の書き方

1.0における`circle.yml`のように、設定ファイルを書いてそれに基づいた処理が行われるという点は変わらないものの、設定の書き方はガラッと変わって後方互換性は一切なくなっていた。

一応マイグレーションガイドがあるので、`circle.yml`からステップ踏んで移行できるようにはなってる。

* [Migrating from 1.0 to 2.0 - CircleCI](https://circleci.com/docs/2.0/migrating-from-1-2/)

### 実行タスク

1.0ではCircleCIがリポジトリの言語から実行タスクを自動判定していたので、設定の書き方は基本的に「デフォルトの実行内容と異なることをやりたければ `override` する」という形だった。2.0ではデフォルトタスクがなくなり、すべて自前で書く形になった。

正直、デフォルトのタスクをそのまま使うことはほとんどなかったので、すべて自前で書ける方が何も考えずに済んで楽になった。

### ジョブとワークフローという概念

タスクは1つの環境上で一気通貫に実行される形ではなくなり、実行したい内容を `Job` としてステップで分けて定義する形になった。 `Job` ごとに環境も分離されていて、それぞれDocker imageを定義して起動する。各言語で必要なimageは [CircleCIが用意している](https://circleci.com/docs/2.0/circleci-images/) が、それ以外のimageでももちろんよい。

`Job` をどの順番で実行するかは `Workflow` として定義する。テストのジョブが成功した場合のみデプロイのジョブを実行するなど、 `Job` 間の依存関係を定義することもできる。

### キャッシュの使い所

`Job` ごとにDockerコンテナが起動する都合上、コンテナ間で同じファイルを共有したい場合や、実行の度に同じファイルを使うようなときにはキャッシュを利用する。前者としては、 `git clone` したソースコードをどの `Job` でも使いまわすようなとき、後者としては、依存するライブラリのダウンロードなどが考えられる。

キャッシュはコンテナ内のどのディレクトリを、何という名前でキャッシュするか、という形で定義する。すでに同名のキャッシュが存在する場合は、それを上書きすることはないので、このあたりが設計上肝になる。

キャッシュ名には [変数 (Template)](https://circleci.com/docs/2.0/caching/#using-keys-and-templates) が使えて、この使い方で「いつキャッシュするか」をコントロールできる。`{{ checksum }}` を使うと特定ファイルのチェックサムがキャッシュ名に入るので、Gemfileなどを指定すれば、これに変更があったときだけキャッシュを上書き＝ライブラリの再ダウンロードが促せる。 `{{ epoch }}`を使えば実行時刻に応じたキャッシュ名となり、またキャッシュリストア時は最新の `epoch` が入ったキャッシュが選ばれるので、毎回ダウンロードし直すことになるソースコードのキャッシュに使える。

## 実装

実装を以下に置く。hugoなのでいわゆるソフトウェアのテストは回しておらず、 [textlint](https://github.com/textlint/textlint) で文章校正だけ行い、OKであれば build と deploy が走るようになっている。

textlintは当初全記事にかける形にしていたが、今までの記事ほとんどでNGが出てしまったので、「ブランチ名と一致するファイル名のmarkdown」にだけ実行する形にした。それでもデフォルトで使っていると結構厳しく感じるので、設定は改めたい。。

```yaml
version: 2

jobs:
  checkout_code:
    docker:
      - image: circleci/golang:1.8
    working_directory: ~/hugo
    steps:
      - checkout
      - save_cache:
          key: hugo-cache-{{ epoch }}
          paths:
            - ~/hugo

  textlint:
    docker:
      - image: circleci/node:9.2.0
    working_directory: ~/hugo/.circleci
    steps:
      - restore_cache:
          keys:
            - hugo-cache
            - hugo-nodemodules-{{ checksum "package.json" }}
      - run:
          command: |
            npm install
            npm run textlint "../content/blog/${CIRCLE_BRANCH}.md"
      - save_cache:
          key: hugo-nodemodules-{{ checksum "package.json" }}
          paths:
            - ~/hugo/.circleci/node_modules

  build:
    docker:
      - image: circleci/golang:1.8
    working_directory: ~/hugo
    steps:
      - restore_cache:
          key: hugo-cache
      - run:
          command: |
            git submodule sync
            git submodule update --init
            go get github.com/gohugoio/hugo
            git clone https://github.com/chroju/chroju.github.io public
            rm -rf public/*
            sudo cp /usr/share/zoneinfo/Japan /etc/localtime
            hugo
      - save_cache:
          key: hugo-cache-public-{{ epoch }}
          paths:
            - ~/hugo/public

  deploy:
    machine:
      enabled: true
    working_directory: ~/hugo/public
    steps:
      - restore_cache:
          key: hugo-cache-public
      - run:
          command: |
            git config --global user.name chroju
            git config --global user.email chor.chroju@gmail.com
            git add --all
            git commit -m "${CIRCLE_BRANCH} (Circle CI)"
            git push git@github.com:chroju/chroju.github.io

workflows:
  version: 2
  build_and_deploy:
    jobs:
      - checkout_code
      - textlint:
          filters:
            branches:
              ignore: master
          requires:
            - checkout_code
      - build:
          requires:
            - checkout_code
      - deploy:
          filters:
            branches:
              only: master
          requires:
            - textlint
            - build
```

## hugo theme の変更

余談にはなるけど、今回のCircleCI実装に合わせて、 hugo のテーマもcocoaというものに変更した。

[nishanths/cocoa-hugo-theme: Configurable, responsive blogging theme for Hugo](https://github.com/nishanths/cocoa-hugo-theme)

hugo のテーマ変更は初めてなのだけど、configの書き方がテーマによって少し違いがあり、そのまま移植という形にはできなかったのでちょっと時間がかかった。

