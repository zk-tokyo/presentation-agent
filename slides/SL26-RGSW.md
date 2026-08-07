---
layout: default
---

# **RGSW**

<div></div>

## RGSW暗号文

平文$m$の秘密鍵$s(x)$によるRGSW暗号文を以下のように書く

<div class="week5-note-card week5-card-side">
<p style="font-size: 1.2rem;"><MathInline expr="\text{RGSW}_{s}(m)=\mathcal{Z} + mG^T"/></p>
</div>

$\mathcal{Z}\gets \begin{pmatrix}\text{RLWE}_{s}(0)\\ \text{RLWE}_{s}(0)\\ \vdots \\ \text{RLWE}_{s}(0)\end{pmatrix}$（RLWE暗号文の長さ$2l$のリスト）
$G^T=\begin{pmatrix}q/B & \\ \vdots & \\ q/B^l & \\ & q/B \\ & \vdots \\ & q/B^l \end{pmatrix}$
（Gadget Matrixと呼び、$B^l=q$のとき$G^{-1}((x_1, x_2))G^T=(x_1,x_2)$）
