---
layout: default
---

# **Fully Homomorphic Encryption** a

完全準同型暗号とは何か、何ができるかについて説明する

## 完全準同型暗号=加算と乗算が両方行える準同型暗号
<div class="week5-note-card">
<p class="text-center">完全準同型暗号(Fully Homomorphic Encryption, 以下FHE)は<strong>暗号文のまま加算と乗算が任意の回数行える</strong></p>
</div>
<br>
<div class="text-center">↓</div>
<div class="week5-note-card">
<p class="text-center">平文<MathInline expr="m_1,m_2\in \{0,1\}"/>に対して<MathInline expr="1-m_1m_2"/>を暗号文の状態で計算することで、<strong>平文に対するNAND演算</strong>を評価できる</p>
</div>
<br>
<div class="text-center">↓</div>
<div class="week5-note-card">
<p class="text-center">理論上<strong>任意のBoolean回路</strong>を暗号文のまま評価できる</p>
</div>
<br>
<br>


>[!note]
>FHEの概念自体は1978年にRSA暗号で有名なRivestらにより提唱された
