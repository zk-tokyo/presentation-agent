---
layout: default
class: week5-prototype week5-prototype-intuition
---

# 完全準同型暗号をどう読むか [直感]

Week 5 では、完全準同型暗号を「暗号文を開けずに計算し、最後に結果だけを復号する仕組み」として読む。

> **このスライドの役割**
> ここでは数式を追わず、FHE、LWE、Bootstrapping、TFHE/PBSの位置関係だけを見る。

| 扱う対象 | 直感的な読み方 |
| --- | --- |
| FHE | 暗号文のまま計算する |
| LWE | 復号できる範囲にノイズを持つ暗号文 |
| Bootstrapping | 増えたノイズを戻して計算を続ける |
| TFHE/PBS | Bootstrapping中に関数評価も行う |
