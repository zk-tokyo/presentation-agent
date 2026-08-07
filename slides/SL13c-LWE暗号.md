---
layout: default
---

# **LWE暗号**

<div class="week5-note-card" style="position: absolute; top: 92px; right: 10px; width: 450px; margin: 12; padding: 10px 12px;">
<p style="font-size: 1.2rem; line-height: 1.45;">大ざっぱにいうと；<br>平文を<MathInline expr="\mathbf{as}"/>によって隠し、<MathInline expr="e"/>を足して式を少しずらすことで<MathInline expr="m"/>や<MathInline expr="\mathbf{s}"/>の復元を困難にする</p>
</div>

## LWE暗号(共通鍵暗号)のメカニズム

平文空間を$\mathbb{Z}_p$, 暗号文空間を$\mathbb{Z}_q^{k+1}$、ノイズの分布を$χ$とし、$p \mid q$と仮定する。

<p style="font-size: 1.4rem; line-height: 1.45;"><MathInline expr="\text{Gen}(1^\lambda)\to \mathbf{s}=(s_0,s_1,\dots,s_{k-1}) \in\{0,1\}^k"/>:</p>

- 長さ$k$のビット列を一様ランダムに取り秘密鍵$\mathbf{s}=(s_0,s_1,\dots,s_{k-1})\in \{0,1\}^k$として出力する

<p style="font-size: 1.4rem; line-height: 1.45;"><MathInline expr="\text{Enc}(\Delta m,\mathbf{s})\to c=(\mathbf{a},b=\mathbf{as}+\Delta m + e)\in \mathbb{Z}_q^{k+1}"/>:</p>

- $\mathbf{a}=(a_0,a_1,\dots,a_{k-1})\in \mathbb{Z}_q^k$は一様ランダムに取り、ノイズ$e$は分布$χ$に基づいて$\mathbb{Z}_q$からサンプルする
- $\Delta$は$\Delta:=q/p$であり、スケーリングファクターと呼ばれる

<p style="font-size: 1.4rem; line-height: 1.45;"><MathInline expr="\text{Dec}(c,\mathbf{s})\to m =\left\lfloor \frac{b-\mathbf{as} \text{ mod }q}{\Delta}\right\rceil \text{ mod } p \in \mathbb{Z}_p"/>:</p>

- $\lfloor a \rceil$は$a$をもっとも近い整数値にする操作。要は四捨五入
- $-\frac{\Delta}{2}\le e < \frac{\Delta}{2}$であれば正常に復号可能

以降、平文$m$の秘密鍵$\mathbf{s}$によるLWE暗号文を$\text{LWE}_{\mathbf{s}}(\Delta m)$と書く

> Q. 暗号文が復号できることを各自確認  
> note:
> 今回$p,q$は素数である必要性がないことに注意。実際は$q=2^{64}$などがよく用いられる  
> ノイズをサンプルする分布にはガウス分布などが用いられる。
