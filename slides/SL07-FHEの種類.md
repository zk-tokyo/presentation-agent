---
layout: default
---

# **FHEの種類**

<div class="week5-note-card">
<p style="font-size: 1.4rem;">Somewhat Homomorphic Encryption(SHE)</p>
<ul>
	<li>暗号文のまま加算と乗算が有限回行える。</li>
	<li>BV暗号など</li>
</ul>
</div>

<div class="week5-note-card">
<p style="font-size: 1.4rem;">Leveled Homomorphic Encryption(LHE)</p>
<ul>
	<li>暗号文のままの加算と乗算をあらかじめパラメーターによって定められた回数だけBootstrappingなしに行うことができる。</li>
	<li>BFG/BGV, CKKSなど</li>
</ul>
</div>

<div class="week5-note-card">
<p style="font-size: 1.4rem;">Fully Homomorphic Encryption(FHE)</p>
<ul>
	<li>Bootstrappingにより、暗号文の状態で加算と乗算を制限回数なしに行える。</li>
	<li>GSW, FHEW, TFHEなど</li>
</ul>
</div>

<br>

> [!note]
> この分け方の他にも世代として分類することもある。
