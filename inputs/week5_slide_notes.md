# Week 5 スライド設計メモ

## デザイン方針

- 内容はintroduction.mdのものに準拠する。introduction.mdに内容的な不備が見つかった場合はその旨を追記する
- 数式を中心とするスライドとわかりやすさを優先するスライドの棲み分け
- シンプルなデザイン

## TODO

### 資料完成日まで

- リスケーリングのスライド充実
- RGSWのスライドの再構成
- HomNANDのスライドに使用する多項式の例を追加

### 当日まで

- 全体的にわかりやすさ、みやすさを調整
- TFHEの基本情報のページの情報追加？
- FHEの主要方式のスライドでCKKSについてfunctional bootstrappingについて言及する

## ファクトチェック上の注意

- TFHE は Chillotti, Gama, Georgieva, Izabachene らによる ASIACRYPT 2016 / Journal of Cryptology 2019 系の方式。
- FHEW は homomorphic accumulator を中心にした高速 bootstrapping の流れを作り、NAND/refresh を 1 秒未満で行う実装結果を報告した。
- TFHE の gate bootstrapping は、TLWE-to-TLWE bootstrapping、blind rotation、sample extraction、key switching を中心に説明するとよい。
- TFHE 論文の HomNAND の標準的な書き方では、メッセージを `{0, 1/4}` にエンコードし、`(0, 5/8) - c1 - c2` のような線形前処理をしてから bootstrapping する。
  - ただし Week 5 の資料では torus を避ける方針なので、スライド本文では整数 mod `q` にスケールした toy example として説明する方が自然。
- Programmable bootstrapping は「テスト多項式/LUT の係数を変えることで、refresh 中に評価する関数を変えられる」と説明するのがよい。
  - 任意の多変数関数の説明に Kolmogorov の重ね合わせ定理を持ち出すのは避ける。
  - 実用的には bit decomposition、circuit decomposition、LUT/gate composition で説明する。
