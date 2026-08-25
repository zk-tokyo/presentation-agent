---
layout: default
---

<!--なんでこんな面倒くさいことをするんだっけ-->

# **Key Switching**

<div></div>

## $\mathbf{a''s''}+\Delta m +e_0 - \text{LWE}_\mathbf{s}(\mathbf{a''s''})$を計算する

わかりやすさのために$\mathbf{a''}$と$\mathbf{s''}$を

$\mathbf{a''}=(a''_{0},a''_{1},\dots,a''_{n-1})$, $\mathbf{s''}=(s''_{0},s''_{1},\dots,s''_{n-1} )$

と書き直しておく。

$\mathbf{a''}$のGadget Decomposition $G^{-1}(\mathbf{a''})=(g^{-1}(a''_0),\dots,g^{-1}(a''_{n-1}))$を考え、$g^{-1}(a''_i)=(\bar{a}_{i,0},\dots,\bar{a}_{i,l-1})$
とする。

事前に$ksk[i,j]=\text{LWE}_\mathbf{s}(s''_i q /B^{j+1})(0\le i \le n-1, 0 \le j \le l-1)$ 

$\quad\quad\quad\quad\quad$(これをKey switching keyと呼ぶ。$\Delta$を使わないことに注意)

を送っておけば、目的の$\mathbf{s}$による$m$の暗号文$\text{LWE}_\mathbf{s}(\Delta m)$は次のように計算できる。

<p class="text-center" style="font-size: 1.4rem;">
<MathInline expr="\text{LWE}_\mathbf{s}(\Delta m)\gets (0,\dots,0,b'_0)-\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\bar{a}_{i,j}ksk[i,j]"/>
</p>
