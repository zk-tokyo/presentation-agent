---
layout: default
---

# RLWE

## RLWE暗号のメカニズム

LWE暗号では値のベクトル$(\mathbf{a},b)$を使ったが、RLWE暗号では多項式の組$(a(x),b(x))$を使う。

平文$\mu(x)$、秘密鍵$s(x)$、ノイズ$e(x)$はいずれも次数$n$未満の多項式とする。
多項式の計算はすべて$\text{mod }x^n+1$で行う。

- Gen$(1^\lambda)\to s(x)$:
	- 係数が小さい多項式$s(x)=s_0+s_1x+\dots+s_{n-1}x^{n-1}$を秘密鍵として出力する

- Enc$(\mu(x),s(x))\to (a(x),b(x))$:
	- $a(x)$を一様ランダムに取り、ノイズ$e(x)$をサンプルする
	- $b(x)=a(x)s(x)+\Delta\mu(x)+e(x)\pmod{x^n+1}$として、$(a(x),b(x))$を暗号文として出力する

- Dec$((a(x),b(x)),s(x))\to \mu(x)$:
	- $b(x)-a(x)s(x)=\Delta\mu(x)+e(x)\pmod{x^n+1}$を計算する
	- 係数ごとに$\Delta$で割って丸める

<div class="week5-note-card is-blue">
<p>Blind Rotationではテスト多項式 <MathInline expr="v(x)"/> を暗号文の状態で回転させたい。そのため、平文が1つの値ではなく多項式として入る暗号文が必要になる。</p>
</div>
