---
layout: default
---

# リスケーリング b
暗号文の状態でのテスト多項式の回転

<div class="week5-note-card">
<p>暗号文の値とテスト多項式 <MathInline expr="v(x)"/> の係数位置と対応させる。</p>
</div>

$v(x)$の構成で見たように、$q$個の値をそのまま使うと、テスト多項式の係数が多くなりすぎる。そこで、Blind Rotationの前に


$\hat{\mathbf{a}}\gets\lceil \mathbf{a}\frac{2n}{q}\rfloor,\qquad\hat{b}\gets \lceil b\frac{2n}{q}\rfloor$
 
として、$\mathbf{a},b$を$\text{mod }2N$の値に変換する。

Blind Rotationのアルゴリズムでは、この$\hat{\mathbf{a}},\hat{b}$を使って

$Q_0\gets x^{-\hat{b}}\text{RLWE}_{s'}(v)$,
$Q_{j+1}\gets \text{CMUX}(\text{RGSW}_{\mathbf{s}'}(s_j),Q_j,x^{\hat{a}_j}Q_j)$

を計算する。したがって、返ってくる多項式は

$\text{RLWE}_{s'}(x^{-\hat{b}+\hat{\mathbf{a}}\mathbf{s}}v)$ である。

もとの暗号文が$b-\mathbf{as}=\Delta m+e$を満たすので、

$\hat{b}-\hat{\mathbf{a}}\mathbf{s}\approx
\left\lceil(\Delta m+e)\frac{2n}{q}\right\rfloor$

となり、そこで構成した$v(x)$の対応する係数が定数項にくる。

