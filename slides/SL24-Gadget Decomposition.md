---
layout: default
---

# **Gadget Decomposition**

<div></div>

10進数と2進数の変換を思い出す。例：$19 = 1\cdot 2^4+0\cdot2^3+0\cdot2^2+1\cdot2^1+1$。  
これと似たようなことを整数の剰余に対してやるのがGadget Decomposition。 すなわち、

<div class="week5-note-card week5-card-side">
<p style="font-size: 1.2rem;">mod q上のある値rに対して、基数Bを用いて<MathInline expr="r = \Sigma_{i=0}^{l-1} r_i\frac{q}{B^{i+1}}\;\;(0\le r_i < B)"/>と表し、<MathInline expr="g^{-1}(r)=(r_0,r_1,\dots,r_{l-1})"/>を出力する</p>
</div>

ベクトル$\mathbf{r}=(r_0,\dots,r_k)$に対しては$G^{-1}(\mathbf{r})=(g^{-1}(r_0),\dots,g^{-1}(r_k))$とする。

> 例：$B=4,l=3$とすると，$\mathbb{Z}_{64}$上の値47のGadget Decompositionは， $47=2\frac{64}{4}+3\frac{64}{16}+3\frac{64}{64}$より、$g^{-1}(47)=(2,3,3)$

<br>

> note:
> $r_i$の範囲はノイズ管理の面で$-\lfloor B/2 \rfloor \le r_i < \lceil B/2 \rceil$とすることがある。($\lfloor a\rfloor$は切り下げ、$\lceil a\rceil$は切り上げ)
