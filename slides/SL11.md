---
layout: default
---

# **LWE暗号文同士の乗算とノイズ** a

手法方式での暗号文同士の乗算の実現方法とノイズへの対処法を説明する

### Gentry's blueprint
- 暗号文を多項式のベクトル表現として解釈し、暗号文同士の積を多項式の積として行う
- ノイズは指数関数的に増加する
- 暗号文を暗号文の状態で復号する(=Bootstrapping)ことでノイズを削減する
 
 ### BGV, BFV, CKKS
- ベクトルである暗号文同士のテンソル積を計算する
	- テンソル積により暗号文の次数・形が通常の暗号文から外れるので、Relinearization/Key Switchingで通常形へ戻す
- BGVではModulus Switching、CKKSではRescalingがノイズ・スケール管理の中心になる。BFVでも実装上はmodulus switching/rescalingに相当するRNS・modulus管理が使われることがある
### GSW
- 暗号文の形を工夫して行列の形で表すことで、暗号文同士の積をビット分解と行列の同士の掛け算で実現しつつBootstrappingを高速化
- ノイズの増大を抑えるためにGadget Decompositionを導入
### FHEW, TFHE
- BootstrappingをGSWからさらに高速化
	- 特殊なBootstrappingを設計して暗号文同士をノイズを減らしながら関数評価することを可能にした
- 平文同士の乗算は平文をbit表現し、暗号文の状態でNAND演算を組み合わせた乗算を適用することで実現可能
