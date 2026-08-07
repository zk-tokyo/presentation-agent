---
layout: default
---

# CMUX

## CMUX

$a_0,a_1\in\{0,1\}$に対して、ビット$b$によってどちらかを指定するマルチプレクサ$\text{MUX}(b,a_0,a_1)=a_b$を暗号文の状態で行うCMUXが構成可能

<div class="week5-note-card week5-card-side is-white">
<p class="text-center" style="font-size: 1.2rem;">
<MathInline expr="\text{MUX}(b,a_0,a_1)=(1-b)a_0+ba_1=b(a_1-a_0)+a_0"/>
</p>
</div>

<p class="text-center">↓<MathInline expr="c_0=\text{RLWE}_{s}(\Delta a_0),c_1=\text{RLWE}_{s}(\Delta a_1), c_b=\text{RGSW}_{s}(b)"/>で置き換える</p>

<div class="week5-note-card week5-card-side">
<p class="text-center" style="font-size: 1.2rem;">
<MathInline expr="\text{CMUX}(c_b,c_0,c_1)=c_b\boxdot(c_1-c_0)+c_0=\text{RLWE}_{s}(\Delta a_b)"/>
</p>
</div>

<div class="cmux-reference-diagram" style="left: 340px; top: 444px; width: 600px; height: 178px;">
  <div class="cmux-reference-gate" aria-hidden="true"><div></div></div>
  <div class="cmux-reference-title">CMUX</div>

  <div class="cmux-reference-label is-a0"><MathInline expr="\mathrm{RLWE}(\Delta a_0)" /></div>
  <div class="cmux-reference-label is-a1"><MathInline expr="\mathrm{RLWE}(\Delta a_1)" /></div>
  <div class="cmux-reference-label is-output"><MathInline expr="\mathrm{RLWE}(\Delta a_b)" /></div>
  <div class="cmux-reference-label is-control"><MathInline expr="\mathrm{RGSW}(b)" /></div>

  <div class="cmux-reference-wire is-a0-wire"></div>
  <div class="cmux-reference-wire is-a0-drop has-arrow-down"></div>
  <div class="cmux-reference-wire is-a0-branch has-arrow-down"></div>
  <div class="cmux-reference-wire is-a1-wire has-arrow-right"></div>
  <div class="cmux-reference-wire is-difference-wire has-arrow-right"></div>
  <div class="cmux-reference-wire is-product-wire"></div>
  <div class="cmux-reference-wire is-product-rise has-arrow-up"></div>
  <div class="cmux-reference-wire is-output-wire has-arrow-right"></div>
  <div class="cmux-reference-wire is-control-wire has-arrow-up"></div>

  <div class="cmux-reference-minus">−</div>
  <div class="cmux-reference-product">•</div>
  <div class="cmux-reference-plus">+</div>
</div>

<style>
.cmux-reference-diagram {
  position: absolute;
  color: #000000;
}

.cmux-reference-gate {
  position: absolute;
  left: 154px;
  top: 18px;
  width: 286px;
  height: 150px;
  background: #eadf9e;
  clip-path: polygon(0 0, 100% 24%, 100% 76%, 0 100%);
}

.cmux-reference-gate > div {
  position: absolute;
  inset: 1.5px;
  background: #ffffff;
  clip-path: polygon(0 0, 100% 24%, 100% 76%, 0 100%);
}

.cmux-reference-title {
  position: absolute;
  left: 257px;
  top: 0;
  z-index: 3;
  font-size: 0.9rem;
}

.cmux-reference-label {
  position: absolute;
  z-index: 3;
  font-size: 0.82rem;
  white-space: nowrap;
}

.cmux-reference-label.is-a0 { left: 0; top: 43px; }
.cmux-reference-label.is-a1 { left: 0; top: 116px; }
.cmux-reference-label.is-output { left: 474px; top: 82px; }
.cmux-reference-label.is-control { left: 249px; top: 158px; }

.cmux-reference-wire {
  position: absolute;
  z-index: 2;
  height: 1.4px;
  background: #2a7f90;
  transform-origin: left center;
}

.cmux-reference-wire.is-a0-wire { left: 112px; top: 55px; width: 254px; }
.cmux-reference-wire.is-a0-drop { left: 366px; top: 55px; width: 33px; transform: rotate(90deg); }
.cmux-reference-wire.is-a0-branch { left: 225px; top: 55px; width: 59px; transform: rotate(90deg); }
.cmux-reference-wire.is-a1-wire { left: 112px; top: 114px; width: 97px; }
.cmux-reference-wire.is-difference-wire { left: 229px; top: 114px; width: 55px; }
.cmux-reference-wire.is-product-wire { left: 316px; top: 114px; width: 50px; }
.cmux-reference-wire.is-product-rise { left: 366px; top: 114px; width: 26px; transform: rotate(-90deg); }
.cmux-reference-wire.is-output-wire { left: 383px; top: 88px; width: 84px; }
.cmux-reference-wire.is-control-wire { left: 303px; top: 157px; width: 29px; transform: rotate(-90deg); }

.cmux-reference-wire.has-arrow-right::after,
.cmux-reference-wire.has-arrow-up::after,
.cmux-reference-wire.has-arrow-down::after {
  content: "";
  position: absolute;
  right: -6px;
  top: 50%;
  width: 7px;
  height: 8px;
  background: #2a7f90;
  clip-path: polygon(0 0, 100% 50%, 0 100%);
  transform: translateY(-50%);
}

.cmux-reference-minus,
.cmux-reference-plus {
  position: absolute;
  z-index: 3;
  display: grid;
  place-items: center;
  width: 20px;
  height: 20px;
  background: #ffffff;
  font-size: 1.1rem;
  line-height: 1;
}

.cmux-reference-minus { left: 207px; top: 104px; }
.cmux-reference-plus { left: 365px; top: 78px; }

.cmux-reference-product {
  position: absolute;
  left: 286px;
  top: 102px;
  z-index: 3;
  display: grid;
  place-items: center;
  width: 22px;
  height: 22px;
  border: 1.3px solid #17324d;
  background: #ffffff;
  font-size: 0.78rem;
  line-height: 1;
}
</style>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

> Q. CMUXの出力が$a_b$のRLWE暗号文になることを各自確認してみよう
