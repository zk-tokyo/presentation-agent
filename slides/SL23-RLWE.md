---
layout: default
---

# RLWE

## RLWE暗号のメカニズム

<div class="week5-note-card">
<p>LWE暗号の多項式版</p>
</div>

平文$\mu(x)$、秘密鍵$s(x)$、ノイズ$e(x)$はいずれも次数$n$未満の多項式とする。
多項式の計算はすべて$\text{mod }x^n+1$で行う。

- Gen$(1^\lambda)\to s(x)$:
  - 係数が小さい多項式$s(x)=s_0+s_1x+\dots+s_{n-1}x^{n-1}$を秘密鍵として出力する

- Enc$(\mu(x),s(x))\to (a(x),b(x))$:
  - $a(x)$を一様ランダムに取り、ノイズ$e(x)$をサンプルする
  - $b(x)=a(x)s(x)+\Delta\mu(x)+e(x)\text{ mod } x^n+1$として、$(a(x),b(x))$を暗号文として出力する

- Dec$((a(x),b(x)),s(x))\to \mu(x)$:
  - $b(x)-a(x)s(x)=\Delta\mu(x)+e(x)\text{ mod } x^n+1$を計算する
  - 係数ごとに$\Delta$で割って丸める
