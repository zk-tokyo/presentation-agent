---
layout: default
---

# **Blind Rotation**

## 平文の状態での$x^{-b+\mathbf{as}}v\;\text{mod}\;x^n+1$の求め方

<div class="week5-note-card" style="width: 50%;">
<p style="font-size: 1.2rem;"><MathInline expr="\mathbf{as}"/>の計算には秘密鍵の情報が必要になってしまう<br>
→マルチプレクサを利用する</p>
</div>

<div class="week5-html-diagram is-mux-comparison" style="right: 150px; top: 124px; width: 430px; height: 420px;">
  <div class="week5-diagram-label" style="left: 84px; top: 50px;"><MathInline expr="a_0"/></div>
  <div class="week5-diagram-label" style="left: 84px; top: 106px;"><MathInline expr="a_1"/></div>
  <div class="week5-mux-gate is-large" style="left: 158px; top: 14px;"><span>MUX</span></div>
  <div class="week5-diagram-label" style="left: 252px; top: 78px;"><MathInline expr="a_b"/></div>
  <div class="week5-diagram-label" style="left: 179px; top: 158px;"><MathInline expr="b"/></div>
  <div class="week5-diagram-line has-arrow" style="left: 114px; top: 63px; width: 43px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 114px; top: 119px; width: 43px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 213px; top: 86px; width: 36px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 184px; top: 152px; width: 10px; transform: rotate(-90deg);"></div>

  <div class="week5-diagram-label" style="left: 16px; top: 254px;"><MathInline expr="\mathrm{RLWE}(a_0)"/></div>
  <div class="week5-diagram-label" style="left: 16px; top: 310px;"><MathInline expr="\mathrm{RLWE}(a_1)"/></div>
  <div class="week5-mux-gate is-cmux is-large" style="left: 158px; top: 218px;"><span>CMUX</span></div>
  <div class="week5-diagram-label" style="left: 256px; top: 275px;"><MathInline expr="\mathrm{RLWE}(a_b)"/></div>
  <div class="week5-diagram-label" style="left: 144px; top: 392px;"><MathInline expr="\mathrm{RGSW}(b)"/></div>
  <div class="week5-diagram-line has-arrow" style="left: 112px; top: 267px; width: 45px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 112px; top: 323px; width: 45px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 213px; top: 288px; width: 40px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 184px; top: 378px; width: 36px; transform: rotate(-90deg);"></div>
</div>

$\mathbf{a}=\left(a_0,a_1,\ldots,a_{k-1}\right),\mathbf{s}=\left(s_0,s_1,\ldots,s_{k-1}\right)$とすると、$\mathbf{as}=\Sigma_{i=0}^{k-1}a_is_i$と表せる。  
$x^{-b+\mathbf{as}}v=x^{-b+\Sigma_{i=0}^{k-1}a_is_i}v=x^{a_{k-1}s_{k-1}}\left(x^{-b+\Sigma_{i=0}^{k-2}a_is_i}v\right)$  
より、$Q_k:=x^{-b+\Sigma_{i=0}^{k-1}a_is_i}v$は$\ Q_0=x^{-b}v$として  
次の漸化式から求められる。  
$Q_{j+1}=x^{a_js_j}Q_j=\left\{\begin{matrix}Q_j\;\;\;\;\text{ if }\ s_j=0\\x^{a_j}Q_j\text{ if } s_j=1\end{matrix}\right.$

よって$x^{-b+\mathbf{as}}v\;\text{mod}\;x^n+1$はマルチプレクサMUXを利用することで  
 以下のアルゴリズムから計算できる

- $Q_0 \gets x^{-b}v$
- for $j=0\dots k-1$
  - $Q_{j+1} \gets \text{MUX}(s_j, Q_j, x^{a_j}Q_j)$
- return $Q_k\;(=x^{-b+\mathbf{as}}v)$

これを$v, s_j, Q_j, x^{a_j}Q_j$を暗号文にして準同型演算で記述する。
