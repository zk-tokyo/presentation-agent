---
layout: default
---

# negacyclic性の利用

<div></div>

<div class="week5-note-card">
<p class="text-center" style="font-size: 1.5rem;">
<MathInline expr="a\ge n"/>のとき、<MathInline expr="x^a = -x^{a-n} \mod x^n+1"/>となり、符号が反転する（negacyclic性）
</p>
</div>

<p class="text-center" style="font-size: 1.5rem;">↓</p>

<div class="week5-note-card is-white">
<p class="text-center" style="font-size: 1.5rem;">
次数aの大きさによって<MathInline expr="x^a"/>は1と-1の2つの値を表現できる
</p>
</div>

<p class="text-center" style="font-size: 1.5rem;">↓</p>

<div class="week5-note-card">
<p class="text-center" style="font-size: 1.5rem;">
この性質をビット演算に使う
</p>
</div>

$v(x)=1+x+\cdots+x^{n-1} \mod x^n+1$のとき

$0\le i \le n-1$なら$\;\;x^{-i}v(x) \;\text{mod}\;x^n+1=1+x+\dots+x^{n-1-i}-x^{n-i}-x^{n-i+1}-\dots-x^{n-1} \mod x^n+1$

$n\le i \le 2n-1$なら$x^{-i}v(x) \;\text{mod}\;x^n+1=-1-x-\dots-x^{n-1-i}+x^{n-i}+x^{n-i+1}+\dots+x^{n-1} \mod x^n+1$
