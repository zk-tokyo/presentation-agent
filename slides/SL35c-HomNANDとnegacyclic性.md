---
layout: default
class: text-[0.88rem]
---

# 全係数が1でもNANDを表せる理由

<div></div>

多項式の計算は$\mathbb{Z}_8[x]/(x^{16}+1)$で行う。

$$
x^{16}=-1
$$

テスト多項式を

$$
v(x)=1+x+x^2+\cdots+x^{15}
$$

とする。Blind Rotation後の多項式$x^{-i}v(x)$では、$i$が前半か後半かで定数項の符号が変わる。

| 回転の番号           | $x^{-i}v(x)$の定数項 | HomNANDで対応する入力 |
| -------------------- | -------------------: | --------------------- |
| $0\le i<16$          |                  $1$ | $(0,0),(1,0),(0,1)$   |
| $i=16+j,\ 0\le j<16$ |    $-1\equiv7\pmod8$ | $(1,1)$               |

後半では

$$
x^{-(16+j)}v(x)=x^{-16}x^{-j}v(x)=-x^{-j}v(x)
$$

となるため、係数を並べ替えなくても$1$と$7$の2つの出力を作れる。

<div class="week5-note-card" style="margin-right: 128px;">
<p class="text-center" style="font-size: 1.08rem; margin: 0;">
同じ係数列を半周分まで拡張すると、後半は前半の符号反転になる。
</p>
</div>
