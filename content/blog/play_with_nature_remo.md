+++
title = "Nature Remo API で遊んだ"
date = 2018-06-11T22:08:35+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

Amazon Echo dotに続いてGoogle Home miniも安売りに釣られて買ったので、せっかくだしVUI (Voice User Interface) の醍醐味であるはずの家電操作もやってみたくなって [Nature Remo](https://nature.global/) を買った。

<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B06XCQFP96/diary081213-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/31MkeLD6o3L._SL160_.jpg" alt="Nature Remo" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B06XCQFP96/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Nature Remo</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 18.06.11</div></div><div class="amazlet-detail">Nature, Inc. <br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/B06XCQFP96/diary081213-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

ちなみにこれ書いてるときに気付いたけど、廉価版の mini ってのも近々出るらしいです。

Nature Remo
-----------

赤外線信号を学習させて使えるスマートリモコン。Wi-Fiに繋げてインターネット経由でAPIを叩く形で操作する。専用のスマートフォンアプリからリモコン感覚でも使えるし、IFTTT Channel化されているので、他サービスと連携させていろいろやったりもできる。あとGoogle HomeやAlexaとも直接連携できるようになっている。

最近この手のIoT家電系製品は他にもあると思うけど、正直あまり比較して買ってはいないので、比較優位があるかはわからない。どうもIRKitの後継のようだったので、実績を鑑みてある程度信頼は置けそうだというのと、TLでちらほら買っているソフトウェアエンジニアを見かけたという、ただそれだけの理由で選んだ。

API開放がよい
-------------

なので他製品での状況はわからないが、Nature RemoはAPIが開放されているのがすごくいい。API仕様はSwaggerで公開されているのもポイントが高い。

http://swagger.nature.global/

やろうと思えば実質なんでもできる。手始めにslackからスラッシュコマンドでエアコンを点けられるようにしてみた。OFFにするコマンドをまだ実装していないので、滅多矢鱈と打てないんだけどイイ感じ。

<a href="https://gyazo.com/ada116f88ba891fa63ecf9e42258143e"><img src="https://i.gyazo.com/ada116f88ba891fa63ecf9e42258143e.png" alt="https://gyazo.com/ada116f88ba891fa63ecf9e42258143e" width="601"/></a>

あとこれは買ってから気付いたのだが、Nature Remoにはセンサーが内蔵されていて、温度・湿度のデータもAPI経由で取得できる。機器の設置場所によっても変動する値だし、全幅の信頼を置いていいデータではないかもしれないが、自室の温度・湿度の状態をモニタリングするのは興味があったので、influxDBへ突っ込んでGrafanaでグラフにしてみている。家に帰って窓を開けて、お茶飲みながらグラフ眺めてると結構如実に気温が下がっていったりして面白い。

<a href="https://gyazo.com/cdead523411083bb6481e577cb1ebe98"><img src="https://i.gyazo.com/cdead523411083bb6481e577cb1ebe98.png" alt="https://gyazo.com/cdead523411083bb6481e577cb1ebe98" width="1088"/></a>

APIでセンサー情報をGETすると、返ってくるjsonはこんな感じで、Swaggerには書かれていない "il" という項目があるんだけど、照度センサーも内蔵しているらしいのでおそらくは "illuminance" かな？と思っている。ちなみに今のところ照度の取得はアプリからもIFTTTからも出来ないので、今後拡張されるのかもしれない。ついでに人感センサーもあるらしいので、そちらの情報も取得できるようになると嬉しい。

```
[
  {
    "name": "Remo",
    "id": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
    "created_at": "2018-04-28T12:12:33Z",
    "updated_at": "2018-06-11T13:18:55Z",
    "firmware_version": "Remo/1.0.62-gabbf5bd",
    "temperature_offset": 0,
    "humidity_offset": 0,
    "users": [
      {
        "id": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
        "nickname": "chroju",
        "superuser": true
      }
    ],
    "newest_events": {
      "hu": {
        "val": 60,
        "created_at": "2018-06-11T12:43:29Z"
      },
      "il": {
        "val": 13.8,
        "created_at": "2018-06-11T13:19:09Z"
      },
      "te": {
        "val": 25.39,
        "created_at": "2018-06-11T07:41:56Z"
      }
    }
  }
]
```

やろうと思えばMackerelで気温を監視して、一定の値になったらWebhookからエアコン起動みたいなこともできると思うけど、大惨事になりそうな予感（閾値近辺で値が行ったり来たりしてON/OFFしまくるとか）があってやってはいない。まぁ自室だから別に大惨事でもいいか。やったら面白そう。


ちなみにAPIを叩くのはGoでやりたかったので、ライブラリ作ろうかなと思ったら既にあったのでありがたく使わせていただいている。何か気付いたことがあればIssueなりPRなり送れたら送りたい。

[papix/go-nature-remo: API Client for Nature Remo (Golang)](https://github.com/papix/go-nature-remo)

とにかく「家電にAPIが生える」という感覚は想像以上に楽しかったので、いろいろ便利にしていきたいです。こうなると逆に、遠隔操作にBluetoothを使うPS4が、本来赤外線操作より便利だったはずなのに、不便に思えてくるのが面白い。
