---
layout: default
---

# **Blind Rotation** a

暗号文の状態でのテスト多項式の回転について説明する

## 平文の状態での$x^{-b+\mathbf{as}}v\;\text{mod}\;x^n+1$の求め方

<div class="week5-note-card" style="width: 30%;">
<p style="font-size: 1.2rem;">マルチプレクサを利用する</p>
</div>

<div class="week5-html-diagram" style="right: 64px; top: 138px; width: 330px; height: 310px;">
  <div class="week5-diagram-label" style="left: 74px; top: 46px;"><MathInline expr="a_0"/></div>
  <div class="week5-diagram-label" style="left: 74px; top: 90px;"><MathInline expr="a_1"/></div>
  <div class="week5-mux-gate" style="left: 124px; top: 20px;"><span>MUX</span></div>
  <div class="week5-diagram-label" style="left: 197px; top: 68px;"><MathInline expr="a_b"/></div>
  <div class="week5-diagram-label" style="left: 139px; top: 123px;"><MathInline expr="b"/></div>
  <div class="week5-diagram-line has-arrow" style="left: 101px; top: 58px; width: 22px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 101px; top: 101px; width: 22px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 169px; top: 77px; width: 26px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 146px; top: 124px; width: 16px; transform: rotate(-90deg);"></div>

  <div class="week5-diagram-label" style="left: 34px; top: 188px;"><MathInline expr="\mathrm{RLWE}(a_0)"/></div>
  <div class="week5-diagram-label" style="left: 34px; top: 231px;"><MathInline expr="\mathrm{RLWE}(a_1)"/></div>
  <div class="week5-mux-gate is-cmux" style="left: 124px; top: 162px;"><span>CMUX</span></div>
  <div class="week5-diagram-label" style="left: 202px; top: 211px;"><MathInline expr="\mathrm{RLWE}(a_b)"/></div>
  <div class="week5-diagram-label" style="left: 118px; top: 292px;"><MathInline expr="\mathrm{RGSW}(b)"/></div>
  <div class="week5-diagram-line has-arrow" style="left: 99px; top: 200px; width: 24px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 99px; top: 244px; width: 24px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 169px; top: 214px; width: 30px;"></div>
  <div class="week5-diagram-line has-arrow" style="left: 146px; top: 281px; width: 22px; transform: rotate(-90deg);"></div>
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

これを準同型演算で記述する。
