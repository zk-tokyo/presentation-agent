---
layout: default
---

# **Sample Extraction**

<div></div>

$x^n \;\text{mod}\;x^n+1 = -1$に注意すると、

<div class="week5-html-diagram is-sample-extraction" style="right: 24px; top: 142px; width: 740px; height: 280px;">
  <div class="week5-diagram-label" style="left: 222px; top: 0; font-size: 1.05rem;"><MathInline expr="a'_0s'_0"/></div>
  <div class="week5-diagram-line has-arrow" style="left: 116px; top: 74px; width: 128px; transform: rotate(-24deg);"></div>
  <div class="week5-diagram-line has-arrow" style="left: 436px; top: 74px; width: 194px; transform: rotate(-164deg);"></div>

  <div class="week5-diagram-label" style="left: 58px; top: 68px; font-size: 1.65rem; line-height: 1;">(</div>
  <div class="week5-diagram-label week5-extract-chip" style="left: 80px; top: 72px; width: 44px;"><MathInline expr="a'_0"/></div>
  <div class="week5-diagram-label is-small" style="left: 127px; top: 80px;">+</div>
  <div class="week5-diagram-label week5-extract-chip is-amber" style="left: 144px; top: 72px; width: 58px;"><MathInline expr="a'_1x"/></div>
  <div class="week5-diagram-label is-small" style="left: 202px; top: 80px;">+ ... +</div>
  <div class="week5-diagram-label week5-extract-chip is-amber" style="left: 258px; top: 72px; width: 116px;"><MathInline expr="a'_{n-1}x^{n-1}"/></div>
  <div class="week5-diagram-label" style="left: 376px; top: 68px; font-size: 1.65rem; line-height: 1;">)</div>

  <div class="week5-diagram-label is-small" style="left: 392px; top: 80px;">×</div>
  <div class="week5-diagram-label" style="left: 410px; top: 68px; font-size: 1.65rem; line-height: 1;">(</div>
  <div class="week5-diagram-label week5-extract-chip" style="left: 424px; top: 72px; width: 44px;"><MathInline expr="s'_0"/></div>
  <div class="week5-diagram-label is-small" style="left: 471px; top: 80px;">+</div>
  <div class="week5-diagram-label week5-extract-chip is-amber" style="left: 488px; top: 72px; width: 56px;"><MathInline expr="s'_1x"/></div>
  <div class="week5-diagram-label is-small" style="left: 543px; top: 80px;">+ ... +</div>
  <div class="week5-diagram-label week5-extract-chip is-amber" style="left: 592px; top: 72px; width: 126px;"><MathInline expr="s'_{n-1}x^{n-1}"/></div>
  <div class="week5-diagram-label" style="left: 720px; top: 68px; font-size: 1.65rem; line-height: 1;">)</div>

  <div class="week5-diagram-line is-amber has-arrow" style="left: 173px; top: 106px; width: 87px; transform: rotate(129deg);"></div>
  <div class="week5-diagram-line is-amber has-arrow" style="left: 655px; top: 106px; width: 460px; transform: rotate(172deg);"></div>
  <div class="week5-diagram-line is-amber has-arrow" style="left: 316px; top: 106px; width: 106px; transform: rotate(39deg);"></div>
  <div class="week5-diagram-line is-amber has-arrow" style="left: 516px; top: 106px; width: 73px; transform: rotate(113deg);"></div>

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

$a'_0s'_0-a'_1s'_{n-1}-a'_2s'_{n-2}-\cdots-a'_{n-1}s'_1$となっているので

$b_0'$は2つのベクトル

$\mathbf{a''}=(a'_0,-a'_{n-1},-a'_{n-2},\dots,-a'_1)$

$\mathbf{s''}=(s'_0,s'_1,\dots,s'_{n-1})$

の内積を用いて

$b'_0=\mathbf{a''s''}+\Delta m+e_0$

と表せる。

よって、秘密鍵$\mathbf{s''}$による平文$m$のLWE暗号文$\text{LWE}_{s''}(\Delta m)=(\mathbf{a''},b'_0)$が構成できる。
