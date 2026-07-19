---
layout: default
---

# **TFHEの基本情報**

- Chillotti, Gama, Georgieva, Izabachèneらによる方式。

- それまでの方式と比べると<mark style="background: #FFB8EBA6;">bootstrappingが非常に高速</mark>であり、論文中ではbootstrappingを約13msで実行するパラメータ例が報告されている。
  - 今回はTFHEで用いられるbootstrappingのことをProgrammable Bootstrappingと呼ぶ

- FHEWをトーラス(Torus)と呼ばれる代数構造に拡張した方式
  - トーラスの話をするとややこしくなるので、レクチャーの中ではトーラスを使わない方法を扱う
  - 鍵生成、暗号化、復号は、今回はLWE暗号と同じになる

> [!note]
> トーラスを考えるとどんないいことがあるのか気になる人は[Chi20+],[Joy22]を読むことをお勧めする

> [!note]
> TFHEのbootstrappingは文献により色々な呼び方があるが、[Chi20+]ではGate BootstrappingとCircuit Bootstrappingの２種類がある
