---
layout: default
---

# **Blind Rotation**

## **Blind Rotationのアルゴリズム**

- $\hat{\mathbf{a}}\gets\lceil \mathbf{a}\frac{2n}{q}\rfloor$
- $\hat{b}\gets \lceil b\frac{2n}{q}\rfloor$
- $Q_0 \gets x^{-\hat{b}}\text{RLWE}_{s'}(v)$ (RLWE暗号文は多項式をかけることができる。)
- for $j=0\dots k-1$
  - $Q_{j+1} \gets \text{CMUX}(\text{RGSW}_{\mathbf{s}'}(s_j), Q_j, x^{\hat{a}_j}Q_j)$
- return $Q_k(=\text{RLWE}_{\mathbf{s}'}(x^{-\hat{b}+\mathbf{\hat{a}s}}v))$

> [!note]
> 正確に言うと$v$はノイズのない"自明な"RLWE暗号文として扱われる。すなわち、$v$を定数項以外の係数が0の多項式、aをゼロベクトルとすることで$v=\Sigma 0\cdot s + v+ 0\;\text{mod}\;x^n+1$とできるので、$v=\text{RLWE}_s(v)=(0,\dots,0,v)$とみなせる

> [!note]
> $s_j$をRGSWで暗号化するための鍵を$\mathbf{s}'$とし、$(\text{RGSW}_{\mathbf{s}'}(s_0),\dots,\text{RGSW}_{\mathbf{s}'}(s_{k-1}))$をBootstrapping Keyと呼ぶ。

> Q. $x^i \text{ mod } x^n+1$にはnegacyclicと呼ばれる性質があり、$i \ge n$のとき、$x^i \text{ mod }x^n+1 = -x^{n-i}$となり、係数の符号が反転してしまう。仮にBlind Rotationでこれが起こるとなぜ問題なのか、そしてどのようすればこれを回避できるだろうか。
