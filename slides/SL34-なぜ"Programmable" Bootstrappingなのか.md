---
layout: default
class: text-[0.95rem]
---

# なぜ "Programmable" Bootstrappingなのか

<div class="week5-note-card" style="margin-top: 16px; padding: 14px 18px;">
  <p class="text-center" style="font-size: 1.25rem; margin: 0;">
    テスト多項式<MathInline expr="v(X)"/>の係数に<MathInline expr="m"/>ではなく<MathInline expr="f(m)"/>を並べると、<br>
    暗号文を作り直しながら関数<MathInline expr="f"/>も評価できる
  </p>
</div>

<div style="margin-top: 18px; display: grid; gap: 11px;">
  <div style="display: grid; grid-template-columns: 42px 310px 1fr; align-items: center; min-height: 62px; border-bottom: 1px solid #e0e0e0; padding: 4px 8px 10px;">
    <div style="width: 30px; height: 30px; display: grid; place-items: center; border-radius: 999px; background: #f2f7fc; border: 1px solid #c9d8ea; font-weight: 700;">1</div>
    <div>平文<MathInline expr="m"/>とノイズ<MathInline expr="e"/>に対応する<br>係数位置</div>
    <div style="font-size: 1.05rem;"><MathInline expr="r(m,e):=\left\lfloor(\Delta m+e)\frac{2n}{q}\right\rceil\bmod 2n"/></div>
  </div>

  <div style="display: grid; grid-template-columns: 42px 310px 1fr; align-items: center; min-height: 62px; border-bottom: 1px solid #e0e0e0; padding: 4px 8px 10px;">
    <div style="width: 30px; height: 30px; display: grid; place-items: center; border-radius: 999px; background: #f2f7fc; border: 1px solid #c9d8ea; font-weight: 700;">2</div>
    <div>テスト多項式<MathInline expr="v(X)"/>の①の係数位置に<br>評価したい値を置く</div>
    <div style="font-size: 1rem;"><MathInline expr="v(X):=\sum_{i=0}^{n-1}v_iX^i,\qquad v_{r(m,e)}:=f(m)"/></div>
  </div>

  <div style="display: grid; grid-template-columns: 42px 310px 1fr; align-items: center; min-height: 62px; padding: 4px 8px 2px;">
    <div style="width: 30px; height: 30px; display: grid; place-items: center; border-radius: 999px; background: #f2f7fc; border: 1px solid #c9d8ea; font-weight: 700;">3</div>
    <div>同じBlind Rotationで<MathInline expr="f(m)"/>が<br>定数項へ移る</div>
    <div style="font-size: 1.05rem;"><MathInline expr="\mathrm{LWE}_{\mathbf{s}}(\Delta m)\longrightarrow\mathrm{LWE}_{\mathbf{s}}(\Delta f(m))"/></div>
  </div>
</div>

<div class="week5-note-card is-white" style="margin-top: 16px; padding: 12px 16px; margin-right: 128px;">
  <div style="font-weight: 700; margin-bottom: 5px;">係数を並べるときの注意</div>
  <div style="font-size: 0.86rem; line-height: 1.55;">
    ・丸め：<MathInline expr="\mathbf{a}"/>と<MathInline expr="b"/>を別々に丸めると回転先が前後するため、候補となる係数すべてに同じ<MathInline expr="f(m)"/>を置く<br>
    ・係数位置の重なり：異なる平文が同じ位置に対応するなら、それらに対する<MathInline expr="f(m)"/>は同じ値である必要がある<br>
    ・符号反転：<MathInline expr="r(m,e)<n"/>では<MathInline expr="v_{r(m,e)}:=f(m)"/>、<MathInline expr="r(m,e)\ge n"/>では<MathInline expr="v_{r(m,e)-n}:=-f(m)"/>と置く
  </div>
</div>
