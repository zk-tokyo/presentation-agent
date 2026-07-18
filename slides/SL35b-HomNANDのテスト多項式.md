---
layout: default
class: text-[0.82rem]
---

# HomNANDの具体例

<div></div>

$$
p=8,\quad q=32,\quad N=16,\quad
q=2N,\quad \Delta=\frac{q}{p}=4, \quad e\in\{0,1\}
$$

$$
\text{bitに対応する平文は} 0\mapsto p-1=7, \; 1\mapsto 1
$$

2つの入力$m_1,m_2$の暗号文$c_1,c_2$のノイズの和を$d\in\{0,1,2\}$とすると、$r=1-m_1-m_2\mod p$より<br>
$c=\text{LWE}_\mathbf{s}(1)-c_1-c_2$による$v(x)$の回転量は$\Delta r-d$。

※ $q=2N$なので、Blind Rotation時のリスケーリングは不要になっている。

HomNANDのときのテスト多項式の係数はすべて$1$になるので、

$$
\begin{aligned}
v(x)={}&1+1x+1x^2+1x^3+1x^4+1x^5+1x^6+1x^7\\
&+1x^8+1x^9+1x^{10}+1x^{11}+1x^{12}+1x^{13}+1x^{14}+1x^{15}
\end{aligned}
$$

| 入力bit       | $r$ | 回転の番号$i=\Delta r-d\pmod q$ | 定数項     | 定数項に対応するbit |
| ------------- | --: | ------------------------------- | ---------- | ------------------- |
| $(0,0)$       | $3$ | $10,11,12$                      | 1          | 1                   |
| $(1,0),(0,1)$ | $1$ | $2,3,4$                         | 1          | 1                   |
| $(1,1)$       | $7$ | $26,27,28$                      | $-1=p-1=7$ | 0                   |

<div class="week5-note-card">
<p class="text-center" style="font-size: 1.5 rem;">
定数項に入力bitのNAND出力に対応する平文がきている
</p>
</div>
