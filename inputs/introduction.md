---
target_audience: "Advanced Cryptography Program Week 6 受講者 (Week 1-5 で ZK / MPC / FHE の理論を一通り学んだ受講者 / オンサイト20-25名 / 学部生〜社会人エンジニア混在)"
audience_type: group
constraints:
  max_slides: 16
  max_duration_minutes: 130
output_language: Japanese
event:
  name: "Advanced Cryptography Program — Week 6"
  parent_event: "Merkle Japan × 東京大学ブロックチェーンイノベーション寄付講座"
  date: "2026 年度"
  location: "東京大学 講義室 (オンサイト)"
---

# Advanced Cryptography Program — Week 6: Programmable Cryptography Stack Design

担当: Shouki Tsuda
構成: 2 時間講義 (実時間 130 分 + 休憩 10 分) + ホワイトボードセッション
形式: オンサイト、20-25 名想定 (Week 1-5 で道具箱を学んだ受講者)

> 本ファイルは **教える内容 (What)** の原稿。スライドの具体的な見せ方 (演出 / アニメーション /
> ビジュアル) は講師がスライド作成時に決定する。本叩き台は全 6 ブロックを最薄 (各 1-2 枚 = 計 14 枚)
> で通す静的版。

## タイムテーブル

| 時刻 | セクション | 内容 | 時間 |
| --- | --- | --- | --- |
| 0:00-0:10 | Hook + Frame | Programmable Cryptography を frame に置く | 10分 |
| 0:10-0:25 | Trade-off の俯瞰 | ZK/MPC/FHE × 4軸の比較 | 15分 |
| 0:25-1:05 | A. zkVM | VM抽象 / R0VM 2.0 / Jolt / SP1 / zkEVM Type 1-4 / 量子耐性 / leanVM | 40分 |
| 1:05-1:15 | 休憩 | — | 10分 |
| 1:15-1:55 | B. vFHE + Ethereum PIR | 用語射程 / Greco / EagleEye / PSE zkFHE / Spiral / SimplePIR | 40分 |
| 1:55-2:15 | C+D+E+F+G 周辺/対比/警鐘 | co-SNARK / zkTLS / MPCitH / VOLE-ZK / Tornado | 20分 |
| 2:15-2:20 | WS Pivot | 次の演習への橋渡し | 5分 |

縮退ルール: 時間超過時は G → F → E の順に削減。主軸 A/B は守る。

Anti-pattern 回避: 数学先行を避ける (各トピック「スタック図 → 動機 → 暗号要素 → 数学」の順) / 3 primitive を
別々に教えない (composition を frame に置く) / TEE には触れない (希釈防止)。

---

## 0. Hook + Frame (10分)

**ゴール**: 「ZK・MPC・FHE は別物」というモデルを崩し、「同一家系の programmable な道具」というモデルに置き換える。

- **Programmable Cryptography という枠組み** (gubsheep, 2024): ZK・MPC・FHE は「ある関数 f を計算する際に、
  誰が何を見るか・何を保証するか」を設計するためのプリミティブ家系。Week 1-5 は道具箱の中身、Week 6 は道具の使い方。
- **World ID 事例で「組み合わせは既に本番」を示す**: 2025-07 から TACEO co-SNARKs が本番稼働、~18M users / 160ヶ国。
  虹彩コード一意性検証を MPC (入力プライバシー) + ZK (出力検証可能性) で実現。未来ではなく現在の話。
- **Week 6 のゴール**: 「目的・信頼前提・コストから primitive を選び、スタックを設計できる」能力の獲得。

一次資料: gubsheep "Programmable Cryptography (Part 1)" (0xPARC) ｜ TACEO "MPC for iris code uniqueness" ｜
TACEO "The Power of ProgCrypto"。

---

## 1. Trade-off の俯瞰 (15分)

**ゴール**: zkVM / vFHE 講義のベースラインを共通化。3×4 の比較マトリクスを完成させる。

| | 信頼前提 | レイテンシ | prover コスト | 合成性 |
| --- | --- | --- | --- | --- |
| **ZK** | 計算上の困難性 (DLP / pairing / hash) のみ。prover 1名 | 証明生成は重いが verify は軽い | 重い (回路サイズ依存) | recursion / aggregation で重ねやすい |
| **MPC** | 閾値以下の party の collusion 想定。online は対話的 | 通信ラウンド数支配 | 各 party 軽い、合計は重い | 静的合成は可、動的合成は protocol 依存 |
| **FHE** | LWE 困難性。鍵管理者の信頼が必要 (Threshold FHE で分散可) | 暗号文上演算は重く深いほど指数的 | bootstrapping が支配 | 暗号文同士は自然合成、結果検証は別途 |

観点: どの primitive も無料ではない。「組み合わせれば全部解決」は誤り (Aztec post)。選択は目的次第。

一次資料: Aztec "Is ZK-MPC-FHE-TEE a real creature?"。

---

## 2. A. zkVM (40分)

**ゴール**: zkVM がなぜ汎用 ZK の事実上の標準になりつつあるかを構造で説明。最後に量子耐性論点を、
**Ethereum の量子耐性獲得に zkVM が使われている具体例 (leanVM / RISC-V)** まで接続する。

### 2.1 なぜ VM 抽象が勝つか
- 回路設計の最大の苦痛: 任意プログラムを R1CS / Plonkish に手で変換するコスト。
- VM 抽象の解: front-end (Rust → ELF / bytecode) と back-end (proof system) を分離。後者を1回作れば前者は無限に交換。
- front-end 拡張: Rust / Cairo / Noir / Solidity。back-end 拡張: Plonk / FRI / Halo2 / Hyperplonk。

### 2.2 R0VM 2.0
- RV32IM フル実行、Continuations (segment 独立証明 → 再帰集約 / 並列証明可 / verifier O(log))、Bonsai (off-chain proving)。
- 2025-04 リリースで Ethereum ブロック証明を 35分 → 44秒。

### 2.3 Jolt / RISC0 / SP1
| | Jolt | RISC0 | SP1 |
| --- | --- | --- | --- |
| 設計哲学 | Lookup-centric | Trace ベース | RISC0 系の改良 (recursion 最適化) |
| Back-end | Lasso | FRI (hash-based) | FRI (hash-based) |
| 強み | Lookup の表現力で短い回路 | 古参で audit/実績、Bonsai 連携 | SDK整備 / Solidity verifier 公式 |

### 2.4 zkEVM Type 1-4 (別解として対比)
- Type 1 EVM equivalence (Taiko) / Type 2 EVM 互換・内部最適化 (Polygon) / Type 3 ほぼ互換 (zkSync Era) /
  Type 4 高級言語互換 (Scroll/StarkNet)。共通課題: Keccak / ecRecover / EVM storage / 256-bit 算術の回路化。
- zkEVM = 特定ドメイン (EVM) に特化した zkVM。

### 2.5 量子耐性 ① — 原理: PKC を ZK で wrap (PKC × ZK の Programmable Cryptography 例)
- STARK / FRI (hash-based commitment) ベースなら安全性は collision-resistant hash のみに依存 → post-quantum に概ね安全。
- Groth16 / KZG (pairing-based) は楕円曲線 DLP 依存 → Shor で破れる。
- 移行アイデア: 既存 Groth16/KZG の検証回路を zkVM 上で実行し STARK で証明する = 「PKC を ZK で wrap」。
- key insight: 「量子計算機が来たら ZK は終わり」ではなく **設計選択の問題**。

### 2.6 量子耐性 ② — Ethereum 実装: leanVM と RISC-V (★ Week6 追加)
**論点**: Ethereum の耐量子 (PQC) 移行で zkVM は中核装置として既に設計・実装フェーズに入っている。

- **コンセンサス層 (CL) = leanVM**:
  - BLS 署名は量子耐性なし → ハッシュベースの **leanXMSS** に移行 (IACR ePrint 2025/055 → 2025/1332)。
  - だが XMSS は **ネイティブ集約不可**。Ethereum は各 slot で大量のバリデータ署名を扱うため集約が必須。
  - 解: 最小 zkVM **leanVM** 上で XMSS 検証を SNARK 証明し、**2-to-1 で再帰集約**する (leanMultisig)。
  - 構成: KoalaBear field / Poseidon2 (SNARK 最適化ハッシュ) / 多項式コミットメント WHIR (FRI 改良)。
    性能目標 1,000 XMSS sigs/s・再帰集約 ~200ms・128-bit security・「初心者に30分で説明できる」シンプルさ。
  - CL 全体のセキュリティが Poseidon2 / WHIR (hash ベース = PQ-secure) の堅牢性に帰着 → 形式検証プロジェクト $20M
    (Lean 4, Veridise/Alex Hicks) と $1M Proximity Gap Prize が正当化される。
- **実行層 (EL) = RISC-V**: Vitalik 2025-04 提案 — EVM を RISC-V で直接置き換える (ZK 証明効率 100倍超 / 形式検証容易)。
- **まとめ**: leanVM は「zkVM のユースケース」であると同時に「**Ethereum が量子耐性を獲得する手段そのものが zkVM**」
  という最重要事例。数値・時期 (2029 目標) は研究・ロードマップ段階であり未確定の論点を含む。

一次資料: a16zcrypto "Understanding Jolt" ｜ RISC Zero zkVM 2.0 announcement ｜ SP1 docs ｜
Vitalik "Possible futures: The Surge" (2024-10) + RISC-V 提案 (2025-04) ｜ Lean Consensus 2026 plan
(hackmd @tcoratger/ryS1ElrWbx) ｜ leanXMSS (ePrint 2025/055, 2025/1332) ｜ EF $1M Proximity Gap Prize ｜
zkEVM Formal Verification Project (Veridise)。
ローカル典拠: ~/research-notes/ethereum-pqc-part{1,2,3}-revision.md, ~/research-notes/Ethereum/Consensus/lean Multisig/TG/lean VM.md。

---

## 3. B. vFHE + Ethereum PIR (40分)

**ゴール**: 「vFHE で何を証明するのか」の射程を明確にし、FHE が production-bound な応用 (PIR) に到達している現状を Ethereum 文脈で示す。

### 3.1 用語の射程確定
1. **vFHE (本講義の対象)**: FHE 計算 `Eval(ct, f) → ct_out` の正当性を ZK 証明 (サーバーが嘘の演算をしていない検証)。
2. **Verifiable decryption**: 復号者が正しい鍵で正しく復号した証明 (脚注扱い)。
3. **広義の ZK+FHE composition**: 暗号文上演算と入力の真正性検証を組み合わせる (具体例として PSE zkFHE)。
> FHE の信頼前提は「データ機密のみ。計算正しさは vFHE で別途」と分解する。

### 3.2-3.5 手法
- **Greco**: BFV/BGV 暗号文の wellformedness を SNARK 制約で表現 (ciphertext 単位)。
- **EagleEye**: FHE 演算 trace を Plonk 系制約に落とし bootstrap 含む長い演算系列を圧縮 (演算 trace 単位)。
- **PSE zkFHE**: BFV 暗号文上演算を Halo2 回路で証明する PoC (ゲート単位、OSS 動作可)。

| 手法 | 証明粒度 | 想定スキーム | 想定アプリ | 状態 |
| --- | --- | --- | --- | --- |
| Greco | ciphertext 単位 | BFV/BGV | クライアント証明 | 論文 + PoC |
| EagleEye | 演算 trace | BGV | server-side 証明 | 論文 + 実験 |
| PSE zkFHE | ゲート単位 | BFV | 教育 PoC | OSS 動作可 |

### 3.6 Ethereum における PIR
- **PIR**: クライアントがどのインデックスを引いたかをサーバーに隠してデータを取得。多くの構成は FHE / LWE ベース。
- 3つの応用文脈: RPC プライバシー (Helios light client + PIR) / Light Client クエリ匿名化 / Mempool プライバシー。
- 代表スキーム: Spiral (MIT, Menon-Wu 2022, ~100ms) / SimplePIR・DoublePIR (Henzinger 2023, 極軽 online) / FrodoPIR (lattice, 保守的)。
- 観点: 汎用 vFHE (EagleEye) と特化応用 (PIR) の対比。FHE は応用文脈で限定すれば既に実用域。

一次資料: Greco (eprint 2024) ｜ EagleEye ｜ PSE zkFHE ｜ Spiral PIR ｜ SimplePIR ｜ TLShare (eprint 2025/1434) ｜ EF FHE/PIR research notes。

---

## 4. 周辺/対比/警鐘 (20分)

- **co-SNARK in production**: 既存 Circom/Noir 回路を変更せず、複数 party の secret-shared witness から1つの SNARK を協調生成。
  World ID (TACEO): 虹彩コード (secret) を 3-party MPC で uniqueness check し Groth16 で証明、Worldcoin contract が公開検証。
- **zkTLS family**: TLSNotary (notary が TLS session key を MPC 共有し選択開示) / vlayer (Web/Email/Time Travel Proofs) /
  Reclaim (制約環境)。Web2 の application data を Web3 で検証可能にする橋渡し。
- **MPCitH ≠ MPC**: MPCitH (IKOS 2007) は prover が頭の中で MPC をシミュレートし transcript を commit+open する **proof technique** (prover 1名)。
  NIST PQ 署名候補: Picnic / AIMer / FAEST / SDitH 等。co-SNARK は **trust model** (prover 複数)。混同禁止。
- **VOLE-ZK**: TLSNotary が backend を Garbled Circuit から QuickSilver (VOLE-ZK) に切替。通信量は回路サイズに線形だが
  prover が極めて軽い → モバイル/組込/ストリーミング向け。代表: Wolverine / QuickSilver / Mac'n'Cheese / Mozzarella。
- **Tornado Cash clustering (警鐘)**: zk-SNARK 設計は数学的に正しいが、使用パターン (タイミング相関・ガス・関連アドレス) から
  $2.3B 相当が de-anonymize 可能 (arXiv 2510.09433)。**暗号保証 ≠ 実用プライバシー**。Week 6 の全技術に適用される警鐘。

一次資料: TACEO co-snarks ｜ tlsnotary/tlsn ｜ vlayer book ｜ Reclaim Protocol ｜ NIST PQC seminar on MPCitH ｜ Tornado Cash clustering (arXiv 2510.09433)。

---

## 5. WS Pivot (5分)

**ゴール**: 講義の Trade-off と exemplar を、次のホワイトボードセッションで「自分で設計する」局面に橋渡し。

- WS のお題と進行 (Part 1 設計 75分 / Part 2 レビュー 75分) の概要。
- 必須テンプレ5要素: Actors / Secret Inputs / Public Outputs / Trust Boundary / Primitive Selection。
- WS で問われるのは「**この設計でなぜ ZK か / なぜ MPC か / なぜ FHE か** を1文で説明できるか」。
- 移行: `whiteboard-session.md` の進行に従って Part 1 設計フェーズへ。
