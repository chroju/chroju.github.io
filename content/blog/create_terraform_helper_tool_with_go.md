+++
title = "Terraformドキュメントをコマンドで見るツールをGoで作る"
date = 2018-03-25T22:56:51+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

クラウドサービスのリソース管理をコード化できるTerraform、とても便利に使っているけれど、リソースの種類によって当然ながら書くべき内容が異なりなかなかスムーズに書くことができない。

[Provider: AWS - Terraform by HashiCorp](https://www.terraform.io/docs/providers/aws/index.html)

例えば自分がよく使うAWSだけでも、このリンク先に書かれているだけのリソースの種類、書き方がある。そして機能やサービスが増えるごとに、リソースの書き方もどんどん多様化していく。今はこれをいちいちウェブ上で書き方を確認しながらTerraformを書いているんだけど、ちょっと手間が多いなという気がしてきた。

同様にInfrastructure as CodeのツールであるAnsibleには、ansible-docというコマンドがあって、ドキュメントをコマンドライン上で見ることができるようになっている。

```
$ ansible-doc file
> FILE    (/usr/local/Cellar/ansible/2.5.0/libexec/lib/python2.7/site-packages/ansible/modules/files/file.py)

        Sets attributes of files, symlinks, and directories, or removes files/symlinks/directories. Many other modules support the same options as the `file'
        module - including [copy], [template], and [assemble]. For Windows targets, use the [win_file] module instead.

OPTIONS (= is mandatory):

- attributes
        Attributes the file or directory should have. To get supported flags look at the man page for `chattr' on the target system. This string should contain
        the attributes in the same order as the one displayed by `lsattr'.
        (Aliases: attr)[Default: None]
        version_added: 2.3

- follow
        This flag indicates that filesystem links, if they exist, should be followed.
        Previous to Ansible 2.5, this was `no' by default.
        [Default: yes]
        type: bool
        version_added: 1.8
...
```

これに類似したものがTerraformにあれば、ブラウザとターミナルを行き来する必要がなくなる。でも探した限りそういうツールはなさそうだったので、自分で作ることにした。

## tfdoc

[chroju/tfdoc](https://github.com/chroju/tfdoc)

まだ全然作り始めたばかりだけど、とりあえずリソース名を指定して実行すると、スニペットを吐き出すところまでは出来た。こんな感じで出力される。

```
$ tfdoc aws_iam_user
resource "aws_iam_user" "sample" {

  // (Required) The user's name. The name must consist of upper and lowercase alphanumeric characters with no spaces. You can also include any of the following characters: =,.@-_.. User names are not distinguished by case. For example, you cannot create users named both "TESTUSER" and "testuser".
  name = ""

  // (Optional, default "/") Path in which to create the user.
  path = ""

  // (Optional, default false) When destroying this user, destroy even if ithas non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroya user with non-Terraform-managed access keys and login profile will fail to be destroyed.
  force_destroy = ""
}
```

Terraformのドキュメントはウェブで公開されているHTML以外の形式がなさそうだったので、そこからスクレイピングして整形して吐くだけの簡単な実装になっている。とはいえ案外こういうきちんとしたサイトでも、書式が揃っていないところがあったりして、やっぱりスクレイピングはしんどいなぁという感じではあったのだけど。。

出力はスニペットだけじゃなくて、先に挙げたansible-docと同様にドキュメントの体裁でも行いたいので、そういう機能も少しばかり付けられたらなと思う。

## Go

tfdocを作るにあたっては、初めてGoを使った。まだ勉強中なのでちゃんと使えると言える段階には無い（ソース見ればわかると思うが）けど、tfdocを作る中で習得していきたい感じ。

Goを選んだのにはいくつか理由があるけれど、クロスコンパイルが出来て様々な環境に合わせたバイナリが生成出来たり、それでいて文法的な難易度が高くはない（という評判を聴いている）のが大きかった。

* [Go言語によるCLIツール開発とUNIX哲学について - ゆううきブログ](http://blog.yuuk.io/entry/go-cli-unix)
* [複数プラットフォームにGoアプリケーションを配布する | SOTA](https://deeeet.com/writing/2014/05/19/gox/)

今は仕事だと主にPythonでツールを書くことが多いのだけど、古いサーバーだとPython2が入っていたりpipが無かったり、環境依存が大きくて困ることが多い。バイナリを置けばインストールが終わるというのは非常に助かる。

難易度の話は、ほぼLLしか経験のない自分にとってはポインタが少しハードルにはなったりして、サクッとすぐ書けるようになるというわけにはいかなかった。元々『Goならわかるシステムプログラミング』でGoの習得を考えていたものの、その点で一旦停まってしまっている。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4908686033/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/515xkIcDgXL._SL160_.jpg" alt="Goならわかるシステムプログラミング" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4908686033/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Goならわかるシステムプログラミング</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 18.03.25</div></div><div class="amazlet-detail">渋川よしき <br />Lambda Note <br />売り上げランキング: 32,638<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4908686033/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

その後に [Treasure 2017 の研修資料は Go を学ぶのに最高だった - kakakakakku blog](http://kakakakakku.hatenablog.com/entry/2017/10/16/081755) で言及されている、 VOYAGE GROUPが公開している [Go入門](https://go-talks.appspot.com/github.com/voyagegroup/talks/2017/treasure-go/intro.slide#1) をやってみて、改めて入口に立った。

レファレンスは [GoDoc](https://godoc.org/) があれば十分という話もあるが、1冊本で手元に置きたい気持ちもあったので、『プログラミング言語Go』を買ってみている。海外だと「Blue book」と呼ばれて、これがバイブル扱いされているっぽい。ただ、実際紐解くと本職インフラエンジニアのなんちゃってプログラマーには少しむずかしい。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4621300253/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/41BaAiMmrnL._SL160_.jpg" alt="プログラミング言語Go (ADDISON-WESLEY PROFESSIONAL COMPUTING SERIES)" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4621300253/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">プログラミング言語Go (ADDISON-WESLEY PROFESSIONAL COMPUTING SERIES)</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 18.03.25</div></div><div class="amazlet-detail">Alan A.A. Donovan Brian W. Kernighan <br />丸善出版 <br />売り上げランキング: 19,223<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4621300253/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

長らくブログもちゃんと更新できていなかったけど、何かを作りたいというモチベーションがあると勉強も進みやすいとわかってきたので、来月いっぱいぐらいはtfdocを形にすることを目指していきたい。TDDがやりやすい仕組みになっていたり、gofmtがコーディングを助けてくれたり、Goにはプログラミングの習得速度を加速してくれる機能が多い。これを進めることで得られるものが多そう。
