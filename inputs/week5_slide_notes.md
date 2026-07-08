
# Week 5 スライド設計メモ

## デザイン方針

- 内容はintroduction.mdのものに準拠する。introduction.mdに内容的な不備が見つかった場合はその旨を追記する
- 優先するもの:
	- 数式を中心とするスライドとわかりやすさを優先するスライドの棲み分け
	- シンプルなデザイン
- 避けるもの:
	- ダッシュボード風のカード乱用
		- カードは補足情報などを記述するために使用
	- amber callout の使いすぎ
	- 装飾的なグラデーション
	- 厳密な式を視覚要約の裏に隠すこと
	- 無駄な強調
		- 「」は多用しない
	- ビジネス書のようなフレーズ
	- AIくさい言葉使い
	- 指示のない具体例

## デザイン仕様

### スライド種別

| 種別     | 見出し表記      | 役割                               |
| ------ | ---------- | -------------------------------- |
| 直感スライド | `[直感] ...` | 式を主役にせず、構造・対応関係・処理の流れを説明する       |
| 数式スライド | `[数式] ...` | 後で見返せるように、定義・復号式・アルゴリズム中の式を厳密に残す |

- 1枚のスライド内で、直感的な説明と数式に基づく説明を混ぜない。
- 直感と数式の対応を示したい場合は、必要に応じて別の接続用スライドを作る。
- 本番で使う時は[直感]や[数式]は削除

### フォント

| 用途 | フォント |
| --- | --- |
| 本文 | `Yu Mincho`, `YuMincho`, `Hiragino Mincho ProN`, `BIZ UDPMincho`, `serif` |
| 見出し | `BIZ UDPMincho` |
| 数式スライドのKaTeX | `Yu Mincho`, `YuMincho`, `Hiragino Mincho ProN`, `BIZ UDPMincho`, `serif` |
| コード | `JetBrains Mono`, `monospace` |

- 見出しは Week 1 / Week 6 と同じ `BIZ UDPMincho` を使う。
- 本文は游明朝系を使い、数式スライドのKaTeXと見え方を揃える。
- 数式はブラウザ上での可読性を優先し、数式スライドに限って明朝系フォントへ寄せる。

### 色

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

- 基本は白背景、黒文字、薄いグレーの面で構成する。
- アクセント色は見出し下線や図の境界など、構造を示す箇所に限定する。
- 装飾的なグラデーションや強い差し色は使わない。

### コンポーネント

| 要素 | 仕様 |
| --- | --- |
| 見出し | `BIZ UDPMincho`、下線付き。プレビューでは下線に `#17324d` を使う |
| 表 | Week 1 / Week 6 の表に合わせ、薄いヘッダ背景、黒いヘッダ罫線、薄い行罫線にする |
| カード | 補足情報に限って使う。薄い青背景、細い青系罫線、左罫線で控えめに示す |
| 引用 | 左罫線のみ。背景色を強く付けない |
| 数式パネル | 数式スライドでのみ使用。薄いグレー背景、左罫線、横スクロール可能にする |
| Mermaid図 | 背景は透明。ノードは薄いグレー、境界はアクセント色、線は黒系にする |

- カードを複数並べるダッシュボード風レイアウトは避ける。
- 表とカードは、Week 3 ではなく Week 1 / Week 6 の実装スタイルを優先する。
- raw HTML 内に `$...$` を置かない。数式は原則Markdown本文または表セルに直接書く。

## TODO

- 全体的にわかりやすさ、みやすさを調整
- 別途作成が必要と思われる図を列挙し、スライドにスペースを確保
	- CMUXの図
		- そもそものマルチプレクサの図も入れる
	- Sample Extractionの図
	- Key Switchingの図
	- HomNANDの図
	- 図はパワポで作成
- SL01とSL02の間に今回の講義を概観するスライドを入れる
- 目次作る
- TFHEの基本情報のページを充実させる
- Programmable Bootstrappingの基本アイデアに直感的な説明を入れる
	- 暗号文を使ってスロットを回転させるイメージ図
- v(x)の構成のスライドを再構成
- RGSWのスライドの再構成
- HomNANDのスライドに使用する多項式の例を追加
- 各スライドで話したいこと、優先度を記載
	- 優先度
		- 話す  a
		- 話せれば話す b 
		- 話さない f
	- 各パート、各セクションで何を理解して欲しいのか、そのために何を説明するのかを明確にする
- FHEの主要方式のスライドでCKKSについてfunctional bootstrappingについて言及する
- LWE暗号文同士の乗算とノイズのスライドで、FHEWとTFHEの説明を分離する
- Key Switchingの後にBootstrappingの流れのまとめを入れる


## 参考資料

- `references/week3_zksnark_slides.pdf`
  - Beamer 形式の技術講義スライド。
  - Week 1 / Week 6 は概説回に近い。Week 5 のような数式・アルゴリズム中心の回では、Week 3 の方が理想形に近い。
- `references/` 配下の FHE 資料
	- `TFHE.pdf`
	- `FHEW.pdf`
	- `Bootstrapping_in_FHEW-like_Cryptosystems.pdf`
	- `BGV.pdf`, `BFV.pdf`, `CKKS.pdf`, `GSW.pdf`
	- `The_Beginner's_Textbook_for_Fully_Homomorphic_Encryption.pdf`
	- `SoK-Fully Homomorphic Encryption over the[Discretized] Torus.pdf`

## ファクトチェック上の注意

- TFHE は Chillotti, Gama, Georgieva, Izabachene らによる ASIACRYPT 2016 / Journal of Cryptology 2019 系の方式。
- FHEW は homomorphic accumulator を中心にした高速 bootstrapping の流れを作り、NAND/refresh を 1 秒未満で行う実装結果を報告した。
- TFHE の gate bootstrapping は、TLWE-to-TLWE bootstrapping、blind rotation、sample extraction、key switching を中心に説明するとよい。
- TFHE 論文の HomNAND の標準的な書き方では、メッセージを `{0, 1/4}` にエンコードし、`(0, 5/8) - c1 - c2` のような線形前処理をしてから bootstrapping する。
	- ただし Week 5 の資料では torus を避ける方針なので、スライド本文では整数 mod `q` にスケールした toy example として説明する方が自然。
- Programmable bootstrapping は「テスト多項式/LUT の係数を変えることで、refresh 中に評価する関数を変えられる」と説明するのがよい。
	- 任意の多変数関数の説明に Kolmogorov の重ね合わせ定理を持ち出すのは避ける。
	- 実用的には bit decomposition、circuit decomposition、LUT/gate composition で説明する。

## Slidev / KaTeX の注意

- Markdown の `$...$` は KaTeX でレンダリングされる。
- ただし raw HTML タグの中に書いた `$...$` は安定してレンダリングされない。
- 安全な書き方:
	- できるだけ数式を raw HTML ブロックの外に出す。
	- HTML の中に数式を置く必要がある場合は、`katex.renderToString` を呼ぶ小さなコンポーネントを用意し、`<Math expr="..." />` のように使う。
	- このデッキでは、インライン数式は `<MathInline expr="..." />`、別行数式は `<MathBlock expr="..." />` を使う。
- HTML 内に残った危険な数式を探すコマンド:

```bash
rg -n '<[^>]*>[^<]*\\$|\\$[^<]*</[^>]+>|\\$[^$]+\\$' slides
```

- raw HTML の table では特に注意する。`<td>$...$</td>` はそのまま文字として出る可能性がある。
