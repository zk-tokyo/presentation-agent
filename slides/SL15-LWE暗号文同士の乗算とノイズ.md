---
layout: default
---

# **LWE暗号文同士の乗算とノイズ**

## Gentry's blueprint

- 暗号文を多項式のベクトル表現として解釈し、暗号文同士の積を多項式の積として行う
- ノイズは指数関数的に増加する
- 暗号文を暗号文の状態で復号する(=Bootstrapping)ことでノイズを削減する

## BGV, BFV, CKKS

- ベクトルである暗号文同士のテンソル積を計算する
  - テンソル積により暗号文の次数・形が通常の暗号文から外れるので、Relinearization/Key Switchingで通常形へ戻す
- BGVではModulus Switching、CKKSではRescalingがノイズ・スケール管理の中心になる。BFVでも実装上はmodulus switching/rescalingに相当するRNS・modulus管理が使われることがある
