---
layout: default
---

**Sample Extraction**



$x^n \;\text{mod}\;x^n+1 = -1$に注意すると、

$\Sigma_{j=0}^{k-1}(a'_{j,0}+a'_{j,1}x+\dots+a'_{j,n-1}x^{n-1})(s'_{j,0}+s'_{j,1}x+\dots+s'_{j,n-1}x^{n-1})$の定数項は$\mathbf{a'}$と$\mathbf{s'}$の各要素の係数をいい感じに配置しなおしたベクトル

$\mathbf{a''}=(a'_{0,0},-a'_{0,n-1},\dots,-a'_{0,1},\dots,a'_{k-1,0},-a'_{k-1,n-1},\dots,-a'_{k-1,1} )$

$\mathbf{s''}=(s'_{0,0},s'_{0,1},\dots,s'_{0,n-1},\dots,s'_{k-1,0},s'_{k-1,1},\dots,s'_{k-1,n-1} )$

を用いて

$b'_0=\mathbf{a''s''}+m+e_0$

と表せる。

よって、$\mathbf{s''}$によるLWE暗号文$\text{LWE}_{s''}(m)=(\mathbf{a''},b_0)$が構成できる。

> ![todo]
> $a'',s''$の要素に急にマイナスが出てくる理由の説明を記載する
> sample extractionのアルゴリズムを記載する