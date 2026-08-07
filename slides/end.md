---
layout: default
class: summary-slide
---

# 講義のまとめ

MPC は、信頼できる第三者を置かずに、複数 party が秘密入力を持ったまま共同で関数を計算する技術である。

秘密分散を使うと、secret を share に分けたまま扱える。

share 上では、加算・減算のような線形演算は軽い。

一方で、乗算には通信や前処理が必要になり、比較・ソート・条件分岐はさらに重くなる。

実用では、次を必ず設計する必要がある。

```text
party は誰か？
input は何か？
function は何か？
output は誰が知るか？
何人まで壊れてよいか？
semi-honest でよいか、malicious が必要か？
party が途中で止まった場合どうするか？
出力から何が漏れるか？
入力の正しさはどう保証するか？
現実の値をどう表現するか？
どの演算が重くなるか？
generic MPC で解くべきか、special-purpose MPC を探すべきか？
MPC である必要があるか？
```

次のホワイトボードセッションでは、この観点を使って具体的な応用を設計する。

---
layout: default
class: dex-architecture
---

# ホワイトボードセッション：Private DEX を設計する

<p class="dex-lead">複数のトレーダーが、注文内容を公開せずに指値注文を突き合わせる分散型取引所 (DEX) を設計する。</p>

<div class="dex-flow" aria-label="Private DEX における注文の処理段階と、各段階で見える情報">
  <div class="dex-row">
    <div class="dex-stage dex-stage-public">
      <b>トレーダー</b>
      <span>署名済み注文を share に分割して送信</span>
    </div>
    <div class="dex-link" aria-hidden="true"></div>
    <div class="dex-knowledge">自分の注文だけを知る</div>
  </div>

  <div class="dex-row">
    <div class="dex-stage dex-stage-secret">
      <b>MPC ノード委員会</b>
      <span>ノード数・許容結託数は設計事項</span>
    </div>
    <div class="dex-link" aria-hidden="true"></div>
    <div class="dex-knowledge">各ノードは share のみ保持する</div>
  </div>

  <div class="dex-row">
    <div class="dex-stage dex-stage-decision">
      <b>マッチング ?</b>
      <span>規則・粒度・公平性は設計事項</span>
    </div>
    <div class="dex-link" aria-hidden="true"></div>
    <div class="dex-knowledge">何を output として開示するかも決める</div>
  </div>

  <div class="dex-row">
    <div class="dex-stage dex-stage-public">
      <b>決済コントラクト</b>
      <span>注文条件と署名を再検証して交換</span>
    </div>
    <div class="dex-link" aria-hidden="true"></div>
    <div class="dex-knowledge">約定注文を平文で受理する（ZK なし）</div>
  </div>

  <div class="dex-row">
    <div class="dex-stage dex-stage-public">
      <b>オンチェーン</b>
      <span>約定内容は公開される</span>
    </div>
    <div class="dex-link" aria-hidden="true"></div>
    <div class="dex-knowledge">誰でも観測でき、履歴を蓄積できる</div>
  </div>
</div>

<div class="dex-legend" aria-label="色の説明">
  <span><i class="dex-swatch dex-swatch-public"></i>公開・参加者が知る領域</span>
  <span><i class="dex-swatch dex-swatch-secret"></i>秘密計算領域</span>
  <span><i class="dex-swatch dex-swatch-decision"></i>グループが設計する箇所</span>
</div>

<div class="dex-task">
  <div>
    <b>グループで設計すること</b>
    <span>① ノード構成・adversary　② 価格・数量・優先順位・部分約定　③ output　④ 署名・nonce・取消・abort　⑤ MPC とオンチェーンの処理分担</span>
  </div>
  <div class="dex-task-timing">
    <b>成果物：</b>設計シート1枚＋3分発表　
    <b>進行：</b>作業75分 / 発表15分 / フィードバック15分 / バッファ15分
  </div>
</div>
