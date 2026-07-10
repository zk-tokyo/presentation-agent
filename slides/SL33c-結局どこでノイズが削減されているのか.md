---
layout: default
---

# 結局どこでノイズが削減されているのか

<div class="week5-boot-flow week5-noise-map">
  <svg class="week5-boot-flow-lines" viewBox="0 0 1120 270" aria-hidden="true">
    <defs>
      <marker id="noiseFlowArrow" markerWidth="11" markerHeight="8" refX="10" refY="4" orient="auto" markerUnits="userSpaceOnUse">
        <path d="M 0 0 L 11 4 L 0 8 z" fill="#17324d" />
      </marker>
      <marker id="noiseReductionArrow" markerWidth="13" markerHeight="10" refX="12" refY="5" orient="auto" markerUnits="userSpaceOnUse">
        <path d="M 0 0 L 13 5 L 0 10 z" fill="#d8c55f" />
      </marker>
    </defs>
    <path class="week5-noise-reduction-arrow" d="M 180 126 H 206" marker-end="url(#noiseReductionArrow)" />
    <path d="M 448 126 H 474" marker-end="url(#noiseFlowArrow)" />
    <path class="week5-noise-reduction-arrow" d="M 706 126 H 732" marker-end="url(#noiseReductionArrow)" />
    <path d="M 974 126 H 1000" marker-end="url(#noiseFlowArrow)" />
  </svg>

  <div class="week5-flow-band is-lwe-left">古い LWE 暗号文</div>
  <div class="week5-flow-band is-rlwe">Bootstrapping 中の処理</div>
  <div class="week5-flow-band is-lwe-right">新しい LWE 暗号文</div>

  <div class="week5-flow-node is-input">
    <div class="week5-flow-kicker">入力</div>
    <div class="week5-flow-main"><MathInline expr="\mathbf{a}\mathbf{s}+\Delta m+e_{\mathrm{old}}"/></div>
    <div class="week5-flow-sub">演算で溜まった <MathInline expr="e_{\mathrm{old}}"/> を含む</div>
  </div>

  <div class="week5-flow-node is-blind">
    <div class="week5-flow-step">1</div>
    <div class="week5-flow-title">Blind Rotation</div>
    <div class="week5-noise-reduction-badge">ノイズ削減ポイント</div>
    <div class="week5-flow-visual is-cmux-rotation-vertical">
      <div class="week5-plain-list">
        <span>m0</span><span>m1</span><span>m2</span><span class="is-target">m*</span>
      </div>
      <div class="week5-vertical-arrow">↓</div>
      <div class="week5-cmux-vertical-chain">
        <span class="week5-cmux-unit">CMUX</span>
        <span class="week5-cmux-arrow">↓</span>
        <span class="week5-cmux-ellipsis">...</span>
        <span class="week5-cmux-arrow">↓</span>
        <span class="week5-cmux-unit">CMUX</span>
      </div>
      <div class="week5-vertical-arrow">↓</div>
      <div class="week5-plain-list is-after">
        <span class="is-target">m*</span><span>m0</span><span>m1</span><span>m2</span>
      </div>
    </div>
  </div>

  <div class="week5-flow-node is-extract">
    <div class="week5-flow-step">2</div>
    <div class="week5-flow-title">Sample Extraction</div>
    <div class="week5-flow-visual is-extraction">
      <span class="week5-flow-coeff is-hit"><MathInline expr="b'_0"/></span>
      <span class="week5-flow-coeff"></span>
      <span class="week5-flow-coeff"></span>
      <span class="week5-flow-coeff"></span>
    </div>
    <div class="week5-noise-pill is-neutral">追加なし</div>
    <div class="week5-flow-sub">定数項を LWE 形式へ<br>持ち替える</div>
  </div>

  <div class="week5-flow-node is-key">
    <div class="week5-flow-step">3</div>
    <div class="week5-flow-title">Key Switching</div>
    <div class="week5-noise-reduction-badge">ノイズ削減ポイント</div>
    <div class="week5-flow-key-copy">
      <div><MathInline expr="\mathbf{a}'\mathbf{s}'+\Delta m+e_{\mathrm{br}}"/></div>
      <div class="week5-flow-key-copy-muted">から</div>
      <div><MathInline expr="\mathbf{a}\mathbf{s}+\mathbf{a}'\mathbf{s}'+e_{\mathrm{ks}}"/></div>
      <div class="week5-flow-key-copy-muted">を減算する</div>
    </div>
  </div>

  <div class="week5-flow-node is-output">
    <div class="week5-flow-kicker">出力</div>
    <div class="week5-flow-main"><MathInline expr="\mathbf{a}\mathbf{s}+\Delta m+e_{\mathrm{new}}"/></div>
    <div class="week5-flow-sub">同じ平文 <MathInline expr="m"/> に対する<br>よりノイズの少ない<br>暗号文になっている</div>
  </div>

</div>
