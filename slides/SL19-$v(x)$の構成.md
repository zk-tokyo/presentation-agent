---
layout: default
---

# $v(x)$の構成

<div></div>

平文$m$に対するLWE暗号文$(\mathbf{a},b)$は$b-\mathbf{as}=\Delta m+e \pmod q$を満たす。

まず、$q$個の係数を持つ多項式を使えるなら、ノイズ$e$が取りうる値をすべて並べて

$v_q(x)=\ m_0x^{\Delta m_0+e_0}+m_0x^{\Delta m_0+e_1}+\dots+m_1x^{\Delta m_1+e_0}+m_1x^{\Delta m_1+e_1}+\dots \text{ mod }x^q+1$

とすれば、$x^{-(b-\mathbf{as})}v_q(x)=x^{-(\Delta m + e)}v_q(x)$の定数項に$m$がくる。

<br>

### 実用上の注意

実用的なパラメータでは$q$が大きすぎるため、多項式の次数は$q$より小さい$n$にし、$\mathbf{a}$と$b$も$n$に合わせて変換する（リスケーリング）

すなわちノイズ削減のためのテスト多項式は以下のような形になる

$v(x)=\ m_0x^{\lfloor (\Delta m_0+e_0) \frac{2n}{q}\rceil}+m_0x^{\lfloor (\Delta m_0+e_1) \frac{2n}{q}\rceil}+\dots+m_1x^{\lfloor (\Delta m_1+e_0) \frac{2n}{q}\rceil}+m_1x^{\lfloor (\Delta m_1+e_1) \frac{2n}{q}\rceil}+\dots \text{ mod }x^n+1$

テスト多項式を回転させる場合、
$\hat{b}=\lfloor b\frac{2n}{q}\rceil, \hat{\mathbf{a}}=\lfloor \mathbf{a}\frac{2n}{q}\rceil$と変換する。係数ごとの丸めにより
$\hat b-\hat{\mathbf a}\mathbf s\approx(b-\mathbf a\mathbf s)\frac{2n}{q}$であり、$x^{-(\hat{b}-\hat{\mathbf{a}}\mathbf s)}v(x) \text{ mod }x^n+1$を計算する

また、丸め後に同じ指数となる項は1つにまとめ、異なる値を同じ係数位置に置かないよう注意する。

<div style="position: absolute; right: 44px; top: 100px; width: 430px; padding: 16px 18px 18px; border: 1px solid #c9d8ea; border-radius: 6px; background: #ffffff;">
  <div style="position: absolute; left: 22px; top: -12px; padding: 2px 10px; border: 1px solid #c9d8ea; border-radius: 4px; background: #ffffff; color: #111827; font-size: 0.74rem; line-height: 1.35;">暗号文空間</div>
  <div style="font-size: 0.78rem; color: #444444; margin-bottom: 8px;">平文の入ったスロットを回転させる</div>
  <div style="display: grid; grid-template-columns: repeat(8, 1fr); border: 1px solid #17324d; border-right: 0; height: 34px;">
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;"><MathInline expr="m_0"/></div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;"><MathInline expr="m_0"/></div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;">...</div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;"><MathInline expr="m_1"/></div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;"><MathInline expr="m_1"/></div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;">...</div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;"><MathInline expr="m_{p-1}"/></div>
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;"><MathInline expr="m_{p-1}"/></div>
  </div>

  <div style="display: flex; align-items: center; gap: 12px; margin: 10px 0 8px;">
    <div style="font-size: 2rem; line-height: 1; color: #17324d;">↓</div>
    <div style="font-size: 0.74rem; line-height: 1.45; color: #111827;">
      暗号文 <MathInline expr="(a,b)"/> に対し、<br>
      <MathInline expr="b-\mathbf{as}=\Delta m+e"/> の分だけ回す
    </div>
  </div>

  <div style="display: grid; grid-template-columns: repeat(8, 1fr); border: 1px solid #17324d; border-right: 0; height: 34px;">
    <div style="display: grid; place-items: center; border-right: 1px solid #17324d; font-size: 0.8rem;"><MathInline expr="m"/></div>
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
    <div style="width: 42px; height: 34px; display: grid; place-items: center; border: 1px solid #17324d; background: #f2f7fc; font-size: 0.8rem;"><MathInline expr="m"/></div>
  </div>
</div>
