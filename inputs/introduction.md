---
target_audience: "Advanced Cryptography Program Week 5 受講者 (オンサイト20-25名 / 学部生〜社会人エンジニア混在 / バックグラウンドにばらつきあり)"
audience_type: group
constraints:
  max_slides: 43
  max_duration_minutes: 120
output_language: Japanese
event:
  name: "Advanced Cryptography Program — Week 5"
  parent_event: "Merkle Japan × 東京大学ブロックチェーンイノベーション寄付講座"
  date: "2026 年度"
  location: "東京大学 講義室 (オンサイト)"
---

# Advanced Cryptography Program Week 5

## レクチャー

- 講義
	- FHEの性質、種類、主要方式、課題を概観する。
	- FHEの主要方式のベースになるLWE暗号を、近似連立方程式の直感から導入する。
	- TFHEのProgrammable Bootstrappingを、LWE/RLWE/RGSW/CMUX/Blind Rotation/Sample Extraction/Key Switchingの流れで説明する。
- ホワイトボードセッション
	- 割り当てられたテーマについて調査・議論し、最重要事項と新たなクエスチョンをホワイトボードで発表する。

### 現行スライド構成

| セクション | 対応スライド | 内容 |
| --- | --- | --- |
| FHEの概要 | SL01-SL10 | 暗号方式、準同型暗号、FHEの定義、SHE/LHE/FHE、主要方式、FHEの課題 |
| LWE暗号の基礎 | SL11-SL15 | 近似連立方程式、判定LWE、共通鍵LWE暗号、LWE暗号文上の線形演算、乗算とノイズ |
| TFHE/PBSの直感 | SL16-SL21 | TFHEの基本情報、多項式の剰余、テスト多項式、リスケーリング、PBSの構成 |
| PBSの部品 | SL22-SL28 | Blind Rotation、RLWE、Gadget Decomposition、RGSW、External Product、CMUX |
| PBSの出力処理 | SL30-SL34 | Sample Extraction、Key Switching、Bootstrappingの流れ、Programmableである理由 |
| HomNAND | SL35-SL35b | 線形前処理、NAND用テスト多項式、具体例 |
| ホワイトボードセッション | SL36-SL37 | テーマ選択、調査、議論、発表 |
| 参考文献 | SL99-SL99c | 原典、主要方式、TFHE補助資料、書籍・実装資料 |

### コンテンツ

#### FHEの概要

**暗号方式**

- 暗号方式(Encryption Scheme)の定義
	- 以下の3の（確率的）多項式時間アルゴリズムの組み(Gen, Enc, Dec)は$\text{Dec}(\text{Enc}(m))=m$を満たす時、暗号方式と呼ばれる。
	    - Gen$(1^\lambda)\to key$: 鍵を生成する（鍵生成）
	    - Enc$(m, key_{enc})\to c$: 平文と鍵から暗号文を生成する（暗号化）
	    - Dec$(c, key_{dec})\to m$: 暗号文と鍵から平文を生成する（復号）
  - 共通鍵暗号と公開鍵暗号
    - 共通鍵暗号(Symmetric Key Encryption): EncとDecで同じkeyを用いる。
    - 公開鍵暗号(Public Key Encryption): Genが鍵のペア(pk,sk)を生成し、pk(公開鍵)が暗号化に使われsk(秘密鍵)が復号に使われる。Encで使うkeyがpkであり、Decで使うkeyがskである。

**FHEの概念**

- 準同型暗号(Homomorphic Encryption)とは 
	- 大雑把に言えば、暗号文のまま計算が行える暗号方式 
	- 平文に対して演算$\oplus$ ,暗号文に対して演算$\otimes$が可能な時、2つの暗号文$c_1=Enc(m_1), c_2=Enc(m_2)$に対して、$Dec(c_1 \otimes c_2)=m_1 \oplus m_2$が成立する 
		- 例えば平文に対する加算と暗号文に対する乗算が対応している場合は
	  ```mermaid
		flowchart LR
			subgraph　平文空間
				direction LR
				A[m1,m2] --> |加算| B[m1+m2]
			end
			subgraph 暗号文空間
			    direction LR
				C[c1,c2] --> |乗算| D[c1*c2]
			end  
			A -->|Enc| C
			D -->|Dec| B
	  ```

	- 加法だけ、あるいは乗法だけが使える方式を部分準同型暗号(PHE)と呼ぶことがある。FHEでは加算と乗算の両方を暗号文上で扱う。
	- RSA暗号やElgamal暗号は暗号文同士の乗算が平文同士の乗算になり、Paillier暗号は暗号文同士の乗算が平文同士の加算になる 
	- 暗号文の状態での演算を準同型演算と呼ぶ。
  完全準同型暗号(Fully Homomorphic Encryption, 以下FHE)は暗号文のまま加算と乗算が行える。加算と乗算が行えればNAND演算を評価できる。すなわち、平文$m_1,m_2\in \{0,1\}$に対して$1-m_1m_2$を暗号文の状態で計算することで、平文に対するNAND演算を評価できる。そのため、暗号文のまま加算と乗算が行えれば、理論上任意のBoolean回路を暗号文のまま評価できる。
  FHEの概念自体は1978年にRSA暗号で有名なRivestらにより提唱され[Riv78+]、具体的な構成方法は格子を用いた方式[Gen09]がGentryにより2009年に提案された。このGentryによる方式(Gentry's blueprintと呼ばれることがある)では、Bootstrappingと呼ばれる操作を導入することによりFHEを実現したが、当初の方式は計算量が非常に大きく、実用には遠かった。しかし、このGentryによる提案をきっかけにFHEの研究は急速に発展していき、現在に至るまで格子・LWE/RLWE系の構成が主要なFHEのベースになっている。特にBootstrappingはFHEに関する研究の中心にあり、Bootstrappingの性能を改善する方法や、回路深さを先に決めてBootstrappingなしで評価するleveled FHEが数多く研究されている。

**FHEのカテゴリと主要方式**
FHEにはいくつかの種類がある。

- Somewhat Homomorphic Encryption(SHE)
	- 暗号文のまま加算と乗算が有限回行える。
- Leveled Homomorphic Encryption(LHE)
	- 暗号文のままの加算と乗算をあらかじめパラメーターによって定められた回数だけBootstrappingなしに行うことができる。
- Fully Homomorphic Encryption(FHE) 
	- Bootstrappingにより、暗号文の状態で加算と乗算を制限回数なしに行える。

※この分け方の他にも世代として分類することもある。

FHEの主要方式として以下の方式が挙げられる。

- Gentry's blueprint
	- Bootstrappingを導入することで初めてFHEを構成した方式。
- BFV/BGV  
	- 整数値に対する演算を行うことのできるFHE
	- Bootstrapping自体は重たいが、準同型演算自体は比較的高速
	- Smart-Vercauteren packing/batching系の手法により、暗号文のままSIMD的な演算が可能
	- 実用上は評価したい回路深さに合わせてパラメーターを調整し、LHEとして使われることが多い
- CKKS
	- 浮動小数点などの近似値計算を準同型演算することができるFHE
	- 機械学習と相性が良く、最近盛んに研究されている。
	- BFV/BGVと同様に準同型演算が比較的高速で、主にLHEとして運用される
- GSW
	- 近似固有ベクトルの概念を利用して、暗号文を行列として扱えるようにしたLWEベースの方式
	- RGSW/TGSWとして、FHEW/TFHE系のexternal productやCMUXの部品になる
- FHEW
	- Homomorphic Accumulatorと呼ばれる考え方により、NAND/refreshのBootstrappingを1秒未満まで高速化した方式
- TFHE
	- FHEWの流れを発展させたtorus上の方式。gate bootstrappingやprogrammable bootstrappingを後半で扱う

**FHEの課題**

- 実行コスト
	- 平文から暗号文への変換により、データそのものが大きくなる
	- 暗号文同士の演算は平文同士の演算よりもはるかに重い
	- 研究によりBootstrapping1回あたりの実行速度は改善されているが、依然としてボトルネックになっている。
- 検証可能性
	- クラウドコンピューティングなどのユースケースにおいてFHEを使って計算を外部に委託した際、計算結果が正しく得られたものなのかどうか確認することができない。
	- この点はWeek 6で扱う検証可能計算・ZKとの接続点になる。
- 安全性モデル
	- FHEは暗号文を意図的に変形して別の平文の暗号文を作る機能を持つため、通常の意味でのnon-malleabilityとは相性が悪い。
	- 多くのFHE方式は基本的にCPA安全性を中心に議論される。CCA安全性が必要な応用では、利用形態や追加の認証・検証レイヤーを別途設計する必要がある。

> [!note]
> スライドでは省略しているが、実用上はパラメータ設計も大きな課題である。安全性、計算速度、ノイズ余裕、鍵サイズ、暗号文サイズの間にトレードオフがある。

#### LWE暗号

**近似連立方程式**

通常の連立方程式はGaussの消去法などで高速に解ける。一方、各式に小さな誤差が混ざった近似連立方程式では、式をたくさん集めても秘密ベクトルを直接求めることが難しくなる。個々の誤差ありの一次方程式は、誤差を$e$、ベクトルの内積を$\mathbf{as}$として

$\mathbf{as}+e=b$

のように表せる。この直感をmod $q$上で定式化したものとしてLWE問題を導入する。

**（判定）LWE問題とLWE仮定**
整数$k\ge 1$, $q \ge 2$, および$\mathbb{Z}$上の確率分布$\chi$に対して，$\mathbf{s}\in\mathbb{Z}^k_q$を固定し，$\mathbf{a}\in \mathbb{Z}_q^k$を一様ランダムに取り，$e\in \mathbb{Z}_q$を$\chi$に従ってとる．このとき$(\mathbf{a},b)\in \mathbb{Z}^{k+1}_q$が$b=\Sigma_{i=0}^{k-1} a_is_i+e \text{ mod } q$を満たす$\mathbf{a},b$の組みか、一様ランダムに選ばれた組みか識別する問題をLWE問題と呼び、この2つが計算量的に識別不可能であるという仮定をLWE仮定と呼ぶ。
> [!note] 
> LWEはLearning With Errorの略

> [!note]
> このLWE問題を判定LWE(Decision-LWE)と呼び，$b=\Sigma_{i=0}^{k-1} a_is_i+e \text{ mod } q$が成立している時に$(\mathbf{a},b)$から$\mathbf{s}$を求める場合を探索LWE(Search-LWE)と呼びわけることがある。


**LWE暗号**
LWE暗号は共通鍵暗号としても公開鍵暗号としても構成できるが、今回は共通鍵暗号としての構成を扱う。
平文空間を$\mathbb{Z}_p$, 暗号文空間を$\mathbb{Z}_q^{k+1}$、ノイズの分布を$χ$とする。

- Gen$(1^\lambda)\to \mathbf{s} \in\{0,1\}^k$:
	- 長さ$k$のビット列を一様ランダムに取り秘密鍵$\mathbf{s}=(s_0,s_1,\dots,s_{k-1})\in \{0,1\}^k$として出力する
- Enc$(\Delta m,\mathbf{s})\to c \in \mathbb{Z}_q^{k+1}$:
	- 平文$m$に対して、$\mathbf{a}=(a_0,a_1,\dots,a_{k-1})\in \mathbb{Z}_q^k$を一様ランダムに取り、ノイズ$e$を分布$χ$に基づいて$\mathbb{Z}_q$からサンプルし、$c=(\mathbf{a},b=\mathbf{as}+\Delta m + e)\in \mathbb{Z}_q^{k+1}$を暗号文として出力する。
		- $\mathbf{as}$は内積を表し、$\mathbf{as}=\Sigma_{i=0}^{k-1}a_is_i$
		- $\Delta$は$\Delta:=q/p$であり、スケーリングファクターと呼ばれる。
		- 以降、平文$m$の秘密鍵$\mathbf{s}$によるLWE暗号文を$\text{LWE}_{\mathbf{s}}(\Delta m)$と書く。
- Dec$(c,\mathbf{s})\to m \in \mathbb{Z}_p$:
	- $\left\lfloor \frac{b-\mathbf{as} \text{ mod }q}{\Delta}\right\rceil \text{ mod } p=\left\lfloor \frac{\Delta m + e \text{ mod }q}{\Delta}\right\rceil \text{ mod } p=\left\lfloor m+\frac{e \text{ mod }q}{\Delta}\right\rceil \text{ mod } p=m$により復号する
		- $\lfloor a \rceil$は$a$をもっとも近い整数値にする操作。要は四捨五入
		- $-\frac{\Delta}{2}\le e < \frac{\Delta}{2}$であれば正常に復号可能

> [!note]
> 今回$p,q$は素数である必要性がないことに注意

> [!question]
> 復号が成立することを各自確認


**LWE暗号同士の演算**
LWE暗号文はこのままでも、平文との加算・乗算、暗号文同士の加算が可能。

- LWE暗号文$(\mathbf{a},b= \mathbf{as}+\Delta m + e)$と平文$m'$の加算
	- $m'$に$\Delta$をかけて$b$に加算すれば、$m+m'$を平文とするLWE暗号文$(\mathbf{a}, \mathbf{as}+\Delta (m+m') + e)$が得られる
- LWE暗号文$(\mathbf{a},b=\mathbf{as}+\Delta m + e)$と平文$m'$の乗算
	- $\mathbf{a},b$の両方に$m'$をかければ、$mm'$を平文とするLWE暗号文$(m'\mathbf{a},  m'\mathbf{as}+\Delta mm' + em')$が得られる
- LWE暗号文$(\mathbf{a},b=\mathbf{as}+\Delta m + e)$とLWE暗号文$(\mathbf{a'},b= \mathbf{a's}+\Delta m' + e')$の加算
	- $\mathbf{a}$と$\mathbf{a'}$、$b$と$b'$をそれぞれ加算することで、$m+m'$を平文とするLWE暗号文$(\mathbf{a+a'},\mathbf{(a+a')s}+\Delta(m+m')+e+e')$が得られる
> [!question]
> これらの演算の結果得られた暗号文が正常に復号できるか各自確認

これらの操作により出力される暗号文はもとの暗号文よりもノイズが増えている。よって、暗号文に対する演算を続けると、ノイズはいずれ$-\frac{\Delta}{2}\le e < \frac{\Delta}{2}$に収まらなくなる

**LWE暗号文同士の乗算とノイズ**
- Gentry's blueprint
	- 暗号文を多項式のベクトル表現として解釈し、暗号文同士の積を多項式の積として行う
	- ノイズは指数関数的に増加する
	- 暗号文を暗号文の状態で復号することでノイズを削減する
- BGV, BFV, CKKS
	- ベクトルである暗号文同士のテンソル積を計算する
	- テンソル積により暗号文の次数・形が通常の暗号文から外れるので、Relinearization/Key Switchingで通常形へ戻す
	- BGVではModulus Switching、CKKSではRescalingがノイズ・スケール管理の中心になる。BFVでも実装上はmodulus switching/rescalingに相当するRNS・modulus管理が使われることがある
- GSW
	- 暗号文の形を工夫して行列の形で表すことで、暗号文同士の積をビット分解と行列同士の掛け算で実現しつつBootstrappingを高速化
	- ノイズの増大を抑えるためにGadget Decompositionを導入
- FHEW, TFHE
	- BootstrappingをGSWからさらに高速化
	- 特殊なBootstrappingを設計して暗号文同士をノイズを減らしながら関数評価することを可能にした
	- 平文同士の乗算は平文をbit表現し、暗号文の状態でNAND演算を組み合わせた乗算を適用することで実現可能

#### TFHEの概略

**TFHEの基本情報**

- Chillotti, Gama, Georgieva, Izabachèneらによる方式。
- それまでの方式と比べるとbootstrappingが非常に高速であり、論文中では1 bitのgate bootstrappingを約13msで実行するパラメータ例が報告されている。
- 今回はTFHEで用いられるbootstrappingをProgrammable Bootstrappingとして説明する。
- トーラスと呼ばれる代数構造を利用する
	- トーラスの話をするとややこしくなるので、レクチャーの中ではトーラスを使わない方法を扱う
	- 鍵生成、暗号化、復号は、このレクチャーではLWE暗号と同じ形で扱う
- FHEWと呼ばれる方式を拡張した方式

> [!note]
> トーラスを考えるとどんないいことがあるのか気になる人は[Chi20+],[Joy22]を読むことをお勧めする

> [!note]
> TFHEのbootstrappingは文献により呼び方が分かれる。[Chi20+]では、TLWE-to-TLWEのGate Bootstrappingと、TLWEからTGSW/TRGSW側へ戻すCircuit Bootstrappingが区別されている。この資料で主に扱うのは、入力LWE暗号文から出力LWE暗号文を作る側である。

#### Programmable Bootstrappingの概観

**多項式の剰余**

- 整数の剰余演算: 5 mod 3 = 2
- 多項式の剰余演算: $x^5 + x + 2=(x^3-x)(x^2+1)+2x+2$より、$x^5+x+2\;\text{mod}\;(x^2+1)=2x+2$
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
	  $=3(x^2+1)+4x\text{ mod }x^2+1$
	  $=4x$

**Programmable Bootstrappingの基本アイディア**


- 直感
	- Bootstrappingでやりたいことは、ノイズの増えた暗号文を、同じ平文を持つ新しい暗号文として作り直すこと。
	- PBSでは、平文の候補を係数に並べたテスト多項式を用意し、暗号文の復号式に現れる量だけ回転させる。
	- 回転後の定数項を取り出すと、目的の平文に対応する係数が得られる。
- key observation
	- $f(x)=a_0+a_1x+\dots+a_{n-1}x^{n-1} \;\text{mod}\;x^n+1$を考える。これに$x^{-i}\;(0\le i\le n-1)$をかけると、$x^{-i}f(x) \;\text{mod}\;x^n+1=a_i+a_{i+1}x\dots+a_{n-1}x^{n-1-i}-a_0x^{n-i}-a_1x^{n-i+1}-\dots-a_{i-1}x^{n-1} \;\text{mod}\;x^n+1$となり、$a_i$が定数項になる
	    - 平文空間のすべての入力に対応する出力値を係数にエンコードした多項式$v(x)$と、ノイズの増加した暗号文$\mathbf{c}=\text{LWE}_\mathbf{s}(\Delta m)=(\mathbf{a},b)$を考える。
	    - LWE暗号文は$b-\mathbf{as}= \Delta m+e$であることに着目し、$x^{-(b-\mathbf{as})}v(x) \;\text{mod}\; x^n+1$の定数項に、入力$m$に対応する係数が来るように$v(x)$を設計する。この一連の処理を暗号文の状態で行うのがBlind Rotationである。
	    - $v(x)$の次数はありえる$\Delta m +e$の値の総数、すなわち$q$にしなければならないように思えるが、実用的なパラメータでは$q$をそのまま多項式次数にするには大きすぎる。そこで、$v$の次数を$q$より小さな値$n$としておき、暗号文$(\mathbf{a},b)$に対して、$\hat{\mathbf{a}}=\left\lfloor \mathbf{a}\frac{2n}{q}\right\rceil, \hat{b}=\left\lfloor b\frac{2n}{q}\right\rceil$とすることで暗号文に対応する平文とテスト多項式の次数を対応させる（この操作をリスケーリングと呼ぶ）。
- Programmable Bootstrappingは以下の３つのサブアルゴリズムから構成される
	- Blind Rotation: ノイズの溜まった暗号文を使って暗号化された多項式を回転させる
	- Sample Extraction: 回転した多項式から定数項を暗号文の状態で抜き出す
    - Key Switching: 定数項の暗号文の鍵を元の暗号文の鍵と一致させる

**多項式を使うとうまくいくことの確認**
- 前提
平文空間:$\mathbb{Z}_8=\{0,1,2,3,4,5,6,7\}$（パディング込み）
実際に使う値:$\{0,1,2,3\}$
暗号文空間:$\{0,1,2,\dots,63\}$
スケーリングファクター:$\Delta=q/8=8$
ノイズ$e$の許容範囲:$0\le e<4$
テスト多項式の係数数:$n=16$（最高次数は15）
- 具体例
平文$m=1$、秘密鍵$\mathbf{s}=(1,0,0,1,1,1,0,1)$、エラー$e=2$
暗号文を$(\mathbf{a},b)=((8,34,4,32,0,31,58,7),24)$とすると、
$b-\mathbf{as}\equiv 10=8\cdot1+2\pmod{64}$
- テスト多項式
$v=0(1+x+x^2+x^3)+1(x^4+x^5+x^6+x^7)+2(x^8+x^9+x^{10}+x^{11})+3(x^{12}+x^{13}+x^{14}+x^{15})$
- リスケーリング後
$\hat{\Delta}=\Delta\frac{2n}{q}=4,\quad \hat{\mathbf{a}}=(4,17,2,16,0,16,29,4),\quad \hat{b}=12$
- $x^{-i}v$の計算
$i=\hat{b}-\hat{\mathbf{a}}\mathbf{s}=12-(4+16+0+16+4)\equiv4\pmod{32}$
よって、$x^{-4}v$の定数項は$x^{-4}1x^4=1x^0=1$
平文に対応する係数が定数項にきていることがわかる


#### RLWEとRGSW

**RLWE暗号**
LWEの多項式版。平文$\mu(x)$、秘密鍵$s(x)$、ノイズ$e(x)$はいずれも次数$n$未満の多項式とし、多項式の計算はすべて$\text{mod }x^n+1$で行う。

- Gen$(1^\lambda)\to s(x)$:
	- 係数が小さい多項式$s(x)=s_0+s_1x+\dots+s_{n-1}x^{n-1}$を秘密鍵として出力する。
- Enc$(\Delta\mu(x),s(x))\to (a(x),b(x))$:
	- $a(x)$を一様ランダムに取り、ノイズ$e(x)$をサンプルする。
	- $b(x)=a(x)s(x)+\Delta\mu(x)+e(x)\text{ mod } x^n+1$として、$(a(x),b(x))$を暗号文として出力する。
- Dec$((a(x),b(x)),s(x))\to \mu(x)$:
	- $b(x)-a(x)s(x)=\Delta\mu(x)+e(x)\text{ mod } x^n+1$を計算する。
	- 係数ごとに$\Delta$で割って丸める。

平文$\mu(x)$の秘密鍵$s(x)$によるRLWE暗号文を$\text{RLWE}_s(\Delta\mu)$と書く。

**Gadget Decomposition**
10進数と2進数の変換を思い出す。例：$19 = 1\cdot 2^4+0\cdot2^3+0\cdot2^2+1\cdot2^1+1$。
これと似たようなことを整数の剰余に対してやるのがGadget Decomposition。
mod $q$上のある値$r$に対して、基数$B$を用いて$r = \Sigma_{i=0}^{l-1} r_i\frac{q}{B^{i+1}}\;\;(0\le r_i < B)$と表したとき、$g^{-1}(r)=(r_0,r_1,\dots,r_{l-1})$として、この操作をGadget Decompositionと呼ぶ。ベクトル$\mathbf{r}=(r_0,\dots,r_k)$に対しては$G^{-1}(\mathbf{r})=(g^{-1}(r_0),\dots,g^{-1}(r_k))$とする。
	例：$B=4,l=3$とすると，$\mathbb{Z}_{64}$上の値47のGadget Decompositionは，
	$47=2\frac{64}{4}+3\frac{64}{16}+3\frac{64}{64}$
	より、$g^{-1}(47)=(2,3,3)$
>[!note]
>$r_i$の範囲はノイズ管理の面で$-\lfloor B/2 \rfloor \le r_i < \lceil B/2 \rceil$とすることがある。($\lfloor a\rfloor$は切り下げ、$\lceil a\rceil$は切り上げ)

多項式$f$に対しても同様のことを考えて、それぞれの項$a_ix^i$について$g^{-1}(a_i)$として、$\frac{q}{B^{i+1}}$について項をまとめ直し, $f=\Sigma_{i=0}^{l-1}f_i\frac{q}{B^{i+1}}$として、$g^{-1}(f)=(f_0,\dots,f_{l-1})$とする。
	例：$\mathbb{Z}_{16}$上のモジュラス$x^3+1$の多項式に対して$B=2, l = 4$とすると，$f=15x^2+4x+7 \text{ mod }x^3+1$をGadget Decompositionをする。
	まずそれぞれの係数に対してGadget Decompositionすると
	$g^{-1}(15)=1\frac{16}{2}+1\frac{16}{4}+1\frac{16}{8}+1\frac{16}{16}$
	$g^{-1}(4)=0\frac{16}{2}+1\frac{16}{4}+0\frac{16}{8}+0\frac{16}{16}$
	$g^{-1}(7)=0\frac{16}{2}+1\frac{16}{4}+1\frac{16}{8}+1\frac{16}{16}$
	これを$f$に代入して$\frac{16}{2^i}$ごとに整理すると
	$f=(1\frac{16}{2}+1\frac{16}{4}+1\frac{16}{8}+1\frac{16}{16})x^2+(0\frac{16}{2}+1\frac{16}{4}+0\frac{16}{8}+0\frac{16}{16})x+0\frac{16}{2}+1\frac{16}{4}+1\frac{16}{8}+1\frac{16}{16}$
	$\;=x^2\frac{16}{2}+(x^2+x+1)\frac{16}{4}+(x^2+1)\frac{16}{8}+(x^2+1)\frac{16}{16}$
	ゆえに、
	$g^{-1}(f)=(x^2,x^2+x+1,x^2+1,x^2+1)$

多項式のベクトル$\mathbf{f}=(f_0,\dots,f_k)$についても同様に$G^{-1}(\mathbf{f})=(g^{-1}(f_0),\dots,g^{-1}(f_k))$とする。
また、以下のような行列をGadget Matrixと呼ぶ。
$G^T=\begin{pmatrix}q/B & & \\ \vdots & & \\ q/B^l & & \\ & q/B & \\ & \vdots & \\ & q/B^l \end{pmatrix}$
もし$B^l=q$ならば、$G^{-1}(\mathbf{f})G^T=\mathbf{f}$が成り立つ。

**RGSW暗号**

$\mathcal{Z}\gets \begin{pmatrix}\text{RLWE}_{s}(0)\\ \text{RLWE}_{s}(0)\\ \vdots \\ \text{RLWE}_{s}(0)\end{pmatrix}$（RLWE暗号文のリスト）とすると、平文$m$の秘密鍵$s(x)$によるRGSW暗号文は

$\text{RGSW}_{s}(m)=\mathcal{Z} + mG^T$
大雑把に言うとRLWEのリスト

**RLWEとRGSWによるexternal product**
多項式のベクトルに対するGadget Decompositionにより、RGSW暗号文とRLWE暗号文の積(External Product)$\boxdot$を定義する
$\text{RGSW}_{s}(m)\boxdot \text{RLWE}_{s}(\Delta m')=G^{-1}(\text{RLWE}_{s}(\Delta m')) \text{RGSW}_{s}(m)=\text{RLWE}_{s}(\Delta mm')$

**CMUX**
RLWEとRGSWを使うことで、$a_0,a_1\in\{0,1\}$に対して、ビット$b$によってどちらかを指定するマルチプレクサ$\text{MUX}(b,a_0,a_1)=a_b$を暗号文の状態で行えるCMUXが構成可能
マルチプレクサは$\text{MUX}(b,a_0,a_1)=(1-b)a_0+ba_1=b(a_1-a_0)+a_0$より計算できるので、それぞれ、$c_0=\text{RLWE}_{s}(\Delta a_0),c_1=\text{RLWE}_{s}(\Delta a_1), c_b=\text{RGSW}_{s}(b)$とすると、$\text{CMUX}(c_b,c_0,c_1)=c_b\boxdot(c_1-c_0)+c_0=\text{RLWE}_{s}(\Delta a_b)$

>[!question]
  CMUXの出力が$a_b$のRLWE暗号文になることを各自確認

#### Programmable Bootstrappingの流れ




**Blind Rotation** 暗号文の状態でのテスト多項式の回転

**平文の状態での考え方** 
$\mathbf{a}=\left(a_0,a_1,\ldots,a_{k-1}\right),\mathbf{s}=\left(s_0,s_1,\ldots,s_{k-1}\right)$とすると、$\mathbf{as}=\Sigma_{i=0}^{k-1}a_is_i$と表せる。
$x^{-b+\mathbf{as}}v=x^{-b+\Sigma_{i=0}^{k-1}a_is_i}v=x^{a_{k-1}s_{k-1}}\left(x^{-b+\Sigma_{i=0}^{k-2}a_is_i}v\right)$ より、$Q_k:=x^{-b+\Sigma_{i=0}^{k-1}a_is_i}v$は$\ Q_0=x^{-b}v$として次の漸化式から求められる。$Q_{j+1}=x^{a_js_j}Q_j=\left\{\begin{matrix}Q_j\;\;\;\;\text{ if }\ s_j=0\\x^{a_j}Q_j\text{ if } s_j=1\end{matrix}\right.$
  よって$x^{-b+\mathbf{as}}v\;\text{mod}\;x^n+1$は以下のアルゴリズムから計算できる
- $Q_0 \gets x^{-b}v$
- for $j=0\dots k-1$
	- $Q_{j+1} \gets \text{MUX}(s_j, Q_j, x^{a_j}Q_j)$
- return $Q_k\;(=x^{-b+\mathbf{as}}v)$
これを準同型演算で記述する。すなわち、MUXをCMUXに置き換える。それに伴い、$s_j$をRGSWで暗号化し、$v$をRLWEで暗号化する

>[!note]
>正確に言うと$v(x)$はノイズのない「自明な」RLWE暗号文として扱われる。$v(x)$自体は任意のテスト多項式でよく、$a(x)=0$とすることで$\text{RLWE}_{s'}(\Delta v)=(0,\Delta v)$とみなせる。


> [!note]
> $s_j$をRGSWで暗号化するための鍵を$s'$とし、$(\text{RGSW}_{s'}(s_0),\dots,\text{RGSW}_{s'}(s_{k-1}))$をBootstrapping Keyと呼ぶ。



**Blind Rotationのアルゴリズム**
- $\hat{\mathbf{a}}\gets\left\lfloor \mathbf{a}\frac{2n}{q}\right\rceil$
- $\hat{b}\gets \left\lfloor b\frac{2n}{q}\right\rceil$
- $Q_0 \gets x^{-\hat{b}}\text{RLWE}_{s'}(\Delta v)$ (RLWE暗号文は多項式をかけることができる。)
- for $j=0\dots k-1$
	- $Q_{j+1} \gets \text{CMUX}(\text{RGSW}_{s'}(s_j), Q_j, x^{\hat{a}_j}Q_j)$
- return $Q_k(=\text{RLWE}_{s'}(\Delta x^{-\hat{b}+\mathbf{\hat{a}s}}v))$



> [!question]
> $x^i \text{ mod } x^n+1$にはnegacyclicと呼ばれる性質があり、$i \ge n$のとき、$x^i \text{ mod }x^n+1 = -x^{i-n}$となり、係数の符号が反転してしまう。仮にBlind Rotationでこれが起こるとなぜ問題なのか、そしてどのようすればこれを回避できるだろうか。

**Sample Extraction**

Blind Rotationによってテスト多項式が回転できて以下のような状態になっている。
$\text{RLWE}_{s'}(\Delta x^{-\hat{b}+\mathbf{\hat{a}s}}v)=\text{RLWE}_{s'}(\Delta(m+\mu_1x+\mu_2x^2+\dots+\mu_{n-1}x^{n-1}))$
これの定数項$m$を暗号文の状態で取り出す。
$\text{RLWE}_{s'}(\Delta x^{-\hat{b}+\mathbf{\hat{a}s}}v)=(a'(x),b'(x))$
$\mu(x)=m+\mu_1x+\mu_2x^2+\dots+\mu_{n-1}x^{n-1}$
とすると、
$b'=b_0'+b_1'x +\dots+b_{n-1}'x^{n-1}=a'(x)s'(x)+\Delta\mu+e$
$=(a'_0+a'_1x+\dots+a'_{n-1}x^{n-1})(s'_0+s'_1x+\dots+s'_{n-1}x^{n-1})$
$\;\;\;+\Delta(m+\mu_1x+\mu_2x^2+\dots+\mu_{n-1}x^{n-1})$
$\;\;\;+(e_0+e_1x+\dots+e_{n-1}x^{n-1})$
この定数項$b'_0$から、$m$を平文とするLWE暗号文を構成できる。
$x^n \;\text{mod}\;x^n+1 = -1$に注意すると、$(a'_0+a'_1x+\dots+a'_{n-1}x^{n-1})(s'_0+s'_1x+\dots+s'_{n-1}x^{n-1})$の定数項は$a'(x)$と$s'(x)$の係数を配置しなおしたベクトル$\mathbf{a''}=(a'_0,-a'_{n-1},-a'_{n-2},\dots,-a'_1)$
$\mathbf{s''}=(s'_0,s'_1,\dots,s'_{n-1})$
を用いて
$b'_0=\mathbf{a''s''}+\Delta m+e_0$
と表せる。よって、$\mathbf{s''}$によるLWE暗号文$\text{LWE}_{s''}(\Delta m)=(\mathbf{a''},b'_0)$が構成できる。

> [!note]
> $\mathbf{a''}$にマイナスが現れるのは、環が$\mathbb{Z}_q[x]/(x^n+1)$であり、$x^n=-1$として折り返されるためである。積の中で次数が$n$以上になった項は定数項へ寄与するときに符号が反転する。

**Sample Extractionのアルゴリズム**

**Key Switching**

Sample Extractionで得られた暗号文$(\mathbf{a''},b'_0)$は$\mathbf{s''}$による暗号文なので、これを$\mathbf{s}$による暗号文に変換する。
わかりやすさのために$\mathbf{a''}$と$\mathbf{s''}$を
$\mathbf{a''}=(a''_{0},a''_{1},\dots,a''_{n-1})$
$\mathbf{s''}=(s''_{0},s''_{1},\dots,s''_{n-1} )$
と書き直しておく。
$\mathbf{a''}$のGadget Decomposition $G^{-1}(\mathbf{a''})=(g^{-1}(a''_0),\dots,g^{-1}(a''_{n-1}))$を考え、$g^{-1}(a''_i)=(\bar{a}_{i,0},\dots,\bar{a}_{i,l-1})$
とする。さらに、
$ksk[i,j]=\text{LWE}_\mathbf{s}(s''_i q/B^{j+1})(0\le i \le n-1, 0 \le j \le l-1)$ (これをKey switching keyと呼ぶ)を考えると、目的の$\mathbf{s}$による$m$の暗号文$\text{LWE}_\mathbf{s}(\Delta m)$は次のように計算できる。
$\text{LWE}_\mathbf{s}(\Delta m)\gets (0,\dots,0,b'_0)-\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\bar{a}_{i,j}ksk[i,j]$
なぜこれでうまくいくのか?
以下のように変形する。
$\text{LWE}_\mathbf{s}(\Delta m)= (0,\dots,0,b'_0)-\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\bar{a}_{i,j}ksk[i,j]$
$=(0,\dots,0,b'_0)-\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\bar{a}_{i,j}\text{LWE}_\mathbf{s}(s''_iq/B^{j+1})$
$=(0,\dots,0,b'_0)-\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\text{LWE}_\mathbf{s}(\bar{a}_{i,j}s''_iq/B^{j+1})$
$=(0,\dots,0,b'_0)-\text{LWE}_\mathbf{s}(\Sigma^{n-1}_{i=0}\Sigma^{l-1}_{j=0}\bar{a}_{i,j}s''_iq/B^{j+1})$
$=(0,\dots,0,b'_0)-\text{LWE}_\mathbf{s}(\Sigma^{n-1}_{i=0}a''_{i}s''_i)$
$=(0,\dots,0,b'_0)-\text{LWE}_\mathbf{s}(\mathbf{a''s''})$
ここで$\text{LWE}_\mathbf{s}(\mathbf{a''s''})=(\tilde{\mathbf{a}},\tilde{\mathbf{a}}\mathbf{s} + \mathbf{a''s''} + \tilde{e})$と表すと、
$(0,\dots,0,b'_0)-\text{LWE}_\mathbf{s}(\mathbf{a''s''})$
$=(0,\dots,0,\mathbf{a''s''}+\Delta m+e_0)-(\tilde{\mathbf{a}},\tilde{\mathbf{a}}\mathbf{s} + \mathbf{a''s''} + \tilde{e})$
$=(-\tilde{\mathbf{a}},-\tilde{\mathbf{a}}\mathbf{s} + \Delta m +e_0 - \tilde{e})$
これは秘密鍵$\mathbf{s}$による$m$の暗号文になっている

**Key Switchingのアルゴリズム**

**Programmable Bootstrappingのアルゴリズム**

**なぜ"Programmable" Bootstrappingなのか**
通常のBootstrappingでは、テスト多項式の係数に入力$m$を並べ、Blind Rotation後の定数項から$m$を取り出す。Programmable Bootstrappingでは、同じ係数位置に$m$ではなく$f(m)$を置く。これにより、暗号文を作り直す処理と同時に一変数関数$f$を評価できる。

平文$m$と許容するノイズ$e$に対応する係数位置を
$r(m,e):=\left\lfloor(\Delta m+e)\frac{2n}{q}\right\rceil\bmod 2n$
とする。$r(m,e)<n$ならテスト多項式$v(x)=\Sigma_{i=0}^{n-1}v_ix^i$の係数を$v_{r(m,e)}=f(m)$、$r(m,e)\ge n$なら$v_{r(m,e)-n}=-f(m)$と設定する。Blind Rotationによってこの係数が定数項へ移るため、最終的に$\text{LWE}_{\mathbf{s}}(\Delta f(m))$が得られる。

係数を並べる際には、$\mathbf{a}$と$b$を別々に丸めることで回転先が少しずれる場合にも同じ$f(m)$を取り出せるよう、同じ出力値を持つ係数に幅を持たせる。また、異なる入力が同じ係数位置に来る場合は、そこで必要な出力値が一致していなければならない。回転先が$n$以上になると係数の符号が反転するため、入力範囲に余白を設けるか、この符号反転と整合するように関数を設計する。一般の関数では、入力範囲の分割や複数回のPBSが必要になる場合がある。


#### HomNAND

ここではトーラス表現を使わず、平文空間を$\mathbb{Z}_p$、暗号文の係数を$\mathbb{Z}_q$とするtoy exampleとして説明する。
TFHE論文の標準的なHomNANDは$\{0,1/4\}$のエンコードと$(0,5/8)-c_1-c_2$を使うが、課題では入出力を同じ形式に保ち、全係数が$1$のテスト多項式を使うため、bitを次のようにエンコードする。

- bit $0 \mapsto p-1$
- bit $1 \mapsto 1$

$p-1\equiv-1\pmod p$である。2つの入力暗号文$c_1,c_2$がそれぞれ$m_1,m_2\in\{p-1,1\}$を暗号化しているとき、

$c=(0,\dots,0,\Delta)-c_1-c_2$

を計算する。ここで$(0,\dots,0,\Delta)$はノイズのない自明な暗号文である。平文レベルでは$r=1-m_1-m_2\pmod p$となる。

| 入力bit | $m_1$ | $m_2$ | $r$ | NAND | PBS後の平文 |
| --- | ---: | ---: | ---: | ---: | ---: |
| $(0,0)$ | $p-1$ | $p-1$ | $3$ | $1$ | $1$ |
| $(1,0)$ | $1$ | $p-1$ | $1$ | $1$ | $1$ |
| $(0,1)$ | $p-1$ | $1$ | $1$ | $1$ | $1$ |
| $(1,1)$ | $1$ | $1$ | $p-1$ | $0$ | $p-1$ |

課題では

$p=8,\quad q=32,\quad n=16,\quad q=2n,\quad \Delta=q/p=4$

とする。入力LWE暗号文のノイズは$e\in\{0,1\}$であり、2つの入力ノイズの和を$d\in\{0,1,2\}$とすると、線形前処理後の暗号文は$\Delta r-d$を持つ。
$q=2n$なので、Blind Rotationの番号は$i=b-\mathbf{a}\mathbf{s}\pmod q$としてLWE暗号文からそのまま得られる。各入力に対応する番号は次の範囲になる。

| 入力bit | $r$ | $i=\Delta r-d\pmod q$ |
| --- | ---: | --- |
| $(0,0)$ | $3$ | $10,11,12$ |
| $(1,0),(0,1)$ | $1$ | $2,3,4$ |
| $(1,1)$ | $7$ | $26,27,28$ |

テスト多項式は$\mathbb{Z}_8[x]/(x^{16}+1)$上の

$v(x)=1+x+x^2+\dots+x^{15}$

とする。$0\le i<16$では$x^{-i}v(x)$の定数項は$1$になり、$i=16+j$では$x^{-(16+j)}v(x)=-x^{-j}v(x)$なので定数項は$-1\equiv7\pmod8$になる。
したがって、PBS後の平文はNANDが$1$なら$1$、NANDが$0$なら$p-1$となり、出力暗号文を同じエンコードのまま次のHomNANDへ渡せる。

### 補足事項

スライドでは初学者向けに省略しているが、理解や厳密さのために以下を押さえる。

- TFHEの本来の記法はtorus上のTLWE/TGSW/TRLWEであり、この資料では整数mod $q$にスケールしたLWE/RLWE/RGSW風の記法へ置き換えている。式の形を追うための簡略化であり、実装上の表現そのものではない。
- PBSは「古いノイズを直接小さくする」操作ではなく、復号式に相当する処理を暗号文のまま行い、同じ平文または指定した関数値を持つ新しい暗号文を作る操作である。出力ノイズはBlind RotationやKey Switchingで新たに入るノイズに支配され、入力暗号文の大きくなったノイズそのものを引き継がない。ただし、入力ノイズがテスト多項式の正しい区間を越えると復号結果が変わる。
- Sample Extractionは、回転後のRLWE暗号文の定数項をLWE形式で読み替える処理であり、TFHE論文でもこの段階自体は追加ノイズを入れないと説明される。Key Switchingでは鍵を戻す代わりにkey switching key由来のノイズが加わる。
- $x^n+1$を法とする環では$x^n=-1$なので、回転が半周を超えると係数の符号が反転する。HomNANDのスライドでは、$p=8,q=32,n=16$の具体例で、全係数が$1$の多項式から$1$と$p-1$が得られることを明示する。
- PBSのテスト多項式で直接指定できるのは基本的に一変数のLUTである。多変数関数は、HomNANDのように入力暗号文の線形結合で一変数の参照値に落とす、ビット分解する、ゲートやLUTを合成する、といった形で扱う。
- RGSW/TGSWは、CMUXやexternal productで使う制御用暗号文として見るとよい。任意の暗号文同士の一般的な乗算を安くする万能部品ではなく、暗号化された選択ビットでRLWE暗号文を切り替えるための部品として導入している。

## ホワイトボードセッション

10グループに分かれ、テーマリストから選んで（当日はランダムで割り当てるかも）調査、議論、発表

- イントロ 5分
- 調査＋議論 1時間50分
- 発表 1時間(=6分x10)
  - 発表は調査結果の最重要事実と問題提起で構成する

### テーマリスト

以下の中から割り当てる。

- **FHEの安全性**
- **BGV/BFVの仕組み**
- **CKKSの仕組み**
- **FHEの実装ライブラリ比較**
- **LWE以外の方式に基づくFHE**
- **機械学習へのFHEの応用**
- **ブロックチェーンへのFHEの応用**
- **他のConfidential Computing（MPC, GC, TEE）との比較**

## 実装課題

- ホワイトボードセッションで発生したクエスチョンの調査と回答（提出不要）
- コードの穴埋め課題

## 参考文献

### 論文

**LWEベースのFHEの仕組みを証明などを省いて解説している資料**
[Ko25] Ko, Ronny. "The Beginner's Textbook for Fully Homomorphic Encryption." *arXiv preprint arXiv:2503.05136* (2025). online: https://arxiv.org/abs/2503.05136

**FHEの概念の初出**
[Riv78+] Ronald L. Rivest, Len Adleman, and Michael L. Dertouzos. On data banks and privacy homomorphisms. In R. A. DeMillo et al., editors, Foundations of Secure Computation, pages 165–179. Academic Press, 1978. online: https://people.csail.mit.edu/rivest/pubs.html#RAD78.

**部分準同型暗号の原典**
[RSA78] Ronald L. Rivest, Adi Shamir, and Leonard Adleman. "A Method for Obtaining Digital Signatures and Public-Key Cryptosystems." *Communications of the ACM* 21.2 (1978): 120–126. online: https://doi.org/10.1145/359340.359342

[ElG85] Taher ElGamal. "A Public Key Cryptosystem and a Signature Scheme Based on Discrete Logarithms." *IEEE Transactions on Information Theory* 31.4 (1985): 469–472. online: https://doi.org/10.1109/TIT.1985.1057074

[Pai99] Pascal Paillier. "Public-Key Cryptosystems Based on Composite Degree Residuosity Classes." *EUROCRYPT 1999* (1999): 223–238. online: https://doi.org/10.1007/3-540-48910-X_16

**Gentry's blueprint**
[Gen09] Gentry, Craig. "Fully homomorphic encryption using ideal lattices." *Proceedings of the forty-first annual ACM symposium on Theory of computing*. 2009. online: https://dl.acm.org/doi/abs/10.1145/1536414.1536440

**LWE / Ring-LWE**
[Reg05] Oded Regev. "On Lattices, Learning with Errors, Random Linear Codes, and Cryptography." *STOC 2005* (2005): 84–93. online: https://doi.org/10.1145/1060590.1060603

[LPR10] Vadim Lyubashevsky, Chris Peikert, and Oded Regev. "On Ideal Lattices and Learning with Errors over Rings." *EUROCRYPT 2010* (2010): 1–23. online: https://doi.org/10.1007/978-3-642-13190-5_1

**初期のFHE・BFV系**
[SV10] Nigel P. Smart and Frederik Vercauteren. "Fully Homomorphic Encryption with Relatively Small Key and Ciphertext Sizes." *PKC 2010* (2010): 420–443. online: https://doi.org/10.1007/978-3-642-13013-7_25

[Bra12] Zvika Brakerski. "Fully Homomorphic Encryption without Modulus Switching from Classical GapSVP." *CRYPTO 2012* (2012): 868–886. online: https://doi.org/10.1007/978-3-642-32009-5_50

**TFHE**
[CGGI16] Ilaria Chillotti, Nicolas Gama, Mariya Georgieva, and Malika Izabachène. "Faster Fully Homomorphic Encryption: Bootstrapping in Less Than 0.1 Seconds." *ASIACRYPT 2016* (2016): 3–33. online: https://doi.org/10.1007/978-3-662-53887-6_1

[Chi20+] Chillotti, Ilaria, Nicolas Gama, Mariya Georgieva, and Malika Izabachène. "TFHE: Fast Fully Homomorphic Encryption over the Torus." *Journal of Cryptology* 33.1 (2020): 34-91. online: https://doi.org/10.1007/s00145-019-09319-x

[Joy22] Joye, Marc. "SoK: Fully Homomorphic Encryption over the [Discretized] Torus." *IACR Transactions on Cryptographic Hardware and Embedded Systems* 2022.4 (2022): 661-692. online: https://doi.org/10.46586/tches.v2022.i4.661-692

[Mic21] Daniele Micciancio and Yuriy Polyakov. "Bootstrapping in FHEW-like Cryptosystems." *WAHC 2021* (2021). online: https://doi.org/10.1145/3474366.3486924

**CKKS**
[Che17+] Cheon, Jung Hee, et al. "Homomorphic encryption for arithmetic of approximate numbers." *International conference on the theory and application of cryptology and information security*. Cham: Springer International Publishing, 2017. online: https://link.springer.com/chapter/10.1007/978-3-319-70694-8_15

**BFV**
[Fan12+] Fan, Junfeng, and Frederik Vercauteren. "Somewhat practical fully homomorphic encryption." *Cryptology ePrint Archive* (2012). online: https://eprint.iacr.org/2012/144

**BGV**
[Bra14+] Brakerski, Zvika, Craig Gentry, and Vinod Vaikuntanathan. "(Leveled) fully homomorphic encryption without bootstrapping." *ACM Transactions on Computation Theory (TOCT)* 6.3 (2014): 1-36. online: https://dl.acm.org/doi/abs/10.1145/2633600

**GSW**
[Gen13+] Gentry, Craig, Amit Sahai, and Brent Waters. "Homomorphic encryption from learning with errors: Conceptually-simpler, asymptotically-faster, attribute-based." *Annual cryptology conference*. Berlin, Heidelberg: Springer Berlin Heidelberg, 2013. online: https://link.springer.com/chapter/10.1007/978-3-642-40041-4_5

**FHEW**
[Duc15+] Ducas, Léo, and Daniele Micciancio. "FHEW: bootstrapping homomorphic encryption in less than a second." *Annual international conference on the theory and applications of cryptographic techniques*. Berlin, Heidelberg: Springer Berlin Heidelberg, 2015. online: https://link.springer.com/chapter/10.1007/978-3-662-46800-5_24

**vFHE**
[Kna24] Christian Knabenhans, Alexander Viand, Antonio Merino-Gallardo, and Anwar Hithnawi. "vFHE: Verifiable Fully Homomorphic Encryption." *Proceedings of the 12th Workshop on Encrypted Computing & Applied Homomorphic Cryptography* (WAHC 2024): 11–22. online: https://doi.org/10.1145/3689945.3694806

### 書籍

[岡本19] 岡本龍明，『現代暗号の誕生と発展』，近代科学社，初版第２刷，2020年3月31日．
[青野19+] 青野良範，安田雅哉，『格子暗号解読のための数学的基礎』，近代科学社，初版第１刷2019年9月30日．
[縫田20] 縫田光司，『耐量子計算機暗号』，森北出版，第１版第１刷，2020年8月7日．

### ライブラリ
- OpenFHE https://openfhe.org/downloads/
### 技術ブログ

[松岡] (完全)準同型暗号の最前線1（入門編）. online: https://qiita.com/nindanaoto/items/98335ad4d32b927effa9
