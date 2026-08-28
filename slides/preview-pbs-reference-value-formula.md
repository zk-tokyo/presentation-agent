---
layout: default
class: week5-prototype week5-prototype-formula
---

# [数式] PBSで参照する量

Blind Rotationでは、復号式に現れる量を指数としてテスト多項式を回転する。

| 対象             | 式                                            |
| -------------- | -------------------------------------------- |
| LWE暗号文         | $c=(\mathbf{a},b)$                           |
| 復号式に現れる量       | $b-\langle\mathbf a,\mathbf s\rangle= \Delta m+e \pmod q$ |
| テスト多項式         | $v(x)$                                       |
| Blind Rotation | $x^{-(b-\langle\mathbf a,\mathbf s\rangle)}v(x)$          |
| 出力             | $f(m)$を暗号化したLWE暗号文                           |

PBSでは、テスト多項式$v(x)$の係数によって出力関数$f$を指定する。
