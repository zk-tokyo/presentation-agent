---
layout: default
---

# **LWE暗号同士の演算**

## LWE暗号文はこのままでも、平文との加算・乗算、暗号文同士の加算が可能。

- LWE暗号文$(\mathbf{a},b= \mathbf{as}+\Delta m + e)$と平文$m'$の加算
  - $m'$に$\Delta$をかけて$b$に加算すれば、$m+m'$を平文とするLWE暗号文$(\mathbf{a}, \mathbf{as}+\Delta (m+m') + e)$が得られる

- LWE暗号文$(\mathbf{a},b=\mathbf{as}+\Delta m + e)$と平文$m'$の乗算
  - $\mathbf{a},b$の両方に$m'$をかければ、$mm'$を平文とするLWE暗号文$(m'\mathbf{a},  m'\mathbf{as}+\Delta mm' + em')$が得られる

- LWE暗号文$(\mathbf{a},b=\mathbf{as}+\Delta m + e)$とLWE暗号文$(\mathbf{a'},b'= \mathbf{a's}+\Delta m' + e')$の加算
  - $\mathbf{a}$と$\mathbf{a'}$、$b$と$b'$をそれぞれ加算することで、$m+m'$を平文とするLWE暗号文$(\mathbf{a+a'},\mathbf{(a+a')s}+\Delta(m+m')+e+e')$が得られる

<div class="week5-note-card week5-card-side">
<p>暗号文と平文の乗算、暗号文同士の加算では、出力される暗号文はもとの暗号文よりもノイズが増えている!</p>
</div>
<br>

よって、暗号文に対する演算を続けると、ノイズはいずれ$-\frac{\Delta}{2}\le e < \frac{\Delta}{2}$に<mark style="background: #FFB8EBA6;">収まらなくなる</mark>

> Q. これらの演算の結果得られた暗号文が正常に復号できるか各自確認
