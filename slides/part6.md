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

MPC の応用例を以下の観点で分解して見る。

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
cost:
  どの演算・通信・運用が重いか
type:
  generic MPC か、special-purpose MPC か
```

---
layout: two-cols-header
class: application-slide app-wallet
---

# 実運用例1: Fireblocks の MPC wallet

<p class="case-kicker">一般形: Threshold signature / MPC wallet</p>

::left::

Fireblocks は、デジタル資産ウォレットの署名に MPC を利用している。Embedded Wallets では、ユーザー端末と Fireblocks 側サーバーによる **2-of-2 MPC signature** を採用している。

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

::right::

## MPC を使う理由

- 単一の端末・サーバーに秘密鍵全体を置かない
- blockchain 側には通常の署名として提出できる
- key share の配置を署名ポリシーに接続できる

## MPC だけでは解決しないこと

- 端末紛失時の復旧と key share の更新
- 誰がどの transaction を承認できるか
- 署名 party やネットワークが停止した場合の可用性
- endpoint・TEE・運用権限を含む信頼境界

<p class="case-note">これは任意の関数を評価する generic MPC ではなく、署名方式の構造を使う special-purpose MPC である。</p>

<p class="case-source">出典: <a href="https://developers.fireblocks.com/docs/overview">Fireblocks Developer Docs — Direct Custody Wallets: Overview</a></p>

---
layout: two-cols-header
class: application-slide app-psi
---

# 実運用例2: Meta の Private Data Lookup

<p class="case-kicker">一般形: Private Set Intersection / private membership test</p>

::left::

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

::right::

## 実際の処理

- client が password hash をリクエストごとの鍵で blind する
- service も秘密鍵を使って処理する
- 最終的な照合は client 側で行い、Meta は結果を得ない

## 実装上のトレードオフ

- 巨大な漏洩済み password 集合の前処理
- client が受け取るデータ量と latency
- sharding index が増やす leakage と性能のバランス
- 繰り返し query や small domain への対策

<p class="case-note">「集合の共通部分を全部返す」のではなく、片側だけが membership の結果を得る special-purpose PSI として見る。</p>

<p class="case-source">出典: <a href="https://engineering.fb.com/2023/08/08/security/how-meta-is-improving-password-security-and-preserving-privacy/">Engineering at Meta — Private Data Lookup</a></p>

---
layout: two-cols-header
class: application-slide app-analytics
---

# 実運用例3: Boston の賃金格差分析

<p class="case-kicker">Boston Women’s Workforce Council × Boston University</p>

::left::

Greater Boston の複数企業が、個社や従業員の給与データを公開せず、地域全体の gender / racial wage gap を共同で測定している。

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

::right::

## MPC が担う部分

- 参加企業は MPC-backed software 経由でデータを提出する
- BWWC は個社データではなく集計結果を分析する
- 組織間で raw payroll data を共有せずに統計を得る

## MPC だけでは解決しないこと

- 入力データの正しさと分類基準の統一
- 小さい集団や細かい属性別 output からの推測
- 欠損値、外れ値、繰り返し分析の扱い
- 統計を誰にどの粒度で公開するか

<p class="case-note">MPC は計算中の raw data を守る。公開統計からの推測には、集計粒度や Differential Privacy など別の設計が必要になる。</p>

<p class="case-source">出典: <a href="https://bwwc.squarespace.com/mpc">Boston Women’s Workforce Council — Data Privacy</a></p>

---
layout: two-cols-header
class: application-slide app-matching
---

# 実運用例4: デンマークの秘密入札

<p class="case-kicker">2008 Danish Sugar Beet Contract Exchange</p>

::left::

砂糖大根の生産契約を売買する double auction で、農家の秘密入札を公開せずに市場を清算した。大規模・実用的な MPC の初期事例として知られている。

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

::right::

## なぜ MPC が必要だったか

- 売り手・買い手は互いに個別 bid を見せたくない
- 単一の auctioneer に全 bid を預けずに計算したい
- 必要な clearing result だけを共同で得たい

## MPC だけでは解決しないこと

- 虚偽 bid や契約資格など input validity
- 比較・集計・clearing rule の計算コスト
- output から推測できる価格・需給情報
- 約定後の契約執行と紛争処理

<p class="case-note">Private DEX 課題も同じ型で、秘密注文、matching rule、output leakage、約定後の執行を分けて考えられる。</p>

<p class="case-source">出典: <a href="https://doi.org/10.1007/978-3-642-03549-4_20">Bogetoft et al., “Secure Multiparty Computation Goes Live,” FC 2009</a></p>
