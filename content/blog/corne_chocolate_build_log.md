+++
title = "Corne Chocolate を組み立てる、40%キーボードに目覚める"
date = 2019-06-09T17:30:59+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

<a href="https://gyazo.com/a1907073d1c0e66e41ef19e5c755151a"><img src="https://i.gyazo.com/a1907073d1c0e66e41ef19e5c755151a.jpg" alt="Image from Gyazo" width="600"/></a>

前回の記事で書いたとおり Corne Chocolate を買って、無事に組み立てが完了した。

## Corne Chocolate

[Corne Chocolate](https://yushakobo.jp/shop/corne-chocolate/) は [foostan](https://twitter.com/foostan?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor) 氏が設計、販売している自作キーボード。

* 分割型
* 42キーのいわゆる40%キーボード
* Cherry MX 対応と Kailh Choc (Low Profile) 対応の2バージョン、それぞれホットスワップ
* オプションでフルカラー LED 実装可能

といった特徴がある。私がこれを買ったのは Lily58 Pro を使うなかで数字列が要らないのではないか、つまり40%キーボードで良いのではないかと悟ったからであり、40%の分割型で Kailh Choc 対応という3つの希望を満たしてくれるのがこれだった。ちなみに Cherry MX 対応のほうは Corne Cherry と呼ばれる。略して crkbd と表記されることもあるみたい。

## 購入、組み立て

Lily58 Pro と同じく遊舎工房さんの実店舗で購入して組み立てた。組み立ては Lily58 Pro とわりと似ているというか、ダイオードが表面実装タイプで、キーソケットも同じ Kailh Choc のスワップタイプのものだったので、はんだ付けの工程はまったく同じで手間取ることがなかった。最初に使えるようになるまでは5時間ぐらい。

<a href="https://gyazo.com/37817309abaa100339c1eecb4c4be121"><img src="https://i.gyazo.com/37817309abaa100339c1eecb4c4be121.jpg" alt="Image from Gyazo" width="400"/></a>

大変だったのは LED 。 Corne に関して他の方のビルドログを探ってみても、一様に LED のはんだ付けが難しいという話が出てくるが、確かに難しかった。LED は PCB 基板の裏側からはんだ付けする必要があるのだけど、裏側にそのまま表面実装ではんだ付けする Underglow 用のものと、基板に空いた穴に LED をはめ込んではんだ付けする Backlight 用のものとの2種類がある。難しいと言われるのは Underglow 用のものの方みたいなんだけど、はんだ付け初級者としてはどちらも難しかった。

### Backlight LED

写真でわかりづらいかもしれないが、 Backlight LED はこのように穴のなかにはめこんで、基板側のランドと繋ぐ必要がある。

<a href="https://gyazo.com/f642119bfce092e5c3ee07fd66740ca3"><img src="https://i.gyazo.com/f642119bfce092e5c3ee07fd66740ca3.jpg" alt="Image from Gyazo" width="400"/></a>

ただ、基板のランドと LED とが平らに並ぶ（「ツライチ」と呼ぶらしい）わけではなく、少し段差があって、その間をうまくはんだでブリッジさせることが難しかった。ただ、上手くいかなければ一度はんだ吸い取り線で一度はがしてやり直せるので、確かに Underglow よりは楽だと思う。

### Underglow LED

表面実装なので、何も考えずランドに予備はんだを盛ってから取り付ける方式でやってみたんだけど、それだと LED が浮いてしまってうまくいかず、一度外してやり直そうと思っても LED の裏側にまではんだが入り込んでしまっているので外せなくて終いにはランドを剥がしてしまった。

<a href="https://gyazo.com/e1f2cce60faa3d27ab881c4638cb0e8a"><img src="https://i.gyazo.com/e1f2cce60faa3d27ab881c4638cb0e8a.jpg" alt="Image from Gyazo" width="400"/></a>

その後いろいろと調べてみたところ、 [Corne Chocolateビルドログ - nokの雑記](http://nok0714.hatenablog.com/entry/2019/03/02/194138) に図解されているように、予備はんだを盛るのではなくて、 LED を先に基板に置いてしまって、端子部分に横からはんだを差し入れるようにするのが良いらしいとわかった。その後気づいたけれど、これは Corne Chocolate ではなくて、前バージョンにあたる [Corne Classic のビルドガイド](https://github.com/foostan/crkbd/blob/master/corne-classic/doc/buildguide_jp.md) にも載っている方法だった。

幸いにも遊舎工房さんで Corne の PCB 単体での販売があったので、それで1枚追加で購入して改めてやり直した。やり方を変えてそれなりにスムーズに実装できるようになったが、この方法はちゃんとはんだが盛れているか目視では確認しづらくて、頻繁に通電してちゃんと光るか確認しながら進めた。ビルドガイドにもある通り、 LED はすべて接続されていて、1つがダメだとその先のものがすべて光らなくなるので、番号順に実装を進めていった。わからなかったのが、光らない LED があるものの、その先の LED は光っており、しかし色がおかしい、という事態。これがどうにも克服できなかった。電気的な部分はまったくわからないなりに [コルネキーボードを作りました ～LED取り付けに四苦八苦記～ | キオクノロンダリング](https://marksard.github.io/2018/08/04/make-the-crkbd/) などを参考に、どの端子がどういう働きをしているかなどを確認してみて、導線で上手いことジャンパすれば直らないかなと四苦八苦した結果、原理はわからないけれど、光らない LED と、その1つ手前の LED の DOUT 同士を繋いでみたところ、光らない LED は光らないままだけど色はちゃんと出るようになった。 Underglow が1つ光らないのは諦めて、いまのところこれで妥協している。

<a href="https://gyazo.com/1f366b2b467921be1dd3fa4ae6a21da1"><img src="https://i.gyazo.com/1f366b2b467921be1dd3fa4ae6a21da1.jpg" alt="Image from Gyazo" width="400"/></a>

## キーキャップとキースイッチ

キースイッチは前回の Lily58 Pro で茶軸を買っていたので、今回は赤軸を買ってみた。軽くサクサク打ててとてもよかったんだけど、小指で押さえるキーや、一定時間押しっぱなしにする修飾キーはタクタイルのクリック感があったほうが押し込みやすかったので、今は以下のようなハイブリッドにしてみている。

<a href="https://gyazo.com/a7464fae428d09232d8f6d96257401f5"><img src="https://i.gyazo.com/a7464fae428d09232d8f6d96257401f5.jpg" alt="Image from Gyazo" width="600"/></a>

キーキャップは monksoffunk 氏が DMM.make で販売しているものを買ってみた。

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://make.dmm.com/item/1009205/" data-iframely-url="//cdn.iframe.ly/Ac1er9N"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

DMM.make では3Dプリント用のデータをアップロードして出品することができる。ユーザーがそのデータに対して注文をかけると、 DMM で実際にプリントして物品を送ってきてくれる仕組み。3Dプリントされた物品を手に持ったことがないのでどんなものかと思ったけど、手触りはさらさらしているものの程よいざらつきもあって、とても打ち心地のいいキーキャップだった。Kailh Choc 用のキーキャップは、[遊舎工房にも置かれている Kailh 自身が販売しているもの](https://yushakobo.jp/shop/pg1350cap-blank/)ぐらいしか出回っていないと思うのだけど、それと比べても見た目、打ち心地ともに上回って満足している。

ちなみにプリントする素材が選べるのだが、PA12GB ブラック磨きを選択している。販売ページの断り書きに「破損の恐れがあるためキャンセルを促される連絡があるかもしれません」とあるけれど、これはこのキーキャップが DMM 側の規定サイズを満たさず、品質保証ができないためのようで、実際に一度は DMM 側から強制的にキャンセルされた。その後サポートから「破損の可能性を受け入れた上で再注文したい」と申し出たところ無事に購入することができ、再注文から9日で到着した。確かに1個だけ軸が折れたものが混ざっていたけれど、キットには予備のキーキャップがいくつか入っているので問題はなかった。

<a href="https://gyazo.com/7336dc16b0729f856685ff7ba63b0e74"><img src="https://i.gyazo.com/7336dc16b0729f856685ff7ba63b0e74.jpg" alt="Image from Gyazo" width="400"/></a>

## キーマップ

まだ適宜変更は入ると思うけど、いまのところ以下のようになっている。

```c
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [_QWERTY] = LAYOUT_kc( \
  //,-----------------------------------------.                ,-----------------------------------------.
        TAB,     Q,     W,     E,     R,     T,                      Y,     U,     I,     O,     P,  BSLS,\
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
     CTLGUI,     A,     S,     D,     F,     G,                      H,     J,     K,     L,  SCLN,  QUOT,\
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
     SFTESC,     Z,     X,     C,     V,     B,                      N,     M,  COMM,   DOT,  SLSH,  RALT,\
  //|------+------+------+------+------+------+------|  |------+------+------+------+------+------+------|
                                   LGUI, LOWER,SPCALT,      ENT,RASLNG,  BSPC \
                              //`--------------------'  `--------------------'
  ),

  [_RAISE] = LAYOUT_kc( \
  //,-----------------------------------------.                ,-----------------------------------------.
       LRST,    F1,    F2,    F3,    F4,    F5,                     F6,    F7,    F8,    F9,   F10,   F12,\
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
       LTOG,  LHUI,  LSAI,  LVAI, XXXXX, XXXXX,                   LEFT,  DOWN,    UP, RIGHT,  VOLU,  BRIU,\
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
       LMOD,  LHUD,  LSAD,  LVAD, XXXXX, XXXXX,                  XXXXX, XXXXX, XXXXX,  MUTE,  VOLD,  BRID,\
  //|------+------+------+------+------+------+------|  |------+------+------+------+------+------+------|
                                   LGUI, LOWER,SPCALT,      ENT,RASLNG,   CAD \
                              //`--------------------'  `--------------------'
  ),

  [_LOWER] = LAYOUT_kc( \
  //,-----------------------------------------.                ,-----------------------------------------.
       EXLM,     1,     2,     3,     4,     5,                      6,     7,     8,     9,     0, XXXXX,\
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
       TILD, XXXXX, XXXXX, XXXXX, XXXXX, LCBRS,                  RCBRS,  MINS,   EQL, XXXXX, XXXXX, XXXXX,\
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
        GRV,    AT,  HASH,   DLR,  PERC, XXXXX,                   ASTR,  UNDS,  PLUS,  CIRC,  AMPR,  ASTR,\
  //|------+------+------+------+------+------+------|  |------+------+------+------+------+------+------|
                                   LGUI, LOWER,SPCALT,      ENT,RASLNG,  BSPC \
                              //`--------------------'  `--------------------'
  )
};
```

デフォルトでは RAISE と LAWER を同時押しすることで変更できる ADJUST レイヤーも含む4レイヤー用意されているが、3レイヤーでなんとか収まった。LOWER が記号や数字、RAISE がファンクションキーや LED の調整などの操作系のキーという振り分けになっている。

42キーとだいぶキー数が減ったことで、1つのキーに Tap Dance や Mod-Tap によって複数の役割をもたせている箇所も増えている。左側の「SFTESC」や、親指部分の「SPCALT」はいずれも Mod-Tap で同時押ししたときと単推しのときで役割を変えている。また LOWER レイヤーの左右それぞれ一番内側中段にある「LCBRS」「RCBRS」は Tap Dance によって `[`, `(`, `{` の3種類の括弧を切り替えられるようにしたものなんだけど、3回タップするのはわりと手間で、ちょっと今見直そうか迷っている。

渾身のキーが右親指の「RASLNG」。これは長押しすると RAISE、単推しで IME 無効化、2回連続押しで IME 有効化という3種類の役割を担っている。IME の on/off 切り替えは1つのキーでトグルさせるのではなく、別々のキーに割り当てたほうが冪等な操作ができて良い、と私も思っているのだけど、例えば左親指で off で右親指で on のように振り分けるとどちらがどっちだったか覚えるのが煩わしいという問題と、同じ IME 操作をするのに意識が左右に散らばってしまって不快という問題があり、1つのキーを押した回数で冪等に切り替える方式を採用した。 Tap Dance の設定を以下のように書いており、1回押したときに `LANG2` と `F13` 、2回押したときに `LANG1` と `F16` を発行するようにしている。LANGの各キーコードによる IME の切り替えは macOS にしか対応しないので、 Windows では IME の設定により、ファンクションキーで IME の有効無効を切り替えられるようにした形。

```c
enum {
  SINGLE_TAP = 1,
  SINGLE_HOLD = 2,
  DOUBLE_TAP = 3,
};

typedef struct {
  bool is_press_action;
  int state;
} tap;

int lang_dance (qk_tap_dance_state_t *state) {
  if (state->count == 1) {
    if (!state->pressed) return SINGLE_TAP;
    else return SINGLE_HOLD;
  }
  else if (state->count == 2) {
    return DOUBLE_TAP;
  }
  else return 6;
}

static tap xtap_state = {
  .is_press_action = true,
  .state = 0
};

void x_finished_1 (qk_tap_dance_state_t *state, void *user_data) {
  xtap_state.state = lang_dance(state);
  switch (xtap_state.state) {
    case SINGLE_TAP:
        register_code(KC_F13);
        register_code(KC_LANG2);
        break;
    case SINGLE_HOLD:
        layer_on(_RAISE);
        break;
    case DOUBLE_TAP:
        register_code(KC_F16);
        register_code(KC_LANG1);
        break;
  }
}

void x_reset_1 (qk_tap_dance_state_t *state, void *user_data) {
  switch (xtap_state.state) {
    case SINGLE_TAP:  
        unregister_code(KC_F13); 
        unregister_code(KC_LANG2);
        break;
    case SINGLE_HOLD: 
        layer_off(_RAISE);
        break;
    case DOUBLE_TAP:
        unregister_code(KC_F16);
        unregister_code(KC_LANG1);
        break;
  }
  xtap_state.state = 0;
}
```

これは自分で思いついたわけではなくて、実装にあたっては以下の記事を大いに参考にさせていただいた。

* [変わり種ErgoDox紹介 + IME話 - Qiita](https://qiita.com/miyaoka/items/e3f7242b4767cd599364)
* [QMK Basics: Tap dance, or how to let a key do more with one, two, three – Thomas Baart](https://thomasbaart.nl/2018/12/13/qmk-basics-tap-dance/)

## Impression

記号キーがどこにあるかはまだ全然覚えていないし、特にパスワードを打つときすごく苦労しているけれど、見込んでいたとおり、すべてのキーがホームポジションから1キーだけ離れたところに収まっているというのは無茶苦茶快適で大満足している。早いけれど、とりあえずはこれで End Game と考えていいんじゃないかなぁと感じているぐらい。40%キーボードが実用に足るとは1か月前にはさらさら考えていなかったのが嘘のように「40%でキー数は十分」と思うようになってきている。 LED についても要らないでしょと思っていたし、実用上の意味はまったくないんだけど、実際光ってみるとカッコよく見えてしまい、作り直しまでしてこだわってしまったので、やってみないとわからないことって多いなぁと。

End Game っぽいとは言え、自作キーボード周りの買い物や工作がこれで終わりではなくて、まだ買いたいものもある。[IMK Corne Case — KeyHive](https://keyhive.xyz/shop/aluminum-corne-helidox-case) で今アルミ製のケースのグループバイが始まっていて、ちょっと高いけど買おうかなぁと思っている（実際の購入は遊舎工房さんの日本プロキシを用いる予定）。あとせっかくなので Kailh Choc の他のキースイッチも Novelkeys から個人輸入で買ってみようかな、と。はんだ付け工具一式も揃ったんだし、また興味を引かれるキーボードを見かけたら買ってみたい。今回 PCB を追加で買ったときに、足りなくなった部品を買いに秋葉原の秋月電子通商やら西川電子部品やらにも初めて足を踏み入れて、今まで知らなかった領域の知識が増えるのがとても楽しかったし、この経験は今後も活きるといいなと思っている。
