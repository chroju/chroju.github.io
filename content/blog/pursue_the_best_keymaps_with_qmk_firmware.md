+++
title = "Lily58 Pro 最強のキーマップを目指して"
date = 2019-05-24T21:49:37+09:00
tags = ""
isCJKLanguage = true
draft = false
+++

自作キーボード Lily58 Pro に関するエントリーシリーズ第3弾、おそらくこれで最後。

* 第1弾 購入編 : [Lily58 Pro または私は如何にして市販品を探すのをやめて分割キーボードを自作するようになったか · the world as code](https://chroju.github.io/blog/2019/04/25/how_i_learned_to_stop_worrying_and_love_the_original_keyboards/)
* 第2弾 作成編 : [電子工作初心者が Lily58 Pro を買ってから作って持ち運ぶまで · the world as code](https://chroju.github.io/blog/2019/04/27/making_lily58_pro_with_a_beginner/)

自作キーボードの大きな魅力の一つが自由なキーマップを作れる点で、市販のキーボードのキーマクロ機能の比ではなく、本当にすべてのキーを自由にアサインできる。 Dvorak ももちろん可能だし、「俺が考えた最強の配列」を作ることもできる。また Lily58 をはじめ多くのキーボードはフルキーボードを比較してキー数が少なく設定されていることが多いため、レイヤーの概念などを駆使して、1つのキーに複数の機能をアサインすることも必要になってくる。どのキーにどの役割をいくつ与えるか、という組み合わせも考えていくと、途方もないほどに自由度が高い。

QMK Firmware
----

<div class="iframely-embed"><div class="iframely-responsive" style="height: 140px; padding-bottom: 0;"><a href="https://github.com/qmk/qmk_firmware" data-iframely-url="//cdn.iframe.ly/jAEMAC5"></a></div></div><script async src="//cdn.iframe.ly/embed.js" charset="utf-8"></script>

例の Ergodox 含め、多くの自作キーボードがファームウェアとして QMK Firmware という OSS を活用している。自作キーボード制作者は自身のキーボードを作成したら、そのキーマップ設定を追加して Pull Request を送ることで QMK Firmware 本体のレポジトリに merge されるようで、現在買えるような自作キーボードであれば、基本的には上記レポジトリから clone すれば、すぐにデフォルトキーマップを焼き込めるようになっている。もちろん、そこから自分でキーマップを変えていくこともできる。

QMK Firmware では単にキー配置を司るだけではなく、多くの付随的な機能を提供している。

### レイヤー

shift キーのように、レイヤー切り替えキーを押下している間のみ、キーアサインが別のものに変換される機能。キー数が少ないキーボードではほぼ必須の機能であり、多くの場合 LOWER と RAISE の2つのレイヤーキーがデフォルトでアサインされている。

### Tap Dance

1回押した場合と、すばやく複数回押した場合でキーアサインを切り替える機能。複数種類の括弧を1つのキーでまかなえるようにしたり、欧米圏でウムラウト付きのアルファベットなどを出す際に使われているのをよく見る印象。

### Mod-Tap

他のキーと同時に押した場合は Modifier key = shift や control などの修飾キーに、単独で押した場合は別のキーに切り替える機能。確かに修飾キーというのは同時押しが基本なので、同時に押さない場合は別のキーとして扱う、というのはなんだか頭いいな、と思う発想だった。

### Modifier Keys

修飾キー + 他のキーを押した状態を、1つのキーにアサインしてしまえる機能。どちらかと言えばキー数に余裕がある場合に、よく使うキーボードショートカットをアサインする、などの利用をするっぽい。

### One Shot Keys

通常、修飾キーを使う際は同時押しが必要になるが、一度押すとそのキーが押された状態になり、別のキーを押すと押された状態が解除される、という機能。 Windows の固定キーに近い。

他にもマウス操作をキーにアサインできるとか、 Unicode のアサインも可能なので :thinking_face: を1キーで出せるとかいろいろできる。つまり **単純なキーの配置だけではなく、どの機能を使うと自分の理想的な運指になるか** ということを考える必要があり、沼と呼ぶに非常にふさわしい。

なお Lily58 は対応していないが、キーボードにありがちな LED を光らせる設定も QMK Firmware でまかなうことができる。一部機能に関しては `rules.mk` というファイルに有効化の設定を書かなくてはならないため、ドキュメントを読みながら対応する必要がある。機能を有効化すると、その機能に関するコードがファームウェアに内包されるようになる仕組みと思われる。私の `rules.mk` はこんな感じ。

```c
# Build Options
#   change to "no" to disable the options, or define them in the Makefile in
#   the appropriate keymap folder that will get included automatically
#
BOOTMAGIC_ENABLE = no       # Virtual DIP switch configuration(+1000)
MOUSEKEY_ENABLE = no        # Mouse keys(+4700)
EXTRAKEY_ENABLE = yes       # Audio control and System control(+450)
CONSOLE_ENABLE = no         # Console for debug(+400)
COMMAND_ENABLE = no         # Commands for debug and configuration
NKRO_ENABLE = no            # Nkey Rollover - if this doesn't work, see here: https://github.com/tmk/tmk_keyboard/wiki/FAQ#nkro-doesnt-work
BACKLIGHT_ENABLE = no       # Enable keyboard backlight functionality
MIDI_ENABLE = no            # MIDI controls
AUDIO_ENABLE = no           # Audio output on port C6
UNICODE_ENABLE = no         # Unicode
BLUETOOTH_ENABLE = no       # Enable Bluetooth with the Adafruit EZ-Key HID
RGBLIGHT_ENABLE = no        # Enable WS2812 RGB underlight.
SWAP_HANDS_ENABLE = no      # Enable one-hand typing
TAP_DANCE_ENABLE = yes

# Do not enable SLEEP_LED_ENABLE. it uses the same timer as BACKLIGHT_ENABLE
SLEEP_LED_ENABLE = no    # Breathing sleep LED during USB suspend

# If you want to change the display of OLED, you need to change here
SRC +=  ./lib/glcdfont.c \
        ./lib/rgb_state_reader.c \
        ./lib/layer_state_reader.c \
        ./lib/logo_reader.c \
        ./lib/key_count.c \
        ./lib/uptime.c \
```

Lily58 デフォルトキーマップ
----

すべて自分で考えて配置するのは大変なので、デフォルトキーマップを元に編集することにした。本記事執筆時点で、デフォルトキーマップは以下の通りになっている。

```c
/* QWERTY
 * ,-----------------------------------------.                    ,-----------------------------------------.
 * | ESC  |   1  |   2  |   3  |   4  |   5  |                    |   6  |   7  |   8  |   9  |   0  |  `   |
 * |------+------+------+------+------+------|                    |------+------+------+------+------+------|
 * | Tab  |   Q  |   W  |   E  |   R  |   T  |                    |   Y  |   U  |   I  |   O  |   P  |  -   |
 * |------+------+------+------+------+------|                    |------+------+------+------+------+------|
 * |LCTRL |   A  |   S  |   D  |   F  |   G  |-------.    ,-------|   H  |   J  |   K  |   L  |   ;  |  '   |
 * |------+------+------+------+------+------|   [   |    |    ]  |------+------+------+------+------+------|
 * |LShift|   Z  |   X  |   C  |   V  |   B  |-------|    |-------|   N  |   M  |   ,  |   .  |   /  |RShift|
 * `-----------------------------------------/       /     \      \-----------------------------------------'
 *                   | LAlt | LGUI |LOWER | /Space  /       \Enter \  |RAISE |BackSP| RGUI |
 *                   |      |      |      |/       /         \      \ |      |      |      |
 *                   `----------------------------'           '------''--------------------'
 */

 [_QWERTY] = LAYOUT( \
  KC_ESC,   KC_1,   KC_2,    KC_3,    KC_4,    KC_5,                     KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    KC_GRV, \
  KC_TAB,   KC_Q,   KC_W,    KC_E,    KC_R,    KC_T,                     KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_MINS, \
  KC_LCTRL, KC_A,   KC_S,    KC_D,    KC_F,    KC_G,                     KC_H,    KC_J,    KC_K,    KC_L,    KC_SCLN, KC_QUOT, \
  KC_LSFT,  KC_Z,   KC_X,    KC_C,    KC_V,    KC_B, KC_LBRC,  KC_RBRC,  KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH,  KC_RSFT, \
                             KC_LALT, KC_LGUI,LOWER, KC_SPC,   KC_ENT,   RAISE,   KC_BSPC, KC_RGUI \
),
/* LOWER
 * ,-----------------------------------------.                    ,-----------------------------------------.
 * |      |      |      |      |      |      |                    |      |      |      |      |      |      |
 * |------+------+------+------+------+------|                    |------+------+------+------+------+------|
 * |  F1  |  F2  |  F3  |  F4  |  F5  |  F6  |                    |  F7  |  F8  |  F9  | F10  | F11  | F12  |
 * |------+------+------+------+------+------|                    |------+------+------+------+------+------|
 * |   `  |   !  |   @  |   #  |   $  |   %  |-------.    ,-------|   ^  |   &  |   *  |   (  |   )  |   -  |
 * |------+------+------+------+------+------|   [   |    |    ]  |------+------+------+------+------+------|
 * |      |      |      |      |      |      |-------|    |-------|      |   _  |   +  |   {  |   }  |   |  |
 * `-----------------------------------------/       /     \      \-----------------------------------------'
 *                   | LAlt | LGUI |LOWER | /Space  /       \Enter \  |RAISE |BackSP| RGUI |
 *                   |      |      |      |/       /         \      \ |      |      |      |
 *                   `----------------------------'           '------''--------------------'
 */
[_LOWER] = LAYOUT( \
  _______, _______, _______, _______, _______, _______,                   _______, _______, _______,_______, _______, _______,\
  KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   KC_F6,                     KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F11,  KC_F12, \
  KC_GRV, KC_EXLM, KC_AT,   KC_HASH, KC_DLR,  KC_PERC,                   KC_CIRC, KC_AMPR, KC_ASTR, KC_LPRN, KC_RPRN, KC_TILD, \
  _______, _______, _______, _______, _______, _______, _______, _______, XXXXXXX, KC_UNDS, KC_PLUS, KC_LCBR, KC_RCBR, KC_PIPE, \
                             _______, _______, _______, _______, _______,  _______, _______, _______\
),
/* RAISE
 * ,-----------------------------------------.                    ,-----------------------------------------.
 * |      |      |      |      |      |      |                    |      |      |      |      |      |      |
 * |------+------+------+------+------+------|                    |------+------+------+------+------+------|
 * |   `  |   1  |   2  |   3  |   4  |   5  |                    |   6  |   7  |   8  |   9  |   0  |      |
 * |------+------+------+------+------+------|                    |------+------+------+------+------+------|
 * |  F1  |  F2  |  F3  |  F4  |  F5  |  F6  |-------.    ,-------|      | Left | Down |  Up  |Right |      |
 * |------+------+------+------+------+------|   [   |    |    ]  |------+------+------+------+------+------|
 * |  F7  |  F8  |  F9  | F10  | F11  | F12  |-------|    |-------|   +  |   -  |   =  |   [  |   ]  |   \  |
 * `-----------------------------------------/       /     \      \-----------------------------------------'
 *                   | LAlt | LGUI |LOWER | /Space  /       \Enter \  |RAISE |BackSP| RGUI |
 *                   |      |      |      |/       /         \      \ |      |      |      |
 *                   `----------------------------'           '------''--------------------'
 */

[_RAISE] = LAYOUT( \
  _______, _______, _______, _______, _______, _______,                     _______, _______, _______, _______, _______, _______, \
  KC_GRV,  KC_1,    KC_2,    KC_3,    KC_4,    KC_5,                        KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    _______, \
  KC_F1,  KC_F2,    KC_F3,   KC_F4,   KC_F5,   KC_F6,                       XXXXXXX, KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, XXXXXXX, \
  KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F11,  KC_F12,   _______, _______,  KC_PLUS, KC_MINS, KC_EQL,  KC_LBRC, KC_RBRC, KC_BSLS, \
                             _______, _______, _______,  _______, _______,  _______, _______, _______ \
```

これに対する自分の意見は以下。

* 右GUI、右Shiftは不要
* Backspace が右親指の位置にあるが、最初は慣れないと思うので右上にも配置したい
* LOWER レイヤーにすべての記号がアサインされているが、 Lily58 は数字キーも存在するのでいくつかは重複アサインとなっており、不要
* ファンクションキーは数字キーと同じ列にそれぞれ配置するとわかりやすそう（F11とF12は諦める）
* 矢印キーは Vim の感覚から `hjkl` にあると覚えやすそう

これを踏まえてキーマップを作成した。

現時点で最強のキーマップ
----

自作キーボードは親指を駆使させ、小指を使わなくさせる傾向にあることが多い。　Ergodox の親指用キーの多さなどは顕著である。多くの人は小指より親指のほうが動かしやすいと思うので理に適った話ではあるが、しかし使い慣れたキー配置からの移行コストもあるわけで、一旦折衷的なキーマップとした。 まずはデフォルトのレイヤー。

```c
/* QWERTY
 * ,------------------------------------------.                    ,-----------------------------------------.
 * | ESC   |   1  |   2  |   3  |   4  |   5  |                    |   6  |   7  |   8  |   9  |   0  |BackSP|
 * |-------+------+------+------+------+------|                    |------+------+------+------+------+------|
 * | Tab   |   Q  |   W  |   E  |   R  |   T  |                    |   Y  |   U  |   I  |   O  |   P  |  -   |
 * |-------+------+------+------+------+------|                    |------+------+------+------+------+------|
 * |CTL/GUI|   A  |   S  |   D  |   F  |   G  |-------.    ,-------|   H  |   J  |   K  |   L  |   ;  |  '   |
 * |-------+------+------+------+------+------|   [   |    |    ]  |------+------+------+------+------+------|
 * |LShift |   Z  |   X  |   C  |   V  |   B  |-------|    |-------|   N  |   M  |   ,  |   .  |   /  |CTL+Sp|
 * `------------------------------------------/       /     \      \-----------------------------------------'
 *                    | LAlt | LGUI |LOWER | /Space  /       \Enter \  |RAISE |BackSP| ESC  |
 *                    |      |      |IMEon |/       /         \      \ |IMEoff|      |      |
 *                    `----------------------------'           '------''--------------------'
 */

 [_QWERTY] = LAYOUT( \
  KC_ESC,           KC_1,   KC_2,    KC_3,    KC_4,    KC_5,                                KC_6,           KC_7,    KC_8,    KC_9,    KC_0,    KC_BSPC,      \
  KC_TAB,           KC_Q,   KC_W,    KC_E,    KC_R,    KC_T,                                KC_Y,           KC_U,    KC_I,    KC_O,    KC_P,    KC_BSLS,      \
  TD(TD_CTL_GUI),   KC_A,   KC_S,    KC_D,    KC_F,    KC_G,                                KC_H,           KC_J,    KC_K,    KC_L,    KC_SCLN, KC_QUOT,      \
  KC_LSFT,          KC_Z,   KC_X,    KC_C,    KC_V,    KC_B,            KC_LBRC,   KC_RBRC, KC_N,           KC_M,    KC_COMM, KC_DOT,  KC_SLSH, LCTL(KC_SPC), \
                                     KC_LALT, KC_LGUI, LT(1, KC_LANG1), KC_SPC,    KC_ENT,  LT(2,KC_LANG2), KC_BSPC, KC_ESC  \
),
```

Backspace と ESC は右親指で押すことを目指すが、現時点では一般的な位置にも配置している。最左列、下から2番目のキーは Tap-Dance により、1回押すと ctrl、2回押すと GUI とした。これは macOS でキーボードショートカットが GUI（⌘）に割り当たっている一方、 GNU Readline の各種ショートカットが ctrl と位置がバラけるのが嫌だったため。これも移行措置として、通常の位置にも GUI を置いている。

なお、 Tap-Dance はどのキーを何回押したときにどう動作させるか、という定義を書く必要があり、キーマップ以外に以下のようなコードを追加している。

```c
enum {
  TD_CTL_GUI = 0
};

qk_tap_dance_action_t tap_dance_actions[] = {
  [TD_CTL_GUI] = ACTION_TAP_DANCE_DOUBLE(KC_LCTRL, KC_LGUI)
};
```

LOWER、RAISEの各キーは Mod-Tap により、単独で押した場合に `KC_LANG1` と `KC_LANG2` というキーをそれぞれ割り当てている。ドキュメントに記載はないのだが、これらは macOS のかな/英数に相当するらしく、 IME の切り替えが Toggle ではなく一発で出来るようになる。 US キーボードを使っていると IME 切り替えは ctrl + space などで Toggle させるしかなかったため、このアサインが出来るのは嬉しかった。

参考 : [変わり種ErgoDox紹介 + IME話 - Qiita](https://qiita.com/miyaoka/items/e3f7242b4767cd599364#_reference-af7104110d01879c97d3)

最右最下は正直余ってしまったので、 ctrl + space を割り当てた。 Windows での IME 切り替えに現在使っているが、 Windows でも OS 側の設定で `KC_LANG` 各キーを IME 切り替えに割り当てられるらしいので、後日対応の予定。

### LOWER

```c
/* LOWER
 * ,-----------------------------------------.                    ,-----------------------------------------.
 * |      |      |      |      |      |      |                    |      |      |      |      |      |      |
 * |------+------+------+------+------+------|                    |------+------+------+------+------+------|
 * |      |      |      |      |   ~  |      |                    |      |      |      |  _   |  +   |      |
 * |------+------+------+------+------+------|                    |------+------+------+------+------+------|
 * |      |      |      |      |   `  |      |-------.    ,-------|      |      |      |  -   |  =   |      |
 * |------+------+------+------+------+------|   (   |    |    )  |------+------+------+------+------+------|
 * |      |      |      |      |      |      |-------|    |-------|      |      |      |      |      |      |
 * `-----------------------------------------/       /     \      \-----------------------------------------'
 *                   | LAlt | LGUI |LOWER | /Space  /       \Enter \  |RAISE |BackSP| RGUI |
 *                   |      |      |      |/       /         \      \ |      |      |      |
 *                   `----------------------------'           '------''--------------------'
 */

[_LOWER] = LAYOUT( \
  _______, _______, _______, _______, _______, _______,                     _______, _______, _______, _______, _______, _______, \
  _______, _______, _______, _______, KC_TILD, _______,                     _______, KC_UNDS, KC_PLUS, _______, _______, _______, \
  _______, _______, _______, _______, KC_GRV,  _______,                     _______, KC_MINS, KC_EQL,  _______, _______, _______, \
  _______, _______, _______, _______, _______, _______,  KC_LPRN, KC_RPRN,  _______, _______, _______, _______, _______, _______, \
                             _______, _______, _______,  _______, _______,  _______, _______, _______ \
),
```

LOWER は記号キー用とした。通常配置で盛り込みきれていない記号キーだけに絞っている。

当初はハイフンを9に割り当てるなど、一般的配列と近い位置に配置していたが、わざわざ遠くへ押しに行く必要もないと考え直し、左右とも人差し指近くに集中させた。

### RAISE

```c
/* RAISE
 * ,-----------------------------------------.                    ,-----------------------------------------.
 * |      |      |      |      |      |      |                    |      |      |      |      |      | DEL  |
 * |------+------+------+------+------+------|                    |------+------+------+------+------+------|
 * | F11  |  F1  |  F2  |  F3  |  F4  |  F5  |                    |  F6  |  F7  |  F8  |  F9  | F10  | F12  |
 * |------+------+------+------+------+------|                    |------+------+------+------+------+------|
 * |      |      |      |      |      |      |-------.    ,-------| LEFT | DOWN |  UP  |RIGHT |      |      |
 * |------+------+------+------+------+------|   [   |    |    ]  |------+------+------+------+------+------|
 * |      |      |      |      |      |      |-------|    |-------| BRID | BRIU | VOLD | VOLU | MUTE |      |
 * `-----------------------------------------/       /     \      \-----------------------------------------'
 *                   | LAlt | LGUI |LOWER | /Space  /       \Enter \  |RAISE |BackSP| CAD  |
 *                   |      |      |      |/       /         \      \ |      |      |      |
 *                   `----------------------------'           '------''--------------------'
 */
[_RAISE] = LAYOUT( \
  _______, _______, _______, _______, _______, _______,                   _______, _______, _______, _______,  _______, KC_DEL,  \
  KC_F11,  KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,                     KC_F6,   KC_F7,   KC_F8,   KC_F9,    KC_F10,  KC_F12,  \
  _______, _______, _______, _______, _______, _______,                   KC_LEFT, KC_DOWN, KC_UP,   KC_RIGHT, _______, _______, \
  _______, _______, _______, _______, _______, _______, _______, _______, KC_BRID, KC_BRIU, KC_VOLD, KC_VOLU,  KC_MUTE, _______, \
                             _______, _______, _______, _______, _______, _______, _______, LCTL(LALT(KC_DEL)) \
),
```

RAISE は機能的なキー担当。先述の方針通りにファンクションキーと矢印キーを並べている。

また Macbook に搭載されている輝度や音量調節のキーをよく使っていたので、それらも割り当てた。 Windows でも動いてくれるとうれしいのだが、いまのところ動かないので要調整。

右親指あたりにある「CAD」というキーは ctrl + alt + delete の同時押しに相当している。 Windows 最悪のあのキーバインドが簡単に打てて QOL がだいぶ上がった。右上の Delete は Windows で使うことがあるかもしれない、ということで念の為配置している。今のところ必要になったことはない。

## Conclusion

この配置になるまで5回ぐらいはキーマップの変更を経ているが、ようやく安定したかなというところ。自作キーボードは組み立て終わってからが沼だとはよく言ったものだなと思う。

なるべく親指の役割を増やす、ホームポジションから手を動かさず済むようにする、というのは実際にやってみると確かに負荷が少ない。もともと自分は「腕を動かすのが嫌」という理由でトラックパッドとトラックボールを愛用してもいるので、キーボード上で指の移動距離を減らす、という考え方にもハマりこんでしまった。

そしてその結果、自分でも面白い変化だと思うが、「数字列」が遠いと思うようになってきた。指を動かす範囲は上下左右1キー以内に現状ほぼ収まってきたので、たまに数字列だけ2キー分指を伸ばさなくてはならないのがどうにも気持ち悪い。

<blockquote class="instagram-media" data-instgrm-captioned data-instgrm-permalink="https://www.instagram.com/p/BxzgRXqAKWD/" data-instgrm-version="12" style=" background:#FFF; border:0; border-radius:3px; box-shadow:0 0 1px 0 rgba(0,0,0,0.5),0 1px 10px 0 rgba(0,0,0,0.15); margin: 1px; max-width:540px; min-width:326px; padding:0; width:99.375%; width:-webkit-calc(100% - 2px); width:calc(100% - 2px);"><div style="padding:16px;"> <a href="https://www.instagram.com/p/BxzgRXqAKWD/" style=" background:#FFFFFF; line-height:0; padding:0 0; text-align:center; text-decoration:none; width:100%;" target="_blank"> <div style=" display: flex; flex-direction: row; align-items: center;"> <div style="background-color: #F4F4F4; border-radius: 50%; flex-grow: 0; height: 40px; margin-right: 14px; width: 40px;"></div> <div style="display: flex; flex-direction: column; flex-grow: 1; justify-content: center;"> <div style=" background-color: #F4F4F4; border-radius: 4px; flex-grow: 0; height: 14px; margin-bottom: 6px; width: 100px;"></div> <div style=" background-color: #F4F4F4; border-radius: 4px; flex-grow: 0; height: 14px; width: 60px;"></div></div></div><div style="padding: 19% 0;"></div> <div style="display:block; height:50px; margin:0 auto 12px; width:50px;"><svg width="50px" height="50px" viewBox="0 0 60 60" version="1.1" xmlns="https://www.w3.org/2000/svg" xmlns:xlink="https://www.w3.org/1999/xlink"><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g transform="translate(-511.000000, -20.000000)" fill="#000000"><g><path d="M556.869,30.41 C554.814,30.41 553.148,32.076 553.148,34.131 C553.148,36.186 554.814,37.852 556.869,37.852 C558.924,37.852 560.59,36.186 560.59,34.131 C560.59,32.076 558.924,30.41 556.869,30.41 M541,60.657 C535.114,60.657 530.342,55.887 530.342,50 C530.342,44.114 535.114,39.342 541,39.342 C546.887,39.342 551.658,44.114 551.658,50 C551.658,55.887 546.887,60.657 541,60.657 M541,33.886 C532.1,33.886 524.886,41.1 524.886,50 C524.886,58.899 532.1,66.113 541,66.113 C549.9,66.113 557.115,58.899 557.115,50 C557.115,41.1 549.9,33.886 541,33.886 M565.378,62.101 C565.244,65.022 564.756,66.606 564.346,67.663 C563.803,69.06 563.154,70.057 562.106,71.106 C561.058,72.155 560.06,72.803 558.662,73.347 C557.607,73.757 556.021,74.244 553.102,74.378 C549.944,74.521 548.997,74.552 541,74.552 C533.003,74.552 532.056,74.521 528.898,74.378 C525.979,74.244 524.393,73.757 523.338,73.347 C521.94,72.803 520.942,72.155 519.894,71.106 C518.846,70.057 518.197,69.06 517.654,67.663 C517.244,66.606 516.755,65.022 516.623,62.101 C516.479,58.943 516.448,57.996 516.448,50 C516.448,42.003 516.479,41.056 516.623,37.899 C516.755,34.978 517.244,33.391 517.654,32.338 C518.197,30.938 518.846,29.942 519.894,28.894 C520.942,27.846 521.94,27.196 523.338,26.654 C524.393,26.244 525.979,25.756 528.898,25.623 C532.057,25.479 533.004,25.448 541,25.448 C548.997,25.448 549.943,25.479 553.102,25.623 C556.021,25.756 557.607,26.244 558.662,26.654 C560.06,27.196 561.058,27.846 562.106,28.894 C563.154,29.942 563.803,30.938 564.346,32.338 C564.756,33.391 565.244,34.978 565.378,37.899 C565.522,41.056 565.552,42.003 565.552,50 C565.552,57.996 565.522,58.943 565.378,62.101 M570.82,37.631 C570.674,34.438 570.167,32.258 569.425,30.349 C568.659,28.377 567.633,26.702 565.965,25.035 C564.297,23.368 562.623,22.342 560.652,21.575 C558.743,20.834 556.562,20.326 553.369,20.18 C550.169,20.033 549.148,20 541,20 C532.853,20 531.831,20.033 528.631,20.18 C525.438,20.326 523.257,20.834 521.349,21.575 C519.376,22.342 517.703,23.368 516.035,25.035 C514.368,26.702 513.342,28.377 512.574,30.349 C511.834,32.258 511.326,34.438 511.181,37.631 C511.035,40.831 511,41.851 511,50 C511,58.147 511.035,59.17 511.181,62.369 C511.326,65.562 511.834,67.743 512.574,69.651 C513.342,71.625 514.368,73.296 516.035,74.965 C517.703,76.634 519.376,77.658 521.349,78.425 C523.257,79.167 525.438,79.673 528.631,79.82 C531.831,79.965 532.853,80.001 541,80.001 C549.148,80.001 550.169,79.965 553.369,79.82 C556.562,79.673 558.743,79.167 560.652,78.425 C562.623,77.658 564.297,76.634 565.965,74.965 C567.633,73.296 568.659,71.625 569.425,69.651 C570.167,67.743 570.674,65.562 570.82,62.369 C570.966,59.17 571,58.147 571,50 C571,41.851 570.966,40.831 570.82,37.631"></path></g></g></g></svg></div><div style="padding-top: 8px;"> <div style=" color:#3897f0; font-family:Arial,sans-serif; font-size:14px; font-style:normal; font-weight:550; line-height:18px;"> この投稿をInstagramで見る</div></div><div style="padding: 12.5% 0;"></div> <div style="display: flex; flex-direction: row; margin-bottom: 14px; align-items: center;"><div> <div style="background-color: #F4F4F4; border-radius: 50%; height: 12.5px; width: 12.5px; transform: translateX(0px) translateY(7px);"></div> <div style="background-color: #F4F4F4; height: 12.5px; transform: rotate(-45deg) translateX(3px) translateY(1px); width: 12.5px; flex-grow: 0; margin-right: 14px; margin-left: 2px;"></div> <div style="background-color: #F4F4F4; border-radius: 50%; height: 12.5px; width: 12.5px; transform: translateX(9px) translateY(-18px);"></div></div><div style="margin-left: 8px;"> <div style=" background-color: #F4F4F4; border-radius: 50%; flex-grow: 0; height: 20px; width: 20px;"></div> <div style=" width: 0; height: 0; border-top: 2px solid transparent; border-left: 6px solid #f4f4f4; border-bottom: 2px solid transparent; transform: translateX(16px) translateY(-4px) rotate(30deg)"></div></div><div style="margin-left: auto;"> <div style=" width: 0px; border-top: 8px solid #F4F4F4; border-right: 8px solid transparent; transform: translateY(16px);"></div> <div style=" background-color: #F4F4F4; flex-grow: 0; height: 12px; width: 16px; transform: translateY(-4px);"></div> <div style=" width: 0; height: 0; border-top: 8px solid #F4F4F4; border-left: 8px solid transparent; transform: translateY(-4px) translateX(8px);"></div></div></div></a> <p style=" margin:8px 0 0 0; padding:0 4px;"> <a href="https://www.instagram.com/p/BxzgRXqAKWD/" style=" color:#000; font-family:Arial,sans-serif; font-size:14px; font-style:normal; font-weight:normal; line-height:17px; text-decoration:none; word-wrap:break-word;" target="_blank">corne chocolate 買っちった</a></p> <p style=" color:#c9c8cd; font-family:Arial,sans-serif; font-size:14px; line-height:17px; margin-bottom:0; margin-top:8px; overflow:hidden; padding:8px 0 7px; text-align:center; text-overflow:ellipsis; white-space:nowrap;">@<a href="https://www.instagram.com/chroju/" style=" color:#c9c8cd; font-family:Arial,sans-serif; font-size:14px; font-style:normal; font-weight:normal; line-height:17px;" target="_blank"> chroju</a>がシェアした投稿 - <time style=" font-family:Arial,sans-serif; font-size:14px; line-height:17px;" datetime="2019-05-23T12:17:49+00:00">2019年 5月月23日午前5時17分PDT</time></p></div></blockquote> <script async src="//www.instagram.com/embed.js"></script>

つまりこういうことである。 Lily58 から数字列をザックリ削ったような形状の [Corne Chocolate](https://github.com/foostan/crkbd) を買ってしまった。キーマップを見てもらってもわかる通り、58キーだとちょろちょろ余ることもわかったし、42キーでも案外イケそうな気はしている。願わくば、これで End Game に至るといいのだが。

