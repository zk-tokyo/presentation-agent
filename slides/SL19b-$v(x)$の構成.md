---
layout: default
---

# $v(x)$の構成

<div></div>

### 実用上の注意

実用的なパラメータでは$q$が大きすぎるため、多項式の次数は$q$より小さい$n$にし、

$\mathbf a$と$b$も$n$に合わせて変換する（Rescaling や Modulus Switching と呼ぶ）。

<div style="font-size: 1.3rem;">
  <MathBlock expr="\begin{aligned}
v(x)={}&m_0x^{\left\lfloor(\Delta m_0+e_0)\frac{2n}{q}\right\rceil}+\cdots+m_0x^{\left\lfloor(\Delta m_0+e_r)\frac{2n}{q}\right\rceil}\\
&+\cdots+m_ix^{\left\lfloor(\Delta m_i+e_0)\frac{2n}{q}\right\rceil}+\cdots+m_ix^{\left\lfloor(\Delta m_i+e_r)\frac{2n}{q}\right\rceil}\\
&+\cdots+m_{p-1}x^{\left\lfloor(\Delta m_{p-1}+e_0)\frac{2n}{q}\right\rceil}+\cdots+m_{p-1}x^{\left\lfloor(\Delta m_{p-1}+e_r)\frac{2n}{q}\right\rceil}
\pmod{x^n+1}
\end{aligned}"/>
</div>

$\hat b=\left\lfloor b\frac{2n}{q}\right\rceil$、$\hat{\mathbf a}=\left\lfloor\mathbf a\frac{2n}{q}\right\rceil$へ変換し、$x^{-(\hat b-\hat{\mathbf a}\mathbf s)}v(x) \pmod{x^n+1}$を計算する。


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
