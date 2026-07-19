---
layout: default
---

# **Sample Extraction**

<div></div>
Blind Rotationによってテスト多項式が回転できて以下のような状態になっている。

<div class="week5-note-card week5-card-side">
<p class="text-center"><MathInline expr="\text{RLWE}_{s'}(\Delta x^{-\hat{b}+\mathbf{\hat{a}s}}v)=\text{RLWE}_{s'}(\Delta(m+\mu_1x+\mu_2x^2+\dots+\mu_{n-1}x^{n-1}))"/></p>

<p class="text-center">この多項式の定数項mを暗号文の状態で取り出す。</p>
</div>

Blind Rotationによって得られた暗号文を$\text{RLWE}_{s'}(\Delta x^{-\hat{b}+\mathbf{\hat{a}s}}v)=(a'(x),b'(x))$とおき、

その平文を$\mu(x)=m+\mu_1x+\mu_2x^2+\dots+\mu_{n-1}x^{n-1}$

とすると、

$b'=b_0'+b_1'x +\dots+b_{n-1}'x^{n-1}$

$=a'(x)s'(x)+\Delta\mu+e$

$=(a'_0+a'_1x+\dots+a'_{n-1}x^{n-1})(s'_0+s'_1x+\dots+s'_{n-1}x^{n-1})$

$\;\;\;+\Delta(m+\mu_1x+\mu_2x^2+\dots+\mu_{n-1}x^{n-1})+(e_0+e_1x+\dots+e_{n-1}x^{n-1})$

3つ目の式を見ると、定数項には$\Delta m + e_0$が含まれている。

定数項$b'_0$は既に$m$を平文とするLWE暗号文の一部になっている!

→$b'_0$に対応する$\mathbf{as}$を$a'(x)s'(x)$から構成する！
