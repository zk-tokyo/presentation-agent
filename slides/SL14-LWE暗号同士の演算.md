---
layout: default
---

<!--
REVIEW: 「ノイズが増える」は個々の値について常に成り立たない。加算では相殺し、平文 0 との乗算では消えるため、「ノイズの上界・分散が増大し得る」とする。
-->

# **LWE暗号同士の演算**

<div></div>

<p style="font-size: 1.4rem; line-height: 2.0;">LWE暗号文<MathInline expr="(\mathbf{a},b= \mathbf{as}+\Delta m + e)"/>と平文<MathInline expr="m'"/>の加算</p>

- $m'$に$\Delta$をかけて$b$に加算すれば、$m+m'$を平文とするLWE暗号文$(\mathbf{a}, \mathbf{as}+\Delta (m+m') + e)$が得られる

<p style="font-size: 1.4rem; line-height: 2.0;">LWE暗号文<MathInline expr="(\mathbf{a},b=\mathbf{as}+\Delta m + e)"/>と平文<MathInline expr="m'"/>の乗算</p>

- $\mathbf{a},b$の両方に$m'$をかければ、$mm'$を平文とするLWE暗号文$(m'\mathbf{a},  m'\mathbf{as}+\Delta mm' + em')$が得られる

<p style="font-size: 1.4rem; line-height: 2.0;">LWE暗号文<MathInline expr="(\mathbf{a},b=\mathbf{as}+\Delta m + e)"/>とLWE暗号文<MathInline expr="(\mathbf{a'},b'= \mathbf{a's}+\Delta m' + e')"/>の加算</p>

- $\mathbf{a}$と$\mathbf{a'}$、$b$と$b'$をそれぞれ加算することで、$m+m'$を平文とするLWE暗号文$(\mathbf{a+a'},\mathbf{(a+a')s}+\Delta(m+m')+e+e')$が得られる

<div class="week5-note-card week5-card-side">
<p>暗号文と平文の乗算、暗号文同士の加算では、出力される暗号文はもとの暗号文よりもノイズが増えている!</p><br>
<p>→暗号文に対する演算を続けると、ノイズはいずれ<MathInline expr="-\frac{\Delta}{2}\le e < \frac{\Delta}{2}"/>に収まらなくなる</p>
</div>
<br>

> Q. これらの演算の結果得られた暗号文が正常に復号できるか各自確認してみよう
