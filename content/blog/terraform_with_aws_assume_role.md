+++
title = "Terraform で AWS assume role が使用できない場合がある"
date = 2018-12-10T21:08:16+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

[![Terraform](https://i.gyazo.com/3e9d184df4735785cec8ee0f04355c6c.png)](https://gyazo.com/3e9d184df4735785cec8ee0f04355c6c)

AWS では [assume role](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_roles_use_switch-role-console.html) と呼ばれる機能を使うことにより、 IAM ユーザーで AWS アカウントへログイン後、他の AWS アカウントの IAM Role へ権限の切り替えを行うことができる。これを使うと、複数の AWS アカウントを保有している会社でも、管理者としては各アカウントにいちいち IAM ユーザーを作らず、中央集権的な管理が可能になるし、利用者としてもユーザー/パスワードを1組だけ覚えればいいとか良いことがたくさんあるので、2018年末の今日においては多くの人が使っていると思う。しかし、これを Terraform で利用する場合に躓きがあった。


## ~/.aws/config の活用

Terraform を使う際に AWS 認証を通すにはいくつか方式がある。というか、 AWS CLI と同じ認証方式が基本的に使える。最も簡単なのは `~/.aws/config` を活用する方式。

```
[profile switch]
region = ap-northeast-1
source_profile = source
role_arn = arn:aws:iam::SQITCH_ACCOUNT_ID:role/switch
mfa_serial = arn:aws:iam::SOURCE_ACCOUNT_ID:mfa/source
``` 

`source_profile` に switch 元になるプロファイルの名前を、 `role_arn` に switch 先になる IAM Role 名を書き、あとは MFA のシリアルも書いておけば、上記の場合 `--profile switch` という引数を付けて AWS CLI を実行することにより、 MFA の token を入力して switch ができる。


これを Terraform の provider - profile に指定すれば使えそうなものなのだが、

```
provider "aws" {
  region  = "eu-west-1"
  profile = "test"
}
```

残念ながら動作せず、 `assume role with MFA enabled, but AssumeRoleTokenProvider session option not set.` というエラーになってしまう。

また別の認証方式として、 `~/.aws` を活用せず、 Terraform の tffile 内に `provider` 設定として直接 assume role の情報を書き入れるという手段もあるが、この場合も同様に動作しない。

```
provider "aws" {
  region = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::SQITCH_ACCOUNT_ID:role/switch"
    session_name = "switch"
  }
}
```

エラーメッセージから察するに MFA token 周りで問題があると見られる。 AWS CLI でこの認証方式を使った場合、コマンドを実行したときに対話式に token を尋ねられるのだが、この部分の実装が terraform-provider-aws には現状無く、 MFA token が入力できないので認証も通らなくなっている。

本件については、すでに以下のように issue が上がっている。 Contributor からも MFA token に関する実装がない点について回答がついていて、「Terraform は対話式のコマンド実行を排除し、中央集権的な環境で自動実行することを目指しているから」「重大な変更が生じるので技術的に困難だから」と理由も述べられている（が、down vote がめっちゃ入ってる）。

[Doesn't ask MFA token code when using assume_role with MFA required · Issue #2420 · terraform-providers/terraform-provider-aws](https://github.com/terraform-providers/terraform-provider-aws/issues/2420)

従って現状は、MFAが有効な assume role で Terraform の認証を通すことは不可能であり、また今後の対応予定も今のところ無いと判断して良さそうである。この問題、どうも結構根深い上に、長らく GitHub 上では議論が続いているようで、すでに close されたもの（ほとんどは Terraform への機能追加ではなく、ワークアラウンドを提示して close という形）と open のもの含めて複数の issue が立っていたりする。

* [AWS assume role not working · Issue #472 · terraform-providers/terraform-provider-aws](https://github.com/terraform-providers/terraform-provider-aws/issues/472#issuecomment-380931474)
* [AWS Assume Role Doesn't work with MFA Enforced Roles · Issue #5078 · terraform-providers/terraform-provider-aws](https://github.com/terraform-providers/terraform-provider-aws/issues/5078)
* [AWS assume role not working · Issue #11270 · hashicorp/terraform](https://github.com/hashicorp/terraform/issues/11270)


## 回避策

### MFA 無効化

試してはいないが、おそらく MFA token 無しで switch 可能な IAM Role であれば、この方式でも上手くいくのだろうという気はしなくもない（※ [MFA 無効化してもダメだったという報告もある。手元で試してないのでわからない](https://github.com/hashicorp/terraform/issues/11270#issuecomment-298224055)）。

が、少なくとも人間に対して払い出す IAM ユーザーにおいて、 MFA を無効化した運用は考えられないので、 MFA を無効化するというのは回避策としては妥当ではない。先に引いたコメントにあるように、中央集権的な環境で Terraform の実行をすべて自動化しているのであれば話は違うとは思うが。

### aws sts assume-role コマンドと環境変数の利用

AWS CLI で assume role を使う別の方式として、 `aws sts assume-role` コマンドを使う方式がある。このコマンドを実行すると、当該の Role へ Switch するのに必要な一時的な API キーが以下のように吐き出される（[チュートリアル: AWS アカウント間の IAM ロールを使用したアクセスの委任 - AWS Identity and Access Management](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/tutorial_cross-account-with-roles.html#tutorial_cross-account-with-roles-3)から抜粋）。

```
{
    "Credentials": {
        "SecretAccessKey": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
        "SessionToken": "AQoDYXdzEGcaEXAMPLE2gsYULo+Im5ZEXAMPLEeYjs1M2FUIgIJx9tQqNMBEXAMPLE
CvSRyh0FW7jEXAMPLEW+vE/7s1HRpXviG7b+qYf4nD00EXAMPLEmj4wxS04L/uZEXAMPLECihzFB5lTYLto9dyBgSDy
EXAMPLE9/g7QRUhZp4bqbEXAMPLENwGPyOj59pFA4lNKCIkVgkREXAMPLEjlzxQ7y52gekeVEXAMPLEDiB9ST3Uuysg
sKdEXAMPLE1TVastU1A0SKFEXAMPLEiywCC/Cs8EXAMPLEpZgOs+6hz4AP4KEXAMPLERbASP+4eZScEXAMPLEsnf87e
NhyDHq6ikBQ==",
        "Expiration": "2014-12-11T23:08:07Z",
        "AccessKeyId": "AKIAIOSFODNN7EXAMPLE"
    }
}
```

この API キーを環境変数に set すれば、 Terraform は環境変数での認証を最優先に実行するので、 assume role の利用が可能になる。 MFA token の入力も `aws sts assume-role` コマンドの実行時点で終わるので問題ない。

ただ注意点としては、環境変数に AWS API キーを設定しまうと、 Terraform はそれ以外の認証情報を一切無視してしまうということ。例えば複数の AWS アカウントをまたいでセットアップを行うような Terraform のレポジトリを使おうとするとき、通常は tffile に複数の `profile` を書いて切り替えようとすると思うが、これらは環境変数の認証情報で上書きされて使えなくなる。あとは率直に、 Terraform を実行するたびにキーを発行して環境変数にセットするのは面倒という話もある。

### aws sts assume-role コマンドと ~/.aws の利用

一時的な API キーを環境変数に set してしまうと問題なのであれば、 `~/.aws/credentials` に書き込んで一時的に profile を作ってしまえばいいんではという案。スクリプトを書けば `aws sts assume-role` コマンドを実行して credentials に書き込むところまで自動化も出来る。これが比較的マシと言えばマシな手段。

この手のツールはすでに作成されていて、見たところ aws-mfa というのが使いやすそうだった。

[broamski/aws-mfa: Manage AWS MFA Security Credentials](https://github.com/broamski/aws-mfa)


## Conclusion

いろいろ検討はしてみたものの、結局のところ「Terraform は MFA を必要とするような手動運用で実行するべきではない」という話になってくるのかなとは思う。先の HashiConf '18 で、 `terraform plan` や `apply` を実行するための基盤となるクラウド環境を [HashiCorpが提供する](https://www.hashicorp.com/blog/terraform-collaboration-for-everyone) という話が出たことと、先述の issue 内でのやり取りを鑑みても、 HashiCorp としては手動での対応が必須になってしまう、対話的な terraform の実行はバッドプラクティスという方向に進めつつあるように見える。

なのでここに挙げたようなワークアラウンドで一旦は回避しつつも、手動 terraform 実行を一掃することを目指さなくてはならないのかな、というのが今回の結論。
