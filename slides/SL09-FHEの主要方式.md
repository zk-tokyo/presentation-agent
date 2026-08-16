---
layout: default
---

<!--
REVIEW: 「GSWがBootstrappingを高速化した」は歴史的に粗い。GSWは近似固有ベクトル法で乗算を単純化してRelinearizationを不要にし、後にFHEWがGSW系の構成をBootstrappingの高速化へ用いた、と整理する。
-->

# **FHEの主要方式**

<div class="week5-note-card">
<p style="font-size: 1.4rem;">GSW</p>
<ul>
	<li>近似固有ベクトルの概念を利用して、暗号文を行列として扱えるようにした方式</li>
	<li>Bootstrappingを高速化した</li>
</ul>
</div>

<div class="week5-note-card is-white">
<p style="font-size: 1.4rem;">FHEW</p>
<ul>
	<li>Homomorphic Accumulatorと呼ばれる考え方により、Bootstrappingを1秒未満まで高速化した方式</li>
</ul>
</div>

<div class="week5-note-card">
<p style="font-size: 1.4rem;">TFHE</p>
<ul>
	<li>FHEWの方式をTorusと呼ばれる数学的な構造に拡張した方式</li>
	<li>論文発表時点で13msのBootstrappingを報告</li>
	<li>詳細は後述</li>
</ul>
</div>
