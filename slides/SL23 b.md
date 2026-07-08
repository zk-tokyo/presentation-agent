---
layout: default
---

# **Sample Extraction**
<div></div>


$x^n \;\text{mod}\;x^n+1 = -1$に注意すると、

$\Sigma_{j=0}^{k-1}(a'_{j,0}+a'_{j,1}x+\dots+a'_{j,n-1}x^{n-1})(s'_{j,0}+s'_{j,1}x+\dots+s'_{j,n-1}x^{n-1})$の定数項は


$b_0'$は2つのベクトル

$\mathbf{a''}=(a'_{0,0},-a'_{0,n-1},\dots,-a'_{0,1},\dots,a'_{k-1,0},-a'_{k-1,n-1},\dots,-a'_{k-1,1} )$

$\mathbf{s''}=(s'_{0,0},s'_{0,1},\dots,s'_{0,n-1},\dots,s'_{k-1,0},s'_{k-1,1},\dots,s'_{k-1,n-1} )$

の内積を用いて

$b'_0=\mathbf{a''s''}+\Delta m+e_0$

と表せる。

よって、秘密鍵$\mathbf{s''}$による平文$m$のLWE暗号文$\text{LWE}_{s''}(m)=(\mathbf{a''},b'_0)$が構成できる。

> [!note]
> $\mathbf{a''}$にマイナスが現れるのは、環が$\mathbb{F}_q[x]/(x^n+1)$であり、$x^n=-1$として折り返されるためである。積の中で次数が$n$以上になった項は定数項へ寄与するときに符号が反転する。
