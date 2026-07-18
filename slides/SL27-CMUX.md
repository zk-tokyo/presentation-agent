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

<p class="text-center">↓<MathInline expr="c_0=\text{RLWE}_{s}(a_0),c_1=\text{RLWE}_{s}(a_1), c_b=\text{RGSW}_{s}(b)"/>で置き換える</p>

<div class="week5-note-card week5-card-side">
<p class="text-center" style="font-size: 1.2rem;">
<MathInline expr="\text{CMUX}(c_b,c_0,c_1)=c_b\boxdot(c_1-c_0)+c_0=\text{RLWE}_{s}(a_b)"/>
</p>
</div>

<br>
<br>
<br>
<br>
<br>

> Q. CMUXの出力が$a_b$のRLWE暗号文になることを各自確認してみよう
