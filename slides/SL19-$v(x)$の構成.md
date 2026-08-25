---
layout: default
---

# $v(x)$の構成

<div></div>

## ポイントは幅を持たせること

<div style="position: absolute; left: 56px; top: 150px; width: 700px; color: #111827; font-size: 1rem; line-height: 1.42;">
  <p>入力平文<MathInline expr="m_i"/>に対するLWE暗号文<MathInline expr="(\mathbf{a},b)"/>は<MathInline expr="b-\mathbf{as}=\Delta m_i+e \pmod q"/>を満たす。</p>
  <p style="margin-top: 12px;"><MathInline expr="q"/>個の係数を使えるなら、ノイズの候補<MathInline expr="e_0,\ldots,e_r"/>を直接並べて</p>
  <div style="font-size: 1.3rem;">
    <MathBlock expr="\begin{aligned}
v_q(x)={}&m_0x^{\Delta m_0+e_0}+\cdots+m_0x^{\Delta m_0+e_r}\\
&+\cdots+m_ix^{\Delta m_i+e_0}+\cdots+m_ix^{\Delta m_i+e_r}\\
&+\cdots+m_{p-1}x^{\Delta m_{p-1}+e_0}+\cdots+m_{p-1}x^{\Delta m_{p-1}+e_r}
\pmod{x^q+1}
\end{aligned}"/>
  </div>
  <p>とする。すると</p>
  <div style="font-size: 1.3rem;"><MathBlock expr="x^{-(b-\mathbf{as})}v_q(x)=x^{-(\Delta m_i+e)}v_q(x)"/></div>
  <p>の定数項に<MathInline expr="m_i"/>がくる。</p>
</div>

<div style="position: absolute; right: 44px; top: 100px; width: 430px; padding: 16px 18px 18px; border: 1px solid #c9d8ea; border-radius: 6px; background: #ffffff;">
  <div style="position: absolute; left: 22px; top: -12px; padding: 2px 10px; border: 1px solid #c9d8ea; border-radius: 4px; background: #ffffff; color: #111827; font-size: 0.74rem; line-height: 1.35;">暗号文空間</div>
  <div style="font-size: 0.78rem; color: #444444; margin-bottom: 8px;">平文の入ったスロットを回転させる</div>
  <div style="display: grid; grid-template-columns: 1fr 0.55fr 1fr 0.55fr 1fr 0.55fr 1fr 0.55fr 1.25fr 0.55fr 1.25fr; border: 1px solid #17324d; border-right: 0; height: 34px;">
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;"><MathInline expr="m_0" /></div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;">…</div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;"><MathInline expr="m_0" /></div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;">…</div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; background: #f2f7fc; font-size: 0.8rem;"><MathInline expr="m_i" /></div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;">…</div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; background: #f2f7fc; font-size: 0.8rem;"><MathInline expr="m_i" /></div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;">…</div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;"><MathInline expr="m_{p-1}" /></div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;">…</div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;"><MathInline expr="m_{p-1}" /></div>
  </div>

  <div style="display: flex; align-items: center; gap: 12px; margin: 10px 0 8px;">
    <div style="font-size: 2rem; line-height: 1; color: #17324d;">↓</div>
    <div style="font-size: 0.74rem; line-height: 1.45; color: #111827;">
      暗号文 <MathInline expr="(a,b)"/> に対し、<br>
      <MathInline expr="b-\mathbf{as}=\Delta m_i+e"/> の分だけ回す
    </div>
  </div>

  <div style="display: grid; grid-template-columns: repeat(8, 1fr); border: 1px solid #17324d; border-right: 0; height: 34px;">
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; background: #f2f7fc; font-size: 0.8rem;"><MathInline expr="m_i"/></div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;">...</div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;"></div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;">...</div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;"></div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;">...</div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;"></div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;">...</div>
  </div>

  <div style="display: flex; align-items: center; gap: 10px; margin-top: 10px;">
    <div style="font-size: 0.74rem; color: #444444;">取り出す</div>
    <div style="width: 42px; height: 34px; display: grid; place-items: center; border: 1px solid #17324d; background: #f2f7fc; font-size: 0.8rem;"><MathInline expr="m_i"/></div>
  </div>
</div>

<div style="height: 314px;"></div>
