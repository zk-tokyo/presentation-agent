---
layout: default
---

# **RGSW**

<div></div>
Gadget Decompositionを利用してRGSWを構成する。
<div class="week5-note-card week5-card-side">
<p style="font-size: 1.2rem;"><MathInline expr="\text{RGSW}_{\mathbf{s}}(m)=\mathcal{Z} + mG^T"/></p>
</div>

ここで以下の行列をGadget Matrixと呼び、
$\mathcal{Z}\gets \begin{pmatrix}\text{RLWE}_{\mathbf{s}}(0)\\ \text{RLWE}_{\mathbf{s}}(0)\\ \vdots \\ \text{RLWE}_{\mathbf{s}}(0)\end{pmatrix}$（RLWE暗号文の長さ$2l$のリスト）とする

$G^T=\begin{pmatrix}q/B & \\ \vdots & \\ q/B^l & \\ & q/B \\ & \vdots \\ & q/B^l \end{pmatrix}$

<div class="week5-note-card week5-card-side">
<p style="font-size: 1.2rem;">RGSWはRLWE暗号文のリストになっている</p>
</div>
