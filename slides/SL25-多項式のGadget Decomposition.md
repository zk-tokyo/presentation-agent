---
layout: default
---

# 多項式のGadget Decomposition

<div></div>

多項式$f=a_0+a_1x+\dots+a_{n-1}x^{n-1}$のそれぞれの項$a_ix^i$について$g^{-1}(a_i)$を計算して、$\frac{q}{B^{i+1}}$について項をまとめ直し,

（すなわち$f=\Sigma_{i=0}^{l-1}f_i\frac{q}{B^{i+1}}$）、$g^{-1}(f)=(f_0,\dots,f_{l-1})$とする。

多項式のベクトル$\mathbf{f}=(f_0,f_1,\dots,f_{k-1})$に対しては$G^{-1}(\mathbf{f})=(g^{-1}(f_0),g^{-1}(f_1),\dots,g^{-1}(f_{k-1}))$

> 例：$\mathbb{Z}_{16}$上のモジュラス$x^3+1$の多項式に対して$B=2, l = 4$として，$f=15x^2+4x+7 \text{ mod }x^3+1$をGadget Decompositionをする。
>
> まずそれぞれの係数に対してGadget Decompositionすると  
> $g^{-1}(15)=1\frac{16}{2}+1\frac{16}{4}+1\frac{16}{8}+1\frac{16}{16}$  
> $g^{-1}(4)=0\frac{16}{2}+1\frac{16}{4}+0\frac{16}{8}+0\frac{16}{16}$  
> $g^{-1}(7)=0\frac{16}{2}+1\frac{16}{4}+1\frac{16}{8}+1\frac{16}{16}$  
> これを$f$に代入して$\frac{16}{2^i}$ごとに整理すると  
> $f=(1\frac{16}{2}+1\frac{16}{4}+1\frac{16}{8}+1\frac{16}{16})x^2+(0\frac{16}{2}+1\frac{16}{4}+0\frac{16}{8}+0\frac{16}{16})x+0\frac{16}{2}+1\frac{16}{4}+1\frac{16}{8}+1\frac{16}{16}$  
> $\;=x^2\frac{16}{2}+(x^2+x+1)\frac{16}{4}+(x^2+1)\frac{16}{8}+(x^2+1)\frac{16}{16}$  
> ゆえに、  
> $g^{-1}(f)=(x^2,x^2+x+1,x^2+1,x^2+1)$
