---
layout: default
---

# Part 5: セキュリティモデルと主要なMPCプロトコル

---
# MPC プロトコルを見るための軸

同じ「MPC」でも、次の設定によって使う技術やコストが変わる。

```text
party はどう振る舞うか？
何人まで壊れてよいか？
出力が得られることまで保証するか？
関数は arithmetic 向きか boolean 向きか？
generic MPC で解くか、専用プロトコルを使うか？
```

---

# party はどう振る舞うか: semi-honest / malicious

## semi-honest　(半正直な参加者)

semi-honest party は、プロトコルの手順には正直に従う。

ただし、計算の途中や最終的に得られた情報から追加で推論するモデルである。

```text
手順は守る
しかし好奇心はある
```

講義の初期例や実装課題では、まず semi-honest を想定すると理解しやすい。

## malicious (悪意のある参加者)

malicious party は、プロトコルから任意に逸脱する。

例えば、

- 嘘の share を送る
- メッセージを送らない
- 途中で止まる
- 他 party と結託する
- プロトコルにない値を使う

malicious security を達成するには、追加の検証・認証・ZK proof・MAC などが必要になる。その分、コストは高くなる。

---

# 何人まで壊れてもよいか: honest majority と dishonest majority

MPC では、何人まで壊れてよいかが重要である。

## honest majority

過半数の party が正直であると仮定する。

```text
n = 5, t = 2
```

このような場合、Shamir ベースのプロトコルなどが使いやすい。

## dishonest majority

半数以上が壊れてもよい、または 2-party で片方が壊れる可能性を考える。

```text
n = 2, t = 1
```

この設定では、より強い暗号技術や前処理が必要になりやすい。

SPDZ などは、dishonest majority かつ malicious security を狙う代表的な系統として紹介できる。

---

# 出力保証

MPC では、privacy だけでなく「出力が得られるか」も問題になる。

MPC では、すべての party が最後まで正しく動くとは限らない。

途中で party が止まったり、必要なメッセージを送らなかったりする場合、プロトコルがどう振る舞うかを決める必要がある。

特に malicious party がいる場合、相手は最後に止まるかもしれない。

考えるべき性質:

| 性質 | 意味 |
|---|---|
| abort | 不正や停止があれば計算が止まり、出力が得られないことを許す |
| fairness | 一部の party だけが出力を得て有利になる状況を防ぐ |
| guaranteed output delivery | 壊れた party がいても honest party が最終的な出力を得る |

<!-- Part 2 では、途中停止を問題設定の論点としてだけ扱った。 -->

ここでは、どの security model や protocol family でどの保証を目指せるか、という分類軸として見る。

fairness や guaranteed output delivery が可能かどうかは、party 数、honest majority の有無、ネットワーク仮定に依存する。

ただし、実用設計では「途中で止まったらどうするか」は必ず考える必要がある。

---

# generic MPC と special-purpose MPC

MPC には、大きく分けて2つの見方がある。

## generic MPC

計算したい関数を回路として表現し、その回路を秘密入力のまま評価する。

```text
任意の関数 f を回路にする
party は input を share する
回路を MPC で評価する
output だけを復元する
```

Yao、GMW、BGW、SPDZ などは、この見方で理解しやすい。

利点は、原理的には幅広い関数を扱えることである。

一方で、比較・分岐・ソート・複雑なデータ構造を含むとコストが大きくなりやすい。

## special-purpose MPC

特定の用途に合わせて設計された、MPC の考え方を使う専用プロトコルである。

例:

- Private Set Intersection
- threshold signature
- MPC wallet
- secure aggregation

これらは実用上重要だが、任意の関数をそのまま評価する汎用 MPC とは少し違う。

実務では、まず次を考える。

```text
この問題は generic MPC で解くべきか？
それとも専用プロトコルがある問題か？
```

この区別を持っておくと、プロトコル名を単に覚えるのではなく、問題設定に応じて候補を絞れる。

---

# 主要なMPCプロトコル

代表的なプロトコルを、分類軸とセットで紹介する。


| プロトコル | 主な設定 | 表現 | 見るべき特徴 |
|---|---|---|---|
| Yao / Garbled Circuit | 主に 2-party | Boolean circuit | garbling と OT。2PC の古典 |
| GMW / OT-based | 2-party / multi-party | Boolean circuit | OT / OT extension を使って回路を評価 |
| BGW | n-party, honest majority | Shamir / arithmetic | 情報理論的安全性。honest majority と相性がよい |
| SPDZ | n-party, dishonest majority, malicious | arithmetic | Beaver triple、MAC、offline / online 分離 |

この表で覚えるべきなのは、名前そのものではなく、party 数、敵対モデル、回路表現、前処理の有無がセットで変わるという点である。

---

# Yao's Garbled Circuit: 2PC と Boolean circuit

Yao's Garbled Circuit は、主に **2-party computation (2PC)** で使われる古典的な方法である。

計算したい関数 \( f \) を Boolean circuit として表し、各 wire の `0/1` に対応するランダムな label を用意する。

一方の party が circuit を **garble** し、もう一方の party が label だけを使って評価する。

```text
garbler:
  circuit を garble する

evaluator:
  入力 label を受け取り、garbled circuit を評価する
```

評価中、evaluator は中間値の `0/1` を直接知らない。

最後に output label だけが通常の出力として decode される。

入力 label の受け渡しには Oblivious Transfer (OT) が使われることが多い。

```text
向いている:
  2-party / Boolean circuit / 比較・分岐・bit 演算

注意:
  circuit size に応じて garbled table が大きくなる
```

---

# SPDZ: malicious security かつ dishonest majority の代表プロトコル

SPDZ は、次のような特徴をもつ。

- malicious security を満たす
- offline / online の2段階のフェーズがある。

```text
offline phase:
  乗算に必要な Beaver triple などを準備する

online phase:
  実際の入力に対して高速に計算する
```

malicious party が不正な share を混ぜることを防ぐために、share に MAC のような認証情報を付ける。

講義では SPDZ の詳細な式は扱わない。

重要なのは、次の直感である。

```text
乗算の重い準備を事前に済ませる
本番では入力依存の計算を速くする
悪意ある party の不正を検出する
```

<!-- ---

## 応用を見るときのチェックリスト

次の Part では、MPC の応用例を見る。

実務で最初に考えるべきなのは、プロトコル名ではなく設計軸である。

```text
何人で計算するか？
誰が壊れる可能性があるか？
どこまでの不正を考えるか？
出力は誰が知るか？
途中停止を許すか？
関数 f は arithmetic 向きか boolean 向きか？
通信コストを許容できるか？
```

この問いに答えたあとで、適切なプロトコル候補を選ぶ。 -->

---