---
layout: center
class: section-slide section-2
---

# Part 2: MPC の問題設定

<ChapterMap :current="2" />

<!-- ## 目的

導入例で作った直感を、MPC の標準的な問題設定に落とし込む。 -->

---
layout: default
class: ttp-slide
---

# Trusted Third Party の理想世界

まず、理想的には次のような信頼できる第三者 T がいれば簡単である。

<div class="ttp-model" aria-label="Trusted Third Party に入力を集める理想世界">
  <div class="ttp-parties">
    <div><b>P1</b><span>入力 x1</span></div>
    <div><b>P2</b><span>入力 x2</span></div>
    <div><b>Pn</b><span>入力 xn</span></div>
  </div>
  <div class="model-arrow"><span>入力を送る</span>→</div>
  <div class="ttp-center"><small>TRUSTED THIRD PARTY</small><b>T</b><span>y = f(x1, ..., xn)</span><em>入力を漏らさない</em></div>
  <div class="model-arrow"><span>y だけ返す</span>→</div>
  <div class="model-output"><small>OUTPUT</small><b>y</b><span>決められた相手へ</span></div>
</div>

この T が約束どおりに振る舞うなら、各 パーティ は互いに入力を明かさず、決められた出力 y だけを得られる。

しかし、T には全員の入力が集まる。現実には T を完全に信用できず、次のように振る舞うかもしれない。

<div class="ttp-risks">
  <span>入力を外部に漏らす</span>
  <span>入力を目的外利用する</span>
  <span>特定の パーティ と結託する</span>
  <span>結果を改ざんする・返さない</span>
</div>

<p class="model-conclusion">MPC は、T に全ての入力を預けず、T が行うはずだった計算を パーティ 間のプロトコルで実現しようとする。</p>

---
layout: default
class: definition-slide mpc-definition-slide
---

# MPC の直感的な定義

MPC は、複数の パーティ がそれぞれ秘密の入力を持つとき、入力を互いに明かさずに、共同で関数の出力だけを得るためのプロトコルである。

<div class="mpc-model" aria-label="信頼できる第三者を置かずに共同計算する図">
  <div class="mpc-party"><b>P1</b><span>input x1</span><small>入力は手元に残す</small></div>
  <div class="mpc-party"><b>P2</b><span>input x2</span><small>入力は手元に残す</small></div>
  <div class="mpc-party"><b>…</b><span>messages</span><small>party 間で通信</small></div>
  <div class="mpc-party"><b>Pn</b><span>input xn</span><small>入力は手元に残す</small></div>
  <div class="mpc-protocol"><small>NO TRUSTED THIRD PARTY</small><b>MPC protocol</b><span>y = f(x1, x2, ..., xn)</span></div>
  <div class="mpc-output"><small>OUTPUT</small><b>y だけを得る</b><span>各 xi は隠す</span></div>
</div>

<p class="central-question">信頼できる第三者に入力を集めずに、どうやって共同で y = f(x1, ..., xn) を計算するか？</p>

具体的な実現方法は一旦脇に置いておいて、MPCを構成、規定していく上でどのようなことを考えるのか？について話していく。

---
layout: two-cols-header
class: dense-two-col basic-setting
---

::left::

# 基本設定

n 人の party が、それぞれ秘密の入力を持っている。

<div class="setting-inputs">
  <span><b>P1</b> input x1</span>
  <span><b>P2</b> input x2</span>
  <span><b>…</b></span>
  <span><b>Pn</b> input xn</span>
</div>

<div class="setting-formula"><small>全員で関数 f を計算する</small><b>y = f(x1, x2, ..., xn)</b></div>

::right::

<div class="setting-layers">
  <div class="setting-core">
    <div class="setting-label">まず押さえる4つ</div>
    <ul>
      <li><b>誰が参加するか</b><span>（party）</span></li>
      <li><b>各 party が何を持つか</b><span>（input）</span></li>
      <li><b>何を計算するか</b><span>（function）</span></li>
      <li><b>誰が結果を受け取るか</b><span>（output）</span></li>
    </ul>
  </div>

  <div class="setting-later">
    <div class="setting-label">このあと扱う設計条件</div>
    <ul>
      <li>何人まで不正でもよいか <span>（corruption threshold）</span></li>
      <li>不正 party をどう想定するか <span>（adversary model）</span></li>
      <li>途中停止をどう扱うか <span>（abort / availability）</span></li>
      <li>出力から何が分かるか <span>（output leakage）</span></li>
      <li>どこにコストがかかるか <span>（通信・計算・前処理）</span></li>
    </ul>
  </div>
</div>

---
layout: default
class: security-properties
---

# MPC が守りたい性質

MPC では、主に次の性質を考える。

## Correctness

与えられた入力に対して、仕様どおりの出力が得られること。

```text
protocol output = f(x1, x2, ..., xn)
```

## Privacy

各 party の入力について、許された出力から分かる以上の情報が漏れないこと。

攻撃者が支配する party 群がプロトコル中に見た情報からも、許された範囲を超えて他の入力を推測できないことを目指す。

直感的には、ある party がプロトコル中に見たものが、自分の入力と最終出力だけから作れそうなら、余計な情報は漏れていないと考える。

## Robustness

一部の party が壊れたり、途中で止まったり、不正なメッセージを送ったりしたときに、プロトコルがどう振る舞うか。

---
layout: default
class: leakage-slide
---

# MPC が保証しないこと

## Output leakage

MPC を説明するときに重要なのは、「入力が漏れない」という言葉を強く言いすぎないことである。

MPC は、プロトコル中に見える情報を制限する。

しかし、出力そのものから分かる情報は隠せない。

例えば、3人の給与平均を公開する場合を考える。

```text
average = 1000万円
```

自分の給与と、もう1人の給与をすでに知っているなら、残り1人の給与は計算できてしまう。

これはプロトコルの失敗ではない。

出力として平均を公開すると決めた時点で、その出力から推測できる情報は漏れる。

したがって、MPC の設計では次の問いが重要になる。

```text
この出力を公開してよいか？
この出力から個別入力が推測されないか？
推測されるとして、それは許容できるか？
```

---
layout: default
class: security-warning
---

# 入力の正しさは別問題

MPC は、入力を隠したまま計算する技術である。

しかし、入力が現実に正しいかどうかは別問題である。

例えば、給与平均では、誰かが嘘の給与を入力するかもしれない。

投票では、資格のない人が入力するかもしれない。

金融や広告の共同集計では、party が不正なデータを入れるかもしれない。

この問題を扱うには、次のような追加の仕組みが必要になる。

- 入力検証
- 監査
- コミットメント
- ZK proof
- 外部認証
- データガバナンス

この区別は、MPC と ZK の使い分けにつながる。

```text
MPC:
  隠したまま共同計算する

ZK:
  隠した情報が条件を満たすことを証明する
```
