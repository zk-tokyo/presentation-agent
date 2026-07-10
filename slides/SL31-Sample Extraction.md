---
layout: default
---

# **Sample Extraction**
<div></div>


$x^n \;\text{mod}\;x^n+1 = -1$に注意すると、

<div class="week5-html-diagram" style="right: 24px; top: 142px; width: 700px; height: 280px;">
  <div class="week5-diagram-label" style="left: 220px; top: 0; font-size: 1.05rem;"><MathInline expr="a'_0s'_0"/></div>
  <div class="week5-diagram-line has-arrow" style="left: 120px; top: 73px; width: 116px; transform: rotate(-31deg);"></div>
  <div class="week5-diagram-line has-arrow" style="left: 388px; top: 73px; width: 145px; transform: rotate(-154deg);"></div>

  <div class="week5-diagram-label week5-extract-chip" style="left: 80px; top: 72px; width: 44px;"><MathInline expr="a'_0"/></div>
  <div class="week5-diagram-label is-small" style="left: 127px; top: 80px;">+</div>
  <div class="week5-diagram-label week5-extract-chip is-amber" style="left: 144px; top: 72px; width: 58px;"><MathInline expr="a'_1x"/></div>
  <div class="week5-diagram-label is-small" style="left: 202px; top: 80px;">+ ... +</div>
  <div class="week5-diagram-label week5-extract-chip is-amber" style="left: 258px; top: 72px; width: 116px;"><MathInline expr="a'_{n-1}x^{n-1}"/></div>

  <div class="week5-diagram-label is-small" style="left: 379px; top: 80px;">×</div>
  <div class="week5-diagram-label week5-extract-chip" style="left: 400px; top: 72px; width: 44px;"><MathInline expr="s'_0"/></div>
  <div class="week5-diagram-label is-small" style="left: 447px; top: 80px;">+</div>
  <div class="week5-diagram-label week5-extract-chip is-amber" style="left: 464px; top: 72px; width: 56px;"><MathInline expr="s'_1x"/></div>
  <div class="week5-diagram-label is-small" style="left: 519px; top: 80px;">+ ... +</div>
  <div class="week5-diagram-label week5-extract-chip is-amber" style="left: 568px; top: 72px; width: 126px;"><MathInline expr="s'_{n-1}x^{n-1}"/></div>

  <div class="week5-diagram-line is-amber" style="left: 167px; top: 104px; width: 116px; transform: rotate(48deg);"></div>
  <div class="week5-diagram-line is-amber" style="left: 314px; top: 104px; width: 196px; transform: rotate(157deg);"></div>
  <div class="week5-diagram-line is-amber" style="left: 314px; top: 104px; width: 200px; transform: rotate(23deg);"></div>
  <div class="week5-diagram-line is-amber" style="left: 492px; top: 104px; width: 314px; transform: rotate(165deg);"></div>

  <div class="week5-diagram-label" style="left: 82px; top: 178px; font-size: 0.88rem;">
    <MathInline expr="a'_1s'_{n-1}x^n"/><br>
    <MathInline expr="\equiv -a'_1s'_{n-1}\;(\mathrm{mod}\;x^n+1)"/>
  </div>
  <div class="week5-diagram-label" style="left: 360px; top: 178px; font-size: 0.88rem;">
    <MathInline expr="a'_{n-1}s'_1x^n"/><br>
    <MathInline expr="\equiv -a'_{n-1}s'_1\;(\mathrm{mod}\;x^n+1)"/>
  </div>
</div>

$(a'_0+a'_1x+\dots+a'_{n-1}x^{n-1})(s'_0+s'_1x+\dots+s'_{n-1}x^{n-1})$の定数項は


$b_0'$は2つのベクトル

$\mathbf{a''}=(a'_0,-a'_{n-1},-a'_{n-2},\dots,-a'_1)$

$\mathbf{s''}=(s'_0,s'_1,\dots,s'_{n-1})$

の内積を用いて

$b'_0=\mathbf{a''s''}+\Delta m+e_0$

と表せる。

よって、秘密鍵$\mathbf{s''}$による平文$m$のLWE暗号文$\text{LWE}_{s''}(m)=(\mathbf{a''},b'_0)$が構成できる。

> [!note]
> $\mathbf{a''}$にマイナスが現れるのは、環が$\mathbb{F}_q[x]/(x^n+1)$であり、$x^n=-1$として折り返されるためである。積の中で次数が$n$以上になった項は定数項へ寄与するときに符号が反転する。
