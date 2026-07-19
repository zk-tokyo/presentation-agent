# 試行錯誤メモ — Week 5 スライド制作の経緯

このファイルは、Advanced Cryptography Program Week 5 (FHE / TFHE) のスライドを制作する過程で経験した試行錯誤・判断ポイント・気づきを時系列で残すものです。

Week 1 の経緯メモは `inputs/journey_week1.md` を参照。レイアウト・デザイン・ビルド検証に関する汎用ノウハウは Week 1 メモの Phase 4–9 に記録されています。

---

<!-- 制作を進めるたびにここに追記していく -->

- Week 5 の PBS toy example では、$p=8,q=64$ と置くなら $\Delta=q/p=8$ を維持する。$x^n+1$ の negacyclic な符号反転を避けるため、$\mathbb{Z}_8$ はパディング込みの平文空間とし、実際に使う値を連続した半分 $\{0,1,2,3\}$ に制限する。modulus switch 後の値は $\hat{\Delta}=\Delta 2n/q=4$ として区別する。
- HomNANDの課題と投影スライドでは、平文空間を$\mathbb{Z}_8$とし、bitを$0\mapsto7,\ 1\mapsto1$へ対応させる。線形前処理は$1-m_1-m_2\pmod8$とし、テスト多項式$v(x)=1+x+\dots+x^{15}$のnegacyclicな符号反転で出力$1$と$7$を作る。入出力のエンコードが同じなので、独立したデコード操作を挟まずHomNANDを接続できる。
- HomNANDの課題パラメータは$p=8,q=32,n=16,k=4,e\in\{0,1\}$とする。LWE暗号化では$\Delta=q/p=4$を掛ける。$q=2n$なのでLWE暗号文の係数をそのままBlind Rotationの回転量として使い、課題固有の処理からリスケーリングを除く。評価鍵側のノイズは小さいtoyパラメータでは扱わず、データ暗号文のノイズは残す。
