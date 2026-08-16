---
layout: default
---

# Programmable Bootstrappingの基本アイディア

## key observation

$v(x)=a_0+a_1x+\dots+a_ix^{i}+\dots+a_{n-1}x^{n-1} \;\text{mod}\;x^n+1$を考える。

これに$x^{-i}\;(0\le i\le n-1)$をかけると、

$x^{-i}v(x) \;\text{mod}\;x^n+1$

$=a_i+a_{i+1}x+\dots+a_{n-1}x^{n-1-i}-a_0x^{n-i}-a_1x^{n-i+1}-\dots-a_{i-1}x^{n-1}$

より、$a_i$が定数項になる。（$x^{-a} \;\text{mod}\;x^n+1 = -x^{n-a}\quad(0\le a\le n)$に注意）

<div style="position: absolute; right: 44px; top: 124px; width: 500px; padding: 16px 18px 18px; border: 1px solid #c9d8ea; border-radius: 6px; background: #ffffff;">
  <div style="position: absolute; left: 22px; top: -12px; padding: 2px 10px; border: 1px solid #c9d8ea; border-radius: 4px; background: #ffffff; color: #111827; font-size: 1rem; line-height: 1.35;">暗号文空間</div>
  <div style="font-size: 1rem; color: #444444; margin-bottom: 8px;">平文の入ったスロットを回転させる</div>
  <PbsSlotRotation />

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
<br>

<div class="week5-note-card week5-card-side">
  <p style="font-size: 1.4rem;">LWE暗号文<MathInline expr="(\mathbf{a},b=\mathbf{as}+\Delta m_i+e)"/>は<MathInline expr="b-\mathbf{as}=\Delta m_i+e"/>を満たすことを利用して、<br>
  <MathInline expr="x^{-(b-\mathbf{as})}v(x) = x^{-(\Delta m_i + e)}v(x) \;\text{mod}\; x^n+1"/>の定数項に<MathInline expr="m_i"/>がくるように<MathInline expr="v(x)"/>の係数を構成する</p>
</div>

<!--
- Lookup Table
	- あるアルゴリズムをプログラムの実行中に計算するのではなく、よく使われる値とそれに対応する出力を事前計算してテーブルを作成しておき、プログラムの実行中はそのテーブルを参照するようにすることで実行速度を上げるテクニック
	- TFHE系のProgrammable Bootstrappingでは、平文から暗号文を直接引くテーブルを作るのではなく、評価したい関数値を係数に埋め込んだテスト多項式をLookup Tableとして扱う
 -->
