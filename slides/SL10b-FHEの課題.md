---
layout: default
---

<!--
REVIEW: 「計算結果が正しいか確認できない」は絶対的すぎる。「通常のFHE単体では、悪意ある計算サーバーに対する結果の正しさを保証しない」とする。Verifiable FHEなどの追加機構は存在する。
-->

# **FHEの課題**

<div class="week5-note-card">
<p style="font-size: 1.4rem;">実行コスト</p>
<ul>
	<li>平文から暗号文への変換により、データそのものが大きくなる</li>
	<li>暗号文同士の演算は平文同士の演算よりも重い</li>
	<li>研究によりBootstrapping1回あたりの実行速度は改善されているが、依然としてボトルネックになっている。</li>
</ul>
</div>
<div class="week5-note-card is-white">
<p style="font-size: 1.4rem;">検証可能性</p>
<ul>
	<li>FHEを使って得られた計算結果が正しいものかどうか確認することができない。</li>
	<li>week6で説明</li>
</ul>
</div>
<div class="week5-note-card">
<p style="font-size: 1.4rem;">安全性モデル</p>
<ul>
	<li>暗号にはnon-malleabilityという安全性の概念があるが、FHEは暗号文を意図的に変形して別の平文の暗号文を作る機能を持つため、non-malleabilityを達成できない</li>
	<li>多くのFHE方式は基本的にCPA安全性を中心に議論される。CCA安全性が必要な応用では、利用形態や追加の認証・検証レイヤーを別途設計する必要がある</li>
</ul>
</div>
