---
layout: default
---

# **Blind Rotation**

## **Blind Rotationのアルゴリズム**

<div class="week5-text-two">

<div>
<h2>暗号文での計算</h2>
<p>
<MathInline expr="\hat{\mathbf{a}}\gets\left\lfloor \mathbf{a}\frac{2n}{q}\right\rceil"/> （リスケーリング） <br>
<MathInline expr="\hat{b}\gets \left\lfloor b\frac{2n}{q}\right\rceil"/> （リスケーリング）<br>
<MathInline expr="Q_0 \gets x^{-\hat{b}}\text{RLWE}_{s'}(\Delta v)"/> (RLWE暗号文は多項式をかけることができる。) <br>
for <MathInline expr="j=0\dots k-1"/> <br>
<MathInline expr ="\quad Q_{j+1} \gets \text{CMUX}(\text{RGSW}_{s'}(s_j), Q_j, x^{\hat{a}_j}Q_j)"/> <br>
return <MathInline expr="Q_k(=\text{RLWE}_{s'}(\Delta x^{-\hat{b}+\mathbf{\hat{a}s}}v))"/> <br>
</p>
</div>

<div>
<h2>平文での計算</h2>
<MathInline expr="\hat{\mathbf{a}}\gets\left\lfloor \mathbf{a}\frac{2n}{q}\right\rceil"/><br>
<MathInline expr="\hat{b}\gets \left\lfloor b\frac{2n}{q}\right\rceil"/> <br>
<MathInline expr="Q_0 \gets x^{-\hat{b}}(v)"/>  <br>
for <MathInline expr="j=0\dots k-1"/> <br>
<MathInline expr ="\quad Q_{j+1} \gets \text{MUX}(s_j, Q_j, x^{\hat{a}_j}Q_j)"/> <br>
return <MathInline expr="Q_k(=x^{-\hat{b}+\mathbf{\hat{a}s}}v)"/> <br>
</div>

</div>

> note:
> 正確に言うと任意のテスト多項式$v(x)$は、$a(x)=0$としたノイズのない自明なRLWE暗号文$\text{RLWE}_{s'}(\Delta v)=(0,\Delta v)$とみなせる

> note:
> $s_j$をRGSWで暗号化するための鍵を$s'$とし、$(\text{RGSW}_{s'}(s_0),\dots,\text{RGSW}_{s'}(s_{k-1}))$をBootstrapping Keyと呼ぶ。

> Q. $x^i \text{ mod } x^n+1$には後述するnegacyclicと呼ばれる性質があり、$i \ge n$のとき、$x^i \text{ mod }x^n+1 = -x^{i-n}$となり、係数の符号が反転してしまう。仮にBlind Rotationでこれが起こるとなぜ問題なのか、そしてどのようすればこれを回避できるだろうか。
