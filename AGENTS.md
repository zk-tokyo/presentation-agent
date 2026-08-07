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
- 質問された場合は、まず質問に答え、必要なら代替案を提示する。自動でパッチを当てない。
- 既存ファイルにユーザーの変更がある場合は保持する。無関係な変更を戻さない。
- 編集範囲は、依頼されたスライド・コンポーネント・スタイルに絞る。
- 作業中に、今後の制作にも有用な新たな事実・留意事項・判断基準・ユーザーの好みが分かった場合は、必要に応じて `AGENTS.md` または該当する `inputs/*.md` に追記する。単発の作業ログではなく、再利用できる運用知識だけを残す。
- ユーザーに阿らない。

## TFHEの論文とあえて外しているポイント

- Torus表現を使わない
- 平文空間と暗号文空間ともに正の値にする

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
- `slides.md` の include 一覧は `bun run slides:generate` で、`slides/` 内の Markdown をファイル名の自然順に並べて自動生成する。include 一覧を手で編集しない。
- 表示しないスライドは `slides.exclude.md` に指定する。
- 基本は Markdown とローカル HTML を組み合わせて書く。
- Markdown の `$...$` は KaTeX でレンダリングされる。
- HTML タグ内に raw な `$...$` 数式を置かない。HTML 内では次を使う。
  - インライン数式: `<MathInline expr="..." />`
  - 別行数式: `<MathBlock expr="..." />`
- raw HTML の table では特に注意する。`<td>$...$</td>` はそのまま文字として出る可能性がある。

## 説明方針

- 内容は一次資料及び`inputs/introduction.md` に準拠する。内容上の不備を見つけた場合は、勝手に補完せず、必要に応じてユーザーに確認するか該当メモに追記する。
- 直感スライドと数式スライドを分ける。明示的な橋渡しスライドでない限り、新しい直感説明と厳密な導出を同じスライドに混ぜない。
- 直感スライドでは、式を主役にせず、構造・対応関係・処理の流れを説明する。
- 数式スライドでは、後で見返せるように、定義・復号式・アルゴリズム中の式を厳密に残す。
- 直感と数式の対応を示したい場合は、必要に応じて接続用スライドを分ける。
- 投影スライドの文言は、短く平易な日本語を優先する。
- 「読む」は文章を読む意味に限定する。係数・値・定数項・復号結果については「扱う」「対応する」「取り出す」「変換する」などを使う。
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

| 用途                 | フォント                                                                  |
| -------------------- | ------------------------------------------------------------------------- |
| 本文                 | `Yu Mincho`, `YuMincho`, `Hiragino Mincho ProN`, `BIZ UDPMincho`, `serif` |
| 見出し               | `BIZ UDPMincho`                                                           |
| 数式スライドの KaTeX | `Yu Mincho`, `YuMincho`, `Hiragino Mincho ProN`, `BIZ UDPMincho`, `serif` |
| コード               | `JetBrains Mono`, `monospace`                                             |

色:

| 用途                       | 色        |
| -------------------------- | --------- |
| 背景                       | `#ffffff` |
| 基本文字色                 | `#000000` |
| プレビュー本文色           | `#111827` |
| 見出し色                   | `#101820` |
| 見出し下線・図のアクセント | `#17324d` |
| 表ヘッダ背景               | `#f5f5f5` |
| 補足・数式背景             | `#fafafa` |
| 補足カード背景             | `#f2f7fc` |
| 補足カード境界線           | `#c9d8ea` |
| 主境界線                   | `#000000` |
| 補助境界線                 | `#e0e0e0` |
| 引用文                     | `#444444` |

コンポーネント:

| 要素       | 仕様                                                                           |
| ---------- | ------------------------------------------------------------------------------ |
| 見出し     | `BIZ UDPMincho`、下線付き。プレビューでは下線に `#17324d` を使う               |
| 表         | Week 1 / Week 6 の表に合わせ、薄いヘッダ背景、黒いヘッダ罫線、薄い行罫線にする |
| カード     | 補足情報に限って使う。薄い青背景、細い青系罫線、左罫線で控えめに示す           |
| 引用       | 左罫線のみ。背景色を強く付けない                                               |
| 数式パネル | 数式スライドでのみ使用。薄いグレー背景、左罫線、横スクロール可能にする         |
| Mermaid 図 | 背景は透明。ノードは薄いグレー、境界はアクセント色、線は黒系にする             |

表とカードは、Week 3 ではなく Week 1 / Week 6 の実装スタイルを優先する。

## Week 5 の技術メモ

- TFHE は Chillotti, Gama, Georgieva, Izabachene らによる ASIACRYPT 2016 / Journal of Cryptology 2019 系の方式。
- FHEW は homomorphic accumulator を中心にした高速 bootstrapping の流れを作り、NAND/refresh を 1 秒未満で行う実装結果を報告した。
- TFHE の gate bootstrapping は、TLWE-to-TLWE bootstrapping、blind rotation、sample extraction、key switching を中心に説明するとよい。
- TFHE 論文の HomNAND の標準的な書き方では、メッセージを `{0, 1/4}` にエンコードし、`(0, 5/8) - c1 - c2` のような線形前処理をしてから bootstrapping する。
- Week 5 の課題と対応スライドでは、標準形とは別のtoy構成として平文空間を `Z_8`、bitを `0 -> 7`, `1 -> 1` とし、`1 - m1 - m2 mod 8` と全係数 `1` のテスト多項式を使う。PBS出力も `7` または `1` となり、独立したデコード操作なしで次のHomNANDへ接続する。
- 課題のtoyパラメータは `p=8, q=32, n=16, k=4, e in {0,1}` とし、LWE暗号化では `Delta=q/p=4` を掛ける。`q=2n` なので、課題のBlind RotationではLWE暗号文の係数をそのまま回転量として使う。
- Week 5 の資料では torus を避ける方針。スライド本文では整数 mod `q` にスケールした toy example として説明する方が自然。
- Programmable bootstrapping は「テスト多項式/LUT の係数を変えることで、refresh 中に評価する関数を変えられる」と説明する。
- 任意の多変数関数の説明に Kolmogorov の重ね合わせ定理を持ち出すのは避ける。
- Programmable bootstrapping の実用面は、bit decomposition、circuit decomposition、LUT/gate composition で説明する。

## 現行スライドの要修正事項

一次資料との照合で判明した、現行スライドの内容上の修正事項。修正依頼を受けた場合は、以下を基準に直す。

### FHE・LWE

- `slides/SL07-FHEの種類.md`
  - Leveled FHEでパラメータにより制限される中心は演算の総回数ではなく乗法深さ。加算回数まで一律に制限されるような説明にしない。
    ->それはあくまでもBFV/BGV, CKKSがそうなだけで合ってLHEの定義が乗算の深さのみ有限回というのは逆に不正確なのでは？
- `slides/SL09-FHEの主要方式.md`
  - TFHEの速度を「数ミリ秒」と丸めず、一次資料のパラメータ例に合わせて「約13ms」または「十数ms」とする。
    ->「論文発表時点で13ms」に修正
- `slides/SL10-FHEの課題.md`
  - 「FHEはnon-malleabilityを達成できない」と無条件に断定しない。「通常のnon-malleabilityやIND-CCAの定義は、公開された任意の準同型評価機能と両立しにくい」と限定する。
    -> いや、FHEはそのままでは原理的にnon-malleabilityが達成不可能だよ
- `slides/SL12-（判定）LWE問題とLWE仮定.md`
  - `q`を合成数でもよいとする本資料では、LWEの係数空間を`\mathbb{F}_q`ではなく`\mathbb{Z}_q`と書く。
    -> F_qとしてしまっているとこをZ_qに修正。
  - 判定LWE・探索LWEはいずれも、通常は複数のLWEサンプルを利用する問題であることを必要に応じて補足する。
    -> 口頭で補足する
- `slides/SL13-LWE暗号.md`
  - 暗号文空間は`\mathbb{Z}_q`ではなく`\mathbb{Z}_q^{k+1}`。
    -> これはタイポだからその通りに修正
  - `\Delta=q/p`を整数として用いるため、`p\mid q`を仮定する。
    -> そうね、noteに書いとくは
- `slides/SL14-LWE暗号同士の演算.md`
  - 暗号文同士の加算や平文乗算でノイズの実値が必ず増えるとは限らない。「ノイズの上界・分散が増える」または「平文乗算ではノイズも同じ係数倍される」と表現する。
    -> まあ確かに正確に言えばそうなんだけど重要度は低いから口頭で補足するわ。

### 多項式・Gadget Decomposition

- `slides/SL17-剰余の復習.md`
  - 多項式除算は`x^5+x+2=(x^3-x)(x^2+1)+2x+2`。商を`x^3+x`としない。
    ->修正して
  - `0\le a\le n`では`x^{-a}=-x^{n-a}\pmod{x^n+1}`。`-x^{a-n}`としない。
    ->修正して
- `slides/SL19-$v(x)$の構成.md`
  - 回転は`x^{-(\hat b-\hat{\mathbf a}\mathbf s)}v(x)`。秘密鍵`\mathbf s`を落とさない。
    -> 修正して
  - `v_q(x)`を導入した式の右辺で、途中から`v(x)`へ表記を変えない。
    ->修正して
  - リスケーリングでは各係数の丸めによるdriftが生じうるため、厳密な等式として扱わない。
    -> \approxを使うように修正して
- `slides/SL24-Gadget Decomposition.md`
  - 整数のmod 64の例は`\mathbb{F}_{64}`ではなく`\mathbb{Z}_{64}`。
    ->修正して
- `slides/SL25-多項式のGadget Decomposition.md`
  - 整数係数のmod 16の例は`\mathbb{F}_{16}`ではなく`\mathbb{Z}_{16}`。
    -> 修正して
  - 多項式ベクトルの式は`G^{-1}(\mathbf f)=(g^{-1}(f_0),\dots)`とし、左辺の引数`\mathbf f`を落とさない。
    -> この用法の「落とす」は日本語に存在しないので２度と使わないで。そんでその通りに修正して。
- `slides/SL26-RGSW.md`
  - Gadget Matrixの確認式末尾の`x2`は`x_2`。
    -> 修正してあるはず。直ってなければ修正して

### Blind Rotation・PBS・HomNAND

- `slides/SL28-Blind Rotation.md`
  - リスケーリングの最近傍丸めは`\left\lfloor \cdot \right\rceil`と書く。`\lceil\cdot\rfloor`としない。
    -> 修正して
  - 自明なRLWE暗号文を作る際、テスト多項式`v(x)`の非定数項を0にする必要はない。任意の`v(x)`について、`a(x)=0`とすれば`\mathrm{RLWE}_{s'}(\Delta v)=(0,\Delta v)`となる。
    -> 修正して
  - 自明なRLWE暗号文の鍵はBlind Rotationで用いる`s'`に合わせる。
    -> 修正して
- `slides/SL34-なぜ"Programmable" Bootstrappingなのか.md`
  - テスト多項式の指数を生の`\mu_i+e_j`としない。`\Delta`を含むLWE位相を`2n/q`倍して丸めたインデックスを使う。
    -> 修正して
  - 1回のPBSで任意の一変数関数を評価できるという説明には条件がある。リスケーリング後の位相が`0\le i<n`に収まるようpaddingするか、評価関数がnegacyclicである必要がある。一般の非negacyclic関数には追加手法や複数回のPBSが必要になりうる。
    -> 説明追加しといて
  - driftや異なる平文・ノイズ区間の係数衝突がないことも、テスト多項式の正しさの前提に含める。
    -> 追加しといて
- `slides/SL34b-negacyclic性の利用.md`
  - 「`x^a`が1と-1の2値を表す」と説明しない。指数が`n`だけ離れた項は同じ係数位置へ符号を反転して折り返される、と説明する。
    -> ここは一般論というかHomNANDへの橋渡しなので直感的な説明にしている。ただ表現は考えるわ
- `slides/SL35-HomNAND.md`
  - 線形前処理の`\mathrm{LWE}_{\mathbf s}(\Delta)`は、通常のノイズ付き暗号化ではなく`(0,\dots,0,\Delta)`というノイズのない自明な暗号文であると明示する。そうしないと、`SL35b`のノイズ和`d=e_1+e_2`に定数暗号文由来のノイズが不足する。
    ->`(0,\dots,0,\Delta)`に置き換えといて
  - `p`を一般化して表を書く場合は、bitエンコード`p-1`と`1`が異なり、表中の剰余`3`をそのまま使える範囲を仮定する。課題では`p=8`に固定されている。
    ->そうなるようにパラメーターを設定する旨書いてない？

### 運営上の不整合

- `slides/SL36-ホワイトボードセッション.md`
  - 記載時間はイントロ5分、調査・議論110分、発表60分で合計175分となり、`inputs/introduction.md`の`max_duration_minutes: 120`と一致しない。意図する総時間をユーザーに確認してから修正する。
  - 10グループへテーマを重複なく割り当てる場合、`SL37`のテーマは8個しかない。重複可とするか、テーマ数を増やすか確認する。
  - `inputs/rules.md`では投影スライドに詳細な時間表記を置かない方針であることにも注意する。
    ->ここら辺は後でまとめて直すのでノータッチで

### 修正時に維持する整合条件

- 通常の平文`m`のLWE暗号文は`\mathrm{LWE}_{\mathbf s}(\Delta m)`、RLWE暗号文は`\mathrm{RLWE}_{s}(\Delta\mu)`と書く。
- Key Switching Keyは通常の平文エンコードではなくmod `q`の位相値を補助暗号化するため、`ksk[i,j]=\mathrm{LWE}_{\mathbf s}(s_i''q/B^{j+1})`のままとし、ここに`\Delta`を追加しない。
- Bootstrapping Keyは、入力LWE秘密鍵`\mathbf s`の各成分を別のRLWE/RGSW秘密鍵`s'`で暗号化した`(\mathrm{RGSW}_{s'}(s_0),\dots)`である。入力暗号文と同じ秘密鍵で暗号化する必要はない。
- Sample Extractionの係数並べ替え`(a'_0,-a'_{n-1},\dots,-a'_1)`と、課題のHomNANDで`p=8,q=32,n=16`から出力`1,1,1,7`を得る計算は監査済みなので維持する。

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
<div
  class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl"
>
  Sources: AUTHORS "TITLE" VENUE YEAR
</div>
```

複数出典を並べる場合は全角区切り `｜` を使う。右下の Merkle Japan ロゴと衝突しない位置に置く。

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
