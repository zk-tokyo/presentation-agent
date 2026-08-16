---
layout: default
---

# Bootstrappingの流れのまとめ

<div class="week5-boot-flow">
  <svg class="week5-boot-flow-lines" viewBox="0 0 1120 270" aria-hidden="true">
    <defs>
      <marker id="bootArrow" markerWidth="11" markerHeight="8" refX="10" refY="4" orient="auto" markerUnits="userSpaceOnUse">
        <path d="M 0 0 L 11 4 L 0 8 z" fill="#17324d" />
      </marker>
    </defs>
    <path d="M 180 126 H 206" marker-end="url(#bootArrow)" />
    <path d="M 448 126 H 474" marker-end="url(#bootArrow)" />
    <path d="M 706 126 H 732" marker-end="url(#bootArrow)" />
    <path d="M 974 126 H 1000" marker-end="url(#bootArrow)" />
  </svg>

  <div class="week5-flow-band is-lwe-left">LWE 暗号文</div>
  <div class="week5-flow-band is-rlwe">RLWE の世界で多項式を動かす</div>
  <div class="week5-flow-band is-lwe-right">LWE 暗号文</div>

  <div class="week5-flow-node is-input">
    <div class="week5-flow-kicker">入力</div>
    <div class="week5-flow-main"><MathInline expr="\mathrm{LWE}_{\mathbf{s}}(\Delta m)"/></div>
    <div class="week5-flow-sub">係数 <MathInline expr="(\mathbf{a},b)"/> の中に<br><MathInline expr="\Delta m"/> と古いノイズ <MathInline expr="e"/> が混ざっている</div>
  </div>

  <div class="week5-flow-node is-blind">
    <div class="week5-flow-step">1</div>
    <div class="week5-flow-title">Blind Rotation</div>
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
    <div class="week5-flow-sub">CMUX を連結してリストを回し、目的の平文が先頭に来る状態を作る</div>
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
    <div class="week5-flow-sub">定数項を LWE 暗号文として<br>切り出す</div>
  </div>

  <div class="week5-flow-node is-key">
    <div class="week5-flow-step">3</div>
    <div class="week5-flow-title">Key Switching</div>
    <div class="week5-flow-key-copy">
      <div style="font-size: 1rem;"><MathInline expr="\mathbf{a}'\mathbf{s}'+\Delta m+e_0"/></div>
      <div class="week5-flow-key-copy-muted">から</div>
      <div style="font-size: 1rem;"><MathInline expr="\mathbf{a}\mathbf{s}+\mathbf{a}'\mathbf{s}'+e"/></div>
      <div class="week5-flow-key-copy-muted">を減算する</div>
      <div class="week5-flow-key-copy-em">共通する <MathInline expr="\mathbf{a}'\mathbf{s}'"/> を消す</div>
    </div>
  </div>

  <div class="week5-flow-node is-output">
    <div class="week5-flow-kicker">出力</div>
    <div class="week5-flow-main"><MathInline expr="\mathrm{LWE}_{\mathbf{s}}(\Delta m)"/></div>
    <div class="week5-flow-sub">同じ平文 <MathInline expr="m"/> を持つが、<br>新しい暗号文として<br>作り直されている</div>
  </div>

</div>
