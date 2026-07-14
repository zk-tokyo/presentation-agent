---
layout: default
---

# HomNANDのテスト多項式

<div></div>
前ページの線形前処理後の平文値を

$$
r = 5 - m_1 - m_2 \pmod 8
$$

とおく。NANDでは、$r=1$なら出力$0$、$r=3,5$なら出力$2$になればよい。

今回はスケーリングを省略し、多項式のモジュラスを$x^8+1$とする。ノイズは正方向にだけずれるとして、$e\in\{0,1\}$と仮定する。

$$
v(x)=0+0x+0x^2+2x^3+2x^4+2x^5+2x^6+0x^7
$$

をテスト多項式にする。Blind Rotationでは$x^{-(r+e)}v(x)$を作り、その定数項を取り出す。

| 入力bit       | $r$ | 回転後の多項式                                                                     | 定数項 |
| ------------- | --- | ---------------------------------------------------------------------------------- | ------ |
| $(0,0)$       | $5$ | $e=0:\ x^{-5}v(x)=2+\cdots$<br>$e=1:\ x^{-6}v(x)=2+\cdots$                         | $2$    |
| $(1,0),(0,1)$ | $3$ | $e=0:\ x^{-3}v(x)=2+2x+2x^2+2x^3$<br>$e=1:\ x^{-4}v(x)=2+\cdots$                   | $2$    |
| $(1,1)$       | $1$ | $e=0:\ x^{-1}v(x)=0+2x^2+2x^3+2x^4+2x^5$<br>$e=1:\ x^{-2}v(x)=0+2x+2x^2+2x^3+2x^4$ | $0$    |

例えば$r=3,e=1$なら、$x^{-4}v(x)$の中の$2x^4$が定数項の$2$になる。$r=1$では、$x^1,x^2$の係数を$0$にしているため、ノイズがあっても定数項は$0$になる。

<div class="week5-note-card is-gray" style="position: absolute; left: 64px; right: 64px; bottom: 10px; padding: 10px 14px;">
<p style="font-size: 0.82rem; line-height: 1.45; margin: 0;">
係数8個のテスト多項式で、NANDが1になる位置の近くを<MathInline expr="2"/>で埋めている。ここでは正方向の小さなノイズだけを見ている。
</p>
</div>

<div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">
Sources: Chillotti, Gama, Georgieva, Izabachène "TFHE: Fast Fully Homomorphic Encryption over the Torus" Journal of Cryptology 2019
</div>
