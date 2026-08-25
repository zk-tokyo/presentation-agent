---
layout: default
---

# **TFHEの基本情報**
。

- それまでの方式と比べると<mark style="background: #FFB8EBA6;">bootstrappingが非常に高速</mark>であり、論文中ではbootstrappingを約13msで実行するパラメータ例が報告されている。

- FHEWをトーラス(Torus)と呼ばれる代数構造に拡張した方式
  - トーラスの話をするとややこしくなるので、レクチャーの中ではトーラスを使わない方法を扱う
  - 鍵生成、暗号化、復号は、今回はLWE暗号と同じになる

- 今回扱う内容
  - Programmable Bootstrappingの基本アイデア
  - Programmable Bootstrappingの3つのサブモジュール
    - Blind Rotation
    - Sample Extraction
    - Key Switching
  - HomNAND
> note:
> トーラスを考えるとどんないいことがあるのか気になる人は[Chi20+],[Joy22]を読むことをお勧めする

> note:
> TFHEのbootstrappingは文献により色々な呼び方があるが、[Chi20+]ではGate BootstrappingとCircuit Bootstrappingの２種類がある
