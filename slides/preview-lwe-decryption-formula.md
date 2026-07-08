---
layout: default
class: week5-prototype week5-prototype-formula
---

# [数式] LWE暗号文と復号条件

LWE暗号文を次の形で置く。

$$c=(\mathbf{a},b), \qquad b=\mathbf{a}\mathbf{s}+\Delta m+e \pmod q$$

秘密鍵成分を消去する。

$$b-\mathbf{a}\mathbf{s}=\Delta m+e \pmod q$$

平文空間へ戻す。

$$\left\lfloor\frac{b-\mathbf{a}\mathbf{s}}{\Delta}\right\rceil \bmod p = m$$

復号が正しいためには、ノイズ項$e$が丸めの境界を越えない範囲にある必要がある。

<div class="week5-note-card">

<p>ここに補足説明</p>

</div>
