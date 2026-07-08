---
layout: default
---

# Homomorphic Encryption a

準同型暗号の概要について説明する

## **準同型暗号(Homomorphic Encryption)とは** 

<div class="week5-note-card">
	<p class="text-center" style="font-size: 1.2rem;">
	平文に対して演算 <MathInline expr="\oplus" />  ,暗号文に対して演算<MathInline expr="\otimes"/>が可能なとき、<br>
	2つの暗号文<MathInline expr="c_1=Enc(m_1), c_2=Enc(m_2)"/>に対して、<MathInline expr="Dec(c_1 \otimes c_2)=m_1 \oplus m_2"/>が成立する
	</p> 
</div>

<br>

例えば平文に対する加算と暗号文に対する乗算が対応している場合は
  ```mermaid
	flowchart LR
		A[m1,m2] --> |加算| B[m1+m2]
		C[c1,c2] --> |乗算| D[c1*c2] 
		A -->|Enc| C
		D -->|Dec| B
  ```

<br>

> [!note]
>  - 加法だけ、あるいは乗法だけが使える方式を部分準同型暗号(PHE)と呼ぶことがある。  
>  - RSA暗号やElgamal暗号は暗号文同士の乗算が平文同士の乗算になり、Paillier暗号は暗号文同士の乗算が平文同士の加算になる 
>  - 暗号文の状態での演算を準同型演算と呼ぶ。
