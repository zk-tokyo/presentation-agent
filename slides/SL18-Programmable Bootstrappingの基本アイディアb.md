---
layout: default
---

# Programmable Bootstrappingの基本アイディア

## Bootstrappingでやりたいこと=暗号文のノイズを減らす

<div style="width: 670px;">
  <h2>key observation</h2>
  <p><MathInline expr="f(x)=a_0+a_1x+\dots+a_{n-1}x^{n-1} \;\text{mod}\;x^n+1"/>を考える。</p>
  <p>これに<MathInline expr="x^{-i}\;(0\le i\le n-1)"/>をかけると、</p>
  <div style="font-size: 0.78rem; line-height: 1.35;">
    <MathBlock expr="x^{-i}f(x) \;\text{mod}\;x^n+1
=a_i+a_{i+1}x+\dots+a_{n-1}x^{n-1-i}
-a_0x^{n-i}-a_1x^{n-i+1}-\dots-a_{i-1}x^{n-1}"/>
  </div>
  <p>より、<MathInline expr="a_i"/>が定数項になる</p>
</div>

<div style="position: absolute; right: 44px; top: 124px; width: 430px; padding: 16px 18px 18px; border: 1px solid #c9d8ea; border-radius: 6px; background: #ffffff;">
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

## 多項式の係数を平文にする

LWE暗号文$(\mathbf{a},b)$は$b-\mathbf{as}= \Delta m+e$を満たすことを利用し、$x^{-(b-\mathbf{as})}v(x) \;\text{mod}\; x^n+1$の定数項に、

入力$m$に対応する係数が来るように$v(x)$（テスト多項式）を設計する。

<!--
- Lookup Table
	- あるアルゴリズムをプログラムの実行中に計算するのではなく、よく使われる値とそれに対応する出力を事前計算してテーブルを作成しておき、プログラムの実行中はそのテーブルを参照するようにすることで実行速度を上げるテクニック
	- TFHE系のProgrammable Bootstrappingでは、平文から暗号文を直接引くテーブルを作るのではなく、評価したい関数値を係数に埋め込んだテスト多項式をLookup Tableとして扱う
 -->
