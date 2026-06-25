---
target_audience: "Advanced Cryptography Program Week 1 受講者 (オンサイト20-25名 / 学部生〜社会人エンジニア混在 / バックグラウンドにばらつきあり)"
audience_type: group
constraints:
  max_slides: 30
  max_duration_minutes: 120
output_language: Japanese
event:
  name: "Advanced Cryptography Program — Week 1"
  parent_event: "Merkle Japan × 東京大学ブロックチェーンイノベーション寄付講座"
  date: "2026 年度"
  location: "東京大学 講義室 (オンサイト)"
---

# Advanced Cryptography Program Week 5

## レクチャー

- 前半
	- FHEに関するハイレベルな話
	- なるべくその場で理解してホワイトボードセッションでの議論に活かしてほしい
- 後半
	- TFHEのアルゴリズムの数式を使った説明
	- その場で理解しきれなくても良く、帰宅してから咀嚼してほしい

### タイムテーブル

計：2時間

| 時刻 | セクション                                                                       | 内容                                                                                                                                                                                                      | 時間（分） |
| ---- | -------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
|      | FHEの概要 <br>ここは他の部分を削ってでも時間かけて丁寧にやりたい                 | • FHEの概念と歴史 <br>◦ 前の週まででEncryption Schemeの話はしない気がするのでそこらへんも軽く触る <br>• HE, SHE, LHE, FHEのカテゴリ <br>• FHEの主要方式 <br>• FHEの課題 <br>◦ 速度 <br>◦ non-malleability | 25         |
|      | LWE暗号 <br>今回はLWEは道具として使うので、SISへの帰着とかなぜ困難かの話はしない | • 近似連立方程式 <br>• LWE問題 <br>• LWE暗号 <br>• LWE暗号文同士の演算<br>• LWE以外の方式に基づくFHE                                                                                                      | 15         |
|      | Bootstrappingの基本概念                                                          | • ノイズを削減する基本的な発想                                                                                                                                                                            | 5          |
|      | TFHEの概略                                                                       | • TFHEの基本情報 <br>• Bootstrappingでノイズ削減しながら関数評価できるよって話                                                                                                                            | 5          |
|      | Programmable Bootstrappingの概観                                                 | • 円分多項式（week4まででやってなければ） <br>• Programmable Bootstrappingの基本アイディア                                                                                                                | 15         |
|      | 休憩                                                                             | -                                                                                                                                                                                                         | 10         |
|      | RLWEとRGSW                                                                       | • RLWE暗号 <br>• Gadget Decomposition <br>• RGSW暗号 <br>• RLWEとRGSWによるexternal product <br>• cmux                                                                                                    | 10         |
|      | Programmable Bootstrappingの流れ                                                 | • BlindRotation <br>• SampleExtraction <br>• KeySwitching                                                                                                                                                 | 30         |
|      | HomNAND                                                                          |                                                                                                                                                                                                           | 5          |

### コンテンツ

#### FHEの概要

**暗号方式**

- 暗号方式(Encryption Scheme)の定義
	- 以下の3の（確率的）多項式時間アルゴリズムの組み(Gen, Enc, Dec)はDec(Enc(m))=mを満たす時、暗号方式と呼ばれる。
	    - Gen$(1^\lambda)\to key$: 鍵を生成する（鍵生成）
	    - Enc$(m, key_{enc})\to c$: 平文と鍵から暗号文を生成する（暗号化）
	    - Dec$(c, key_{dec})\to m$: 暗号文と鍵から平文を生成する（復号）
  - 共通鍵暗号と公開鍵暗号
    - 共通鍵暗号(Symmetric Key Encryption): EncとDecで同じkeyを用いる。
    - 公開鍵暗号(Public Key Encryption): Genが鍵のペア(pk,sk)を生成し、pk(公開鍵)が公開されてsk(秘密鍵)が公開されない。Encで使うkeyがpkであり、Decで使うkeyがskである。

**FHEの概念**

- 準同型暗号(Homomorphic Encryption)とは 
	- 大雑把に言えば、暗号文のまま計算が行える暗号方式 
	- 平文に対して演算$\oplus$ ,暗号文に対して演算$\otimes$が可能な時、2つの暗号文$c_1=Enc(m_1), c_2=Enc(m_2)$に対して、$Dec(c_1 \otimes c_2)=m_1 \oplus m_2$が成立する 
		- 例えば平文に対する加算と暗号文に対する乗算が対応している場合は
	  ```mermaid
		flowchart LR
			subgraph　平文空間
				direction LR
				A[m1,m2] --> B[m1+m2]
			end
			subgraph 暗号文空間
			    direction LR
				C[c1,c2] --> D[c1*c2]
			end  
			A -->|Enc| C
			D -->|Dec| B
	  ```

	- 暗号文のまま平文の加算と乗算両方は行えない。
	- RSA暗号やElgamal暗号は暗号文同士の乗算が平文同士の乗算になり、Paillier暗号は暗号文同士の乗算が平文同士の加算になる 
	- 暗号文の状態での演算を準同型演算と呼ぶ。
  完全準同型暗号(Fully Homomophic Encyption, 以下FHE)は暗号文のまま加算と乗算が行える。加算と乗算が行えればNAND演算を評価できる。すなわち、平文$m_1,m_2\in \{0,1\}$に対して$1-m_1m_2$を暗号文の状態で計算することで、平文に対するNAND演算を評価できる。そのため、暗号文のまま加算と乗算が行えれば、理論上任意のプログラムを暗号文のまま評価することできる。
  FHEの概念自体は1978にRSA暗号で有名なRivestらにより提唱され[RAD78]、具体的な構成方法は格子を用いた方式[Gen09]がGentryにより2009年に提案された。このGentryによる方式(Gentry's Blue Printと呼ばれることがある)では、Bootstrappingと呼ばれる操作を導入することによりFHEを実現したが、この論文におけるBootstrappigの計算量は非常に大きく、全く実用的なものではなかった。しかし、このGentryによる提案をきっかけにFHEの研究は急速に発展していき、現在に至るまでGentryの方式で用いられた格子と呼ばれる数学的な構造は主要なFHEのベースになっている。特にBootstrappingはFHEに関する研究の潮流の中心にあり、Boostrappingの性能を改善する方法やBootstrapping回避する方式が数多く研究されている。

**FHEのカテゴリと主要方式**
FHEにはいくつかの種類がある。

- Somewhat Homomorphic Encryption(SHE)
	- 暗号文のまま加算と乗算が行えるものの、どちらかの演算の演算回数に定数回の上限が与えられる。
- Leveled Homomorphic Encryption(LHE)
	- SHEと同様にどちらかの演算に上限があるが、その上限がパラメーターによって変化する。
- Fully Homomorphic Encryption(FHE) - 暗号文の状態で加算と乗算を行えて、どちらも制限回数がない。
  この分け方の他にも世代として分類することもある。

FHEの主要方式として以下の方式が挙げられる。

- Gentry's Blue Print
	- Bootstrappingを導入することで初めてFHEを構成した方式。
- BFV/BGV  
	- 整数値に対する演算を行うことのできるFHE
	- Bootstrapping自体は重たいが、準同型演算自体は比較的高速
	- SV packingと呼ばれる手法により、暗号文のままのSIMD演算が可能
	- ある程度準同型演算を行うとBootstrappingを行う必要性が生ずるため、パラメーターを調整してLHEとして使われることがメイン
- CKKS
	- 浮動小数点などの近似値計算を準同型演算することができるFHE
	- 機械学習と相性が良く、最近盛んに研究されている。
	- BFV/BGVと同様に準同型演算が比較的高速で、主にLHEとして運用される
- GSW
	- 
- FHEW
- TFHE
	- 後半で説明

**FHEの課題**
FHEには2つの大きな課題がある。

- 実行コスト
- malleability
	- 暗号にはnon-malleabilityと呼ばれる安全性の概念が存在する。
	- FHEは準同型演算ができるが故にnon-malleabilityを満たすことができず、選択暗号文攻撃と呼ばれる種類の攻撃に対して脆弱になる。
	- 仮に選択暗号文攻撃がされなくても、クラウドコンピューティングなどのユースケースにおいてFHEを使って計算を外部に委託した際、計算結果が正しく得られたものなのかどうか確認することができない。

#### LWE暗号

**（判定）LWE問題とLWE仮定**
整数$n\ge 1$，素数$q \ge 2$, および$\mathbb{Z}$上の確率分布$\chi$に対して，$\mathbf{s}\in\mathbb{F}^n_q$を固定し，$\mathbf{a}\in \mathbb{F}_q^n$を一様ランダムに取り，$e\in \mathbb{F}_q$を$\chi$に従ってとる．このとき$(\mathbf{a},b)\in \mathbb{F}^{n+1}_q$が$b=\Sigma_{i=1}^{q} \mathbf{as}+e \text{ mod } q$を満たす$\mathbf{a},b$の組みか、一様ランダムに選ばれた組みか識別する問題をLWE問題と呼び、この2つが計算量的に識別不可能であるという仮定をLWE仮定と呼ぶ。
> [!note] 
> LWEはLearning With Errorの略

> [!note]
> このLWE問題を判定LWE(Decision-LWE)と呼び，$b=\Sigma_{i=1}^{q} \mathbf{as}+e \text{ mod } q$が成立している時に$(\mathbf{a},b)$から$\mathbf{s}$を求める場合を探索LWE(Search-LWE)と呼びわけることがある。


**LWE暗号**
LWE暗号は共通鍵暗号としても公開鍵暗号としても構成できるが、今回は共通鍵暗号としての構成を扱う。
平文空間を$\mathbb{F}_p$, 暗号文空間を$\mathbb{F}_q^{k+1}$、ノイズの分布を$χ$とする。

- Gen$(1^\lambda)\to \mathbf{s} \in\{0,1\}^k$:
	- 長さ$k$のビット列を一様ランダムに取り秘密鍵$\mathbf{s}=(s_0,s_1,\dots,s_{k-1})\in \{0,1\}^k$として出力する
- Enc$(m,\mathbf{s})\to c \in \mathbb{F}_q^{k+1}$:
	- 平文$m$に対して、$\mathbf{a}=(a_0,a_1,\dots,a_{k-1})\in \mathbb{F}_q^k$を一様ランダムに取り、ノイズ$e$を分布$χ$に基づいて$\mathbb{Z}_q$からサンプルし、$c=(\mathbf{a},b=\mathbf{as}+\Delta m + e)\in \mathbb{F}_q^{k+1}$を暗号文として出力する。
		- $\mathbf{as}$は内積を表し、$\mathbf{as}=\Sigma_{i=0}^{k-1}a_is_i$
		- $\Delta$は$\Delta:=q/p$であり、スケーリングファクターと呼ばれる。
		- 以降、平文$m$の秘密鍵$\mathbf{s}$によるLWE暗号文を$\text{LWE}_{\mathbf{s}}(m)$と書く。
- Dec$(c,\mathbf{s})\to m \in \mathbb{F}_p$:
	- $\lceil \frac{b-\mathbf{as} \text{ mod }q}{\Delta}\rfloor \text{ mod } p=\lceil \frac{\Delta m + e \text{ mod }q}{\Delta}\rfloor \text{ mod } p=\lceil m+\frac{e \text{ mod }q}{\Delta}\rfloor \text{ mod } p=m$により復号する
		- $\lceil a \rfloor$は$a$をもっとも近い整数値にする操作。要は四捨五入
		- $-\frac{\Delta}{2}\le e < \frac{\Delta}{2}$であれば正常に復号可能

> [!note]
> 今回$p,q$は素数である必要性がないことに注意

> [!question]
> 復号が成立することを各自確認


**LWE暗号同士の演算**
LWE暗号文はこのままでも、平文との加算・乗算、暗号文同士の加算が可能。

- LWE暗号文$(\mathbf{a},b=\Sigma \mathbf{as}+\Delta m + e)$と平文$m'$の加算
	- $m'$に$\Delta$をかけて$b$に加算すれば、$m+m'$を平文とするLWE暗号文$(\mathbf{a},\Sigma \mathbf{as}+\Delta (m+m') + e)$が得られる
- LWE暗号文$(\mathbf{a},b=\Sigma \mathbf{as}+\Delta m + e)$と平文$m'$の乗算
	- $\mathbf{a},b$の両方に$m'$をかければ、$mm'$を平文とするLWE暗号文$(m'\mathbf{a}, \Sigma m'\mathbf{as}+\Delta mm' + em')$が得られる
- LWE暗号文$(\mathbf{a},b=\Sigma \mathbf{as}+\Delta m + e)$とLWE暗号文$(\mathbf{a'},b=\Sigma \mathbf{a's}+\Delta m' + e')$の加算
	- $\mathbf{a}$と$\mathbf{a'}$、$b$と$b'$をそれぞれ加算することで、$m+m'$を平文とするLWE暗号文$(\mathbf{a+a'},\Sigma\mathbf{(a+a')s}+\Delta(m+m')+e+e')$が得られる
> [!question]
> これらの演算の結果得られた暗号文が正常に復号できるか各自確認

これらの操作により出力される暗号文はもとの暗号文よりもノイズが増えている。よって、暗号文に対する演算を続けると、ノイズはいずれ$-\frac{\Delta}{2}\le e < \frac{\Delta}{2}$に収まらなくなる

**LWE暗号文同士の乗算とノイズの管理**
- Gentry's Blue Print
- BGV, BFV, CKKS
- GSW
- FHEW, TFHE


#### Bootstrappingの基本概念

#### TFHEの概略

**TFHEの基本情報**

- zamaが2020年に提案した方式
- それまでの方式と比べるとBootstrappingが非常に高速かつ省メモリであり、数MBのメモリ消費でミリ秒単位で実行可能
- トーラスと呼ばれる代数構造を利用する
	- トーラスの話をするとややこしくなるので、レクチャーの中ではトーラスを使わない方法を扱う
- FHEWと呼ばれる方式を拡張した方式

> [!note]
> トーラスを考えるとどんないいことがあるのか気になる人は[Chi20+],[Zha24+]を読むことをお勧めする

#### Programmable Bootstrappingの概観

**多項式の剰余**

- 整数の剰余演算: 5 mod 3 = 2
- 多項式の剰余演算: $x^5 + x + 2 \;\text{mod}\; x^2 + 1 = (x^3+x)(x^2+1)+2x+1 \;\text{mod}\; x^2 + 1=2x+1$
  特に、
	- $x^n \;\text{mod}\;x^n+1 = -1$
	- $x^{-a} \;\text{mod}\;x^n+1 = -x^{n-a}$

> [!question]
>  $x^n \;\text{mod}\;x^n+1 = -1$と$x^{-a} \;\text{mod}\;x^n+1 = -x^{n-a}$が成立することは各自確認

**有限体と多項式**

多項式が有限体$\mathbb{F}_p$の要素を係数に持つとき、係数に対してはmod $p$を適用する。
	$\mathbb{F}_5$の要素を係数に持つ多項式のモジュラス$x^2+1$での演算の例
	  $(3x+2)(x+4)\text{ mod } x^2+1$
	  $=3x^2+14x+8 \text{ mod } x^2+1$
	  $= 3x^2+4x+3\text{ mod }x^2+1$
	  $=3(x^2+1)+x+3\text{ mod }x^2+1$
	  $=x+3$

**Programmable Bootstrappingの基本アイディア**

- Lookup Table
	- あるアルゴリズムをプログラムの実行中に計算するのではなく、よく使われる値とそれに対応する出力を事前計算してテーブルを作成しておき、プログラムの実行中はそのテーブルを参照するようにすることで実行速度を上げるテクニック
	- 平文とそれに対応するノイズの少ない暗号文のテーブルを作り、暗号文のノイズを削減したい時は、その暗号文と同じ平文を持つノイズの少ない暗号文をテーブルから引っ張ってくるようにすることでBootstrappingを高速化する
- key observation
	- $f(x)=a_0+a_1x+\dots+a_{n-1}x^{n-1} \;\text{mod}\;x^n+1$を考える。これに$x^{-i}\;(0\le i\le n-1)$をかけると、$x^{-i}f(x) \;\text{mod}\;x^n+1=a_i+a_{i+1}x\dots+a_{n-1}x^{n-1-i}-a_0x^{n-i}-a_1x^{n-i+1}-\dots-(i-1)x^{n-1} \;\text{mod}\;x^n+1$となり、$a_i$が定数項になる
	- 多項式をLookup Tableとして使う
	    - 平文空間のすべての平文を係数にエンコードした多項式$v(x)=\Sigma_{i,j} m_ix^{m_i+e_j} \;\text{mod}\; x^n+1$とノイズの増加した暗号文$\mathbf{c}=LWE_\mathbf{s}(m)=(\mathbf{a},b)$を考え、$x^{-(c-\mathbf{as})}v(x) \;\text{mod}\; x^n+1=x^{-(m+e)}v(x)\;\text{mod}\; x^n+1$として、この多項式の定数項を抜き出すと平文$m$が出てくる。この一連の処理を暗号文の状態でやる
	    - $v(x)$の次数はありえる$\Delta m +e$の値の総数、すなわち$q$にしなければならないように思えるが、$q$は実際には2048bitなどの巨大な数であるため、単純に$v$の次数を$q$にすると$v$が大きくなり過ぎてしまう。そこで、$v$の次数を$q$より小さな値$n$としておき、暗号文$(\mathbf{a},b)$に対して、$\hat{\mathbf{a}}=\lceil \mathbf{a}\frac{2n}{q}\rfloor, \hat{b}=\lceil b\frac{2n}{q}\rfloor$とすることで暗号文に対応する平文とテスト多項式の次数を対応させる（この操作をリスケーリングと呼ぶ）。
	- **$x^{-(\hat{b}-\hat{\mathbf{a}}\mathbf{s})}v$の数値による具体例([Ko25]のものを改変)
- Programmable Bootstrappingは以下の３つのサブアルゴリズムから構成される
	- Blind Rotation: ノイズの溜まった暗号文を使って暗号化された多項式を回転させる
	- Sample Extraction: 回転した多項式から定数項を暗号文の状態で抜き出す
    - Key Switching: 定数項の暗号文の鍵を元の暗号文の鍵と一致させる**

**多項式をLUTとして使うとうまくいくことの確認**
- 前提
平文空間:$\{0,1,2,3,4,5,6,7\}$
暗号文空間:$\{0,1,2,\dots,63\}$
スケーリングファクター:$\Delta = 8$
ノイズ$e$の許容範囲:$0\le e<4$
ベクトルの次元:$k=8$
多項式の次数:$n=16$
平文を1($\Delta1=8$), 秘密鍵を$\mathbf{s}=(1,0,0,1,1,1,0,1)$、エラー$e=2$として、暗号文を
$(\mathbf{a},b)=(8,34,4,32,0,31,58,7,24)$とする
- テスト多項式
$v=0+0x+0x^2+0x^3+1x^4+1x^5+1x^6+1x^7+2x^8+2x^9+2x^{10}+2x^{11}+1x^{12}+1x^{13}+1x^{14}+1x^{15}$
- リスケーリング
$\hat{\mathbf{a}}=(4,17,2,16,0,16,29,4)$
$\hat{b}=12$
- $x^{-(\hat{b}-\hat{\mathbf{a}}\mathbf{s})}v$の計算
$\hat{b}-\hat{\mathbf{a}}\mathbf{s}=12-(4*1+0*17+0*2+16*1+0*1+16*1+29*0+4*1)\text{ mod }32 = 4$
よって、$x^{-(\hat{b}-\hat{\mathbf{a}}\mathbf{s})}v$の定数項は$x^{-4} 1 x^4=1x^0=1$
暗号文$(\mathbf{a},b)$の平文が定数項にきていることがわかる


#### RLWEとRGSW

**RLWE暗号**
LWEの多項式版

**Gadget Decomposition**
10進数と2進数の変換を思い出す。例：$19 = 1\cdot 2^4+0\cdot2^3+0\cdot2^2+1\cdot2^1+1$。
これと似たようなことを整数の剰余に対してやるのがGadget Decomposition。
mod $q$上のある値$r$に対して、基数$B$を用いて$r = \Sigma_{i=1}^l r_i\frac{q}{B^i}\;\;(0\le r_i < B)$と表したとき、$g^{-1}(r)=(r_1,r_2,\dots,r_l)$として、この操作をGadget Decompositionと呼ぶ。ベクトル$\mathbf{r}=(r_1,\dots,r_{k+1})$に対しては$G^{-1}(\mathbf{r})=(g^{-1}(r_1),\dots,g^{-1}(r_{k+1}))$とする。
	例：$B=4,l=3$とすると，$\mathbb{F}_{64}$上の値47のGadget Decompositionは，
	$47=1\frac{64}{4}+0\frac{64}{16}+15\frac{64}{64}$
	より、$g^{-1}(47)=(1,0,15)$
>[!note]
>$r_i$の範囲はノイズ管理の面で$-\lfloor B/2 \rfloor \le r_i < \lceil B/2 \rceil$とすることがある。($\lfloor a\rfloor$は切り下げ、$\lceil a\rceil$は切り上げ)

多項式$f$に対しても同様のことを考えて、それぞれの項$a_ix^i$について$g^{-1}(a_i)$として、$\frac{q}{B^l}$について項をまとめ直し, $f=\Sigma_{i=1}^lf_i\frac{q}{B^l}$として、$g^{-1}(f)=(f_1,\dots,f_l)$とする。
	例：$\mathbb{F}_{16}$上のモジュラス$x^3+1$の多項式に対して$B=2, l = 4$とすると，$f=15x^2+4x+7 \text{ mod }x^3+1$をGadget Decompositionをする。
	まずそれぞれの係数に対してGadget Decompositionすると
	$g^{-1}(15)=1\frac{16}{2}+1\frac{16}{4}+1\frac{16}{8}+1\frac{16}{16}$
	$g^{-1}(4)=0\frac{16}{2}+1\frac{16}{4}+0\frac{16}{8}+0\frac{16}{16}$
	$g^{-1}(7)=0\frac{16}{2}+1\frac{16}{4}+1\frac{16}{8}+1\frac{16}{16}$
	これを$f$に代入して$\frac{16}{2^i}$ごとに整理すると
	$f=(1\frac{16}{2}+1\frac{16}{4}+1\frac{16}{8}+1\frac{16}{16})x^2+(0\frac{16}{2}+1\frac{16}{4}+0\frac{16}{8}+0\frac{16}{16})x+0\frac{16}{2}+1\frac{16}{4}+1\frac{16}{8}+1\frac{16}{16}$
	$\;=x^2\frac{16}{2}+(x^2+x+1)\frac{16}{4}+(x^2+1)\frac{16}{8}+(x^2+1)\frac{16}{16}$
	ゆえに、
	$g^{-1}(f)=(x^2,x^2+x+1,x^2+1,x^2+1)$

多項式のベクトル$\mathbf{f}=(f_1,\dots,f_{k+1})$についても同様に$G^{-1}(\mathbf{f})=(g^{-1}(f_1),\dots,g^{-1}(f_{k+1}))$とする。
また、以下の行列をGadget Matrixと呼ぶ。
$G^T=\begin{pmatrix}1/B & & &\\ \vdots & & &\\ 1/B^l & & &\\ & 1/B & \\ & \vdots & &\\ & 1/B^l & &\\ & & \ddots &\\ & & & 1/B\\ & & & \vdots \\ & & & 1/B^l\end{pmatrix}$
もし$B^l=q$ならば、$G^{-1}(\mathbf{f})G^T=\mathbf{f}$が成り立つ

**RGSW暗号**

$\mathcal{Z}\gets \begin{pmatrix}\text{RLWE}_{\mathbf{s}}(0)\\ \text{RLWE}_{\mathbf{s}}(0)\\ \vdots \\ \text{RLWE}_{\mathbf{s}}(0)\end{pmatrix}\in \mathbb{F}_{n,q}[x]^{(k+1)l\times (k+1)}$とすると、平文$m$の秘密鍵$\mathbf{s}$によるRGSW暗号文は

$\text{RGSW}_{\mathbf{s}}(m)=\mathcal{Z} + mG^T$
大雑把に言うとRLWEのリスト

**RLWEとRGSWによるexternal product**
多項式のベクトルに対するGadget Decompositionにより、RGSW暗号文とRLWE暗号文の積(External Product)$\boxdot$を定義する
$\text{RGSW}_\mathbf{s}(m)\boxdot \text{RLWE}_\mathbf{s}(m')=G^{-1}(\text{RLWE}_\mathbf{s}(m')) \text{RGSW}_\mathbf{s}(m)=\text{RLWE}_\mathbf{s}(mm')$

**CMUX**
RLWEとRGSWを使うことで、$a_0,a_1\in\{0,1\}$に対して、ビット$b$によってどちらかを指定するマルチプレクサ$\text{MUX}(b,a_0,a_1)=a_b$を暗号文の状態で行えるCMUXが構成可能
マルチプレクサは$\text{MUX}(b,a_0,a_1)=(1-b)a_0+ba_1=b(a_1-a_0)+a_0$より計算できるので、それぞれ、$c_0=\text{RLWE}_\mathbf{s}(a_0),c_1=\text{RLWE}_\mathbf{s}(a_1), c_b=\text{RGSW}_\mathbf{s}(b)$とすると、$\text{CMUX}(c_b,c_0,c_1)=c_b\boxdot(c_1-c_0)+c_0=\text{RLWE}_\mathbf{s}(a_b)$

#### Programmable Bootstrappingの流れ




**Blind Rotation** 暗号文の状態でのテスト多項式の回転

**平文の状態での考え方** 
$\mathbf{a}=\left(a_0,a_1,\ldots,a_{k-1}\right),\mathbf{s}=\left(s_0,s_1,\ldots,s_{k-1}\right)$とすると、$\mathbf{as}=\Sigma_{i=0}^{k-1}a_is_i$と表せる。
$x^{-b+\mathbf{as}}v=x^{-b+\Sigma_{i=0}^{k-1}a_is_i}v=x^{a_{k-1}s_{k-1}}\left(x^{-b+\Sigma_{i=0}^{k-2}a_is_i}v\right)$ より、$Q_k:=x^{-b+\Sigma_{i=0}^{k-1}a_is_i}v$は$\ Q_0=x^{-b}v$として次の漸化式から求められる。$Q_j=x^{a_{j-1}s_{j-1}}Q_{j-1}=\left\{\begin{matrix}Q_{j-1}\ \ \ \ \ \ if\ s_j=0\\x^{a_j}Q_{j-1}if{\ s}_j=1\end{matrix}\right.$
  よって$x^{-b+\mathbf{as}}v\;\text{mod}\;x^n+1$は以下のアルゴリズムから計算できる
- $q_0 \gets x^{-b}v$
- for $j=1\dots k$
	- $Q_j \gets \text{MUX}(s_{j-1}, Q_{j-1}, x^{a_j}Q_{j-1})$
- return $Q_k(=x^{-b+\mathbf{as}}v)$
これを準同型演算で記述する。すなわち、MUXをCMUXに置き換える。それに伴い、$s_j$をRGSWで暗号化し、$v$をRLWEで暗号化する

>[!note]
>正確に言うと$v$はノイズのない"自明な"RLWE暗号文として扱われる。すなわち、$v$を定数項以外の係数が0の多項式、aをゼロベクトルとすることで$v=\Sigma 0\cdot s + v+ 0\;\text{mod}\;x^n+1$とできるので、$v=\text{RLWE}_s(v)=(0,\dots,0,v)$とみなせる


> [!note]
> $s_j$をRGSWで暗号化するための鍵を$\mathbf{s}'$とし、$(\text{RGSW}_{\mathbf{s}'}(s_0),\dots,\text{RGSW}_{\mathbf{s}'}(s_{k-1}))$をBootstrapping Keyと呼ぶ。



**Blind Rotaionのアルゴリズム**
- $\hat{\mathbf{a}}\gets\lceil \mathbf{a}\frac{2n}{q}\rfloor$
- $\hat{b}\gets \lceil b\frac{2n}{q}\rfloor$
- $c_0 \gets x^{-\hat{b}}\text{RLWE}_{s'}(v)$ (RLWE暗号文は多項式をかけることができる。)
- for $j=1\dots k$
	- $Q_j \gets \text{CMUX}(\text{RGSW}_{\mathbf{s}'}(s_{j-1}), Q_{j-1}, x^{\hat{a}_j}Q_{j-1})$
- return $Q_k(=\text{RLWE}_{\mathbf{s}'}(x^{-\hat{b}+\mathbf{\hat{a}s}}v))$



> [!question]
> $x^i \text{ mod } x^n+1$にはnegacyclicと呼ばれる性質があり、$i \ge n$のとき、$x^i \text{ mod }x^n+1 = -x^{n-i}$となり、係数の符号が反転してしまう。仮にBlind Rotationでこれが起こるとなぜ問題なのか、そしてどのようすればこれを回避できるだろうか。

**Sample Extraction**

Blind Rotationによってテスト多項式が回転できて以下のような状態になっている。
$\text{RLWE}_{s'}(x^{-\hat{b}+\mathbf{\hat{a}s}}v)=\text{RLWE}_{s'}(m+mx^{m+e_j}+mx^{m+e_{j+1}}+\dots+(m+1)x^{m+1+e_0}+\dots)$
これの定数項$m$を暗号文の状態で取り出す。
$\text{RLWE}_{s'}(x^{-\hat{b}+\mathbf{\hat{a}s}}v)=(\mathbf{a}',b')$
$\mu = m+mx^{m+e_j}+mx^{m+e_{j+1}}+\dots+(m+1)x^{m+1+e_0}+\dots$
とすると、
$b'=b_0'+b_1'x +\dots+b_{n-1}'x^{n-1}=\mathbf{a's'}+\mu+e$
$=\Sigma_{j=1}^k(a'_{j,0}+a'_{j,1}x+\dots+a'_{j,n-1}x^{n-1})(s'_{j,0}+s'_{j,1}x+\dots+s'_{j,n-1}x^{n-1})$
$\;\;\;+ m+mx^{m+e_j}+mx^{m+e_{j+1}}+\dots+(m+1)x^{m+1+e_0}+\dots$
$\;\;\;+(e_0+e1x+\dots+e_{n-1}x^{n-1})$
実はこれの定数項$b'_0$がそのまま$m$のLWE暗号文になっている。
$x^n \;\text{mod}\;x^n+1 = -1$に注意すると、$\Sigma_{j=1}^k(a'_{j,0}+a'_{j,1}x+\dots+a'_{j,n-1}x^{n-1})(s'_{j,0}+s'_{j,1}x+\dots+s'_{j,n-1}x^{n-1})$の定数項は$\mathbf{a'}$と$\mathbf{s'}$の各要素の係数をいい感じに配置しなおしたベクトル$\mathbf{a''}=(a'_{1,0},-a'_{1,n-1},\dots,a'_{1,1},\dots,a'_{k,0},-a'_{k,n-1},\dots,a'_{k,1} )$
$\mathbf{s''}=(s'_{1,0},-s'_{1,n-1},\dots,s'_{1,1},\dots,s'_{k,0},-s'_{k,n-1},\dots,s'_{k,1} )$
を用いて
$b'_0=\mathbf{a''s''}+m+e_0$
と表せる。よって、$\mathbf{s''}$によるLWE暗号文$\text{LWE}_{s''}(m)=(\mathbf{a''},b_0)$が構成できる。

**Sample Extractionのアルゴリズム**

**Key Switching**

Sample Extractionで得られた暗号文$(\mathbf{a''},b_0)$は$\mathbf{s''}$による暗号文なので、これを$\mathbf{s}$による暗号文に変換する。
わかりやすさのために$\mathbf{a''}$と$\mathbf{s''}$を
$\mathbf{a''}=(a''_{1},a''_{2},\dots,a''_{kn})$
$\mathbf{s''}=(s''_{1},s''_{2},\dots,s''_{kn} )$
と書き直しておく。
$\mathbf{a''}$のGadget Decomposition $G^{-1}(\mathbf{a''})=(g^{-1}(a''_1),\dots,g^{-1}(a''_1kn))$を考え。
$g^{-1}(a''_i)=(\bar{a}_{i,1},\dots,\bar{a}_{i,l})$
とする。さらに、
$ksk[i,j]=\text{LWE}_\mathbf{s}(s''_iB^{-j})(1\le i \le kn, 1 \le j \le l)$ (これをKey switching keyと呼ぶ)を考えると、目的の$\mathbf{s}$による$m$の暗号文$\text{LWE}_\mathbf{s}(m)$は次のように計算できる。
$\text{LWE}_\mathbf{s}(m)\gets (0,\dots,0,b'_0)-\Sigma^{kn}_{i=1}\Sigma^{l}_{j=1}\bar{a}_{i,j}ksk[i,j]$
なぜこれでうまくいくのか?
以下のように変形する。
$\text{LWE}_\mathbf{s}(m)= (0,\dots,0,b'_0)-\Sigma^{kn}_{i=1}\Sigma^{l}_{j=1}\bar{a}_{i,j}ksk[i,j]$
$=(0,\dots,0,b'_0)-\Sigma^{kn}_{i=1}\Sigma^{l}_{j=1}\bar{a}_{i,j}\text{LWE}_\mathbf{s}(s''_iB^{-j})$
$=(0,\dots,0,b'_0)-\Sigma^{kn}_{i=1}\Sigma^{l}_{j=1}\text{LWE}_\mathbf{s}(\bar{a}_{i,j}s''_iB^{-j})$
$=(0,\dots,0,b'_0)-\text{LWE}_\mathbf{s}(\Sigma^{kn}_{i=1}\Sigma^{l}_{j=1}\bar{a}_{i,j}s''_iB^{-j})$
$=(0,\dots,0,b'_0)-\text{LWE}_\mathbf{s}(\Sigma^{kn}_{i=1}a''_{i}s''_i)$
$=(0,\dots,0,b'_0)-\text{LWE}_\mathbf{s}(\mathbf{a''s''})$
ここで$\text{LWE}_\mathbf{s}(\mathbf{a''s''})=(\tilde{\mathbf{a}},\tilde{\mathbf{a}}\mathbf{s} + \mathbf{a''s''} + \tilde{e})$と表すと、
$(0,\dots,0,b'_0)-\text{LWE}_\mathbf{s}(\mathbf{a''s''})$
$=(0,\dots,0,\mathbf{a''s''}+m+e_0)-(\tilde{\mathbf{a}},\tilde{\mathbf{a}}\mathbf{s} + \mathbf{a''s''} + \tilde{e})$
$=(-\tilde{\mathbf{a}},-\tilde{\mathbf{a}}\mathbf{s} + m +e_0 - \tilde{e})$
これは秘密鍵$\mathbf{s}$による$m$の暗号文になっている

**Key Switchingのアルゴリズム**

**Programable Bootstrappingのアルゴリズム**

**なぜ"Programmable" Bootstrappingなのか**
テスト多項式を工夫することで、ノイズを削減しながら任意の一変数関数$f$を評価できる。すなわち、
$v(x)=\Sigma_{i,j} f(\mu_i)x^{\mu_i+e_j} \;\text{mod}\; x^n+1$
のようにすると、$x^{-i}v(x)$が$0\le i \le n-1$である限り。
また、任意の多変数関数はKolmogorovの重ね合わせ定理により単変数多項式の線型結合で表現することができる
関数評価を行わないノイズを減らすだけのProgrammable BootstrappingをNoise Bootstrappingと呼ぶことがある。



#### HomNAND

平文空間を{0,1.2.3}、暗号文空間を{0,1,2,3,4,5,6,7,8}とする。
このとき$\Delta=2$よりノイズ$e$の許容範囲は$0\le e\le 1$
二つの暗号文$c_0,c_1$に対して$c_b=(0,\dots,0,5)-c_0-c_1$を計算してからBootstrappingする。
この際、テスト多項式は
$v(x) =  x + x^2 + x^3+x^4+  \text{ mod } x^4+1$
としておくと、

## ホワイトボードセッション

10グループに分かれ、テーマリストから選んで（当日はランダムで割り当てるかも）調査、議論、発表

- イントロ 5分
- 調査＋議論 1時間50分
- 発表 1時間(=6分x10)
  - 発表は調査結果の最重要事実と問題提起で構成する

### テーマリスト

**FHEの安全性**

- 背景：FHEは原理的にNM-CCA2安全性を持つことができず、安全性証明はCPA安全性を持つことを証明することが多い。一方で、CPA安全性だけでは不十分であるという指摘もあり、FHEが満たすべき安全性を新たに定義する研究も存在する。
- 調査項目：
  - TFHEが128-bit securityを達成するためのパラメーター
  - CPA, CCA1, CCA2安全性とは何か
    - 形式的な定義と、現実世界でのどのような状況を指すか
  - One-wayness, Indistinguishability, Non-malleabilityとは何か（形式的な定義）とそれらの等価性
  - BFG/BGV, CKKS, TFHEはどの安全性を持つか
  - FHEに対する新たな安全性の先行研究
- 発表すること：

**LHEとFHEの使い分け**

- 背景：
- 調査項目：
  - LHEでBootstrappingなしに可能な準同型演算の回数とパラメーターの相関
  - 通常のBootstrappingとProgrammable Bootstrappingとの違い
    - 仕組みと計算コストの違い

**BGV/BFVの仕組み**

- 背景：
- 調査項目：

**CKKSの仕組み**

- 背景：
- 調査項目：

**TFHEでトーラスが使われる理由**

- 背景：
- 調査項目：

**FHEの実装ライブラリ比較**

- 背景：
- 調査項目：
  - FHEの実装ライブラリは何があるか
  - どのFHEスキームを扱っているか
  - どの言語で実装されているか
  - FHEスキームに出てくるデータの表現方法とパラメーターの大きさ
  - 高速化のための工夫
  - ライブラリ間のパフォーマンス比較
  - バグはないか

**LWE以外の方式に基づくFHE**

- 背景：
- 調査項目：

**機械学習へのFHEの応用**

- 背景：
- 調査項目

**ブロックチェーンへのFHEの応用**

- 背景：
- 調査項目

**他のConfidential Computing（MPC, GC, TEE）との比較**

- 背景：
- 調査項目

## 実装課題

**必須**

- 提出不要 
	- ホワイトボードセッションで扱ったテーマの深掘り
- コードの穴埋め
	- LWE
	- RLWE
	- RGSW
	- BlindRotation
	- SampleExtraction
	- KeySwitching
	- Bootstrapping
	- HomNAND
- HomNANDによる全加算機の実装

**少なくとも1つ選択**

1. 穴埋めしたコードの最適化とパフォーマンス比較（NTT、ビットシフトによるモジュロ演算など）
2. 既存ライブラリを使ったアプリケーションのモック作り

**オプション課題(気になる人だけ)**

- BFV/BGVの実装
- CKKSの実装

## 参考文献

### 論文

**LWEベースのFHEの仕組みを証明などを省いて解説している資料**
[Ko25] Ko, Ronny. "The Beginner's Textbook for Fully Homomorphic Encryption." *arXiv preprint arXiv:2503.05136* (2025). online: https://arxiv.org/abs/2503.05136

**FHEの概念の初出**
[Riv78+] Ronald L. Rivest, Len Adleman, and Michael L. Dertouzos. On data banks and privacy homomorphisms. In R. A. DeMillo et al., editors, Foundations of Secure Computation, pages 165–179. Academic Press, 1978. online: https://people.csail.mit.edu/rivest/pubs.html#RAD78.

**Gnetry's Blue Print**
[Gen09] Gentry, Craig. "Fully homomorphic encryption using ideal lattices." *Proceedings of the forty-first annual ACM symposium on Theory of computing*. 2009. online: https://dl.acm.org/doi/abs/10.1145/1536414.1536440

**TFHE**
[Chi20+] Chillotti, Ilaria, et al. "TFHE: Fast Fully Homomorphic Encryption Over the Torus: I. online: Chillotti et al." *Journal of Cryptology* 33.1 (2020): 34-91. https://idp.springer.com/authorize/casa?redirect_uri=https://link.springer.com/article/10.1007/s00145-019-09319-x&casa_token=c_x0bNeB64gAAAAA:fizFBp08C1rUeRx7THtpIzytowXZlV9eiFtea4lPQ_h8o9XthUADw0Jo-OUG6Vmk1fCcs9OOadr8D27N

[Zha24+] Zhang, Junxue, et al. "Sok: Fully homomorphic encryption accelerators." *ACM Computing Surveys* 56.12 (2024): 1-32. online: https://dl.acm.org/doi/abs/10.1145/3676955

**CKKS**
[Che17+]Cheon, Jung Hee, et al. "Homomorphic encryption for arithmetic of approximate numbers." *International conference on the theory and application of cryptology and information security*. Cham: Springer International Publishing, 2017. online: https://link.springer.com/chapter/10.1007/978-3-319-70694-8_15

**BFV**
[Fan12+] Fan, Junfeng, and Frederik Vercauteren. "Somewhat practical fully homomorphic encryption." *Cryptology ePrint Archive* (2012). online: https://eprint.iacr.org/2012/144

**BGV**
[Bra14+] Brakerski, Zvika, Craig Gentry, and Vinod Vaikuntanathan. "(Leveled) fully homomorphic encryption without bootstrapping." *ACM Transactions on Computation Theory (TOCT)* 6.3 (2014): 1-36. online: https://dl.acm.org/doi/abs/10.1145/2633600

**GSW**
[Gen13+] Gentry, Craig, Amit Sahai, and Brent Waters. "Homomorphic encryption from learning with errors: Conceptually-simpler, asymptotically-faster, attribute-based." *Annual cryptology conference*. Berlin, Heidelberg: Springer Berlin Heidelberg, 2013. online: https://link.springer.com/chapter/10.1007/978-3-642-40041-4_5

**FHEW**
[Duc15+] Ducas, Léo, and Daniele Micciancio. "FHEW: bootstrapping homomorphic encryption in less than a second." *Annual international conference on the theory and applications of cryptographic techniques*. Berlin, Heidelberg: Springer Berlin Heidelberg, 2015. online: https://link.springer.com/chapter/10.1007/978-3-662-46800-5_24

**vFHE**
[Kna23+] Knabenhans, Christian, et al. "vfhe: Verifiable fully homomorphic encryption." *Proceedings of the 12th Workshop on Encrypted Computing & Applied Homomorphic Cryptography*. 2023. online: https://dl.acm.org/doi/abs/10.1145/3689945.3694806

### 書籍

[岡本19] 岡本龍明，『現代暗号の誕生と発展』，近代科学社，初版第２刷，2020年3月31日．
[青野19+] 青野良範，安田雅哉，『格子暗号解読のための数学的基礎』，近代科学者，初版第１刷2019年9月30日．
[縫田20] 縫田光司，『耐量子計算機暗号』，森北出版，第１版第１刷，2020年8月7日．

### ライブラリ

### 技術ブログ

[松岡] (完全)準同型暗号の最前線1（入門編）. online: https://qiita.com/nindanaoto/items/98335ad4d32b927effa9
