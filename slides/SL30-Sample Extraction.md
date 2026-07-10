---
layout: default
---

# **Sample Extraction**

<div></div>
Blind Rotationによってテスト多項式が回転できて以下のような状態になっている。

<div class="week5-note-card week5-card-side">
<p class="text-center"><MathInline expr="\text{RLWE}_{s'}(x^{-\hat{b}+\mathbf{\hat{a}s}}v)=\text{RLWE}_{s'}(m+mx^{m+e_j}+mx^{m+e_{j+1}}+\dots+(m+1)x^{m+1+e_0}+\dots)"/></p>

<p class="text-center">この多項式の定数項mを暗号文の状態で取り出す。</p>
</div>

Blind Rotationによって得られた暗号文を$\text{RLWE}_{s'}(x^{-\hat{b}+\mathbf{\hat{a}s}}v)=(a'(x),b'(x))$とおき、

その平文を$\mu = m+mx^{m+e_j}+mx^{m+e_{j+1}}+\dots+(m+1)x^{m+1+e_0}+\dots$

とすると、

$b'=b_0'+b_1'x +\dots+b_{n-1}'x^{n-1}$

$=a'(x)s'(x)+\Delta\mu+e$

$=(a'_0+a'_1x+\dots+a'_{n-1}x^{n-1})(s'_0+s'_1x+\dots+s'_{n-1}x^{n-1})$

$\;\;\;+\Delta( m+mx^{m+e_j}+mx^{m+e_{j+1}}+\dots+(m+1)x^{m+1+e_0}+\dots)$

$\;\;\;+(e_0+e_1x+\dots+e_{n-1}x^{n-1})$

3つ目の式を見ると、定数項には$\Delta m + e_0$が含まれている。

→定数項$b'_0$から、$m$を平文とするLWE暗号文を構成できる。
