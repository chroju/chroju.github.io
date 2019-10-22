+++
title = "Ansible Roleの継続的自動UpdateについてLTした"
date = 2018-04-28T10:32:32+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

<a href="https://gyazo.com/510241fc62c4497af3a35142fe5ca5ed"><img src="https://i.gyazo.com/510241fc62c4497af3a35142fe5ca5ed.png" alt="https://gyazo.com/510241fc62c4497af3a35142fe5ca5ed" width="600"/></a>

5分間のLTしてこんなクールなタンブラーが貰えるなんて、RedHat社は素晴らしい会社だと思います。ちょっとびっくりした。

[Ansible Night in Tokyo 2018.04](https://ansible-users.connpass.com/event/84907/)でLTをしてきた。なんだか最近inputもoutputもパッとしてない感じがしたので、「そうだ！　LTしよう！！！」とほぼ思いつきで。自身3回目なんだけど、RedHatでAnsibleの話をするってのはちょっと日和った。TL見る限りだと好評っぽかったのでありがたい限りでした。

<script async class="speakerdeck-embed" data-id="911e623710df4b10bd00ef7509d53574" data-ratio="1.37081659973226" src="//speakerdeck.com/assets/embed.js"></script>

テーマはAnsible Roleの継続的自動更新。Ansibleにはプログラムのパッケージ（RubyGemsとかpipとか）みたいな感じで、Ansible Roleという単位にコードをまとめて再利用する仕組みがある。自分もよく使うのだけど、このRoleに更新をかけたとき、それをimportしている各Playbook上で、バージョンの追随をするのが結構面倒で、みんなどうしてんだろうという思いもあり話してみた。

この手の話はRuby界隈でも「定期的なbundle updateをいかに実行するか」という話がよく聞かれたり、ソフトウェア開発分野でもポピュラーな課題っぽかったので、そちらをいろいろ参考にした。結果としてCIで回しましょうという、まぁそうだよねという結論に至っている。

難題は実装部分で、RubyGemsであれば `bundle outdated` という最新ではないgemを出力するコマンドがあったりするんだけど、Ansible Roleを管理する `ansible-galaxy` コマンドには「更新を確認する」ための機能はない。なので少し変則的なのだが、

```yaml:requirements.lock.yml
- src: hoge.fuga
  version: 1.0.0
```

という、入れたいバージョンをロックしたrequirements.lock.ymlと、

```yaml:requirements.yml
- src: hoge.fuga
```

というバージョンを記述していないrequirements.ymlを用意することにした。 `ansible-galaxy install` はバージョン指定無しで実行すると最新を引っ張ってくるので、前者と後者で入るRoleのバージョンに差異があれば「更新あり」と判断できるようになる、という話。明らかにワークアラウンド、という感じなので、他にもっとスマートなやり方をしている人がいれば教えてほしいところ。これに限らずなのだが、Infrastructure as Codeにソフトウェア開発のプラクティスを適用できる、というのはその通りなのだけど、それが実際どう実装するべきなのだという情報をもっと知りたい。

ちなみにLTは1年以上ぶりだったし経験ほとんどないので、上のスライド見て分かる通り明らかに詰め込みすぎで、思いっきり時間オーバーするしアレでした。しかしフィードバックも貰いやすいし、他の人のLTも参考になるし、もっとやっていきたいですね。
