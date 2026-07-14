# 試行錯誤メモ — Week 5 スライド制作の経緯

このファイルは、Advanced Cryptography Program Week 5 (FHE / TFHE) のスライドを制作する過程で経験した試行錯誤・判断ポイント・気づきを時系列で残すものです。

Week 1 の経緯メモは `inputs/journey_week1.md` を参照。レイアウト・デザイン・ビルド検証に関する汎用ノウハウは Week 1 メモの Phase 4–9 に記録されています。

---

<!-- 制作を進めるたびにここに追記していく -->

- Week 5 の PBS toy example では、$p=8,q=64$ と置くなら $\Delta=q/p=8$ を維持する。$x^N+1$ の negacyclic な符号反転を避けるため、$\mathbb{Z}_8$ はパディング込みの平文空間とし、実際に使う値を連続した半分 $\{0,1,2,3\}$ に制限する。modulus switch 後の値は $\hat{\Delta}=\Delta 2N/q=4$ として区別する。
