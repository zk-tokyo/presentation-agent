---
layout: default
class: text-[0.9rem]
---

# HomNANDの流れ

<div></div>

<div class="mt-3 space-y-2 text-[0.94rem] leading-relaxed">
  <div class="week5-note-card week5-card-side is-white" style="padding: 9px 14px;">
    <div class="font-bold mb-1">1. 入力bitのエンコードと暗号化</div>
    <div><MathInline expr="0\mapsto p-1=7,\quad1\mapsto1"/>とエンコードする</div>
    <div><MathInline expr="c_1=\mathrm{LWE}_{\mathbf{s}}(m_1),\quad c_2=\mathrm{LWE}_{\mathbf{s}}(m_2)"/>と暗号化</div>
  </div>

  <div class="text-center text-lg leading-none">↓</div>

  <div class="week5-note-card week5-card-side" style="padding: 9px 14px;">
    <div class="font-bold mb-1">2. 前処理</div>
    <div><MathInline expr="c=\mathrm{LWE}_{\mathbf{s}}(1)-c_1-c_2"/></div>
    <div>平文は<MathInline expr="r=1-m_1-m_2\pmod p"/>、回転の番号は<MathInline expr="i=b-\mathbf{a}\mathbf{s}\pmod q"/>になる</div>
  </div>

  <div class="text-center text-lg leading-none">↓</div>

  <div class="week5-note-card week5-card-side is-white" style="padding: 9px 14px;">
    <div class="font-bold mb-1">3. Blind Rotation</div>
    <div><MathInline expr="q=2N=32"/>なので、<MathInline expr="i"/>をそのままテスト多項式の回転量として使う</div>
    <div>全係数が<MathInline expr="1"/>のテスト多項式を、暗号文のまま<MathInline expr="x^{-i}"/>倍する</div>
  </div>

  <div class="text-center text-lg leading-none">↓</div>

  <div class="week5-note-card week5-card-side" style="padding: 9px 14px; margin-right: 128px;">
    <div class="font-bold mb-1">4. Sample ExtractionとKey Switching</div>
    <div>回転後の定数項をLWE暗号文として取り出し、元のLWE秘密鍵に対応する暗号文へ変換する</div>
    <div>出力は<MathInline expr="\mathrm{LWE}_{\mathbf{s}}(1)"/>または<MathInline expr="\mathrm{LWE}_{\mathbf{s}}(p-1)"/>となり、そのまま次のHomNANDへ渡せる</div>
  </div>
</div>
