---
layout: default
---

# $v(x)$の構成

<div></div>

平文$m$に対するLWE暗号文$(\mathbf{a},b)$は$b-\mathbf{as}=\Delta m+e \pmod q$を満たす。

まず、$q$個の係数を持つ多項式を使えるなら、ノイズ$e$が取りうる値をすべて並べて

$v_q(x)=\sum_{m\in\mathbb{Z}_p}\sum_e m x^{\Delta m+e}\text{ mod }{x^q+1}$

$\quad\quad\;\; = m_0x^{\Delta m_0+e_0}+m_0x^{\Delta m_0+e_1}+\dots+m_1x^{\Delta m_1+e_0}+m_1x^{\Delta m_1+e_1}+\dots \text{ mod }x^q+1$

とすれば、$x^{-(b-\mathbf{as})}v_q(x)=x^{\Delta m + e}v(x)$の定数項に$m$がくる。

ただし実用的なパラメータでは$q$が大きすぎるため、多項式の次数は$q$より小さい$2n$にし、$\mathbf{a}$と$b$も$2n$に合わせて変換する（リスケーリング）

> 例：平文$0,1,2$に対応する係数を4つずつ並べるなら  
> $v(x)=0(1+x+x^2+x^3)+1(x^4+x^5+x^6+x^7)+2(x^8+x^9+x^{10}+x^{11})+\cdots$
