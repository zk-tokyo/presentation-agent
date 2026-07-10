---
layout: default
---

# **（判定）LWE問題とLWE仮定**

## LWE問題とは

<div class="week5-note-card week5-card-side" style="width: 80%; margin-left: auto; margin-right: auto;">
<p class="text-center" style="font-size: 1.2rem;">値の組み<MathInline expr="(\mathbf{a}, b)"/>が<MathInline expr="b=\mathbf{as} +e \text{ mod } q"/>を満たすか、<br>ただのランダムな値の組み合わせなのか判定する問題</p>
</div>

ここで、整数$k\ge 1$, $q \ge 2$, $\mathbf{s}\in\mathbb{Z}^k_q$, および$\mathbb{Z}$上の確率分布$\chi$に対して，$\mathbf{a}\in \mathbb{F}_q^k$を一様ランダムに取り，$e\in \mathbb{Z}_q$を$\chi$に従ってとっている。また$\mathbf{as}$は内積を表す。

また、LWE問題を解くのが計算量的に困難であるという仮定をLWE仮定と呼ぶ。
<br>

> [!note]
> LWEはLearning With Errorの略で、上の式のeはノイズ(error)と呼ばれる。

> [!note]
> このLWE問題を判定LWE(Decision-LWE)と呼び，$b=\Sigma_{i=0}^{k-1} a_is_i+e \text{ mod } q$が成立している時に$(\mathbf{a},b)$から$\mathbf{s}$を求める場合を探索LWE(Search-LWE)と呼びわけることがある。
