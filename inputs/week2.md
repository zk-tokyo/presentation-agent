---
target_audience: "Advanced Cryptography Program Week 2 受講者 (オンサイト20-25名 / 学部生〜社会人エンジニア混在 / バックグラウンドにばらつきあり)"
audience_type: group
constraints:
  max_slides: 38
  max_duration_minutes: 120
output_language: Japanese
event:
  name: "Advanced Cryptography Program — Week 2"
  parent_event: "Merkle Japan × 東京大学ブロックチェーンイノベーション寄付講座"
  date: "2026 年度"
  location: "東京大学 講義室 (オンサイト)"
---
# Advanced Cryptography Program — Week 2: Multi-Party Computation (MPC)

担当: 中江  
位置づけ: Week 2 の講義で、MPC部分を担当  
構成: 120分講義 + 30分休憩 + 2時間ホワイトボードセッション
形式: オンサイト、20-25名想定

---

## 聴衆の想定

- 大学生や社会人など、ゼロ知識証明(やMPC、FHEなど)を中心とするプライバシー技術に興味のある人たち
- エンジニアが多いが、コーディング経験がない参加者もいる
- 暗号理論や MPC の前提知識は揃っていない可能性がある
- 人数は20〜25名程度

このため、講義では数式やプロトコル名から入るのではなく、具体例、直感、設計上の問いから入る。
実装経験のある参加者には実務上の判断軸を渡し、実装経験のない参加者にも「何を隠し、何を出力し、どこが難しいのか」が説明できる状態を目指す。

---

## 講義本編の中心メッセージ

この講義では、MPC を「個別プロトコルの名前」ではなく、複数の party が秘密入力を持つときに、信頼できる第三者へデータを集めずに共同で計算するための設計手法として導入する。

> 信頼できる第三者に全員の入力を渡せないとき、  
> 各 party の入力を隠したまま、共同で関数の出力だけを得るにはどうすればよいか。

ZK が主に「秘密を明かさずに、ある主張が正しいことを証明する技術」だとすれば、MPC は「秘密入力を持つ複数 party が、入力を集約せずに関数を計算する技術」である。

この講義で目指すのは、Yao / GMW / BGW / SPDZ の詳細を暗記することではなく、party / input / function / output / adversary / leakage を切り分けて、「この問題に MPC を使うべきか」「使うなら何が重く、何を設計すべきか」を判断するための見方を持つことである。

講義全体で受講者に持ち帰ってほしい直感は、次の3つである。

1. **MPC は、複数 party が秘密入力を持ったまま、入力を一か所に集めずに共同計算する技術である**
2. **MPC の設計では、party / input / function / output / adversary / leakage を明確にすることが本質である**
3. **実用では、線形演算は軽い一方で、乗算・比較・分岐・通信・可用性・出力漏洩が設計上のボトルネックになる**

---

## 講義で扱う範囲

### 本編で必ず扱う

#### 設計レンズとして必ず扱う

- MPC の問題設定
- Trusted Third Party と ideal functionality の直感
- party / input / function / output / adversary / leakage / cost
- output leakage
- 入力の正しさは別問題
- party が途中で止まった場合の扱いと、abort / fairness / guaranteed output delivery の用語と直感
- MPC が向く場面・向かない場面

#### 技術的な直感として必ず扱う

- 加法的秘密分散
- Shamir の秘密分散法の直感
- 現実の値はそのままではなくエンコードして扱うという直感
- share 上の加算・減算
- 乗算が難しい理由
- Beaver triple の直感
- secret-dependent control flow が重くなる理由

#### 分類・応用として短く扱う

- semi-honest / malicious
- honest majority / dishonest majority
- generic MPC / special-purpose MPC の違い
- Yao / GMW / BGW / SPDZ の位置づけ
- threshold signature / MPC wallet
- PSI
- privacy-preserving analytics
- ZK / FHE / MPC の違い

### 補足または発展に回す

#### 実装寄りの発展

- 符号付き整数・固定小数点・丸め誤差の詳細
- detailed OT extension: oblivious transfer を多数回効率よく使うための拡張技術
- ABY: arithmetic / boolean / Yao を組み合わせるフレームワーク
- SPDZ の MAC 検証の詳細

#### プロトコル設計の発展

- RSS: replicated secret sharing
- FSS: function secret sharing
- BGW の次数削減の詳細
- fairness / guaranteed output delivery の詳細

#### 理論寄りの発展

- malicious security の形式的証明
- UC security

---

## Learning Outcomes

Week 2 の講義終了時に、受講者は以下を説明・議論できるようになる。

1. MPC を「複数 party が秘密入力を持ったまま、入力を一か所に集めずに共同計算する技術」として説明できる
2. party / input / function / output / adversary / leakage / cost の観点で、MPC の問題設定を分解できる
3. 計算中の privacy、 output leakage、入力の正しさ、party が途中で止まる場合の扱いを区別できる
4. 加法的秘密分散、Shamir の (k,n)-threshold の直感、share 上の加算・減算が軽い理由を説明できる
5. 乗算、secret-dependent control flow、比較・分岐が重くなる理由と、Beaver triple の役割を直感的に説明できる
6. semi-honest / malicious、honest majority / dishonest majority、generic / special-purpose MPC の違いを説明できる
7. ZK / FHE / MPC の違いを比較し、ある応用に MPC を使うべきか、他技術や専用プロトコルを検討すべきかを議論できる

---

## 120分タイムテーブル

| 時間 | パート | 内容 | ゴール |
|---:|---|---|---|
| 0–10分 | 導入 | Advanced Cryptography Program 内での MPC の位置づけ、ZK との違い、給与平均の例 | MPC を「秘密入力を集めずに共同計算する技術」として掴む |
| 10–25分 | 問題設定 | Trusted Third Party、party / input / function / output / adversary / leakage / cost | MPC の問題を設計レンズで分解できるようにする |
| 25–35分 | 漏洩と運用論点 | output leakage、入力の正しさ | 「MPC なら全部隠せる」ではないことを理解する |
| 35–55分 | 秘密分散 | 加法的秘密分散、Shamir の直感、現実の値のエンコード | secret / share と、現実の値を MPC に乗せる感覚を作る |
| 55–75分 | share 上の演算 | 加算・減算、public value、乗算が難しい理由、Beaver triple | 線形演算と乗算のコスト差を理解する |
| 75–85分 | 非線形処理 | arithmetic / boolean circuit、secret-dependent control flow、比較・分岐が重い理由 | 普通のプログラムと MPC 実装の違いを掴む |
| 85–95分 | Checkpoint | ここまでの確認質問・Q&A | 基本直感を揃える |
| 95–108分 | セキュリティモデルと地図 | semi-honest / malicious、honest / dishonest majority、abort / fairness / guaranteed output delivery、generic / special-purpose、Yao / GMW / BGW / SPDZ の位置づけ | プロトコル名を暗記でなく地図として見る |
| 108–118分 | 応用と技術選択 | threshold wallet、PSI、analytics、ZK / FHE / MPC 比較 | どの問題に MPC を使うべきか議論できるようにする |
| 118–120分 | まとめ | 設計シートへの接続 | ホワイトボードセッションに入れる状態にする |

---

# Part0 表紙・導入・目次

## Advanced Cryptography Program Week 2: Multi-Party Computation (MPC)

お互いの入力を隠したまま、共同で計算を行って答えだけを得る

担当: 中江  
Merkle Japan × 東京大学ブロックチェーンイノベーション寄付講座

---

## 導入: 3人の給与平均はいくら？

3人がそれぞれ給与を持っている。

```text
Alice: 給与 x1（非公開）
Bob:   給与 x2（非公開）
Carol: 給与 x3（非公開）
```

知りたいのは平均だけである。

```text
average = (x1 + x2 + x3) / 3
```

普通に計算するなら、誰か1人が全員の給与を集めたり、全員が公開して計算すればよい。

しかし、その場合は計算者が全員の給与を見てしまう。

ここでやりたいことは、次のような計算である。

```text
個別の給与は誰にも見せない
ただし、出力である平均だけは全員または指定された人が知る
```

---

## 目次

1. マルチパーティ計算(MPC: Multi-Party Computation) は何をしたい技術か(入門パート)
2. MPC の問題設定(技術？パート)
3. 秘密分散(数学パート)
4. MPC での演算(数学パート)
5. 出力保証と可用性(知識パート)
6. MPC の応用と技術選択(知識・応用パート)
7. まとめとホワイトボードセッションへの接続
8. 参考文献・補足資料

---

# Part 1: マルチパーティ計算(MPC: Multi-Party Computation) は何をしたい技術か

---

## 目的

<!-- Advanced Cryptography Program の中で MPC が何を扱う技術なのかを位置づけ、具体例から MPC の必要性を理解する。

最初に伝えるべきことは、MPC が「秘密を魔法のように消す技術」ではないという点である。 -->

MPC は、複数の人(パーティー)が秘密の値を持っているときに、お互いにその値を秘匿したまま共同で計算するための技術である。

例えば、

- 3人の給与の平均
- 2人がそれぞれ秘密の値を持っているとする。どちらの数が大きいかを、値を明らかにせずに比較する(Yao's Millionaires' Problem)
- 匿名投票の集計

など、複数の人が秘密の値を持っているときに、その値を明らかにせずに計算する必要がある場面は多い。

*用語: party...計算に参加している人、あるいは企業など、秘密を共有している1つのかたまりのこと*
*補足: SMPC(Secure Multi-Party Computation)と呼ばれることもある*

---

## Advanced Cryptography Program における MPC の位置づけ

Advanced Cryptography Program では、ゼロ知識証明を中心に、プライバシーを守りながら計算・検証・データ活用を行う技術を扱う。

この Week 2 では、その中でも MPC を扱う。

ZK と MPC はどちらも「秘密を扱う」技術だが、中心となる問いが違う。

```text
ZK:
  主に、秘密を明かさずに、ある主張が正しいことを証明する

MPC:
  主に、秘密入力を持つ複数の人が、入力を一か所に集めずに共同で計算する
```

この講義では、MPCをプライバシーテックの一角として、概念理解から始め、数学的な実現方法、そして主要なMPCプロトコルや近年の応用例までを網羅的にカバーする。

---

# Part 2: MPC の問題設定

<!-- ## 目的

導入例で作った直感を、MPC の標準的な問題設定に落とし込む。 -->

---

## Trusted Third Party の理想世界

まず、理想的には次のような信頼できる第三者 T がいれば簡単である。

```text
1. 各 party は T に自分の入力だけを送る
2. T は y = f(x1, x2, ..., xn) を計算する
3. T は決められた出力 y だけを返す
4. T は入力を漏らさない
```

この T が約束どおりに振る舞うなら、各 party は互いに入力を明かさず、決められた出力 y だけを得られる。

しかし、T には全員の入力が集まる。現実には T を完全に信用できず、次のように振る舞うかもしれない。

- 入力を外部に漏らす
- 入力を目的外利用する
- 特定の party と結託する
- 結果を改ざんする・返さない

MPC は、T に全入力を預けず、T が行うはずだった計算を party 間のプロトコルで実現しようとする。

---

## MPC の直感的な定義

MPC は、複数の party がそれぞれ秘密の入力を持つとき、入力を互いに明かさずに、共同で関数の出力だけを得るためのプロトコルである。

```text
入力:
  P1 has x1
  P2 has x2
  ...
  Pn has xn

計算:
  y = f(x1, x2, ..., xn)

目標:
  各 xi は隠す
  y だけを得る
```

今日の中心になる問いは次である。

```text
信頼できる第三者に入力を集めずに、
どうやって共同で y = f(x1, ..., xn) を計算するか？
```

具体的な実現方法は一旦脇に置いておいて、どのようなことを考えるのか？について話していく。

---

## 基本設定

n 人の party がいる。

```text
P1 has input x1
P2 has input x2
...
Pn has input xn
```

全員で関数 f を計算し、出力 y を得る。

```text
y = f(x1, x2, ..., xn)
```

MPC の設計では、少なくとも次を決める必要がある。

| 問い | 決めるもの |
|---|---|
| 誰が参加するか | party set |
| 各 party は何を入力するか | input |
| 何を計算するか | function f |
| 誰が出力を知るか | output policy |
| 何人まで壊れてよいか | corruption threshold |
| 壊れた party はどう振る舞うか | adversary model |
| party が途中で止まる可能性をどう扱うか | availability / abort |
| 出力から漏れる情報を許容するか | output leakage |
| どの計算・通信が高コストになるか | cost |

ここでいう cost には、実行時間だけでなく、通信量、ラウンド数、事前計算、実装の複雑さも含まれる。

party が途中で止まる可能性も、MPC の問題設定に含まれる。

詳しくは Part 5 の出力保証で扱う。

---

## MPC が守りたい性質

MPC では、主に次の性質を考える。

### Correctness

与えられた入力に対して、仕様どおりの出力が得られること。

```text
protocol output = f(x1, x2, ..., xn)
```

### Privacy

各 party の入力について、許された出力から分かる以上の情報が漏れないこと。

攻撃者が支配する party 群がプロトコル中に見た情報からも、許された範囲を超えて他の入力を推測できないことを目指す。

直感的には、ある party がプロトコル中に見たものが、自分の入力と最終出力だけから作れそうなら、余計な情報は漏れていないと考える。

### Robustness

一部の party が壊れたり、途中で止まったり、不正なメッセージを送ったりしたときに、プロトコルがどう振る舞うか。

---

## MPC が保証しないこと

### Output leakage

MPC を説明するときに重要なのは、「入力が漏れない」という言葉を強く言いすぎないことである。

MPC は、プロトコル中に見える情報を制限する。

しかし、出力そのものから分かる情報は隠せない。

例えば、3人の給与平均を公開する場合を考える。

```text
average = 1000万円
```

自分の給与と、もう1人の給与をすでに知っているなら、残り1人の給与は計算できてしまう。

これはプロトコルの失敗ではない。

出力として平均を公開すると決めた時点で、その出力から推測できる情報は漏れる。

したがって、MPC の設計では次の問いが重要になる。

```text
この出力を公開してよいか？
この出力から個別入力が推測されないか？
推測されるとして、それは許容できるか？
```

---

### 入力の正しさは別問題

MPC は、入力を隠したまま計算する技術である。

しかし、入力が現実に正しいかどうかは別問題である。

例えば、給与平均では、誰かが嘘の給与を入力するかもしれない。

投票では、資格のない人が入力するかもしれない。

金融や広告の共同集計では、party が不正なデータを入れるかもしれない。

この問題を扱うには、次のような追加の仕組みが必要になる。

- 入力検証
- 監査
- コミットメント
- ZK proof
- 外部認証
- データガバナンス

この区別は、MPC と ZK の使い分けにつながる。

```text
MPC:
  隠したまま共同計算する

ZK:
  隠した情報が条件を満たすことを証明する
```

---

# Part 3: 秘密分散

<!-- ## 目的

MPC の中心的な技術である秘密分散を理解する。

ここでは、MPC のすべてのプロトコルを説明するのではなく、次の直感を作る。

```text
secret を share に分ける
share 単体では secret が分からない
share のまま計算できるものがある
必要なときだけ output を復元する
``` -->

---

## 秘密分散とは？

秘密分散とは、秘密の値を複数の party に分散して持たせる技術である。

各 party には、秘密そのものではなく、ランダム性を使って作られた**share**という値が渡される。

そして、少数のshareだけでは秘密の値が分からないようにする。一方で、決められた数以上の shareを集めることで秘密の値を復元できる。

もう少し形式的には、SharingとReconstructの2つのアルゴリズムからなる。また、この講義では特にn個のshareの内k個以上が集まれば復元でき、k-1個以下では秘密の値が分からない**k-of-n threshold secret sharing**を中心に見る。

(模式図を挿入)

---

## 例:加法的秘密分散

まず、最も直感的な例として **加法的秘密分散** を見る。加法的秘密分散では、secret を複数の share に分け、すべての share を足すと secret に戻るようにする。

有限体 mod p 上で secret x を n 個の share に分ける。

mod p は、p で割った余りだけを見る世界だと考えればよい。

```text
x = share_1 + share_2 + ... + share_n mod p
```

sharingは例えば次のようにできる。

```text
share_1, ..., share_{n-1} をランダムに選ぶ
share_n = x - share_1 - ... - share_{n-1} mod p
```

また、reconstructは全てのshareを足すだけである。
```text
x = share_1 + share_2 + ... + share_n mod p
```

例:

```text
p = 101
x = 42

share_1 = 17
share_2 = 60
share_3 = 66

17 + 60 + 66 = 143
143 mod 101 = 42
```

このとき、それぞれの share はランダムに見える。

```text
P1 sees share_1 = 17
P2 sees share_2 = 60
P3 sees share_3 = 66
```

1つの share だけを見ても、元の secret が 42 だったとは分からない。より一般に、基本的な加法的秘密分散では、n-1 個以下の share からは secret が分からない。

その代わり、復元には n 個すべての share が必要になる。
つまり、基本的な加法的秘密分散は n-of-n の秘密分散として理解できる。

---

## 加法的秘密分散の特徴

加法的秘密分散の大きな利点は、シンプルで、shareのまま加算・減算ができることである。

secret xがshareされた状態を[x]と書く。それぞれのshareは[x]_1, [x]_2, [x]_3のように書く。ここで1,2,3は各パーティの番号だと思えばよい。
```text
[x] = ([x]_1, [x]_2, [x]_3)
[y] = ([y]_1, [y]_2, [y]_3)
```

このとき、x+yがshareされた状態は次のように表せる。

```text
[x + y] = ([x]_1 + [y]_1, [x]_2 + [y]_2, [x]_3 + [y]_3)
```

すなわち、各 party は、自分の share だけをローカルに足せばよい。

**secret を復元する必要はなく、通信も不要である。**

この性質により、合計・平均・線形変換は MPC と相性がよい。

一方で、基本的な加法的秘密分散では復元に全 share が必要になる。
次に、「何個の share が集まれば復元できるか」という軸を見る。

---

## 復元条件: なぜ k-of-n が欲しいのか

基本的な加法的秘密分散は、すべての share が必要な **n-of-n** として理解できる。

```text
n-of-n:
  n 個すべての share が必要
  1 個でも欠けると復元できない
```

しかし、n-of-n だけでは運用上つらい場面がある。

```text
全員が毎回オンラインでないと復元できない
1つの share を失うと復元できない
一部の party が止まると output が得られない
```

そこで、より柔軟な復元条件として **k-of-n** を考える。

```text
k-of-n:
  n 個のうち k 個あれば復元できる
  k - 1 個以下では secret が分からない
```

これが **k-of-n threshold secret sharing** の考え方である。

この復元条件を自然に実現する代表例が、Shamir 秘密分散である。

---

## Shamir の直感: 点が足りないと多項式が定まらない

Shamir 秘密分散の直感は、多項式を点から復元することである。

```text
1点だけでは、どの直線か分からない
2点あれば、直線が決まる

2点だけでは、どの2次多項式か分からない
3点あれば、2次多項式が決まる
```

secret は q(0)、つまり多項式の切片に置く。
十分な数の点が集まれば、多項式が決まり、q(0) が分かる。
点が足りなければ、q(0) はまだ決まらない。正確には、同じ k-1 個の点を通りながら、q(0) が別の値になる多項式がまだ作れてしまう。

---


## Shamir の秘密分散法

Shamir の秘密分散法では、secret を多項式の切片に埋め込む。

```text
q(0) = secret
```

secret は q(0) にあるが、party には q(0) そのものは渡さない。

ここでも、計算は有限体 mod p 上で行う。

復元に k 個の share が必要な場合、次数 k-1 のランダム多項式を使う。

```text
q(z) = secret + a1 z + a2 z^2 + ... + a_{k-1} z^{k-1}
```

各 party には、多項式上の点を渡す。

```text
P1 receives q(1)
P2 receives q(2)
P3 receives q(3)
...
Pn receives q(n)
```

次数 k-1 の多項式は、k 個の点があれば決まる。
```text
k 個の share:
  多項式 q(z) を復元できる
  切片 q(0) として secret が分かる

k - 1 個以下の share:
  多項式 q(z) が一意に決まらない
  secret は分からない
```

---

## 加法的秘密分散と Shamir の比較

| 観点 | 加法的秘密分散 | Shamir 秘密分散 |
|---|---|---|
| 直感 | 足すと戻る | 通る点から多項式を戻す |
| 復元条件 | 基本形は n-of-n | k-of-n |
| 加算・減算 | 軽い | 軽い |
| 乗算 | 追加処理が必要 | 追加処理が必要 |

---

## MPCでの使い方: 何を opening してよいかを設計する

秘密分散は、それ単体で終わる技術ではない。  
MPC においては、secret を share に分けたあと、できる限り share のまま計算を進める。

secret そのものや意味のある中間値を不用意に opening すると、入力に関する情報が漏れる可能性がある。
そのため、MPC では share のまま計算を進め、設計上 opening してよい値や安全にマスクされた値だけを復元する。

したがって、MPC では基本的に、

```text
secret
  ↓ sharing
share
  ↓ share のまま計算
output share
  ↓ 許可された output だけopeningする
output
```

という流れで考える。

---

## エンジニア視点: 現実の値をどう扱うか

給与、年齢、金額、確率、小数などの現実の値を、MPC の中でそのまま扱えるわけではない。

多くの MPC では、計算対象を有限体や ring 上の値として表現する。

```text
現実の値
  ↓ encode
有限体 / ring / 固定小数点表現
  ↓ sharing
share
  ↓ MPC protocol
output share
  ↓ opening
encoded output
  ↓ decode
出力
```

このため、実装では次のような論点が出る。

- 値の範囲をどう決めるか
- 負の数をどう表すか
- 小数を固定小数点としてどうスケールするか
- overflow や丸めをどう扱うか

講義本編では詳細な符号化方式には踏み込まない。

ただし、MPC を使うには「計算したい値や関数を、どの表現に落とすか」を設計する必要がある。

---

# Part 4: MPC での演算

<!-- ## 目的

secret を share にしたあと、share のままどう計算するかを理解する。

このパートで一番重要なメッセージは次である。

> 線形演算は軽い。  
> 乗算から難しい。  
> 比較・ソート・条件分岐はさらに重い。 -->

---

## 線形演算は軽い

加法的秘密分散や Shamir 秘密分散では、加算・減算・公開値による定数倍は各 party が自分の share に対してローカルに計算できる。つまり、通信なしで進む。

以下では、加法的秘密分散を例に見る。

```text
x = [x]_1 + [x]_2 + [x]_3
y = [y]_1 + [y]_2 + [y]_3
```

このとき、加算は

```text
x + y = ([x]_1 + [y]_1) + ([x]_2 + [y]_2) + ([x]_3 + [y]_3)
```

各 party は、自分の share だけを足せばよい。

```text
P1 computes [x]_1 + [y]_1
P2 computes [x]_2 + [y]_2
P3 computes [x]_3 + [y]_3
```

通信は不要である。

注意: この性質を持つ秘密分散は、線形秘密分散（LSS; Linear Secret Sharing）と呼ばれる。

注意: 公開値 c を足す場合の扱いは秘密分散方式によって異なる。
加法的秘密分散では、全 party が c を足すと x + nc になってしまうため、
1つの share にだけ足す、または c を share 化してから加える。

---

## 乗算はローカル計算だけでは閉じない

線形演算では、各 party は自分の share だけを処理すればよかった。しかし、乗算ではそうならない。

実際にMPCにおける乗算を考えてみよう。

```text
x = [x]_1 + [x]_2 + [x]_3
y = [y]_1 + [y]_2 + [y]_3
```

素朴に計算をしようとすると、積は次のようになる。

```text
xy = ([x]_1 + [x]_2 + [x]_3)([y]_1 + [y]_2 + [y]_3)
```

展開すると、自分の share だけでは計算できない交差項が現れる。

```text
[x]_1 [y]_2 (party 1 と party 2 の share が必要)
[x]_1 [y]_3 (party 1 と party 3 の share が必要)
[x]_2 [y]_1 (party 2 と party 1 の share が必要)
...
```

各 party は他 party の share を知らないため、ローカル計算だけでは xy の share を作れない。

そのため、乗算には通信または前処理が必要になる。

---

## Beaver triple: MPC での乗算のための使い捨てマスク

乗算を効率よく行う代表的な考え方が Beaver triple である。

MPC で行いたい計算とは別に、前処理で、ランダムな a, b とその積 c を share しておく。

```text
c = a * b
```

各 party は a, b, c そのものではなく、それぞれの share を持つ。

```text
[a], [b], [c]
```

この3つ組を **Beaver triple** という。

重要なのは、この triple を **1回の乗算に対して一度だけ使う**ことである。

---

## Beaver triple による乗算
[x], [y] を各 party が持っているとき、 [x * y] を計算したいとする。

まず、次を計算する。

```text
[d] = [x] - [a]
[e] = [y] - [b]
```

そして d, e を復元して全体に公開する。

```text
d = x - a
e = y - b
```

a, b はランダムな使い捨てマスクなので、d, e を公開しても x, y は直接分からない。

d と e が公開されたあと、次の式を使う。

```text
[x * y] = [c] + d*[b] + e*[a] + d*e
```

したがって、party は share のまま [x * y] を作れる。

このように、線形演算と異なり乗算ではopening が発生するため、通信ラウンドが必要になる。

---

## Arithmetic circuit と Boolean circuit

shareのまま計算できるとはいっても、全ての演算が同じ重さではない。

```text
加算・減算・公開値による定数倍:
  ローカル計算で済む

乗算:
  通信または前処理が必要
```

したがって、MPC で何か関数を実装するときは、「どんな演算列・回路で表現するか」を考える必要がある。

この講義では、代表的な見方として2つの回路表現を押さえる。

| 観点 | Arithmetic circuit | Boolean circuit |
|---|---|---|
| 基本ゲート | 加算・乗算 | AND / XOR / NOT |
| 得意 | 合計、平均、内積、行列演算 | 比較、分岐、ビット演算 |
| 注意 | 非線形処理が重い | bit 数に応じて回路が大きくなる |

数値計算は arithmetic circuit が自然で、比較や分岐は boolean circuit が自然である。

お互いの表現を行き来することもプロトコルによってはできるが、追加の変換コストがかかるなど万能ではない。

---

## MPC における制御フローの考え方

MPC で重要なのは、secret な値に依存する分岐を普通のプログラムの `if` 文として扱えないことである。

例えば、次のような処理を考える。

```text
if secret_x > 0:
    return secret_x
else:
    return 0
```

その分岐が実行経路として観測されると、どちらの枝に進んだかから `secret_x > 0` かどうかが漏れる。

そのため、MPC では secret な条件分岐を、制御フローではなく回路上の選択として表現する。

```text
[condition] = ([secret_x] > 0)
[result] = [condition] * [secret_x] + (1 - [condition]) * 0
```

このとき、比較そのものが重く、さらに選択のための演算も必要になる。

これは、MPC が「通常のプログラムをそのまま秘密化する」技術ではなく、「何を計算したいかを回路や演算列として設計する」技術であることを示している。

---

## 重くなりやすい演算

MPC で重くなりやすいのは、次のような処理である。

| 処理 | 重くなりやすい理由 |
|---|---|
| 比較 | 値をビット単位で扱う必要がある |
| 最大値・最小値 | 比較を含む |
| ソート | 多数の比較を含む |
| 条件分岐 | 分岐条件を隠す必要がある |
| secret な値による除算 | 逆元計算やゼロ判定が必要になる |
| secret なインデックスによる配列アクセス | インデックスを隠す必要がある |

一方で、有限体上で 0 でない public constant による割り算は、その逆元を掛けるだけで済む場合がある。

---

## MPC のコストはどこで決まるか

普通のプログラムでは、主に CPU 時間やメモリを気にする。

ここまで見た演算の違いは、MPCでは次のコストとして現れる。

| コスト軸 | 何を見るか |
|---|---|
| 通信量 | party 間で送るデータ量 |
| 通信ラウンド数 | 乗算の opening など何回の同期ステップが必要か |
| 非線形ゲート数 | 乗算、AND、比較、ビット分解など、通信や前処理が必要になる演算の数 |
| party 数 | 参加者数に応じて通信が増える |
| 敵対モデル | semi-honest / malicious で必要な検証が変わる |

普通のコードでは同じ数行に見えても、MPC では落とし込まれた回路、通信、通信ラウンドの数で性能が大きく変わる。

---

<!-- # Checkpoint: ここまでの理解確認

ここで5〜10分程度の理解確認を入れる。

受講者に問いかける質問:

1. MPC は trusted third party をどう置き換えているか？
2. share 単体から secret が分からないとはどういうことか？
3. 加算が軽い理由は何か？
4. 乗算が難しい理由は何か？
5. 平均を出力したとき、そこから個別入力が漏れることはあるか？

ここで答えが詰まる場合は、プロトコル名に進む前に Part 1〜4 の直感に戻る。

--- -->

# Part 5: セキュリティモデルと主要なMPCプロトコル

## MPC プロトコルを見るための軸

同じ「MPC」でも、次の設定によって使う技術やコストが変わる。

```text
party はどう振る舞うか？
何人まで壊れてよいか？
出力が得られることまで保証するか？
関数は arithmetic 向きか boolean 向きか？
generic MPC で解くか、専用プロトコルを使うか？
```

---

## party はどう振る舞うか: semi-honest / malicious

### semi-honest　(半正直な参加者)

semi-honest party は、プロトコルの手順には正直に従う。

ただし、計算の途中や最終的に得られた情報から追加で推論するモデルである。

```text
手順は守る
しかし好奇心はある
```

講義の初期例や実装課題では、まず semi-honest を想定すると理解しやすい。

### malicious (悪意のある参加者)

malicious party は、プロトコルから任意に逸脱する。

例えば、

- 嘘の share を送る
- メッセージを送らない
- 途中で止まる
- 他 party と結託する
- プロトコルにない値を使う

malicious security を達成するには、追加の検証・認証・ZK proof・MAC などが必要になる。その分、コストは高くなる。

---

## 何人まで壊れてもよいか: honest majority と dishonest majority

MPC では、何人まで壊れてよいかが重要である。

### honest majority

過半数の party が正直であると仮定する。

```text
n = 5, t = 2
```

このような場合、Shamir ベースのプロトコルなどが使いやすい。

### dishonest majority

半数以上が壊れてもよい、または 2-party で片方が壊れる可能性を考える。

```text
n = 2, t = 1
```

この設定では、より強い暗号技術や前処理が必要になりやすい。

SPDZ などは、dishonest majority かつ malicious security を狙う代表的な系統として紹介できる。

---

## 出力保証

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

## generic MPC と special-purpose MPC

MPC には、大きく分けて2つの見方がある。

### generic MPC

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

### special-purpose MPC

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

## 主要なMPCプロトコル

代表的なプロトコルを、分類軸とセットで紹介する。


| プロトコル | 主な設定 | 表現 | 見るべき特徴 |
|---|---|---|---|
| Yao / Garbled Circuit | 主に 2-party | Boolean circuit | garbling と OT。2PC の古典 |
| GMW / OT-based | 2-party / multi-party | Boolean circuit | OT / OT extension を使って回路を評価 |
| BGW | n-party, honest majority | Shamir / arithmetic | 情報理論的安全性。honest majority と相性がよい |
| SPDZ | n-party, dishonest majority, malicious | arithmetic | Beaver triple、MAC、offline / online 分離 |

この表で覚えるべきなのは、名前そのものではなく、party 数、敵対モデル、回路表現、前処理の有無がセットで変わるという点である。

---

## Yao's Garbled Circuit: 2PC と Boolean circuit

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

## SPDZ: malicious security かつ dishonest majority の代表プロトコル

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

# Part 6: 応用例

## 応用を見るための型

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

## 実運用例1: Fireblocks の MPC wallet

一般形は Threshold signature / MPC wallet。

Fireblocks は、デジタル資産ウォレットの署名に MPC を利用している。
Embedded Wallets では、ユーザー端末と Fireblocks 側サーバーによる 2-of-2 MPC signature を採用している。

```text
party:
  ユーザー端末
  Fireblocks の SGX-enabled server

input:
  各 party の key share
  署名対象の transaction

function:
  完全な秘密鍵を1箇所に集めず署名を作る

output:
  blockchain で検証できる signature

hidden:
  完全な秘密鍵と各 key share
```

MPC を使う理由:

- 単一の端末・サーバーに秘密鍵全体を置かない
- blockchain 側には通常の署名として提出できる
- key share の配置を署名ポリシーに接続できる

MPC だけでは解決しないこと:

- 端末紛失時の復旧と key share の更新
- 誰がどの transaction を承認できるか
- 署名 party やネットワークが停止した場合の可用性
- endpoint・TEE・運用権限を含む信頼境界

これは任意の関数を評価する generic MPC ではなく、署名方式の構造を使う special-purpose MPC である。

出典: [Fireblocks Developer Docs — Direct Custody Wallets: Overview](https://developers.fireblocks.com/docs/overview)

---

## 実運用例2: Meta の Private Data Lookup

一般形は Private Set Intersection / private membership test。

Meta は Enterprise Center のパスワード作成・リセット時に、入力されたパスワードが漏洩済みリストに含まれるかを、Private Data Lookup (PDL) で確認している。

```text
party:
  ユーザーの client
  Meta Enterprise Center の service

input:
  client: 入力された password
  service: 漏洩済み password の集合

function:
  password が漏洩済み集合に含まれるか確認

output:
  一致したかをユーザーだけが知る

hidden:
  Meta からユーザーの試行 password を隠す
  ユーザーから漏洩済み集合全体を隠す
```

実際の処理:

- client が password hash をリクエストごとの鍵で blind する
- service も秘密鍵を使って処理する
- 最終的な照合は client 側で行い、Meta は結果を得ない

実装上のトレードオフ:

- 巨大な漏洩済み password 集合の前処理
- client が受け取るデータ量と latency
- sharding index が増やす leakage と性能のバランス
- 繰り返し query や small domain への対策

これは「集合の共通部分を全部返す」のではなく、片側だけが membership の結果を得る special-purpose PSI として見られる。

出典: [Engineering at Meta — Private Data Lookup](https://engineering.fb.com/2023/08/08/security/how-meta-is-improving-password-security-and-preserving-privacy/)

---

## 実運用例3: Boston の賃金格差分析

Boston Women’s Workforce Council と Boston University は、MPC-backed system を使って賃金格差を分析している。

Greater Boston の複数企業が、個社や従業員の給与データを公開せず、地域全体の gender / racial wage gap を共同で測定する事例である。

```text
data owner:
  参加企業

computation:
  BWWC と Boston University の MPC-backed system

input:
  給与、gender、race、job category、tenure など

function:
  属性別の給与統計を集計

output:
  Greater Boston 全体の wage gap statistics

hidden:
  個々の従業員データと企業ごとの生データ
```

MPC が担う部分:

- 参加企業は MPC-backed software 経由でデータを提出する
- BWWC は個社データではなく集計結果を分析する
- 組織間で raw payroll data を共有せずに統計を得る

MPC だけでは解決しないこと:

- 入力データの正しさと分類基準の統一
- 小さい集団や細かい属性別 output からの推測
- 欠損値、外れ値、繰り返し分析の扱い
- 統計を誰にどの粒度で公開するか

MPC は計算中の raw data を守る。
公開統計からの推測には、集計粒度や Differential Privacy など別の設計が必要になる。

出典: [Boston Women’s Workforce Council — Data Privacy](https://bwwc.squarespace.com/mpc)

---

## 実運用例4: デンマークの秘密入札

2008年1月、デンマークの砂糖大根生産契約を売買する double auction で、農家の秘密入札を公開せずに市場を清算した。
大規模・実用的な MPC の初期事例として知られている。

```text
data owner:
  契約を売買する農家

input:
  非公開の売買価格と数量

function:
  supply / demand を集計し double auction を清算

output:
  clearing result と成立した契約移転

hidden:
  output から必要となる以上の個別 bid
```

なぜ MPC が必要だったか:

- 売り手・買い手は互いに個別 bid を見せたくない
- 単一の auctioneer に全 bid を預けずに計算したい
- 必要な clearing result だけを共同で得たい

MPC だけでは解決しないこと:

- 虚偽 bid や契約資格など input validity
- 比較・集計・clearing rule の計算コスト
- output から推測できる価格・需給情報
- 約定後の契約執行と紛争処理

Private DEX 課題も同じ型で、秘密注文、matching rule、output leakage、約定後の執行を分けて考えられる。

出典: [Bogetoft et al., “Secure Multiparty Computation Goes Live,” FC 2009](https://doi.org/10.1007/978-3-642-03549-4_20)

---

# Part 7: ZK / FHE / MPC と関連技術の比較・まとめ

<!-- ## 目的

MPC を他のプライバシー技術と比較し、いつ使うべきかを判断できるようにする。 -->

---

## 関連技術との比較

| 技術 | 主な目的 | 誰が計算するか | 隠す対象 | 保証の見方 |
|---|---|---|---|---|
| ZK | 正しいことを証明する | prover | witness | proof で保証 |
| FHE | 暗号化したまま計算する | evaluator | データと中間値 | 計算結果の検証は別設計になることが多い |
| MPC | 入力を集めず共同計算する | 複数 party | 各 party の入力 | プロトコルと敵対モデル次第 |
| TEE | ハードウェア内で安全に計算する | enclave | enclave 外からのデータ | ハードウェア仮定に依存 |
| DP | 出力から個人情報を推測しにくくする | 集計者 | 個人の寄与 | 統計的プライバシー保証 |

---

## 使い分けの直感

### ZK

使いたい場面:

- 入力を隠したまま、条件を満たすことを証明したい
- 計算結果の正しさを verifier に納得させたい
- blockchain 上で検証したい

例:

```text
私は十分な残高を持っている
しかし残高そのものは見せたくない
```

### FHE

使いたい場面:

- データを暗号化したまま外部に計算を委託したい
- 計算者は1者でもよい
- データを復号せずに処理したい

例:

```text
クラウドに暗号化データを置いたまま計算したい
```

### MPC

使いたい場面:

- 複数 party がそれぞれ秘密入力を持っている
- 入力を一か所に集めたくない
- 全員または一部の party が共同で答えを得たい

例:

```text
複数社がデータを出さずに共同統計を出したい
```

### TEE

使いたい場面:

- ハードウェア仮定を受け入れられる
- 既存のプログラムに近い形で実行したい
- 運用上、enclave を信頼境界として扱える

### DP

使いたい場面:

- 出力統計から個人の寄与を推測されにくくしたい
- output leakage を抑えたい
- 厳密な個別値より、統計的な有用性とプライバシーのトレードオフを取りたい

DP は MPC の単純な代替というより、MPC の output leakage 対策として併用されることもある。

---

## MPC を使う前に確認すること

MPC が向くのは、複数 party が関わっており、それぞれが秘密入力を持ち、入力を一か所に集めずに、明確な関数の output だけを得たい場合である。

MPC は強力だが、採用する前に次を確認する必要がある。

| 観点 | 確認すること |
|---|---|
| party | 誰が参加し、必要なタイミングでオンラインになれるか |
| function | 非線形演算が多すぎないか |
| security | semi-honest でよいか、malicious security が必要か |
| cost | 通信量、ラウンド数、前処理を許容できるか |
| output | 出力そのものから個別入力が漏れすぎないか |
| representation | 現実の値を有限体や固定小数点へ落とせるか |
| operation | 実装・運用・監査の責任分界を決められるか |

MPC を実世界で使うかどうかは、暗号技術だけでなく、プロダクト・運用・組織間契約の問題でもある。

---

## 講義のまとめ

MPC は、信頼できる第三者を置かずに、複数 party が秘密入力を持ったまま共同で関数を計算する技術である。

秘密分散を使うと、secret を share に分けたまま扱える。

share 上では、加算・減算のような線形演算は軽い。

一方で、乗算には通信や前処理が必要になり、比較・ソート・条件分岐はさらに重くなる。

実用では、次を必ず設計する必要がある。

```text
party は誰か？
input は何か？
function は何か？
output は誰が知るか？
何人まで壊れてよいか？
semi-honest でよいか、malicious が必要か？
party が途中で止まった場合どうするか？
出力から何が漏れるか？
入力の正しさはどう保証するか？
現実の値をどう表現するか？
どの演算が重くなるか？
generic MPC で解くべきか、special-purpose MPC を探すべきか？
MPC である必要があるか？
```

次のホワイトボードセッションでは、この観点を使って具体的な応用を設計する。

---

# ホワイトボードセッション用の設計シート

具体的な応用を考えるときは、次の順に整理する。

| 観点 | 問い |
|---|---|
| party | 誰が計算に参加するか |
| input | 各 party は何を秘密入力として持つか |
| function | 何を共同で計算したいか |
| output | 誰が何を出力として知るか |
| leakage | 出力から何が推測されるか |
| adversary | semi-honest でよいか、malicious を考えるか |
| representation | 値を有限体、ring、固定小数点などでどう表すか |
| cost | 乗算、比較、分岐、ソート、通信がどこで重くなるか |
| availability | party が途中で止まった場合どうするか |
| input validity | 入力の正しさをどう保証するか |
| protocol shape | generic MPC か、special-purpose MPC か |
| alternatives | ZK、FHE、TEE、DP などの方が適切ではないか |

このシートは、MPC の知識を暗記するためではなく、「この応用を本当に MPC で解くべきか」を議論するために使う。

---

# ホワイトボードセッション課題: Private DEX を設計する

複数のトレーダーが指値注文（Limit Order）を提出する Private DEX を設計する。

## 与えられる前提

- すべての未約定注文は MPC ノードに秘密分散される。
- 未約定注文は、他のトレーダー、単一の MPC ノード、一般ユーザー（公開情報）から秘匿される。
- MPC は、売値と買値の条件が交差する注文を発見する。
- 約定時には、対象となった注文とトレーダーの署名をコントラクトへ提出する。
- コントラクトは注文条件を再検証し、アトミックに資産を交換する。
- このシステムでは ZK Proof を使用しない。そのため、約定した注文内容はオンチェーンで公開される。

## グループで設計すること

1. party / input / function / output を定義する。
2. 価格、数量、価格優先・時間優先、部分約定を含むマッチングルールを決める。
3. MPC ノードの結託数と adversary model を決める。
4. 注文への署名、nonce、期限、取消、replay 防止を設計する。
5. 約定結果や繰り返し観測から何が漏れるかを整理する。
6. ノード停止、トレーダーの資産不足、約定直前の取消、abort をどう扱うか決める。
7. MPC 内で重くなる比較・ソート・通信と、コントラクト側で再検証する処理を分ける。
8. この設計が保証することと、保証しないことを明示する。

## 成果物と進行

- 成果物: MPC 設計シート 1 枚と3分間の発表
- グループ作業: 75分
- 発表: 15分
- フィードバック: 15分
- バッファ・全体まとめ: 15分

---

## 講義終了時の確認質問

最後に、受講者に次の問いを投げる。

1. MPC は何を置き換える技術か？
2. MPC は何を隠し、何を隠さないのか？
3. 加法的秘密分散で加算が軽いのはなぜか？
4. 乗算に Beaver triple が必要になる理由は何か？
5. secret な値に依存する `if` 文が普通に書けないのはなぜか？
6. semi-honest と malicious では何が違うか？
7. honest majority と dishonest majority では何が違うか？
8. generic MPC と special-purpose MPC では何が違うか？
9. threshold wallet はなぜ MPC の実用例として重要か？
10. PSI では、共通部分を出す場合とサイズだけを出す場合で何が違うか？
11. MPC と ZK は何が違うか？
12. どのような場合に MPC を使わない判断をすべきか？

---

## 推奨スライド構成

<!-- 特に Shamir、Beaver triple、制御フロー、出力保証、応用例は、1枚に詰め込むより分割した方が理解しやすい。

Part 6 の応用例はすべて同じ型で見る。各応用を深掘りするというより、party / input / function / output / leakage / cost / type で分解する練習として扱う。 -->

| 枚数 | パート | 内容 |
|---:|---|---|
| 1 | 表紙 | Advanced Cryptography Program Week 2: MPC |
| 2 | 導入 | 3人の給与平均はいくら？ |
| 3 | 導入 | 目次 |
| 4 | Part 1 | MPC は何をしたい技術か |
| 5 | Part 1 | Advanced Cryptography Program における MPC の位置づけ |
| 6 | Part 2 | Trusted Third Party の理想世界 |
| 7 | Part 2 | MPC の直感的な定義 |
| 8 | Part 2 | 基本設定: party / input / function / output |
| 9 | Part 2 | MPC が守りたい性質: correctness / privacy / robustness |
| 10 | Part 2 | MPC が保証しないこと |
| 11 | Part 3 | 秘密分散とは？ |
| 12 | Part 3 | 例: 加法的秘密分散 |
| 13 | Part 3 | 加法的秘密分散の特徴 |
| 14 | Part 3 | 復元条件: なぜ k-of-n が欲しいのか |
| 15 | Part 3 | Shamir の直感: 点が足りないと多項式が定まらない |
| 16 | Part 3 | Shamir の秘密分散法 |
| 17 | Part 3 | 加法的秘密分散と Shamir の比較 |
| 18 | Part 3 | MPC での使い方: 何を opening してよいかを設計する |
| 19 | Part 3 | エンジニア視点: 現実の値をどう扱うか |
| 20 | Part 4 | 線形演算は軽い |
| 21 | Part 4 | 乗算はローカル計算だけでは閉じない |
| 22 | Part 4 | Beaver triple: 乗算のための使い捨てマスク |
| 23 | Part 4 | Beaver triple による乗算 |
| 24 | Part 4 | Arithmetic circuit と Boolean circuit |
| 25 | Part 4 | MPC における制御フローの考え方 |
| 26 | Part 4 | 重くなりやすい演算 |
| 27 | Part 4 | MPC のコストはどこで決まるか |
| 28 | Part 5 | MPC プロトコルを見るための軸 |
| 29 | Part 5 | party はどう振る舞うか: semi-honest / malicious |
| 30 | Part 5 | 何人まで壊れてもよいか: honest majority / dishonest majority |
| 31 | Part 5 | 出力保証: abort / fairness / guaranteed output delivery |
| 32 | Part 5 | generic MPC と special-purpose MPC |
| 33 | Part 5 | 主要な MPC プロトコル |
| 34 | Part 5 | Yao's Garbled Circuit: 2PC と Boolean circuit |
| 35 | Part 5 | SPDZ: malicious security と dishonest majority |
| 36 | Part 6 | 応用を見るための型 |
| 37 | Part 6 | Fireblocks の MPC wallet |
| 38 | Part 6 | Meta の Private Data Lookup |
| 39 | Part 6 | Boston の賃金格差分析 |
| 40 | Part 6 | デンマークの秘密入札 |
| 41 | Part 7 | 関連技術との比較: ZK / FHE / MPC / TEE / DP |
| 42 | Part 7 | 使い分けの直感 |
| 43 | Part 7 | MPC を使う前に確認すること |
| 44 | まとめ | 講義のまとめ |

補足スライドを作るなら、次を Appendix に回す。

- detailed OT extension
- ABY と arithmetic / boolean / Yao の組み合わせ
- SPDZ の MAC 検証の詳細
- 固定小数点・丸め誤差・overflow
- fairness / guaranteed output delivery の詳細
- 応用例ごとの実装方式・実サービス事例
