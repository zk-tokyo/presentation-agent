---
layout: default
---

# CMUX

## **RLWEとRGSWによるexternal product**

多項式のベクトルに対するGadget Decompositionにより、RGSW暗号文とRLWE暗号文の積(External Product)$\boxdot$を定義する  
$\text{RGSW}_{s}(m)\boxdot \text{RLWE}_{s}(m')=G^{-1}(\text{RLWE}_{s}(m')) \text{RGSW}_{s}(m)=\text{RLWE}_{s}(mm')$

## CMUX

RLWEとRGSWを使うことで、$a_0,a_1\in\{0,1\}$に対して、ビット$b$によってどちらかを指定するマルチプレクサ$\text{MUX}(b,a_0,a_1)=a_b$を暗号文の状態で行うCMUXが構成可能  
マルチプレクサは$\text{MUX}(b,a_0,a_1)=(1-b)a_0+ba_1=b(a_1-a_0)+a_0$より計算できるので、それぞれ、$c_0=\text{RLWE}_{s}(a_0),c_1=\text{RLWE}_{s}(a_1), c_b=\text{RGSW}_{s}(b)$とすると、$\text{CMUX}(c_b,c_0,c_1)=c_b\boxdot(c_1-c_0)+c_0=\text{RLWE}_{s}(a_b)$

> Q. CMUXの出力が$a_b$のRLWE暗号文になることを各自確認
