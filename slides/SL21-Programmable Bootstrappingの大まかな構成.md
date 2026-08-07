---
layout: default
---

# Programmable Bootstrappingの大まかな構成

<br>

<div class="week5-note-card">
<p class="text-center" style="font-size: 1.5rem;">Blind Rotation</p>
<p class="text-center">ノイズの溜まった暗号文<MathInline expr="(\mathbf{a}, b)"/>と暗号化された<MathInline expr="v(x)"/>を使って<MathInline expr="x^{-(b-\mathbf{as})}v(x)"/>を計算する</p>
</div>
<br>
<div class="text-center">↓</div>
<div class="week5-note-card">
<p class="text-center" style="font-size: 1.5rem;">Sample Extraction</p>
<p class="text-center">
回転した多項式<MathInline expr="x^{-(b-\mathbf{as})}v(x)"/>の暗号文から定数項を暗号文の状態で抜き出す
</p>
</div>
<br>
<div class="text-center">↓</div>
<div class="week5-note-card">
<p class="text-center" style="font-size: 1.5rem;">Key Switching</p>
<p class="text-center">定数項の暗号文の鍵を元の暗号文の鍵と一致させる</p>
</div>
