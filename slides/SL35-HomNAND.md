---
layout: default
---

#  HomNAND
<div></div>


平文空間を$\mathbb{Z}_4$, 暗号文空間を$\mathbb{Z}_8$とする。

入力となるビットを次のように離れた値の平文へエンコードする。

- bit $0 \mapsto 0$
- bit $1 \mapsto 2$

2つの入力暗号文$c_1,c_2$がそれぞれ$m_1,m_2\in\{0,2\}$を暗号化しているとき、

$c=(0,\dots,0,5)-c_1-c_2$

を計算してからProgrammable Bootstrappingを行う。平文レベルで見ると、

| $m_1$ | $m_2$ | $5-m_1-m_2 \pmod 8$ | NAND |
| --- | --- | --- | --- |
| $0$ | $0$ | $5$ | $1$ |
| $2$ | $0$ | $3$ | $1$ |
| $0$ | $2$ | $3$ | $1$ |
| $2$ | $2$ | $1$ | $0$ |

となる。したがって、テスト多項式を$r=1\mapsto0,\ r=3,5\mapsto2$のLookup Tableとして設計する。

<div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">
Sources: Chillotti, Gama, Georgieva, Izabachène "TFHE: Fast Fully Homomorphic Encryption over the Torus" Journal of Cryptology 2019
</div>
