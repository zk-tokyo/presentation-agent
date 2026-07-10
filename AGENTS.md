# AGENTS.md — プレゼンテーション制作ガイド

## 最初に読むもの

スライドや関連アセットを編集する前に、まず以下を読む。

1. `inputs/introduction.md` — Week 5 の講義ブリーフ、対象者、制約、元コンテンツ。
2. `inputs/rules.md` — 共通のスライド制作ルール。
3. `inputs/journey.md` — Week 5 の判断経緯やピットフォール。必要に応じて参照する。

`inputs/week5_slide_notes.md` はユーザーの作業メモとして扱う。TODO、構成案、ユーザーが検討中の論点を確認したい場合に参照するが、エージェントが常に従うべき制作ルールはこの `AGENTS.md` に集約する。

対象者は、学部生から社会人エンジニアまでが混在し、暗号・数学の前提知識にもばらつきがある。説明はもっとも弱い共通前提に合わせる。ただし、数学的に誤った説明にはしない。

## 協働ルール

- 文言相談や概念確認の段階では、ユーザーが明示的に編集を依頼しない限りファイルを編集しない。
- 「この表現は正確か」と聞かれた場合は、まず正確性を答え、必要なら代替案を提示する。自動でパッチを当てない。
- 既存ファイルにユーザーの変更がある場合は保持する。無関係な変更を戻さない。
- 編集範囲は、依頼されたスライド・コンポーネント・スタイルに絞る。
- 作業中に、今後の制作にも効く新たな事実・留意事項・判断基準・ユーザーの好みが分かった場合は、必要に応じて `AGENTS.md` または該当する `inputs/*.md` に追記する。単発の作業ログではなく、再利用できる運用知識だけを残す。

## リポジトリ構成

```text
slides.md              Slidev のエントリポイント。個別スライドを include する
slides/SL*.md          個別スライドの Markdown
style.css              グローバルなスライドスタイル
components/            スライドで使う Vue コンポーネント
public/images/         静的画像アセット
inputs/                ブリーフ、ルール、設計メモ、制作経緯
references/            参照 PDF や補助資料
dist/                  ビルド出力
```

## Slidev の規約

- `slides.md` では `canvasWidth: 1280` と `aspectRatio: 16/9` を維持する。
- 個別スライドは `layout: default` などの YAML frontmatter から始める。
- 個別スライドは `slides.md` から `--- src: ./slides/SLNN.md ---` で include する。
- 基本は Markdown とローカル HTML を組み合わせて書く。
- Markdown の `$...$` は KaTeX でレンダリングされる。
- HTML タグ内に raw な `$...$` 数式を置かない。HTML 内では次を使う。
  - インライン数式: `<MathInline expr="..." />`
  - 別行数式: `<MathBlock expr="..." />`
- raw HTML の table では特に注意する。`<td>$...$</td>` はそのまま文字として出る可能性がある。

## 説明方針

- 内容は `inputs/introduction.md` に準拠する。内容上の不備を見つけた場合は、勝手に補完せず、必要に応じてユーザーに確認するか該当メモに追記する。
- 直感スライドと数式スライドを分ける。明示的な橋渡しスライドでない限り、新しい直感説明と厳密な導出を同じスライドに混ぜない。
- 直感スライドでは、式を主役にせず、構造・対応関係・処理の流れを説明する。
- 数式スライドでは、後で見返せるように、定義・復号式・アルゴリズム中の式を厳密に残す。
- 直感と数式の対応を示したい場合は、必要に応じて接続用スライドを分ける。
- 投影スライドの文言は、短く平易な日本語を優先する。
- 技術的に正確でも、講義で導入しない可能性がある用語は避ける。
- 誤った簡略化はしない。例: LWE のノイズ `e` は関係を非線形にするものではない。小さな誤差を足すことで、隠れた値を直接復元しにくくするもの。
- 投影スライド上の表現をわかりやすく丸める場合、厳密な用語は Speaker Notes や口頭補足に回す。
- カードは、そのスライドの理解を補助するために使う。講義の別分岐や新概念の導入をカードに入れない。
- 指示のない具体例を追加しない。

## デザイン方針

まずこの `AGENTS.md` に従い、共通ルールが必要な場合は `inputs/rules.md` を参照する。

- 基本は白背景、黒文字、控えめなグレー・青系の面で構成する。
- カードは補足情報に限定する。ダッシュボード風にカードを乱用しない。
- amber callout を使いすぎない。
- 装飾的なグラデーションや強い差し色は使わない。
- 厳密な式を視覚要約の裏に隠さない。
- 無駄な強調を避ける。「」は多用しない。
- ビジネス書風の言い回し、AI っぽい文言は避ける。
- 視線の流れが曖昧になる 2x2 レイアウトは避ける。
- 読む順番は、上から下、または左から右の 1 軸にする。
- オーバーフローを避ける。1280x720 のスライドでも、タイトル、本文、フッター、ロゴのための余白が必要。
- ユーザーが後で手動調整したい図は、座標調整が重い SVG よりも HTML/CSS で構成することを優先する。外側 `div` の `top` / `right` / `bottom` / `width` で位置とサイズを触れる形にする。

## デザイン仕様

フォント:

| 用途 | フォント |
| --- | --- |
| 本文 | `Yu Mincho`, `YuMincho`, `Hiragino Mincho ProN`, `BIZ UDPMincho`, `serif` |
| 見出し | `BIZ UDPMincho` |
| 数式スライドの KaTeX | `Yu Mincho`, `YuMincho`, `Hiragino Mincho ProN`, `BIZ UDPMincho`, `serif` |
| コード | `JetBrains Mono`, `monospace` |

色:

| 用途 | 色 |
| --- | --- |
| 背景 | `#ffffff` |
| 基本文字色 | `#000000` |
| プレビュー本文色 | `#111827` |
| 見出し色 | `#101820` |
| 見出し下線・図のアクセント | `#17324d` |
| 表ヘッダ背景 | `#f5f5f5` |
| 補足・数式背景 | `#fafafa` |
| 補足カード背景 | `#f2f7fc` |
| 補足カード境界線 | `#c9d8ea` |
| 主境界線 | `#000000` |
| 補助境界線 | `#e0e0e0` |
| 引用文 | `#444444` |

コンポーネント:

| 要素 | 仕様 |
| --- | --- |
| 見出し | `BIZ UDPMincho`、下線付き。プレビューでは下線に `#17324d` を使う |
| 表 | Week 1 / Week 6 の表に合わせ、薄いヘッダ背景、黒いヘッダ罫線、薄い行罫線にする |
| カード | 補足情報に限って使う。薄い青背景、細い青系罫線、左罫線で控えめに示す |
| 引用 | 左罫線のみ。背景色を強く付けない |
| 数式パネル | 数式スライドでのみ使用。薄いグレー背景、左罫線、横スクロール可能にする |
| Mermaid 図 | 背景は透明。ノードは薄いグレー、境界はアクセント色、線は黒系にする |

表とカードは、Week 3 ではなく Week 1 / Week 6 の実装スタイルを優先する。

## Week 5 の技術メモ

- TFHE は Chillotti, Gama, Georgieva, Izabachene らによる ASIACRYPT 2016 / Journal of Cryptology 2019 系の方式。
- FHEW は homomorphic accumulator を中心にした高速 bootstrapping の流れを作り、NAND/refresh を 1 秒未満で行う実装結果を報告した。
- TFHE の gate bootstrapping は、TLWE-to-TLWE bootstrapping、blind rotation、sample extraction、key switching を中心に説明するとよい。
- TFHE 論文の HomNAND の標準的な書き方では、メッセージを `{0, 1/4}` にエンコードし、`(0, 5/8) - c1 - c2` のような線形前処理をしてから bootstrapping する。
- Week 5 の資料では torus を避ける方針。スライド本文では整数 mod `q` にスケールした toy example として説明する方が自然。
- Programmable bootstrapping は「テスト多項式/LUT の係数を変えることで、refresh 中に評価する関数を変えられる」と説明する。
- 任意の多変数関数の説明に Kolmogorov の重ね合わせ定理を持ち出すのは避ける。
- Programmable bootstrapping の実用面は、bit decomposition、circuit decomposition、LUT/gate composition で説明する。

参考資料:

- `references/week3_zksnark_slides.pdf` — Week 5 のような数式・アルゴリズム中心の回では、Week 3 の Beamer 形式が参考になる。
- `references/TFHE.pdf`
- `references/FHEW.pdf`
- `references/Bootstrapping_in_FHEW-like_Cryptosystems.pdf`
- `references/BGV.pdf`
- `references/BFV.pdf`
- `references/CKKS.pdf`
- `references/GSW.pdf`
- `references/The_Beginner's_Textbook_for_Fully_Homomorphic_Encryption.pdf`
- `references/SoK-Fully Homomorphic Encryption over the[Discretized] Torus.pdf`

## 出典

論文、記事、OSS リリース、事件レポート、外部の事実主張を参照するスライドには、ユーザーから別指示がない限り小さな出典フッターを入れる。

```html
<div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">
Sources: AUTHORS "TITLE" VENUE YEAR
</div>
```

複数出典を並べる場合は全角区切り ` ｜ ` を使う。右下の Merkle Japan ロゴと衝突しない位置に置く。

## 検証

内容や Markdown だけの編集でも、最低限以下を実行する。

```bash
bun run build
```

レイアウトに影響する変更では、可能ならブラウザ表示やスクリーンショットでも確認する。ユーザーがすでに dev server を起動していて表示確認も行うと言っている場合は、別サーバーを起動しない。

よく使う確認コマンド:

```bash
rg -n '<[^>]*>[^<]*\\$|\\$[^<]*</[^>]+>|\\$[^$]+\\$' slides
rg -n 'zktokyo|zk tokyo|zk-tokyo' slides public style.css
```

## よく使うコマンド

```bash
bun run build
bun run dev
rg -n "pattern" slides inputs style.css
```
