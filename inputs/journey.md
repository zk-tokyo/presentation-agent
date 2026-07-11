# 試行錯誤メモ — Week 5 スライド制作の経緯

このファイルは、Advanced Cryptography Program Week 5 (FHE / TFHE) のスライドを制作する過程で経験した試行錯誤・判断ポイント・気づきを時系列で残すものです。

Week 1 の経緯メモは `inputs/journey_week1.md` を参照。レイアウト・デザイン・ビルド検証に関する汎用ノウハウは Week 1 メモの Phase 4–9 に記録されています。

---

<!-- 制作を進めるたびにここに追記していく -->

- Week 5 の PBS toy example では、テスト多項式の係数位置の確認と実際の Blind Rotation の丸め誤差の説明を混ぜない。16係数で8平文を見せる場合は、参考例として $\Delta=4$、$i=\lfloor(b-\mathbf{as})2N/q\rfloor$ とし、各平文に2係数を割り当てると説明が破綻しにくい。
