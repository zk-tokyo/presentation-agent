---
layout: default
---

# $v(x)$の構成

<div></div>

平文$m$に対するLWE暗号文$(\mathbf{a},b)$は$b-\mathbf{as}=\Delta m+e \pmod q$を満たす。

まず、$q$個の係数を持つ多項式を使えるなら、ノイズ$e$が取りうる値をすべて並べて

$v_q(x)=\sum_{m\in\mathbb{Z}_p}\sum_e m x^{\Delta m+e}\pmod{x^q+1}$ とすればよい。

<div class="week5-note-card is-blue">
<p><MathInline expr="b-\mathbf{as}=\Delta m+e"/> なので、<MathInline expr="x^{-(b-\mathbf{as})}v_q(x)"/> の定数項に <MathInline expr="m"/> がくる。</p>
</div>

ただし実用的なパラメータでは$q$が大きすぎるため、$q$個の係数を持つ多項式は使いにくい。

そこで実際には、係数の数が小さい多項式で同じことが起こるように調整する。この調整は後でリスケーリングとして説明する。

以下では、調整後に使うテスト多項式の形だけを見る。

例：平文$0,1,2$に対応する係数を4つずつ並べるなら

$v(x)=0(1+x+x^2+x^3)+1(x^4+x^5+x^6+x^7)+2(x^8+x^9+x^{10}+x^{11})+\cdots$

となる。
