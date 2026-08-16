---
layout: default
---

# **RGSW**

<div></div>

## **RLWEとRGSWによるexternal product**

多項式のベクトルに対するGadget Decompositionにより、

RGSW暗号文とRLWE暗号文の積(External Product)$\boxdot$を定義する

$$\text{RGSW}_{s}(m)\boxdot \text{RLWE}_{s}(\Delta m'):=G^{-1}(\text{RLWE}_{s}(\Delta m')) \text{RGSW}_{s}(m)$$

これを計算すると、

$$
\begin{aligned}
    &G^{-1}\!\left(\mathrm{RLWE}_s(\Delta m')\right)\mathrm{RGSW}_s(m)\\
    &=G^{-1}\!\left(\mathrm{RLWE}_s(\Delta m')\right)(\mathcal Z+mG^\mathsf T)\\
    &=\underbrace{
    G^{-1}\!\left(\mathrm{RLWE}_s(\Delta m')\right)\mathcal Z}_{\mathrm{RLWE}_s(0)}
    + m\underbrace{
    G^{-1}\!\left(\mathrm{RLWE}_s(\Delta m')\right)G^\mathsf T}_{\mathrm{RLWE}_s(\Delta m')}\\
&=\mathrm{RLWE}_s(\Delta mm')
\end{aligned}
$$
