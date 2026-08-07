---
layout: default
---

# RLWE

## RLWE暗号 = LWE暗号の多項式版

多項式の計算はすべて$\mod x^n+1$で行う（多項式の係数の剰余は以降$q$とする)。

<p style="font-size: 1.4rem;"><MathInline expr="\text{Gen}(1^\lambda)\to s(x)"/>:</p>

- 係数が小さい多項式$s(x)=s_0+s_1x+\dots+s_{n-1}x^{n-1}$を秘密鍵として出力する

<p style="font-size: 1.4rem;"><MathInline expr="\text{Enc}(\Delta\mu(x),s(x))\to (a(x),b(x))"/>:</p>

- $a(x)$を一様ランダムに取り、ノイズ$e(x)$をサンプルする
- $b(x)=a(x)s(x)+\Delta\mu(x)+e(x)\text{ mod } x^n+1$として、$(a(x),b(x))$を暗号文として出力する
- 平文$\mu(x)$の秘密鍵$s(x)$によるRLWE暗号文を$\text{RLWE}_s(\Delta\mu)$と書く

<p style="font-size: 1.4rem;"><MathInline expr="\text{Dec}((a(x),b(x)),s(x))\to \mu(x)"/>:</p>

- $b(x)-a(x)s(x)=\Delta\mu(x)+e(x)\text{ mod } x^n+1$を計算する
- 係数ごとに$\Delta$で割って丸める

> note:
> RLWE暗号文はLWE暗号文と同様に暗号文と平文の加算、乗算、暗号文同士の加算が行える
