---
layout: center
class: section-slide section-1
---

# Part 1: マルチパーティ計算(MPC: Multi-Party Computation) は何をしたい技術か

<ChapterMap :current="1" />

---
layout: default
class: framing-slide
---

# 目的

<!-- Advanced Cryptography Program の中で MPC が何を扱う技術なのかを位置づけ、具体例から MPC の必要性を理解する。

最初に伝えるべきことは、MPC が「秘密を魔法のように消す技術」ではないという点である。 -->

<div class="purpose-grid">
  <div class="purpose-main">
    <p>MPC は、複数の人(パーティ)が秘密の値を持っているときに、お互いにその値を秘匿したまま共同で計算するための秘密計算技術である。</p>
    <p>例えば、</p>
    <ul>
      <li>3人の給与の平均</li>
      <li>2人が持つ数を明らかにせずに比較する<br><small>（Yao's Millionaires' Problem）</small></li>
      <li>匿名投票の集計</li>
    </ul>
    <p>など、複数の人が秘密の値を持っているときに、その値を明らかにせずに計算する必要がある場面は多い。</p>
  </div>
  <div class="purpose-terms">
    <TermNote term="パーティ(party)" description="計算に参加する人や企業など、1つの参加主体のこと。" />
    <TermNote term="SMPC" description="Secure Multi-Party Computation の略。MPC と呼ばれることも多い。" />
  </div>
</div>

---
layout: default
class: zk-mpc-position
---

# Advanced Cryptography Program における MPC の位置づけ

Advanced Cryptography Program では、ゼロ知識証明(ZK)をはじめとする、プライバシーを守りながら計算・検証・データ活用を行う技術を扱う。

Week 2 では、その中でも MPC を扱う。

ZK と MPC はどちらも「秘密を扱う」技術だが、中心となる問いが違う。

```text
ZK:
  主に、秘密を明かさずに、ある主張が正しいことを証明する

MPC:
  主に、秘密入力を持つ複数の人が、入力を一か所に集めずに共同で計算する
```

この講義では MPCの概念理解から始め、数学的な実現方法、そして主要なMPCプロトコルや近年の応用例までを網羅的にカバーする。
