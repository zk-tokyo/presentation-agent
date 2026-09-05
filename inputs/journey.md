# 試行錯誤メモ — Week 1 スライド制作の経緯

このファイルは、Advanced Cryptography Program Week 1 のスライドを制作する過程で経験した試行錯誤・判断ポイント・気づきを時系列で残したものです。次回以降の制作で同じ轍を踏まないための参考資料として、また `inputs/rules.md` のルール抽出の元になります。

---

## Phase 0 — 初期着手

**入力**: Notion ページ (`Week1-359d05af0d5a806196bfc4795f766f10`) の講義計画。
- 2 時間講義 + 30 分休憩 + 3 時間ホワイトボードセッション
- オンサイト 20-25 名
- 学習成果 8 項目 / S0-S3 構成 / KelpDAO×LayerZero 題材のホワイトボード

**判断**: 当初は Notion の全情報を「漏れなく」スライド化しようとして 32 枚に。これが過剰だった (後述)。

**作成した SVG 図解**:
- `scope_gap.svg` — 攻撃面 vs 防御スコープ
- `prog_crypto_3d.svg` — Programmable Cryptography の 3D 積み木アーキ
- `sumcheck_protocol.svg` — Prover/Verifier の Sumcheck ラウンド構造
- `jolt_arch.svg` — Jolt = Sumcheck + Lasso アーキ
- `longfellow_arch.svg` — Issuer/Holder/Verifier フロー + 技術スタック
- `kelp_attack.svg` — KelpDAO×LayerZero 攻撃フロー
- `4_questions.svg` — サービス設計の 4 つの問い
- `proof_meanings.svg` — 「証明」の 3 つの意味

---

## Phase 1 — 教授視点の自己レビュー (再帰的自己改善)

**手法**: general-purpose エージェントに「Programmable Cryptography 講義経験 20 年の教授」ペルソナで全 32 枚を厳密レビューさせた。

**指摘された致命的問題 (Critical 5 件)**:
1. **Longfellow を Sumcheck 系として誤分類** — Longfellow の核は **Ligero / MPC-in-the-head 系**であり、Sumcheck はコア構造ではない。SL17 の三角構図 (主役 Sumcheck/Jolt / 共通 / 社会実装 Longfellow) は誤った因果連鎖。
   - 修正: 「2 つの独立した革命 — 系統 A: Sumcheck (Jolt) / 系統 B: MPC-in-the-head (Longfellow)」と並列に位置づけ直し、SVG 技術スタックも書き直し。
2. **Sumcheck prover を無条件で「線形時間」と断言** — 一般には d·|H|^n に依存し、線形化は Thaler 2013 の structured polynomial 系に限った結果。
   - 修正: 「structured multilinear extension 上で concretely efficient (Thaler 2013 系)」に弱めた。
3. **FHE の信頼前提を雑に「server を信頼しない」と書いた** — 素の FHE は計算正しさを保証しない。データ機密と計算正しさを分けて記述しないと罠 #2 (soundness ≠ ZK) と衝突。
   - 修正: 「server にデータ機密は信頼しない / 計算正しさは別途 (Verifiable FHE)」に分解。
4. **2026 年事件 (Mexican gov, Aave \$8.45B) を出典なし固有数字で提示** — 未来事象の数値は講師の信用毀損リスク。
   - 修正: 「仮想/最新シナリオ」「数値は配布 Chainalysis レポート参照」と注記。
5. **Programmable Cryptography に「学術的定義」と銘打って 0xPARC スローガンを提示** — エンジニアリングスローガンと UC framework の合成性は質的に異なる。
   - 修正: 「コミュニティで使われる実践的枠組み」とラベリング、UC との違いを明示。

**学び**: 自分一人で書くと、用語の所属系譜や計算量仮定の付帯条件など、講師経験者なら気付く「滑り」が複数発生する。**自己レビュー時は、別人格の専門家ペルソナを明示的に呼び出す**のが効く。

---

## Phase 2 — 講義投影用への絞り込み

**指摘**: 「講義資料にはいらない情報もあるようにみえる」 (ユーザフィードバック)

**対応**: 「投影スライド」と「講師ハンドアウト」の役割分離を意識して 32 → 28 枚に削減。

**削除した 4 枚**:
- SL04 詳細タイムテーブル → 講師ハンドアウト
- SL11 倫理単独スライド → SL10 内のコールアウトに統合
- SL24 「休憩 10 分」ページ → 講師が口頭で言えば足りる
- SL30 詳細クロージング → SL32 に統合

**圧縮した 2 枚**:
- SL05 S0 Welcome — 7 項目あった運営事項を「AI ルール + 学習契約 + 1 行アクセシビリティ」に
- SL29 プロジェクト発表 — 難易度タグや脚注を外し 4 系統名前のみに

**学び**: 学生がスクリーンを見て価値があるのは: 図解 / 対比表 / 用語定義 / 例 / Open Question。**逆に運営的詳細 (時刻表、ルーブリック詳細、自己評価リスト、Track 説明の網羅) は配布資料・Notion 側へ**。

---

## Phase 3 — 時間表記・認知レベル表記の一掃

**指摘**: 「『認知レベル設計』『休憩 30 分 → ホワイトボード 180 分』のような時間表記もいらないな」

**対応**: 全スライドから運営側の時間情報を抽出して削除。
- SL01 カバー: 「2 時間講義 + 30 分休憩 + 3 時間ホワイトボードセッション」を削除
- SL02 全体構成: 「Why (35 分)」「(37 分)」「(20 分)」「10 分のミニ休憩」を削除
- SL03 Outcomes: 「認知レベル設計 / Bloom's taxonomy」枠を削除
- SL06, SL13 セクション扉: タイトル横の「(35 分)」「(37 分)」を削除
- SL31 WB 予告: 「Phase 1 (30 分)」等の所要時間を削除
- SL32 まとめ: 「30 分 → 180 分」を削除

**学び**: 時刻は講師の手元のためのもの。投影には文脈がなく、見る側はノイズに感じる。**時間に関する情報は「次の活動が何か」だけが投影してよい (例: 『このあと ① One-Minute Paper ② ポストテスト』)**。

---

## Phase 4 — Playwright 導入とオーバーフロー検証

**指摘**: 「下にはみだしちゃってるスライドもまあまああるからレイアウトを見直してください。playwright つかったらわかるかなあ?」

**苦戦したポイント**: Playwright の Chromium は `libglib-2.0.so.0` を要求し、Nix 環境のシステムライブラリと噛み合わずに起動できなかった。複数のパスを試行:
1. `playwright-chromium` インストール → `libglib` 不足で動かない
2. Nix store の 64bit libglib を `LD_LIBRARY_PATH` で繋ぐ → 別 lib (libnspr 等) が連鎖的に不足
3. Playwright Firefox インストール → host requirement validation 失敗
4. **最終解**: システムインストール済の Firefox を `firefox --headless --screenshot=` で直接駆動。SPA 用ローカルサーバ (`/tmp/spa_server.py`, port 4002) を Python で書き、`dist/` を SPA fallback 付きで配信。
   - Firefox は `load` イベントで撮るので Vue SPA 描画が間に合わないことがある → 3 回試行して最大サイズを採用するループで安定化。

**発見した overflow 問題** (canvasWidth: 980 デフォルトでは余白不足):
- スライド 10 (証明 3 意味): 下部 2 枠が切れる
- スライド 13 (Programmable Crypto): Open Question 末尾が切れる
- スライド 16 (Sumcheck): 下部 2 枠が切れる
- スライド 19 (Longfellow): 下部 2 列が切れる
- スライド 24/25 (罠): 下端ぎりぎり

**根本対処**: `slides.md` に `canvasWidth: 1280` を追加。これで `980×551` → `1280×720` 論理キャンバスとなり、`max-h-[400px]` の画像でも余裕が生まれた。

**追加で各スライドの圧縮も実施**:
- SL12 (証明 3 意味): SVG 330→420px、下部 2 枠 → 1 行警告に統合
- SL15 (Programmable Crypto): 右 SVG 360→480px、左テキスト圧縮
- SL18 (Sumcheck): 380→450px、下部 2 枠 → 1 行に圧縮
- SL21 (Longfellow): 400→460px、ステータス 5 行リスト → 1 行
- SL27 (罠 1-3): 2 列+col-span-2 → 3 列均等
- SL28 (罠 4-5): カード文字を bullet → 横並びに

**タイトル改行の調整**:
- SL13 (S2 扉): 「機能で覚えてはいけない / 敵対モデルと合成パターンで理解する」が自然な 2 行に
- SL17 (Sumcheck 革命): 「変わった。」の句点取り残しを 1 行収まりに

**学び**:
1. **Slidev デフォルト canvasWidth: 980 は窮屈**。日本語ベースで図 + 表 + テキストを並べるなら `canvasWidth: 1280` がおすすめ。
2. **Playwright が動かない環境では Firefox CLI + Python SPA サーバで代用可**。撮影タイミングが不安定なので 3 回試行+最大サイズ採用で堅牢化。
3. **設計時点で画像 `max-h-[Npx]` を制限**。`canvas高さ × 70%` を超えると下が確実に切れる。

---

## Phase 5 — zktokyo (Merkle Japan) ブランディング適用

**指示**: GitHub の `presentation/zktokyo-coreprogram2026-sponsors` ブランチのトンマナを適用。

**ブランチから取得した知見**:
- 旧称: ZK Tokyo → 新称: Merkle Japan (リブランディング)
- ロゴアセット (`zktokyo_logo.png`, `ut_blockchain.png`)
- デザイン語彙の規則性:
  - **Cards**: `rounded-xl` (not `lg`), `border border-{c}-200` (not `border-2 border-{c}-700`), 軽い枠線 + 薄い pastel 背景
  - **White cards**: `bg-white border border-gray-200 shadow-sm` の組み合わせ
  - **Text hierarchy**: `text-gray-900` (heading), `text-gray-700` (body), `text-gray-500` (subtle), `text-gray-400` (very subtle) — 純黒は使わない
  - **Accent**: `text-amber-600` (アクセント) / `text-amber-700` (ラベル)
  - **Bullets**: `▶` (amber) / `✓` (green) を Unicode で
  - **Cover**: `layout: center` + 上部にロゴ並び + 段階的タイトル (small label → large main → amber accent → subtitle)
  - **Section dividers**: `layout: center` + amber 2行タイトル + 3-4 サブカード

**一括置換した内容** (sed):
```bash
sed -i 's/rounded-lg/rounded-xl/g' SL*.md
sed -i 's/border-2 border-amber-700/border border-amber-300/g' SL*.md  # 全色対応
sed -i 's/border-amber-400/border-amber-200/g' SL*.md  # 軽量化
sed -i 's/border-gray-400/border-gray-200/g' SL*.md
```

**続いてユーザから差し替え指示**: 「`public/images/merklejapan_logo.png` にロゴ差し替えで。組織名も ZK Tokyo から Merkle Japan へリブランディングした。」

**対応**:
- `global-bottom.vue` を `merklejapan_logo.png` 96px に変更
- SL01 カバーロゴを差し替え、alt も「Merkle Japan」に統一
- スライド内の "ZK Tokyo" / "zktokyo" / "zk-tokyo" 残存ゼロを grep -r で確認

**学び**: ブランドの一括変更時は、(1) ロゴ画像差し替え (2) global コンポーネント (3) カバースライド (4) grep でテキスト痕跡掃除、の 4 ステップを定型化すると漏れない。

---

## Phase 6 — `\$` エスケープの一掃

**指摘**: 「`\$` といったエスケープは不要だと思う。`\` まで印字されてしまっている。」

**原因**: Slidev の `mdc: true` モードや Markdown パーサで `$292M` のような金額表記をうっかり `\$292M` と書いてしまっていた。バックスラッシュがそのまま印字される。

**対応**:
```bash
sed -i 's/\\\$/$/g' slides/*.md public/images/*.svg
```

10 箇所すべて修正、`grep -r '\\\$'` で残存ゼロ確認。

**学び**: KaTeX 数式の `$` を escape する必要は **ない** (Slidev はインライン数式に LaTeX `\(...\)` を使う / 表示 `$` は普通の文字)。スライドで通貨を扱うときは escape を入れないこと。

---

## Phase 7 — scope_gap.svg のベン図化

**指摘**: 「内と外という図なのに重複している説明がある (ソースコード)。ベン図的に書いたらいいんじゃないかな。」

**問題**: 旧 scope_gap.svg は「攻撃側スコープの大きな枠 + 防御側スコープの小さな枠」が並列に配置され、「ソースコード」が攻撃側のタイル(smart contract)と防御側のリスト(ソースコード)に **重複** していた。これは集合論的に矛盾している (防御 ⊂ 攻撃 のはずなのに別個に書いてある)。

**新設計**: 入れ子ベン図 (Euler diagram)。
- 外側の赤いだ円 (430×220) = 攻撃側スコープ
- 内側の青いだ円 (180×115) = 防御側スコープ — 攻撃側の中に **真部分集合** として内包
- 防御スコープ内 (3 項目): ソースコード / 既知の脆弱性パターン / オンチェーンロジック
- 攻撃のみ領域 (防御だ円外、攻撃だ円内 / 6 項目): ガバナンス / ソーシャル工学 / オペレーション / ウォレット UI / AI 無人化 / クロスチェーン Bridge
- 重複なし、関係が一目で伝わる

**学び**: 集合関係 (A ⊂ B) を視覚化するなら、**並列ボックスではなく内包だ円**。「ベン図的に描く」はこの種の関係を見える化する基本テクニック。

---

## Phase 8 — P8 (SL09 フェイルストップ) の単段化

**指摘**: 「p8 は二段だとどこに目をやったらいいのかわからなくて見づらいね。教授の視点で export した png なりをみて、レイアウト再設計してくれます?」

**問題**: 旧 SL09 は 2×2 風 (左上「何が問題か」/ 右上「なぜ ZK か」/ 左下 Proof-of-Exploit フロー / 右下 橋渡し callout) で視線の起点が決まらない。

**新設計**: 単一線形フロー (top-to-bottom)。
1. **タイトル** (S1-B. 暗号で守るだけでは足りない)
2. **ヒーロー amber 枠** — 福島第一の教訓 + ZK 証明で出力できる というメッセージを 1 つに集約
3. **Proof-of-Exploit mermaid フロー** (大きく、中央配置): AI Agent → Exploit → ZK Proof → verifier → 自動停止
4. **下段 4 カード横並び** — 正しさ / 機密性 / 自動化 / 紛争時の証拠 を「従来 (グレー打消し線) → ZK Proof-of-Exploit (amber 矢印)」で対比

視線が必ず上から下に流れ、各セクションが「次に何を見ればいいか」を内包している。

**学び**:
- **2 段配置 (or 2×2) は教育用スライドでは原則避ける**。視線の起点が分からない。
- 「主張 → 図 → 比較表」のように **1 軸の線形フロー** にする。
- 比較は **横並び 3-4 カード**で対立要素を視覚的に揃える (旧設計の縦長 4 行テーブルより読みやすい)。

---

## Phase 9 — 出典 footer の追加

**指示**: 「Notion に各文言のソースとなる URL や論文あったと思うけど、それはこのスライドに登場するページの左下に記述して、資料配布時にソースを辿れるようにしてほしい。」

**対応**: 該当スライドの最下部に `<div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">Sources: ...</div>` を追加。

**追加箇所** (11 スライド):
- SL08 (3 事例) — Chainalysis / LayerZero post-mortem / Anthropic threat report
- SL10 (3 社会需要) — Google Longfellow OSS / Buterin Privacy Pools / EU eIDAS 2.0 / a16z Jolt
- SL12 (証明 3 意味) — Goldreich / Goldwasser-Micali-Rackoff STOC '85
- SL15 (Programmable Crypto) — Whitehat 0xPARC / Canetti FOCS 2001
- SL18 (Sumcheck) — LFKN JACM 1992 / Thaler CRYPTO 2013
- SL19 (Jolt) — Arun-Setty-Thaler a16z / Lasso eprint 2023/1216
- SL20 (Folding/Commit) — Brakedown / Ligero / Nova / LatticeFold+ / BaseFold
- SL21 (Longfellow) — Google OSS / Trail of Bits / Frigo & shelat
- SL22 (ZK Bridge) — Polyhedra / Succinct
- SL27 (罠 1-3) — 0xPARC ZK Bug Tracker / KRS25 eprint 2025/611
- SL31 (WB 予告) — Chainalysis / LayerZero / KelpDAO response

**学び**: 学術系プログラム向けスライドは **出典の追跡可能性**が信頼の基盤。`bottom-3 left-6` (絶対位置) で Merkle Japan ロゴ (右下) と衝突せず、`text-[10px] text-gray-400` で本文を邪魔しない。

---

## 経緯から得たメタ学習

1. **「Notion をスライド化する」≠「Notion を貼り付ける」**。Notion は講師のための網羅資料、スライドは学生のための投影資料。スライド化時は「投影として価値あるか」で取捨選択する。
2. **作ったらまず実機 (or それに近い形) で見る**。Slidev の dev server / dist / screenshot で「下が切れていないか」「視線がどこに行くか」を必ず検証。
3. **教授ペルソナによる自己レビューは効く**。自分が無意識に流していた専門用語の系譜や仮定が浮き彫りになる。
4. **ブランディングは「色 + フォント」だけではない**。カードの角丸・枠線の太さ・余白・bullet マーカー・文字色階層まで一貫させて初めて統一感が出る。
5. **数値や事件名は出典必須**。仮想 / 未来シナリオは「仮想」と明示。

詳細なルールは `inputs/rules.md` を参照。
