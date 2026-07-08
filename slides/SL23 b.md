---
layout: default
---

# **Sample Extraction**
<div></div>


$x^n \;\text{mod}\;x^n+1 = -1$に注意すると、

$(a'_0+a'_1x+\dots+a'_{n-1}x^{n-1})(s'_0+s'_1x+\dots+s'_{n-1}x^{n-1})$の定数項は


$b_0'$は2つのベクトル

$\mathbf{a''}=(a'_0,-a'_{n-1},-a'_{n-2},\dots,-a'_1)$

$\mathbf{s''}=(s'_0,s'_1,\dots,s'_{n-1})$

の内積を用いて

$b'_0=\mathbf{a''s''}+\Delta m+e_0$

と表せる。

よって、秘密鍵$\mathbf{s''}$による平文$m$のLWE暗号文$\text{LWE}_{s''}(m)=(\mathbf{a''},b'_0)$が構成できる。

> [!note]
> $\mathbf{a''}$にマイナスが現れるのは、環が$\mathbb{F}_q[x]/(x^n+1)$であり、$x^n=-1$として折り返されるためである。積の中で次数が$n$以上になった項は定数項へ寄与するときに符号が反転する。
