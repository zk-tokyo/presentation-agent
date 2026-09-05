# CLAUDE.md — プレゼンテーション制作タスク定義

## 1. 必読インプット (作業開始前に必ず読む)

1. `inputs/introduction.md` — 講義ブリーフ (YAML frontmatter + Notion 構成案完全転記)
2. `inputs/rules.md` — デザイン語彙・レイアウト・ブランディング・学術的正確性ルール
3. `inputs/journey.md` — 過去の判断・ピットフォール・試行錯誤の記録

これらを読まずに制作に着手しない。

## 2. リポジトリ構造

```
slides.md              # Slidev エントリポイント (src: で各スライドを include)
slides/SL*.md          # 個別スライドファイル
public/images/         # SVG/PNG アセット
style.css              # グローバル CSS (Noto Sans JP / BIZ UDPMincho)
layouts/cover.vue      # カバーレイアウト
global-bottom.vue      # 全スライド footer (Merkle Japan ロゴ + ページ番号)
components/            # Vue コンポーネント
inputs/                # ブリーフ・ルール・経緯
dist/                  # bun run build の出力
```

## 3. Slidev フォーマット規約

### slides.md (エントリ)
- YAML frontmatter に必ず `canvasWidth: 1280` と `aspectRatio: 16/9` を含める
- 各スライドは `--- src: ./slides/SLNN.md ---` で include

### 個別スライド (slides/SL*.md)
- 先頭に YAML frontmatter `layout: default | center | statement` (default が基本)
- 本文は Markdown + HTML (Tailwind/UnoCSS クラス使用可)
- Mermaid 図: ` ```mermaid {scale: 0.65-0.85} ` で囲む
- Speaker notes: `<!-- Speaker Notes: ... -->`

## 4. デザイン適用 (必須)

`inputs/rules.md` 第 3 章 (デザイン語彙) に従う。要点:

- 角丸: **`rounded-xl`**
- 枠線: **`border border-{c}-200/300`** (太線は使わない)
- 白カード: `bg-white rounded-xl border border-gray-200 shadow-sm`
- アクセントカード: `bg-{c}-50 rounded-xl border border-{c}-200`
- テキスト階層: `text-gray-900 / 700 / 500 / 400` (純黒禁止)
- アクセント色: `text-amber-600 / 700`
- Bullet: `&#9654;` (amber ▶) / `&#10003;` (green ✓) — 素の `•` は使わない
- 大数字: `font-black` (900)

## 5. 投影スライドに入れる / 入れない

`inputs/rules.md` 第 1 章に従う。

**入れない**:
- 詳細タイムテーブル / 時刻ごとの内訳
- 時間表記 (`(35分)`, `120分→180分` 等)
- 認知レベル分類 (Bloom's taxonomy 等)
- ルーブリック詳細・自己評価リスト
- 講師の心構え・台本

**入れる**:
- 図解 / 比較表 (3-7 行) / 用語定義 / 具体例 / Open Question / 出典

## 6. 出典 (Sources) 表示

論文・記事・OSS・事件レポートを参照しているスライドには必須:

```html
<div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">
Sources: AUTHORS "TITLE" VENUE YEAR ｜ ...
</div>
```

区切り: 全角 ` ｜ `。Merkle Japan ロゴ (右下) と衝突しない位置。

## 7. ブランディング

- Footer ロゴ: `/images/merklejapan_logo.png` (96px width)
- Cover: `layout: center` + `merklejapan_logo.png` × パートナーロゴの並び
- 旧称 "ZK Tokyo" / "zktokyo" / "zk-tokyo" は **全削除**。grep で残存ゼロを確認

## 8. 文字エスケープ禁止事項

- `$` (通貨記号) は **escape しない**。`\$292M` ではなく `$292M` と書く
- 確認: `grep -r '\\\$' slides/ public/images/` で残存ゼロ

## 9. 学術的正確性 (Programmable Cryptography 関連)

`inputs/rules.md` 第 8 章に従う。要点:

- **Longfellow** は MPC-in-the-head 系 (Ligero 系)、Sumcheck 系ではない
- **Sumcheck prover** は無条件で「線形時間」と書かない。「structured ME 上で concretely efficient (Thaler 2013 系)」と限定
- **FHE 信頼前提**は「データ機密のみ。計算正しさは別途 (Verifiable FHE)」と分解
- **ZK 敵対モデル**は `malicious prover (soundness)` + `malicious verifier (ZK)` の二重性を併記
- **Programmable Cryptography** は 0xPARC スローガン。UC framework とは強さが質的に異なる
- 未来事象の数値は「仮想/最新シナリオ」明示か出典脚注

## 10. レイアウト原則

- **2 段 (2×2 grid) は使わない**。視線の起点が決まらないため
- 1 軸の線形フロー (top-to-bottom or left-to-right) を基本に
- 比較は横並び 3-4 カード
- 画像は `max-h-[300-460px]` (キャンバス 1280×720 で安全な範囲)
- 集合関係 (A ⊂ B) は **入れ子だ円** で描く。並列ボックスは禁止
- 同じ要素を 2 箇所に重複して書かない

## 11. 視覚的フィードバック (Playwright) ワークフロー

スライド編集後は必ず実機レンダリングを確認する。Playwright Chromium が動かない環境 (libglib 不足等) では Firefox CLI で代替する。

### A. ビルド
```bash
bun run build
```

### B. SPA fallback サーバ起動 (`/tmp/spa_server.py`)
```python
import http.server, socketserver, os
from pathlib import Path
ROOT = '/home/gohan/workspace/presentation-agent/dist'
os.chdir(ROOT)
class H(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        p = self.path.split('?')[0]
        if not Path(ROOT+p).exists() or Path(ROOT+p).is_dir():
            self.path = '/index.html'
        return super().do_GET()
    def log_message(self,*a): pass
with socketserver.TCPServer(("",4002), H) as s: s.serve_forever()
```
起動:
```bash
nohup python3 /tmp/spa_server.py > /tmp/spa.log 2>&1 &
disown
```

### C. 各スライドをスクショ (3 回試行 + 最大サイズ採用)
```bash
for i in $(seq 1 28); do
  printf -v num "%02d" $i
  bestsize=0
  for attempt in 1 2 3; do
    firefox --headless --window-size=1920,1080 --screenshot=/tmp/_tmp.png "http://localhost:4002/${i}?print" 2>/dev/null
    size=$(stat -c %s /tmp/_tmp.png 2>/dev/null || echo 0)
    [ "$size" -gt "$bestsize" ] && mv /tmp/_tmp.png /tmp/slide_shots/slide_${num}.png && bestsize=$size
  done
done
```

### D. PNG を `Read` ツールで確認
- オーバーフロー (下端切れ) を検出
- 視線フロー (1 軸か / 2×2 になっていないか) を検証
- 余白・コントラスト・出典の有無を確認

### E. blank スライドの再撮影
ファイルサイズが極端に小さい (< 50KB 程度) スライドは Firefox の描画タイミングが間に合っていない。並列 5 回試行で最大を採用:
```bash
for a in $(seq 1 5); do
  firefox --headless --window-size=1920,1080 --screenshot=/tmp/_tmp_${a}.png "http://localhost:4002/${i}?print" 2>/dev/null &
done
wait
cp "$(ls -S /tmp/_tmp_*.png | head -1)" /tmp/slide_shots/slide_${num}.png
rm /tmp/_tmp_*.png
```

## 12. 完了前のチェックリスト

```bash
# 1. 古いスタイル残存ゼロ
grep -r "rounded-lg\|border-2 border-" slides/

# 2. $ エスケープ残存ゼロ
grep -r '\\\$' slides/ public/images/

# 3. 旧ブランド名残存ゼロ
grep -rI 'zktokyo\|zk tokyo\|zk-tokyo' slides/ public/images/ *.vue style.css

# 4. ビルド成功
bun run build

# 5. 全スライド (28 枚目安) スクショ取得・目視確認
ls /tmp/slide_shots/slide_*.png | wc -l
```

すべて通過するまで完了報告しない。

## 13. ピットフォール (繰り返し禁止)

`inputs/rules.md` 第 10 章の表を確認。代表例:
- Notion 全情報の貼り付け (30 枚超 → 運営情報混入)
- canvasWidth デフォルト (980) で日本語密度過多
- 2×2 grid で視線迷子
- 集合関係を並列ボックス (重複発生)
- 数値・事件名を出典なしで提示
- 「休憩」等の運営スライドを単独 1 枚
- 太枠 `border-2 border-{c}-700` の多用

## 14. 出力言語

`inputs/introduction.md` の YAML `output_language` に従う (現状: Japanese)。

## 15. アニメーション概念図スライド

**任意のトピック**を 1 つの SVG 概念図上で 4-6 phase auto-morph させるスライドのスタイル。攻撃 timeline / プロトコル round-trip / システムアーキテクチャ / before-after 進化 / 状態遷移 / 配信 pipeline 等、「stable な actor 群の上で state が時間進行する」題材すべてに適用する。一発で出すための **必読** トリガーは `/animated-concept-slide` または「アニメで見せて」「動く図にして」「ascon-proposal みたいに」「もっと手触り感」「再現可視化」等。

設計思想と iteration 方法論は `.claude/skills/animated-concept-slide/SKILL.md` を参照。本セクションはこのリポジトリでの**具体的な実装テンプレート** (viewBox 寸法・font サイズ・色 palette・spacing・検証コマンド) を定義する。トピックが変わっても **本セクションの数値はそのまま流用**する — 変えるのは actor の形・色 state の意味・phase caption だけ。

ベスト実装例: `components/KelpAttackDemo.vue` + `slides/SL08b.md`。新規スライドを作るときは両方を読んでから始めること。他のトピックへの応用 (TLS handshake, ZK proof verify, deployment pipeline, etc) は SKILL.md の「Adapting to a new topic」節に従う。

### 15.1 ファイル構成

- 1 つの drill-down につき 2 ファイルだけ:
  - `components/<Event>AttackDemo.vue` — phase 機構 + SVG + scoped CSS (~500 行)
  - `slides/SL<NN>b.md` — タイトル + `<Component />` + Sources footer + Speaker Notes (~30 行)
- `slides.md` の include 順に追加 (drill-down は通常、概要スライドの直後)
- コンポーネント class prefix は短く一貫させる (例: `kf-` for Kelp flow)。SVG 内の text/rect が多数あるので prefix がないと scoped CSS が衝突する

### 15.2 SVG ベースキャンバス

- `viewBox="0 0 1200 430"` 固定 (slide canvas 1280 → SVG 1 unit ≈ 1 px 実機)
- `preserveAspectRatio="xMidYMid meet"` で aspect 保持
- `width: 100%; height: auto;` で slide width にスケール
- すべての視覚要素を **1 つの SVG 内に** 入れる (HTML divs を SVG 上に重ねない)。座標系が単一になり、配置の整合性が CSS なしで保証される

### 15.3 phase 機構の必須要件

```ts
const totalPhases = 6
const phaseDurations = [3500, 4500, 3500, 4500, 5000, 4500]  // 各 phase ごとに ms

function getInitialPhase() {
  if (typeof window === 'undefined') return { phase: 0, play: true }
  const p = new URLSearchParams(window.location.search)
  const raw = p.get('phase') ?? p.get('stage')
  if (raw == null) return { phase: 0, play: true }
  const s = parseInt(raw, 10)
  return (!Number.isNaN(s) && s >= 0 && s < totalPhases)
    ? { phase: s, play: false }
    : { phase: 0, play: true }
}
const initial = getInitialPhase()
const phase = ref(initial.phase)
const isPlaying = ref(initial.play)
```

- **必ず同期初期化**。`onMounted` 内で URL 読むと初回 render が phase=0 で動き、Vue keyed transition が中途半端な状態でスクショされる
- `?phase=N` で auto-play 停止 + phase 固定 → スクショ撮影と講師の deep link 用

### 15.4 フォントサイズ (プレゼン投影前提)

| 用途 | px | 備考 |
|---|---|---|
| node title (User, Endpoint, Bridge 等) | **19** | `font-family: BIZ UDPMincho` |
| DVN-like sub-node name | **18** | `JetBrains Mono` |
| RPC-like leaf node id | **17** | `JetBrains Mono` |
| big number (`requiredDVNCount: 1` 等) | **22** | `font-weight: 900`、白 box on red fatal |
| config code | **18** | `JetBrains Mono` |
| chain band label (KARAK L2 等) | **14** | letter-spacing 0.12em |
| RPC state ("BURN ✓" 等) | **14** | |
| drain amount | **21** | 900 weight、`-116,500 rsETH` 等 |
| config note | **15** | 700 weight、`⚠ 1-of-1 — ...` |
| sources footer | 10 | 既存ルール 6 通り (例外) |

**14px 未満は使わない**。投影で読めない。詳細テキストは speaker notes に移すこと。

### 15.5 色セマンティクス (state colors)

| state | stroke | fill | filter |
|---|---|---|---|
| healthy | `#10b981` (green) | white | — |
| compromised | `#f59e0b` (amber) | `#fffbeb` | — |
| lying / active attack | `#dc2626` (red) | `#fee2e2` | `drop-shadow(0 0 6px rgba(220,38,38,.5))` |
| offline | `#4b5563` | `#1f2937` (dark) | — + 赤 ⊗ overlay |
| drained | `#dc2626` | `#fef2f2` | `drop-shadow(0 0 10px rgba(220,38,38,.5))` |
| fatal config value | white text | `#dc2626` bg | `kf-pulse` animation |
| neutral icon | `#475569` fill | | |

state は CSS class で morph (`.is-compromised`, `.is-lying`, `.is-offline`, `.is-fatal`, etc)。`v-if` で markup を切り替えない (要素は phase 跨ぎで生存させる、色だけ変える)。例外: phase 5 で初めて出現する drain box などは `v-if` 可。

### 15.6 actor 表現 (icon-above-label)

main ノードは **icon を上、テキストを下、両方を box center で中央揃え**:

```vue
<g class="kf-node">
  <rect x="60" y="65" width="160" height="90" rx="8" class="kf-node-bg"/>
  <g class="kf-node-icon" transform="translate(140, 90)">
    <!-- icon shape (radius ~7-15) -->
  </g>
  <text x="140" y="138" text-anchor="middle" class="kf-node-title">User</text>
</g>
```

cluster 内の sub-ノード (高さ ~52px) は icon-left + text-right の横配置にする。ただし icon と text の対の視覚中心を box center に揃える (icon を `left+25` 程度に置き、text を `text-anchor=middle` で box の右半分の中心に)。

標準 icon ライブラリ (構成は `components/KelpAttackDemo.vue` 参照):
- User: `<circle>` 頭 + `<path>` 体の stick figure
- Endpoint: `<rect>` 封筒 + `<path>` フラップ
- Verifier/Shield (DVN, ULN302): 五角形 `<path>` + 内側 check `<path>`
- Vault (Bridge): `<rect>` + 中央 `<circle>` + 十字
- Server stack (RPC): 3 段の `<rect>` + LED `<circle>`

### 15.7 グルーピング (chain bands)

システム境界 (chain A ↔ chain B, on-chain ↔ off-chain) は dashed `<rect>` でグループ化:

```svg
<rect x="50" y="30" width="395" height="125" rx="8"
      fill="rgba(99,102,241,0.05)" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="6 4"/>
<text x="65" y="50" font-size="14" font-weight="700" fill="#4f46e5"
      letter-spacing="0.12em">KARAK L2</text>
```

中間に位置する off-chain entity (DVN cluster 等) はどの band の中にも入れない (band 外配置で「どこにも属さない」を視覚化)。

### 15.8 traveling particles

bridge highway 上を流れる粒子は `<circle>` + CSS `@keyframes` で transform: translateX 制御:

```css
.kf-msg-particle { fill: #10b981; animation: kf-flow-healthy 3s linear infinite; }
@keyframes kf-flow-healthy {
  0% { transform: translateX(0); opacity: 0; }
  5%,95% { opacity: 1; }
  100% { transform: translateX(940px); opacity: 0; }
}
```

- 健全 phase で緑粒子 (healthy message flow)
- 攻撃 phase で赤粒子 (false attestation)
- DDoS phase は radius を 0→55 に expanding する burst circle で表現

複数粒子に `animation-delay: -1s, -2s` で staggering して連続感を出す。

### 15.9 spacing / 余白

- main node 間 gap: **55px** (短すぎると窮屈、長すぎるとスカスカ)
- node の縦中心 (bridge highway): **y=110**
- chain band 縦範囲: y=30-155 (上段) / y=285-425 (下段 RPC pool)
- 全体を viewBox center (x=600) に対して対称配置 (User cx=140, Bridge cx=1080)

### 15.10 phase 進行の伝え方 (phase bar は使わない)

**bottom phase bar / dot navigation / ⏸▶⟲ controls は入れない**。図そのものが phase 進行を伝える設計にする。caption や step 番号を別 UI に切り出すと viewer の視線が図から逃げ、また UI 自体が「panel-thinking」を呼び込む。

代わりに以下で phase 進行を表現する:

1. **config / code strip (上部)** — phase ごとに 1 行 caption を表示。例:
   - `setConfig(requiredDVNCount: 1)  // 1-of-1 — 1 票で release`
   - `π ← Prove{ ∃W : exploit(W, C) = drain }  // off-chain`
   この strip は `<transition name="...-fade" mode="out-in">` で phase 切り替え時に fade。

2. **active 要素自体の color state 変化** — DVN が緑→赤、RPC が healthy→hijacked→offline、Verifier が idle→accepted ✓ など、actor の見た目が phase を物語る。

3. **transient 要素の v-if 出現** — drain box、HALTED banner、π log entry など、phase 5 で初めて出る climax 要素。

`?phase=N` URL pin による screenshot 撮影と講師の deep-link は引き続き機能する (これは UI ではなく URL の問題)。

### 15.11 slide markdown wrapper (`SL<NN>b.md`)

最小構成:

```markdown
---
layout: default
---

# <event名> — <一行 hook>

<YourAttackDemo />

<div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">
Sources: ...
</div>

<!--
Speaker Notes:
【事件概要】... ｜ 流出額 ｜ 帰属 ｜ 日付
【重要な前提】仮想シナリオなら明示
【概念図の読み方】左から右に flow、polling wire は ...
【各 phase の物語】phase 0 — ... ／ phase 1 — ... ／ ...
【講義での強調点】コード無傷、攻撃面は config、もし X なら防げた、...
-->
```

- title は **1 行**。"深掘り:" 等の冗長な接頭辞は削除
- subtitle (灰色の小文字注釈) は **入れない**。文脈は speaker notes へ
- Sources footer は §6 に従う
- Speaker Notes は脚本そのもの。配布資料として印刷も想定するので冗長でも OK

### 15.12 検証ワークフロー

phase ごとにスクショ撮影 (`?phase=N` URL で固定可能):

```bash
for p in 0 1 2 3 4 5; do
  for a in 1 2 3 4; do
    firefox --headless --window-size=1920,1080 \
      --screenshot=/tmp/_p${p}_a${a}.png \
      "http://localhost:4002/${SLIDE_N}?print&phase=${p}" 2>/dev/null &
  done
  wait
  # take largest file (smallest = blank from race)
  best=0
  for a in 1 2 3 4; do
    size=$(stat -c %s /tmp/_p${p}_a${a}.png 2>/dev/null || echo 0)
    if [ "$size" -gt "$best" ]; then
      cp /tmp/_p${p}_a${a}.png /tmp/slide_shots/slide_<NN>b_phase${p}.png
      best=$size
    fi
  done
  rm -f /tmp/_p${p}_*.png
done
```

各 phase の PNG を `Read` ツールで目視確認:
- icon 位置 / text 中心揃え
- overflow なし (Merkle ロゴ・sources footer と衝突しない)
- 色 state が phase で正しく遷移
- font が読めるサイズか

### 15.13 ピットフォール (この pattern 特有)

| 失敗 | 対処 |
|---|---|
| step-by-step caption + 大きな step 番号を入れる | これは panel-thinking。caption は 1 行、step 番号は dot だけ |
| icon と text が左右に分かれて未整列 | icon 上 text 下で `text-anchor=middle`、両方 box center |
| `onMounted` 内で URL から phase 初期化 | 初回 render が 0 で動き transition が破綻。sync init 必須 |
| 文字 11px 以下 | 投影で読めない。14px 以上を strict floor |
| subtitle に冗長な context | 削除して Speaker Notes に移行 |
| HTML divs を SVG 上に重ねる | 座標系が分裂して整列地獄。すべて SVG 内に統一 |
| `v-if` で要素を出し入れして state 表現 | morph 感が消える。要素は生存、CSS class で色変化 |
| Lazarus 等の attacker icon を盛り盛り入れる | clutter。攻撃の起点が必要なら 1 つ控えめに、または speaker notes だけで充分 |
| viewBox 高さを 460+ にして title/footer と衝突 | viewBox 400-430 が安全 |
| bottom phase bar (caption + dots + ⏸▶) を付ける | UI が「panel-thinking」を呼び込み、視線が図から逃げる。phase 進行は上部 code-strip と actor color 変化だけで伝える (§15.10) |
