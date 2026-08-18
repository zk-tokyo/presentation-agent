---
layout: default
---

# **Blind Rotation**

## 平文の状態での$x^{-b+\mathbf{as}}v\;\text{mod}\;x^n+1$の求め方

<div class="week5-note-card" style="width: 47%;">
<p style="font-size: 1.2rem;"><MathInline expr="\mathbf{as}"/>の計算には秘密鍵の情報が必要になってしまう<br>
→マルチプレクサを利用する</p>
</div>

<div class="week5-html-diagram is-mux-comparison" style="right: 42px; top: 122px; width: 600px; height: 188px;">
  <div class="week5-diagram-label" style="left: 20px; top:-30px;"><MathInline expr="\text{MUX}(b,a_0,a_1)=b(a_1-a_0)+a_0"/></div>
  <div class="week5-diagram-label" style="left: 2px; top: 24px;"><MathInline expr="a_0"/></div>
  <div class="week5-diagram-label" style="left: 2px; top: 80px;"><MathInline expr="a_1"/></div>
  <div class="week5-mux-gate is-large" style="left: 88px; top: 14px;"><span>MUX</span></div>
  <div class="week5-diagram-label" style="left: 187px; top: 62px;"><MathInline expr="a_b"/></div>
  <div class="week5-diagram-label" style="left: 104px; top: 164px;"><MathInline expr="b"/></div>
  <div class="week5-diagram-line has-arrow" style="left: 32px; top: 37px; width: 55px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 32px; top: 93px; width: 55px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 144px; top: 66px; width: 40px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 116px; top: 151px; width: 18px; transform: rotate(-90deg);"></div>

  <div class="blind-gate-divider" aria-hidden="true"></div>

  <div class="week5-diagram-label" style="left: 320px; top: -30px;"><MathInline expr="\text{CMUX}(c_b,c_0,c_1)=c_b\boxdot(c_1-c_0)+c_0"/></div>
  <div class="week5-diagram-label" style="left: 300px; top: 24px;"><MathInline expr="\mathrm{RLWE}(\Delta a_0)"/></div>
  <div class="week5-diagram-label" style="left: 300px; top: 80px;"><MathInline expr="\mathrm{RLWE}(\Delta a_1)"/></div>
  <div class="week5-mux-gate is-cmux is-large" style="left: 444px; top: 14px;"><span>CMUX</span></div>
  <div class="week5-diagram-label" style="left: 522px; top: 62px;"><MathInline expr="\mathrm{RLWE}(\Delta a_b)"/></div>
  <div class="week5-diagram-label" style="left: 422px; top: 164px;"><MathInline expr="\mathrm{RGSW}(b)"/></div>
  <div class="week5-diagram-line has-arrow" style="left: 397px; top: 37px; width: 46px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 397px; top: 93px; width: 46px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 500px; top: 66px; width: 20px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 472px; top: 151px; width: 18px; transform: rotate(-90deg);"></div>
</div>

<div class="blind-rotation-blocks absolute left-[54px] top-[324px] w-[1160px]">
  <section class="blind-rotation-block">
    <div class="blind-block-kicker">1　漸化式にする</div>
    <div class="blind-vector-definition">
      <MathInline expr="\mathbf a=(a_0,\ldots,a_{k-1}),\quad \mathbf s=(s_0,\ldots,s_{k-1})" />
    </div>
    <p><MathInline expr="\mathbf{as}=\sum_{i=0}^{k-1}a_is_i" /> と表せるので、</p>
    <div class="blind-equation">
      <MathBlock expr="x^{-b+\mathbf{as}}v=x^{a_{k-1}s_{k-1}}\left(x^{-b+\sum_{i=0}^{k-2}a_is_i}v\right)" />
    </div>
    <p><MathInline expr="Q_k:=x^{-b+\sum_{i=0}^{k-1}a_is_i}v" />、<MathInline expr="Q_0=x^{-b}v" /> とおく。</p>
    <div class="blind-equation is-recurrence">
      <MathBlock expr="Q_{j+1}=x^{a_js_j}Q_j=\begin{cases}Q_j &amp; (s_j=0)\\x^{a_j}Q_j &amp; (s_j=1)\end{cases}" />
    </div>
  </section>

  <div class="blind-block-arrow" aria-hidden="true">→</div>

  <section class="blind-rotation-block is-result">
    <div class="blind-block-kicker">2　MUXで反復する</div>
    <p>よって <MathInline expr="x^{-b+\mathbf{as}}v\bmod(x^n+1)" /> は、MUXを利用して次のように計算できる。</p>
    <ul class="blind-algorithm">
      <li><MathInline expr="Q_0\gets x^{-b}v" /></li>
      <li>
        <span>for <MathInline expr="j=0,\ldots,k-1" /></span>
        <div><MathInline expr="Q_{j+1}\gets\mathrm{MUX}(s_j,Q_j,x^{a_j}Q_j)" /></div>
      </li>
      <li>return <MathInline expr="Q_k\;(=x^{-b+\mathbf{as}}v)" /></li>
    </ul>
    <p class="blind-result-note"><MathInline expr="v,s_j,Q_j,x^{a_j}Q_j" /> を暗号文にし、準同型演算で記述する。</p>
  </section>
</div>

<style>
.blind-gate-divider {
  position: absolute;
  left: 274px;
  top: 10px;
  width: 1px;
  height: 160px;
  background: #e0e0e0;
}

.blind-rotation-blocks {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 40px minmax(0, 1fr);
  align-items: stretch;
}

.blind-rotation-block {
  min-height: 286px;
  padding: 15px 18px 13px;
  border-top: 3px solid #17324d;
  background: #fafafa;
  color: #111827;
}

.blind-rotation-block.is-result {
  border-top-color: #2c627d;
  background: #f2f7fc;
}

.blind-block-kicker {
  margin-bottom: 9px;
  font-size: 20px;
  font-weight: 700;
  color: #17324d;
}

.blind-rotation-block p {
  margin: 5px 0;
  font-size: 18px;
  line-height: 1.38;
}

.blind-vector-definition {
  margin-bottom: 5px;
  font-size: 17px;
  white-space: nowrap;
}

.blind-equation {
  margin: 5px 0 4px;
  font-size: 16px;
  overflow-x: visible;
}

.blind-equation.is-recurrence {
  margin-top: 2px;
  font-size: 17px;
}

.blind-equation .katex-display {
  margin: 0;
}

.blind-block-arrow {
  display: grid;
  place-items: center;
  font-size: 30px;
  color: #17324d;
}

.blind-algorithm {
  margin: 8px 0 7px;
  padding-left: 25px !important;
}

.blind-algorithm li {
  margin: 3px 0;
  font-size: 18px;
  line-height: 1.35;
}

.blind-algorithm li > div {
  margin: 3px 0 0 20px;
}

.blind-result-note {
  margin-top: 10px !important;
  padding-top: 8px;
  border-top: 1px solid #c9d8ea;
}
</style>
