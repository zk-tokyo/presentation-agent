---
layout: default
---

# **Blind Rotation**

## **Blind Rotationのアルゴリズム**

<div class="week5-text-two">

<div>
<h2>暗号文での計算</h2>
<p>
<MathInline expr="\hat{\mathbf{a}}\gets\lceil \mathbf{a}\frac{2n}{q}\rfloor"/> （暗号文の大きさを多項式の次数の大きさに合わせる処理） <br>
<MathInline expr="\hat{b}\gets \lceil b\frac{2n}{q}\rfloor"/> （同上）<br>
<MathInline expr="Q_0 \gets x^{-\hat{b}}\text{RLWE}_{s'}(v)"/> (RLWE暗号文は多項式をかけることができる。) <br>
for <MathInline expr="j=0\dots k-1"/> <br>
<MathInline expr ="\quad Q_{j+1} \gets \text{CMUX}(\text{RGSW}_{s'}(s_j), Q_j, x^{\hat{a}_j}Q_j)"/> <br>
return <MathInline expr="Q_k(=\text{RLWE}_{s'}(x^{-\hat{b}+\mathbf{\hat{a}s}}v))"/> <br>
</p>
</div>

<div>
<h2>平文での計算</h2>
<MathInline expr="\hat{\mathbf{a}}\gets\lceil \mathbf{a}\frac{2n}{q}\rfloor"/><br>
<MathInline expr="\hat{b}\gets \lceil b\frac{2n}{q}\rfloor"/> <br>
<MathInline expr="Q_0 \gets x^{-\hat{b}}(v)"/>  <br>
for <MathInline expr="j=0\dots k-1"/> <br>
<MathInline expr ="\quad Q_{j+1} \gets \text{MUX}(s_j, Q_j, x^{\hat{a}_j}Q_j)"/> <br>
return <MathInline expr="Q_k(=x^{-\hat{b}+\mathbf{\hat{a}s}}v)"/> <br>
</div>

</div>

> [!note]
> 正確に言うと$v$はノイズのない"自明な"RLWE暗号文として扱われる。すなわち、$v$を定数項以外の係数が0の多項式、aをゼロベクトルとすることで$v=\Sigma 0\cdot s + v+ 0\;\text{mod}\;x^n+1$とできるので、$v=\text{RLWE}_s(v)=(0,\dots,0,v)$とみなせる

> [!note]
> $s_j$をRGSWで暗号化するための鍵を$s'$とし、$(\text{RGSW}_{s'}(s_0),\dots,\text{RGSW}_{s'}(s_{k-1}))$をBootstrapping Keyと呼ぶ。

> Q. $x^i \text{ mod } x^n+1$には後述するnegacyclicと呼ばれる性質があり、$i \ge n$のとき、$x^i \text{ mod }x^n+1 = -x^{n-i}$となり、係数の符号が反転してしまう。仮にBlind Rotationでこれが起こるとなぜ問題なのか、そしてどのようすればこれを回避できるだろうか。
