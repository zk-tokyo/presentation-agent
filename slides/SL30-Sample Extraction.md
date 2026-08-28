---
layout: default
---

# **Sample Extraction**

<div></div>

<div class="week5-note-card week5-card-side">
<p class="text-center" style="font-size: 1.3rem;"><MathInline expr="\text{RLWE}_{s'}(\Delta x^{-\hat{b}+\langle\hat{\mathbf a},\mathbf s\rangle}v(x))=\text{RLWE}_{s'}(\Delta(m+\mu_1x+\mu_2x^2+\dots+\mu_{n-1}x^{n-1}))"/></p>

<p class="text-center" style="font-size: 1.3rem;">この多項式の定数項<MathInline expr="m"/>を暗号文のまま取り出す</p>
</div>

Blind Rotationによって得られた暗号文を$\text{RLWE}_{s'}(\Delta x^{-\hat{b}+\langle\hat{\mathbf a},\mathbf s\rangle}v(x))=(a'(x),b'(x))$とおき、

$$
a'(x)=a'_0+a'_1x+\dots+a'_{n-1}x^{n-1}
, \quad s'(x)=s'_0+s'_1x+\dots+s'_{n-1}x^{n-1}
, \quad b'(x)=b_0'+b_1'x +\dots+b_{n-1}'x^{n-1}
$$

とおくと、

<p class="text-center" style="font-size: 1.3rem;">

<MathInline expr="
\begin{aligned}
b'(x)&=b_0'+b_1'x +\dots+b_{n-1}'x^{n-1}\\
&=a'(x)s'(x)+\Delta\mu+e\\
&=(a'_0+a'_1x+\dots+a'_{n-1}x^{n-1})(s'_0+s'_1x+\dots+s'_{n-1}x^{n-1})\\
&\;\;\;+\Delta(m+\mu_1x+\mu_2x^2+\dots+\mu_{n-1}x^{n-1})+(e_0+e_1x+\dots+e_{n-1}x^{n-1})
\end{aligned}"
/>

</p>

定数項$b'_0$に$\Delta m + e_0$が含まれている！

$(a'_0+a'_1x+\dots+a'_{n-1}x^{n-1})(s'_0+s'_1x+\dots+s'_{n-1}x^{n-1})$の定数項がどうなるか確認する
