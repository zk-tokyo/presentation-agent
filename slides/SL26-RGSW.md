---
layout: default
---

# **RGSW**

<div></div>

## 平文$m$の秘密鍵$s(x)$によるRGSW暗号文

$\mathcal{Z}\gets 
\begin{pmatrix}
\text{RLWE}_{s}(0)\\ 
\text{RLWE}_{s}(0)\\ 
\vdots \\ 
\text{RLWE}_{s}(0)
\end{pmatrix}
$
$
=\begin{pmatrix}
a^{(0)}(x),& a^{(0)}(x)s(x)+e^{(0)}(x)\\
a^{(1)}(x),& a^{(1)}(x)s(x)+e^{(1)}(x)\\
\vdots & \vdots \\
a^{(2l-1)}(x),& a^{(2l-1)}(x)s(x)+e^{(2l-1)}(x)
\end{pmatrix}
$（$2l$個のRLWE暗号文のリスト）

$G^T=\begin{pmatrix}q/B & \\ \vdots & \\ q/B^l & \\ & q/B \\ & \vdots \\ & q/B^l \end{pmatrix}$
（Gadget Matrixと呼び、$B^l=q$のとき$G^{-1}((x_1, x_2))G^T=(x_1,x_2)$）

<div class="week5-note-card week5-card-side">
<p style="font-size: 1.2rem;">
<MathInline expr="
\text{RGSW}_{s}(m)=\mathcal{Z} + mG^T
=\begin{pmatrix}
a^{(0)}(x) + m q/B,& a^{(0)}(x)s(x)+e^{(0)}(x)\\
\vdots & \vdots \\
a^{(l-1)}(x) + m q/B^{l},& a^{(l-1)}(x)s(x)+e^{(l-1)}(x)\\
a^{(l)}(x) ,& a^{(l)}(x)s(x)+m q/B+e^{(l)}(x)\\
\vdots & \vdots \\
a^{(2l-1)}(x) ,& a^{(2l-1)}(x)s(x)+m q/B^l+e^{(2l-1)}(x)
\end{pmatrix}
=\begin{pmatrix}
\text{RLWE}_{s}(-s(x)m q/B)\\
\vdots \\
\text{RLWE}_{s}(-s(x)m q/B^l)\\
\text{RLWE}_{s}(m q/B)\\
\vdots \\
\text{RLWE}_{s}(m q/B^l)
\end{pmatrix}
"/>
</p>
</div>
