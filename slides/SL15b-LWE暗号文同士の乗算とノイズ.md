---
layout: default
---

# **LWE暗号文同士の乗算とノイズ**

## GSW

- 暗号文の形を工夫して行列の形で表すことで、暗号文同士の積をビット分解と行列同士の掛け算で実現した
- ノイズの増大を抑えるためにGadget Decompositionを導入

## FHEW, TFHE

- GSWを利用してBootstrappingを高速化
  - Bootstrappingでノイズを減らしながら関数評価することを可能にした
- 平文同士の乗算は平文をbit表現し、暗号文の状態でNAND演算を組み合わせた乗算を適用することで実現可能
