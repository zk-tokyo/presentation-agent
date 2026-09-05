# プレゼンテーション制作ルール集

このファイルは、Advanced Cryptography Program / Merkle Japan のスライド制作で確立したルールをまとめたものです。次回以降の Week の制作、および他のシリーズ (Sponsor pitch 等) を作る際の必読リファレンス。

経緯の詳細は `inputs/journey.md` を参照。

---

## 1. スライドの役割分離

### 投影スライドに **入れていいもの**
- 図解 (SVG / Mermaid)
- 比較表 (3-7 行程度、それ以上は分割)
- 用語の短い定義
- 具体例 (1-2 個)
- Open Question (ペア対話 30 秒で答えられるレベル)
- 学習成果の概要 (講義冒頭 1 回だけ)
- 出典 (左下に小さく)

### 投影スライドに **入れてはいけないもの**
- **詳細なタイムテーブル** (時刻ごとの内訳) → 講師ハンドアウトへ
- **運営的詳細** (ルーブリック詳細、自己評価リスト、Discord URL 全部) → Notion へ
- **時間表記** (「(35 分)」「120 分 → 180 分」など) → 講師ハンドアウトへ
- **認知レベル分類** (「Bloom's taxonomy に沿って…」など教学設計の裏側) → 講師ハンドアウトへ
- 講師の心構え・台本

**判断基準**: 「学生がスクリーンを見たときに、その情報があると講義の理解が深まるか?」 No → 削る。

---

## 2. レイアウト原則

### キャンバスサイズ
- `slides.md` の YAML frontmatter に **必ず `canvasWidth: 1280` と `aspectRatio: 16/9` を指定**。
- Slidev デフォルト (980×551) は日本語密度が高い講義スライドには窮屈すぎる。

### 視線の流れ
- **2 段配置 (2×2 grid) は避ける**。視線の起点が決まらず、学生が「どこを見ればいい?」と迷う。
- **1 軸の線形フロー** (top-to-bottom または left-to-right) を基本に。
- 比較は **横並び 3-4 カード**で。縦長テーブルより視覚的にスキャンしやすい。
- 「タイトル → ヒーロー主張 → 主要図 → 補足カード」が安定したパターン。

### オーバーフロー予防
- 画像は `max-h-[400px]` 程度に制限 (1280×720 キャンバスで、タイトル + 画像 + 補足の構成なら 460px くらいまで)。
- 1 スライドに収まる縦コンテンツ目安: タイトル (60px) + メイン要素 (480-520px) + フッター (50px)。
- カード密度を下げたい場合は **3 列に分散**、または **複数行の bullet を 1 行横並び**にまとめる。
- **テキスト + 画像 (2 段)** のパターンは、画像 460px / テキスト 1 行に絞るのが理想。

---

## 3. デザイン語彙 (Merkle Japan)

### カード
- 角丸: **`rounded-xl`** (常に。`rounded-lg` は使わない)
- 枠線: **`border border-{c}-200` または `border border-{c}-300`** (軽量)
  - 太い枠 (`border-2 border-{c}-700` 等) は使わない
- 白カード (中立): `bg-white rounded-xl border border-gray-200 shadow-sm`
- アクセントカード: `bg-{c}-50 rounded-xl border border-{c}-200` (例: amber-50 + amber-200)

### テキスト階層 (純黒は使わない)
- 見出し: `text-gray-900`
- 本文: `text-gray-700`
- 補足: `text-gray-500`
- 極小: `text-gray-400`
- アクセント (重要部分): `text-amber-600` / `text-amber-700`
- 強調 (`<strong>`): デフォルトで `font-weight: 700` だが、`<strong class="text-gray-900">` で色を明示するとなお良い

### 太さ
- 大見出し / 数字強調: `font-black` (900)
- 通常見出し: `font-bold` (700)
- 注意ラベル: `font-bold text-[10px] tracking-widest text-gray-400` (eyebrow text)

### 色のセマンティクス
| 色 | 用途 |
|---|---|
| amber (`amber-50/200/600/700`) | プログラム主題、ハイライト、ポジティブな強調 |
| green (`green-50/200/700`) | 成功、推奨事項、コミュニケーション |
| blue (`blue-50/200/600`) | 情報、補足、ZK 関連 |
| red (`red-50/200/300/700`) | 警告、リスク、攻撃 |
| purple (`purple-50/300`) | 別カテゴリ識別 (例: AI 時代の需要) |
| gray (`gray-50/200/300/500/700/900`) | 中立、補助、フッター |

### Bullet マーカー
- 通常の `•` は使わない (見栄えが弱い)
- amber アクセント箇所: `<span class="text-amber-500">&#9654;</span>` (▶)
- green ポジティブ箇所: `<span class="text-green-500">&#10003;</span>` (✓)
- 中立箇所: `&#9679;` (●) または `&#9656;` (▸)

### Cover / Section divider
- レイアウトは **`layout: center`** (`layout: cover` ではなく)
- 構造: 上から
  1. ロゴ並び (cover のみ): `flex items-center justify-center gap-6` + `&times;` の小さい区切り
  2. ラベル: `text-sm font-bold text-gray-400 tracking-widest`
  3. メインタイトル: `text-5xl font-black text-gray-900`
  4. アクセントタイトル: `text-3xl font-black text-amber-600`
  5. サブ説明: `text-base text-gray-500 max-w-2xl mx-auto`
  6. (任意) 3-4 個のサブカード (各 `bg-white rounded-xl border border-gray-200 shadow-sm`)

---

## 4. ブランディング

### Footer (`global-bottom.vue`)
- ロゴ: `/images/merklejapan_logo.png`
- サイズ: width **96px** (横長ロゴなので 72px だと文字が読めない)
- 位置: `bottom: 16px; right: 24px`
- ページ番号: cover を除く全スライド (`v-if="!isFirstSlide"`)、`font-family: BIZ UDPMincho`

### Cover ロゴ並び
- メインロゴ + `&times;` + パートナーロゴ (例: 東大ブロックチェーン寄付講座)
- 各ロゴ `h-24` で揃える
- 後方に `bg-gradient-radial from-amber-100 via-transparent to-transparent opacity-70 blur-3xl` のソフトな後光

### ブランド名
- 正式: **Merkle Japan** (旧: ZK Tokyo)
- 旧称への言及が必要な場合: 「Merkle Japan (旧 ZK Tokyo)」
- リブランディング後は資料・スライドの本文中に "ZK Tokyo" を残さない (`grep -ri 'zktokyo\|zk tokyo\|zk-tokyo' slides/` で確認)

---

## 5. 出典 (Sources) ルール

### 配置
- **すべての** 論文・記事・blog ・OSS リリース・事件レポートを参照しているスライドに必須
- 位置: 左下に絶対配置
- 実装:
  ```html
  <div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">
  Sources: AUTHORS "TITLE" VENUE YEAR ｜ AUTHORS "TITLE" eprint/URL
  </div>
  ```

### フォーマット
- 区切り文字: 全角縦棒 ` ｜ ` (見やすい)
- 学術論文: `Last, First et al. "Title" Venue Year`
- eprint: `Last, First "Title" eprint YEAR/NUMBER`
- OSS / blog: `Org "Title" (Month Year)`
- 複数引用は 1 行で連結 (改行しない、必要なら `max-w-3xl` 内で wrap)

### 例
```
Sources: Lund, Fortnow, Karloff, Nisan "Algebraic methods for interactive proof systems" JACM 39(4), 1992 ｜ Thaler "Time-Optimal Interactive Proofs for Circuit Evaluation" CRYPTO 2013
```

---

## 6. 図表 (SVG / Mermaid)

### SVG
- viewBox: `0 0 940 480` 系 (16:9 に近い比率、講義スライドのアスペクト)
- フォント: `Noto Sans JP, sans-serif`
- 角丸: `rx="8"` から `rx="14"` (大枠は大きめ、小枠は小さめ)
- 影: `<filter id="dropsoft"><feDropShadow dx="0" dy="2" stdDeviation="3" flood-opacity="0.15-0.18"/></filter>`
- 色: スライドのカラーパレットに揃える (amber #fde2e2, blue #d7e8ff, gray #f9fafb 等)

### 集合関係の可視化
- **A ⊂ B (内包関係) は入れ子だ円** (nested ellipses) で描く
- 並列ボックスは関係を曖昧にするので避ける
- 同じ要素を 2 箇所に書かない (重複が概念矛盾を生む)

### Mermaid
- `{scale: 0.65-0.85}` でサイズ調整
- スタイル: `style NODE fill:#COLOR,stroke:#COLOR,stroke-width:2px`
- 色は本文カードと統一 (amber: `#fef3c7/#b8860b`, red: `#fee2e2/#cc3333`, green: `#dcfce7/#2c7a3f`)

---

## 7. 文字エスケープ

### `$` (ドル記号 / 通貨)
- **必ずそのまま `$` で書く**。`\$` と escape しない。
- Slidev / Markdown は `$292M` のような通貨表記をリテラルに扱う (KaTeX のインライン数式は `$...$` ではなく `\( ... \)` で書く構成)。
- 過去に `\$292M` のように escape して `\$` がそのまま印字される事故が発生 → 撲滅済。

### 確認コマンド
```bash
grep -r '\\\$' slides/ public/images/  # 残存ゼロを確認
```

---

## 8. 学術的正確性

### Programmable Cryptography 関連の用語
- **Longfellow は Sumcheck 系ではない** — Ligero / MPC-in-the-head 系の系譜。並べて記述するときは「2 つの独立した系統」と明示。
- **Sumcheck prover を無条件で「線形時間」とは言わない** — 「structured multilinear extension 上で concretely efficient (Thaler 2013 系)」と限定をつける。
- **FHE の信頼前提**は「データ機密性のみ。計算正しさは別途必要 (Verifiable FHE)」と分解する。
- **ZK の敵対モデル**は `malicious prover (soundness)` と `malicious verifier (ZK)` の二重性がある。両方挙げる。
- **Programmable Cryptography** は 0xPARC のスローガンであり、formal な合成性枠組み (UC framework) とは強さが質的に異なる。

### 数値・固有名の扱い
- **未来事象の数値は「仮想/最新シナリオ」と明示**するか、出典 URL を脚注化。
- 出典のない具体数 (例: 「Aave TVL \$8.45B 蒸発」) は講師の信用毀損リスク → 「配布 XXX レポート参照」と回避するか、信頼できる出典を脚注化。

---

## 9. ワークフロー (検証)

### ビルド検証
```bash
bun run build  # dist/ 生成、エラー確認
```

### 投影レイアウト確認 (Playwright 不可環境向け)
1. 既存ビルドを SPA fallback サーバで配信
   ```python
   # /tmp/spa_server.py — port 4002 で dist/ を SPA fallback 付き配信
   ```
2. Firefox CLI でスクショ
   ```bash
   firefox --headless --window-size=1920,1080 --screenshot=/tmp/slide_NN.png "http://localhost:4002/N?print"
   ```
3. 3 回試行 (描画タイミング揺らぎ吸収) → 最大サイズを採用
4. `Read` ツールで PNG 確認 → overflow / 視線 / コントラスト検証

### 一括置換チェック後
```bash
grep -r "rounded-lg\|border-2 border-" slides/  # 旧スタイル残存ゼロ
grep -r '\\\$' slides/ public/images/  # escape ゼロ
grep -rI 'zktokyo\|zk tokyo\|zk-tokyo' .   # 旧ブランド名ゼロ
```

---

## 10. ピットフォール集 (繰り返さないために)

| ピットフォール | 対処 |
|---|---|
| Notion 全情報をスライド化 → 30 枚超で運営情報が混入 | 「投影に価値あるか」で取捨選択、25-28 枚目安 |
| 認知レベルや所要時間をスライドに書く | 講師ハンドアウトに分離 |
| `\$292M` と escape → 「\$」がそのまま印字 | `$292M` のまま書く |
| 集合関係を 2 つの並列ボックスで描く | 入れ子だ円 (nested Euler) |
| 視線が迷う 2×2 grid | 1 軸の線形フロー、横並び 3-4 カード |
| `canvasWidth: 980` (デフォルト) で日本語密度を詰める | `canvasWidth: 1280` |
| Longfellow を「Sumcheck の応用」と説明 | MPC-in-the-head 系として並列に位置づけ |
| Sumcheck prover を「線形時間」と断言 | 「structured ME 上で concretely efficient」と限定 |
| FHE の信頼を「server を信頼しない」と一括 | データ機密と計算正しさを分けて記述 |
| 数値・事件名を出典なしで提示 | 「仮想シナリオ」明示 or 出典脚注 |
| 章扉に時間を書く ("S1 Why (35 分)") | タイトルから時間を消す |
| 「休憩」のような運営スライドを 1 枚使う | 講師の口頭で代用、または前後スライドの最後の行に統合 |
| ブランド色を本文中バラバラに使う | amber を主軸に、role による色割り当てに従う |
| 強い枠線 (`border-2 border-{c}-700`) を多用 | `border border-{c}-200/300` の軽量枠 |
