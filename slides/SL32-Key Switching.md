---
layout: default
---

# **Key Switching**
<div></div>

## Sample Extractionで得られたLWE暗号文$(\mathbf{a''},b'_0=\mathbf{a''s''}+\Delta m + e_0)$を$\mathbf{s}$によるLWE暗号文に変換する
<div class="week5-note-card">
<p class="text-center" style="font-size: 1.2 rem;">
<MathInline expr="\mathbf{a''s''}+\Delta m +e_0"/>から<MathInline expr="\mathbf{as}+\mathbf{a''s''}+e"/>を引けば<MathInline expr="-\mathbf{as}+\Delta m + e_0-e"/>が得られる
</p>
</div>

しかし、$\mathbf{s}''$はもともと秘密鍵$\mathbf{s}$を暗号化してbskをつくるために使用した$\mathbf{s}'$なので、$\mathbf{s}''$を公開して$\mathbf{a''s''}$を直接計算することはできない...

<div><p class="text-center">↓</p></div>
<div class="week5-note-card">
<p class="text-center" style="font-size: 1.2 rem;">
<MathInline expr="\mathbf{s}''"/>を暗号化して公開して<MathInline expr="\text{LWE}_\mathbf{s}(\mathbf{a''s''})"/>
を暗号文のまま計算する
</p>
</div>


わかりやすさのために$\mathbf{a''}$と$\mathbf{s''}$を

$\mathbf{a''}=(a''_{0},a''_{1},\dots,a''_{n-1})$, $\mathbf{s''}=(s''_{0},s''_{1},\dots,s''_{n-1} )$

と書き直しておく。

$\mathbf{a''}$のGadget Decomposition $G^{-1}(\mathbf{a''})=(g^{-1}(a''_0),\dots,g^{-1}(a''_{n-1}))$を考え、$g^{-1}(a''_i)=(\bar{a}_{i,0},\dots,\bar{a}_{i,l-1})$
とする。

さらに、$ksk[i,j]=\text{LWE}_\mathbf{s}(s''_iB^{-(j+1)})(0\le i \le n-1, 0 \le j \le l-1)$ (これをKey switching keyと呼ぶ)を考えると、目的の$\mathbf{s}$による$m$の暗号文$\text{LWE}_\mathbf{s}(m)$は次のように計算できる。

$\text{LWE}_\mathbf{s}(m)\gets (0,\dots,0,b'_0)-\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\bar{a}_{i,j}ksk[i,j]$
