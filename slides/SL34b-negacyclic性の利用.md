---
layout: default
---

# negacyclic性の利用

<div></div>

<!--
 <div class="week5-note-card">
<p class="text-center" style="font-size: 1.25rem;">
<MathInline expr="x^{a}\equiv
\begin{cases}
x^{a} & (0\le a<n),\\
-x^{a-n} & (n\le a<2n)
\end{cases}
\pmod{x^n+1}"/>となり、<MathInline expr="a"/>が<MathInline expr="n"/>をまたぐと符号が反転する（negacyclic性）
</p>
</div>

<p class="text-center" style="font-size: 1.25rem;">↓</p>
-->

<div class="week5-note-card">
<p class="text-center" style="font-size: 1.25rem;">
<MathInline expr="x^{-i}"/>をv(x)にかけたときの定数項は正と負の2つの値を表現できる<br>
→この性質をbit演算に利用する
</p>
</div>

$v(x)=1+x+\cdots+x^{n-1} \mod x^n+1$に対し、

### $0\le i \le n-1$のとき

$x^{-i}v(x) \;\text{mod}\;x^n+1=1+x+\dots+x^{n-1-i}-x^{n-i}-x^{n-i+1}-\dots-x^{n-1} \mod x^n+1$


### $n\le i \le 2n-1$のとき

$i = n + i'\quad(0\le i' < n)$とすると、$x^{-n}=-1 \mod x^n+1$より

$x^{-i}v(x) \mod x^n+1$

$=x^{-n-i'}v(x) \mod x^n+1$

$=-x^{-i'}(1+x+\cdots+x^{n-1}) \mod x^n+1$


$=x^{-i'}(-1-x-\cdots-x^{n-1}) \mod x^n+1$

$=-1-x-\dots-x^{n-1-i'}+x^{n-i'}+x^{n-i'+1}+\dots+x^{n-1} \mod x^n+1$
