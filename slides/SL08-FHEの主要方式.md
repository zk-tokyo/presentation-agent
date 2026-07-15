---
layout: default
---

# **FHEの主要方式**

<div class="week5-note-card">
<p style="font-size: 1.4rem;">Gentry's blueprint</p>
<ul>
	<li>2009年にGentryによって<strong>格子</strong>を用いることで初めて実現されたFHE</li>
	 <li>格子を使った方式では、暗号文での演算を続けることで正常な復号ができなくなるが、<strong>Bootstrapping</strong>と呼ばれる操作を導入することによりFHEを実現したが、当初の方式は計算量が非常に大きく、実用には遠かった。</li>
</ul>
</div>

<div class="week5-note-card is-white">
<p style="font-size: 1.4rem;">BFV/BGV</p>
<ul>
	<li>整数値に対する演算に適したFHE</li>
	<li>暗号文のままSIMD的な演算が可能</li>
	<li>準同型演算は比較的高速だが、Bootstrapping自体は重たいため、LHEとして使われることが多い</li>
</ul>
</div>

<div class="week5-note-card">
<p style="font-size: 1.4rem;">CKKS</p>
<ul>
	<li>浮動小数点などの近似値計算に適したFHE</li>
	<li>機械学習と相性が良く、最近盛んに研究されている。</li>
	<li>BFV/BGVと同様に準同型演算が比較的高速で、主にLHEとして運用される</li>
</ul>
</div>
