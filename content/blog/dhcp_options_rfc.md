+++
title = "AWS DHCP オプションセットを RFC から理解する"
date = 2019-09-11T21:34:11+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

AWS には DHCP オプションセットという仕組みがある。 DNS サーバーや NTP サーバーの IP アドレスをこれに設定し、 VPC と関連付けておくと、 DHCP の仕組みを使って EC2 インスタンスへ自動的に設定の配布を行なってくれる。

これまで特に不具合もなく使っていたのだが、 Ubuntu 18.04 を初めて使うにあたり、 DHCP オプションセットに設定できる `domain-name` をスペース区切りで複数指定したところ、スペースが「032」という文字列で置換された状態で設定されてしまい、 DNS が正常に機能しないという事象が起きた。以下は実際の設定ではないが、こういうイメージ。

```bash
$ cat /etc/resolv.conf
nameserver 127.0.0.53
options edns0
search ap-northeast-1.compute.internal032example.com
```

[DHCP オプションセットのドキュメント](https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/VPC_DHCP_Options.html) を見ると、たしかに `domain-name` の複数指定は「一部の Linux オペレーティングシステム」でしか動作しないとある。しかし「一部」と言われても、ディストリを替えたら動きませんでした、だとわりと困る（今回の場合は 16.04 なら複数指定が動作したが、 18.04 では NG だった）ので、そもそもなぜこの項目が「一部」の Linux ディストリでしか有効にならないのか、 DHCP オプションの仕様から調べ直してみた。

## DHCP Options を定義する RFC

そもそも DHCP Options とはなんぞ？という話だが、これは [RFC 2132](https://tools.ietf.org/html/rfc2132) で定義されている。

> Configuration parameters and other control information are carried in tagged data items that are stored in the 'options' field of the DHCP message. 

DHCP message の中には 'options' field が設けられており、ここに各種設定パラメータを載せることができる。 DHCP というと IP アドレスやデフォルトゲートウェイの配布というのが主な機能ではあるが、それ以外の様々な設定値がここに載ってくる。

DHCP Options はなんでも情報を載せられるわけではなく、何を載せられるのかが RFC 内で定義されており、それぞれのオプションを表す `Code` と呼ばれる整数値が割り当てられている。また 2132 以外の RFC で定義されている DHCP Options も存在している。以下は一例。

* [RFC 2241](https://tools.ietf.org/html/rfc2241) : DHCP Options for Novell Directory Services
* [RFC 3397](https://tools.ietf.org/html/rfc3397) : Dynamic Host Configuration Protocol (DHCP) Domain Search Option
* [RFC 4833](https://tools.ietf.org/html/rfc4833) : Timezone Options for DHCP

## AWS オプションセットと RFC

さて、それでは AWS オプションセットで設定可能な各値は、 RFC で言うとどのコードに当たるのかという話になる。結論から書くと以下の通りだった。Section というのは RFC2132 で記載のあるセクション番号を指す。

| Code | Section | Option name          |
|------|---------|----------------------|
|    6 |     3.8 | domain-name-servers  |
|   15 |    3.17 | domain-name          |
|   42 |     8.3 | ntp-servers          |
|   44 |     8.5 | netbios-name-servers |
|   46 |     8.7 | netbios-node-type    |

問題の domain-name は Code 15 に当たる。

>  This option specifies the domain name that client should use when resolving hostnames via the Domain Name System.
>  The code for this option is 15.  Its minimum length is 1.

記載の通り、想定されているのは単数形の "domain name" である。他の、例えば先の表にもある Code 6 のように、複数の値を取ることが想定されている場合は　"a list of ~" という書き方がされていることから考えても、 Code 15 のこの記載は、複数の値を想定していない。

AWS DHCP オプションセットにおいて、 `domain-names` にスペース区切りで複数のサフィックスを指定した場合、一部の Linux ディストリビューションによってはそのまま複数の値として扱われるのは言い方がよくないが「たまたま」ということになる。おそらくスペース区切りの文字列をそのまま resolv.conf に書き入れるような実装になっており、複数のサフィックスがそのまま適用されるということになる。一方で Ubuntu 18.04 などはスペースが "032" に書き換わる、これは ASCII printable characters において 32 がスペースなので、おそらくはそのような変換が噛まされているのだと思われる。

## 対処

以上のように RFC 上そうなっているから、というのが冒頭の「不具合」の理由になるため、対処はしようがない。そもそもドキュメントに注意書きがされているのだし、 16.04 で複数指定できていたのがむしろラッキーだったんだろう。 DHCP に頼らず別の方法で設定するしかない。

望むらくは `domain-names` の実装を AWS に変更してもらえないものかなとは思う。 domain name を複数指定できる DHCP Option は実は別にあって、 RFC3397 に載っている [Code 119](https://tools.ietf.org/html/rfc3397#section-2) がそれに当たる。こちらを採用してもらえれば、憂いなく domain name の複数指定が実現できるようになる。

## 余談

ちなみに冒頭に載せた Ubuntu 18.04 と DHCP オプションセットを巡ってはもう1つ問題があって、先の `resolv.conf` のイメージにもあるように、 nameserver が `127.0.0.53` で設定されてしまうという事象が発生する。

これに関してはまったく別の問題で、Systemd のバグらしい。 DHCP なんぞ基本的かつ根幹の部分だと思うのだが、意外にハマりどころがあって難儀している。

* [Bug #1624320 “systemd-resolved appends 127.0.0.53 to resolv.conf...” : Bugs : systemd package : Ubuntu](https://bugs.launchpad.net/ubuntu/+source/systemd/+bug/1624320)