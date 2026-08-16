---
layout: default
class: text-[0.95rem]
---

# なぜ "Programmable" Bootstrappingなのか

<div class="week5-note-card" style="margin-top: 16px; padding: 14px 18px;">
  <p class="text-center" style="font-size: 1.25rem; margin: 0;">
    テスト多項式<MathInline expr="v_q(x)"/>の係数を<MathInline expr="m_j"/>から<MathInline expr="f(m_j)"/>へ変えると、<br>
    暗号文を作り直しながら関数<MathInline expr="f"/>も評価できる
  </p>
</div>

<div style="margin-top: 18px;">
<div style="text-align: right; font-size: 0.82rem; color: #444444; margin-bottom: 2px;">※ここではわかりやすさのためにリスケーリングを省略</div>
<div style="font-size: 1.2rem;">
  <MathBlock expr="\begin{aligned}
v_q(x)={}&m_0x^{\Delta m_0+e_0}+\cdots+m_0x^{\Delta m_0+e_r}
+\cdots+m_ix^{\Delta m_i+e_0}+\cdots+m_ix^{\Delta m_i+e_r}+\cdots\pmod{x^q+1}
\end{aligned}"/>
</div>
<br>
  <p class="text-center" style="font-size: 1rem; margin: 0;">
    ↓係数を<MathInline expr="f(m_j)"/>にする
  </p>
<br>
  <div style="font-size: 1.2rem; line-height: 1.2;">
    <MathBlock expr="\begin{aligned}
v_q(x)={}&f(m_0)x^{\Delta m_0+e_0}+\cdots+f(m_0)x^{\Delta m_0+e_r}
+\cdots+f(m_i)x^{\Delta m_i+e_0}+\cdots+f(m_i)x^{\Delta m_i+e_r}
+\cdots
\pmod{x^q+1}
\end{aligned}"/>
  </div>
</div>

<br>

<div style="margin-top: 8px; display: grid; grid-template-columns: 1fr 44px 1.45fr 44px 1fr; align-items: center; text-align: center;">
  <div>
    <div style="font-size: 0.76rem; color: #444444;">入力</div>
    <div style="font-size: 1.05rem;"><MathInline expr="\mathrm{LWE}_{\mathbf{s}}(\Delta m_i)"/></div>
  </div>
  <div style="font-size: 1.6rem; color: #17324d;">→</div>
  <div>
    <div style="font-size: 0.76rem; color: #444444;">同じBlind Rotationを行う</div>
    <div><MathInline expr="x^{-(b-\mathbf{as})}v_q(x)"/>の定数項が<MathInline expr="f(m_i)"/>になる</div>
  </div>
  <div style="font-size: 1.6rem; color: #17324d;">→</div>
  <div>
    <div style="font-size: 0.76rem; color: #444444;">出力</div>
    <div style="font-size: 1.05rem;"><MathInline expr="\mathrm{LWE}_{\mathbf{s}}(\Delta f(m_i))"/></div>
  </div>
</div>

<br>

<div class="week5-note-card is-white" style="margin-top: 14px; padding: 10px 16px; margin-right: 128px;">
  <div style="font-weight: 700; margin-bottom: 3px;">係数を並べるとき</div>
  <div style="font-size: 0.9rem; line-height: 1.5;">
    実際にはリスケーリングの丸めもある。回転先が少しずれても同じ値を取り出せるよう、同じ<MathInline expr="m_j"/>に対応する複数の位置へ<MathInline expr="f(m_j)"/>を繰り返し置く。<br>
    異なる平文が同じ位置に重なる場合、1回のPBSで区別できるのは、それらに対する<MathInline expr="f(m_j)"/>が同じときだけ。
  </div>
</div>
