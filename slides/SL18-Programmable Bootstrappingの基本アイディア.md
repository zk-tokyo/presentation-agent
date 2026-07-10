---
layout: default
---

# Programmable Bootstrappingの基本アイディア

## Bootstrappingでやりたいこと=暗号文のノイズを減らす

<div class="week5-note-card is-blue" style="width: 63%;">
<p style="font-size: 1.2rem;">古い暗号文の情報を使って、リストの中からノイズの少ない暗号文を索引する</p>
</div>

## key observation

$f(x)=a_0+a_1x+\dots+a_{n-1}x^{n-1} \;\text{mod}\;x^n+1$を考える。

これに$x^{-i}\;(0\le i\le n-1)$をかけると、

$x^{-i}f(x) \;\text{mod}\;x^n+1=a_i+a_{i+1}x\dots+a_{n-1}x^{n-1-i}-a_0x^{n-i}-a_1x^{n-i+1}-\dots-a_{i-1}x^{n-1} \;\text{mod}\;x^n+1$

より、$a_i$が定数項になる

## 定数項を平文にする

<div class="week5-note-card">
<p class="text-center">平文空間のすべての平文を係数にした多項式を考え、暗号文を使って目的の平文を定数項に持ってくる</p>
</div>

<div style="position: absolute; right: 44px; top: 118px; width: 430px; padding: 16px 18px 18px; border: 1px solid #c9d8ea; border-radius: 6px; background: #ffffff;">
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

LWE暗号文$(\mathbf{a},b)$は$b-\mathbf{as}= \Delta m+e$を満たすことを利用し、$x^{-(b-\mathbf{as})}v(x) \;\text{mod}\; x^n+1$の定数項に、入力$m$に対応する係数が来るように$v(x)$を設計する。

だいたい$v_q(x)=\sum_{m\in\mathbb{Z}_p}\sum_e m x^{\Delta m+e}\pmod{x^q+1}$ のような感じ

<!--
- Lookup Table
	- あるアルゴリズムをプログラムの実行中に計算するのではなく、よく使われる値とそれに対応する出力を事前計算してテーブルを作成しておき、プログラムの実行中はそのテーブルを参照するようにすることで実行速度を上げるテクニック
	- TFHE系のProgrammable Bootstrappingでは、平文から暗号文を直接引くテーブルを作るのではなく、評価したい関数値を係数に埋め込んだテスト多項式をLookup Tableとして扱う
 -->
