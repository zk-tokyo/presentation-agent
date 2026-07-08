---
layout: default
---

# **TFHEの基本情報** a

TFHEの概要について説明する

- Chillotti, Gama, Georgieva, Izabachèneらによる方式。ASIACRYPT 2016の「Faster fully homomorphic encryption: Bootstrapping in less than 0.1 seconds」およびJournal of Cryptology版「TFHE: Fast Fully Homomorphic Encryption over the Torus」[Chi20+]として知られる。


- それまでの方式と比べると<mark style="background: #FFB8EBA6;">bootstrappingが非常に高速</mark>であり、論文中ではbootstrappingを約13msで実行するパラメータ例が報告されている。
	- 今回はTFHEで用いられるbootsrappingのことをProgrammable Bootsrappingと呼ぶ


- FHEWをトーラス(Torus)と呼ばれる代数構造に拡張した方式
	- トーラスの話をするとややこしくなるので、レクチャーの中ではトーラスを使わない方法を扱う



> [!note]
> トーラスを考えるとどんないいことがあるのか気になる人は[Chi20+],[Joy22]を読むことをお勧めする

> [!note]
> TFHEのboostrappingは文献により色々な呼び方があるが、[Chi20+]ではGate BootsrappingとCircuit Bootstrappingの２種類がある