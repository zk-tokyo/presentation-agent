---
layout: default
---

<div></div>

テスト多項式を工夫することで、ノイズを削減しながら任意の一変数関数$f$を評価できる。すなわち、

$v(x)=\Sigma_{i,j} f(\mu_i)x^{\mu_i+e_j} \;\text{mod}\; x^n+1$

のようにすると、$x^{-i}v(x)$が$0\le i \le n-1$の範囲で正しく定数項へ写る限り、Bootstrappingの結果が$f(m)$の暗号文になる。

> [!note]
> 関数評価を行わず、ノイズを減らすことだけを目的としたBootstrappingをNoise Bootstrappingと呼ぶことがある。

> [!note]
> 最近はCKKSにおいてfunctional Bootstrappingと呼ばれる、近似値に対する任意関数の評価が研究されている
