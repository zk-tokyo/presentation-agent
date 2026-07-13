---
layout: center
class: section-slide section-6
---

# Part 6: 応用例

<ChapterMap :current="6" />

---
layout: default
class: application-lens
---

# 応用を見るための型

MPC の応用は、名前ではなく同じ型に分解して見る。

```text
party:
  誰が計算に参加するか
input:
  各 party が何を秘密入力として持つか
function:
  何を共同で計算するか
output:
  誰が何を知るか
hidden:
  何を隠したいか
output leakage:
  出力から何が推測されるか
cost:
  どの演算・通信・運用が重いか
type:
  generic MPC か、special-purpose MPC か
```

---
layout: two-cols-header
class: application-slide app-wallet
---

::left::

# 応用例1: Threshold signature / MPC wallet

秘密鍵を1台に置かず、複数 party の share で署名を作る。

```text
party:
  複数の signer / key share holder

input:
  各 party の key share

public input:
  署名対象の message / transaction

function:
  秘密鍵全体を復元せずに署名を作る

output:
  signature

hidden:
  秘密鍵全体
  各 party の key share
```

::right::

```text
output leakage:
  signature は公開される
  誰が署名に参加したか、いつ署名したかが運用上見えることがある

cost:
  threshold 設定、share 紛失、offline party、malicious party への対応

type:
  special-purpose MPC
```

threshold signature は、汎用の「任意関数を回路として評価する MPC」とは少し違う。
署名方式の代数構造を活かした special-purpose MPC として理解するとよい。

---
layout: two-cols-header
class: application-slide app-psi
---

# 応用例2: Private Set Intersection

::left::

2つ以上の party がそれぞれ集合を持っている。

知りたいのは共通部分、または共通部分のサイズだけである。

```text
party:
  Company A
  Company B

input:
  Company A has set X
  Company B has set Y

function:
  intersection or intersection size

output:
  X ∩ Y
  or
  |X ∩ Y|

hidden:
  共通部分以外の要素
  片方だけが持つ要素
  場合によっては集合サイズ
```

::right::

```text
output leakage:
  共通部分そのものを出す場合、その要素が両者に存在することは公開される
  サイズだけを出す場合でも、small domain や繰り返しクエリでは推測が増える

cost:
  集合サイズ、malicious input、small domain、繰り返しクエリへの対応

type:
  special-purpose PSI protocol がよく使われる
```

PSI は、不正検知、広告、顧客照合、医療、接触確認などで説明しやすい。

---
layout: two-cols-header
class: application-slide app-analytics
---

# 応用例3: Privacy-preserving analytics

::left::

複数組織がデータを持っている。

個別データを出さずに、全体の統計量だけを知りたい。

```text
party:
  複数の組織

input:
  各組織のデータ

function:
  集計・統計量・モデル指標の計算

output:
  合計
  平均
  分布
  モデル指標

hidden:
  各組織の個別データ
  個人や顧客ごとの寄与
```

::right::

```text
output leakage:
  小さい集団の統計量や繰り返し集計から個別データが推測されることがある

cost:
  合計・平均・分散・一部の線形モデルは相性がよい
  複雑なフィルタ、比較、ソート、欠損値処理は重くなりやすい

type:
  generic MPC または secure aggregation 系
```

analytics では、MPC だけでなく Differential Privacy を組み合わせることもある。

MPC は計算中の入力を守る。

Differential Privacy は、出力から個人情報が推測されるリスクを抑える。

---
layout: two-cols-header
class: application-slide app-matching
---

# 応用例4: Matching / auction / voting

::left::

マッチング、オークション、投票では、入力を隠したまま結果だけを出したい。

```text
party:
  参加者
  場合によっては運営者 / 集計者

input:
  希望順位
  入札額
  投票内容

function:
  ルールに従って結果を計算する

output:
  マッチング結果
  勝者
  集計結果

hidden:
  希望順位
  入札額
  投票内容
```

::right::

```text
output leakage:
  結果から入力の一部が推測されることがある
  voting では投票資格や二重投票の防止も別途設計が必要になる

cost:
  比較、ソート、条件分岐、最適化問題が重くなりやすい
  入力の正当性確認が別途必要になることがある

type:
  ルール次第で generic MPC または special-purpose protocol
```

この領域は直感的には MPC に向いているが、実装と運用の論点が多い。
