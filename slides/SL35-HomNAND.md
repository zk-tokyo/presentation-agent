---
layout: default
class: text-[0.88rem]
---

# HomNAND

<div></div>

<div class="week5-note-card">
<p style="font-size: 1.2rem; line-height: 1.65;">
① 平文空間を<MathInline expr="\mathbb{Z}_p"/>とし、bitを<MathInline expr="0\mapsto p-1,\quad 1\mapsto1"/>とエンコードする<br>
② 入力暗号文<MathInline expr="c_1,c_2"/>に対して<MathInline expr="c=\mathrm{LWE}_{\mathbf{s}}(1)-c_1-c_2"/>を計算する<br>
③ <MathInline expr="c"/>に対して、全係数が<MathInline expr="1"/>のテスト多項式<MathInline expr="1+x+\dots+x^{n-1} \mod x^n+1"/>でProgrammable Bootstrappingを行う<br>
④ Programmable Bootstrappingの出力が平文同士のNAND演算の出力になっている
</p>
</div>

$c$の平文は$r=1-m_1-m_2\pmod p$となる。

| 入力bit | $m_1$ | $m_2$ | $r=1-m_1-m_2\pmod p$ | NAND | NANDの結果に対応する平文 |
| ------- | ----: | ----: | -------------------: | ---: | -----------------------: |
| $(0,0)$ | $p-1$ | $p-1$ |                  $3$ |  $1$ |                      $1$ |
| $(1,0)$ |   $1$ | $p-1$ |                  $1$ |  $1$ |                      $1$ |
| $(0,1)$ | $p-1$ |   $1$ |                  $1$ |  $1$ |                      $1$ |
| $(1,1)$ |   $1$ |   $1$ |                $p-1$ |  $0$ |                    $p-1$ |

<div class="week5-note-card is-white" style="margin-right: 128px;">
<p class="text-center" style="font-size: 1.2rem; margin: 0;">
rが1,3の時は1が、p-1の時はp-1がv(x)定数項にくるようにパラメーターを設定する
</p>
</div>
