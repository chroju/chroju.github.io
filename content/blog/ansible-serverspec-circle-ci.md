+++
categories = "ansible Serverspec docker 'circle ci'"
comments = true
date = "2015-11-18T00:00:00+09:00"
title = "Ansible + Serverspec + Docker + circle ci によるインフラCI"

+++

[CircleCIでDockerコンテナに対してansibleを実行しserverspecでテストをする - さよならインターネット](http://blog.kenjiskywalker.org/blog/2014/11/13/circleci-docker-ansible-serverspec/)

この記事に書かれている内容を実際にやってみた。Ansibleを一旦は触ってみたところから、Circle.CIどころかCI経験が一切ない、ServerspecとDockerも使ったことがないという出発点だったので、得られるものはだいぶ大きい経験だった。完了したレポジトリは以下。

[chroju/ansible-ruby-devs](https://github.com/chroju/ansible-ruby-devs)


Ansibleにテストは必要か？
====================
AnsibleはPlaybookに書かれた設定通りにサーバーをセッティングしてくれるツールなのだから、傍証としてのテストは必要ないし、そもそもそれはAnsibleに対する信頼の問題だという話がある。（かのオライリーのServerspec本でも「Serverspecの必要性」を状況に応じて説明した章がある）が、自分は以下の理由からAnsible実行後のテストは必要と考えている。

1. Playbookの書き方が間違っている
----------
確かにPlaybookに書いた内容通りにサーバーは組まれるのだが、そもそもPlaybookの書き方がおかしくて、想定通りの実行結果にならない可能性はある。そのレベルであればコードレビューで気付くべきではないかという話もあるが、こういう趣味の個人開発では難しかったり、レビューで漏れがあったりというのも有り得るわけで、自動テストに任せられるならその方が確かかとは思う。

2. 冪等性の問題
----------
特にshellモジュールを用いたときなどは冪等性が維持されない可能性があり、複数回の実行で想定外のサーバー状態になる可能性はある。


テストツールの選定
====================
普通にServerspec。Ansibleで定義したインベントリファイルやrolesをServerspecと共有してくれる[ansible_spec](http://qiita.com/volanja/items/5e97432d6b231dbb31c1)というツールもあり、当初はこちらを使おうとしていた。が、前述した「Ansibleの書き方自体が間違っている可能性」をテストするとなると、できるだけAnsibleとテストツールは疎結合とするべきと考え、ファイルや設定は一切共有しない形でServerspecを使っている。


Circle CIの利用
====================
繰り返しになるが初である。インフラエンジニアがCIをすることはまぁない（なかった）。そんな頻繁に設定を変えるわけでもなし。インフラCIが可能かつ必要となったのは、Infrastructure as Codeの台頭と、クラウドネイティブ化によりImmutableかつ極めて速いライフサイクルでサーバーインフラが更新されるようになったことによるもの。

で、Circle CIでググってもそんなに使い方みたいな初歩的な記事は出ない。どうもCIツールの使い方なんてのはJenkins登場の頃に身につけてて当然だろって感じの扱いっぽい。実際使いながら自分なりに理解したのは「レポジトリをpushすると、それを使って自動的にテストやデプロイを回してくれる」ツールということで、Circle CIについてはこんな感じに認識してるんだがあってんのかなぁ。

* レポジトリの使用言語やファイル構成を見て良きに計らって勝手にテストしてくれる。
* もちろん自分でテストコマンドを書いてもOKで、Circle CIにやってほしいことは `circle.yml` というYAMLファイルに書いてレポジトリの第一階層に置いておく。
* GitHub連携を前提としており、連携したレポジトリの `push` をトリガーとして動作する。
* 動作としてはCircle CI上でDockerコンテナ（ubuntuベース）を起動→レポジトリを `git clone` →circle.ymlを読んで実行


実装
====================
実際のcircle.ymlはこうなった（といってもほぼ丸のまま冒頭記事のものを使っているが）。Dockerイメージのキャッシュには以下の記事も参考にした。

[CircleCIでDockerイメージをキャッシュするのに、実はちょっとした工夫が必要な件 - tehepero note(・ω<)](http://stormcat.hatenablog.com/entry/2015/02/04/004227)


```yaml
machine:
  timezone:
    Asia/Tokyo
  services:
    - docker

dependencies:
  pre:
    - if [[ -e ~/docker/docker_ansible_image.tar ]]; then docker load --input ~/docker/docker_ansible_image.tar ; else docker build -t centos_ansible ~/ansible-ruby-devs/ ; mkdir -p ~/docker ; docker save -o ~/docker/docker_ansible_image.tar centos_ansible ; fi

  cache_directories:
    - "~/docker"

test:
  override:
    - docker run -v `pwd`/ansible:/ansible centos_ansible /bin/sh -c 'ansible-playbook /ansible/ci_site.yml -i /ansible/ci_hosts -c local && cd /ansible/spec && /home/develop/.rbenv/bin/rbenv exec bundle install && /home/develop/.rbenv/bin/rbenv exec bundle exec rake spec'
```

この方法の肝はAnsibleとServerspecのフォルダを`docker run`の`-v`オプションでコンテナにマウントさせてしまって、ローカルでいずれも実行させている点だと思う。Dockerコンテナに対してSSHで外から処理を行うことももちろん可能ではあるが、ちょこちょこと小細工は必要だし、CI上の処理であればミニマムに済ませたいところ。

テストにおいてはインベントリファイルも`site.yml`もテスト用の設定値となるので、CI用のファイルを置いている。ただ、これらはレポジトリにとっては余分なファイルでしかないので、本来であれば取り除きたいような気もする。妙案は浮かばない。Dockerコンテナは2回目以降の実行だと`load`するだけで済むし、AnsibleとServerspecはローカル実行なので、処理時間はだいぶ速い。

実行結果はslackの個人チャンネルに流している。GtiHubに上げるだけで勝手にテストして結果も自動通知されるというのはとても楽しい。やれることの自由度が広すぎて夢が広がる。


つまずいた点
====================
* Dockerfile初挑戦につき、結構戸惑った。Ansibleでsshd_configを編集させていたのだが、コンテナにそもそもsshが入ってなくてコケたりした。
* Circle CIでのカレントディレクトリの扱いがわからず、しばらく `circle.yml` で指定するファイルパスに悩まされた。クローンしたレポジトリの中にいる状態で始まるっぽい？
* `docker run` に `&&` 付きでコマンド渡すときに `/bin/sh -c` が必要だとしばらく気付かなかった。
* Dockerコンテナを `save` して `load` してるので、Dockerfile書き換えたら当然ながらCircle CIを「without cache」で実行しないとダメです。
