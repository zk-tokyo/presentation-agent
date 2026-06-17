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

- 準同型暗号(Homomorphic Encryption)とは - 大雑把に言えば、暗号文のまま計算が行える暗号方式 - 平文に対して演算$\oplus$ ,暗号文に対して演算$\otimes$が可能な時、2つの暗号文$c_1=Enc(m_1), c_2=Enc(m_2)$に対して、$Dec(c_1 \otimes c_2)=m_1 \oplus m_2$が成立する - 暗号文のまま平文の加算と乗算両方は行えない。- RSA暗号やElgamal暗号は暗号文同士の乗算が平文同士の乗算になり、Paillier暗号は暗号文同士の乗算が平文同士の加算になる - 暗号文の状態での演算を準同型演算と呼ぶ。
  完全準同型暗号(Fully Homomophic Encyption, 以下FHE)は暗号文のまま加算と乗算が行える。加算と乗算が行えればNAND演算を評価できる。すなわち、平文$m_1,m_2$に対して$(1-m_1)m_2$を暗号文の状態で計算することで、平文に対するNAND演算を評価できる。そのため、暗号文のまま加算と乗算が行えれば任意の論理回路を暗号文のまま評価することできる。
  「ここにユースケースの話」。
  FHEの概念自体は1978にRSA暗号で有名なRivestらにより提唱され[RAD78]、具体的な構成方法は格子を用いた方式[Gen09]がGentryにより2009年に提案された。このGentryによる方式(Gentry's Blue Printと呼ばれることがある)では、Bootstrappingと呼ばれる操作を導入することによりFHEを実現したが、この論文におけるBootstrappigの計算量は非常に大きく、全く実用的なものではなかった。しかし、このGentryによる提案をきっかけにFHEの研究は急速に発展していき、現在に至るまでGentryの方式で用いられた格子は主要なFHEのベースになっている。特にBootstrappingはFHEに関する研究の潮流の中心にあり、Boostrappingの性能を改善する方法やBootstrapping回避する方式が数多く研究されている。

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

**近似連立方程式**
**LWE仮定とLWE問題**
**LWE暗号**
LWE暗号は共通鍵暗号としても公開鍵暗号としても構成できるが、今回は共通鍵暗号として扱う。
平文空間を$\mathbb{Z}_p$, 暗号文空間を$\mathbb{Z}_q^{k+1}$、ノイズの分布を$χ$とする。

- Gen$(1^\lambda)\to \mathbf{s} \in\{0,1\}^k$:
  - 長さ$k$のビット列を一様ランダムに取り秘密鍵$\mathbf{s}=(s_0,s_1,\dots,s_{k-1})\in \{0,1\}^k$として出力する
- Enc$(m,\mathbf{s})\to c \in \mathbb{Z}_q^{k+1}$:
  - 平文$m$に対して、$\mathbf{a}=(a_0,a_1,\dots,a_{k-1})\in \mathbb{Z}_q^k$を一様ランダムに取り、ノイズ$e$を分布$χ$から取ってきて、$c=(\mathbf{a},b=\mathbf{as}+\Delta m + e)\in \mathbf{Z}_q^{k+1}$を暗号文として出力する
  - $\mathbf{as}$は内積を表し、$\mathbf{as}=\Sigma_{i=0}^{k-1}a_is_i$
  - $\Delta$は$\Delta:=q/p$であり、スケーリングファクターと呼ばれる。
  - 以降、平文$m$の秘密鍵$\mathbf{s}$によるLWE暗号文を$\text{LWE}_{\mathbf{s}}(m)$と書く。
- Dec$(c,\mathbf{s})\to m \in \mathbb{Z}_p$:
  - $\lceil \frac{b-\mathbf{as} \text{ mod }q}{\Delta}\rfloor \text{ mod } p=\lceil \frac{\Delta m + e \text{ mod }q}{\Delta}\rfloor \text{ mod } p=\lceil m+\frac{e \text{ mod }q}{\Delta}\rfloor \text{ mod } p=m$により復号する
  - $\lceil a \rfloor$は$a$をもっとも近い整数値にする操作。要は四捨五入
  - $-\frac{\Delta}{2}\le e < \frac{\Delta}{2}$であれば正常に復号可能

**LWE暗号同士の演算**
LWE暗号文はこのままでも、平文との加算・乗算、暗号文同士の加算が可能。

- LWE暗号文と平文の加算
- LWE暗号文と平文の乗算
- LWE暗号文とLWE暗号文の加算

**LWE暗号文同士の乗算**

- BGV, BFV, CKKS
- GSW,FHEW, TFHE

#### Bootstrappingの基本概念

#### TFHEの概略

**TFHEの基本情報**

- zamaが2020年に提案した方式
- それまでの方式と比べるとBootstrappingが非常に高速かつ省メモリであり、数MBのメモリ消費でミリ秒単位で実行可能
- トーラスと呼ばれる代数構造を利用する
  - トーラスの話をするとまたややこしくなるので、レクチャーの中ではトーラスを使わない方法を扱う
- FHEWと呼ばれる方式を拡張した方式

#### Programmable Bootstrappingの概観

**多項式の剰余**

- 整数の剰余演算: 5 mod 3 = 2
- 多項式の剰余演算: $x^5 + x + 2 \;\text{mod}\; x^2 + 1 = (x^3+x)(x^2+1)+2x+1 \;\text{mod}\; x^2 + 1=2x+1$
  - $x^n \;\text{mod}\;x^n+1 = -1$
  - $x^{-a} \;\text{mod}\;x^n+1 = -x^{n-a}$

**Programmable Bootstrappingの基本アイディア**

- Lookup Table
  - あるアルゴリズムをプログラムの実行中に計算するのではなく、よく使われる値とそれに対応する出力を事前計算してテーブルを作成しておき、プログラムの実行中はそのテーブルを参照するようにすることで実行速度を上げるテクニック
  - 平文とそれに対応するノイズの少ない暗号文のテーブルを作り、暗号文のノイズを削減したい時は、その暗号文と同じ平文を持つノイズの少ない暗号文をテーブルから引っ張ってくるようにすることでBootstrappingを高速化する
- key observation
  - $f(x)=a_0+a_1x+\dots+a_{n-1}x^{n-1} \;\text{mod}\;x^n+1$を考える。これに$x^{-i}\;(0\le i\le n-1)$をかけると、$x^{-i}f(x) \;\text{mod}\;x^n+1=a_i+a_{i+1}x\dots+a_{n-1}x^{n-1-i}-a_0x^{n-i}-a_1x^{n-i+1}-\dots-(i-1)x^{n-1} \;\text{mod}\;x^n+1$
  - 多項式をLookup Tableとして使う
    - 平文空間のすべての平文を係数にエンコードした多項式$v(x)=\Sigma_{i,j} \mu_ix^{\mu_i+e_j} \;\text{mod}\; x^n+1$とノイズの増加した暗号文$\mathbf{c}=LWE_\mathbf{s}(m)=(\mathbf{a},b)$を考え、$x^{-(c-\mathbf{as})}v(x) \;\text{mod}\; x^n+1=x^{-(m+e)}v(x)\;\text{mod}\; x^n+1$として、この多項式の定数項を抜き出すと平文$m$が出てくる。この一連の処理を暗号文の状態でやる
      - Blind Rotation: ノイズの溜まった暗号文を使って多項式を回転させる
      - Sample Extraction: 回転した多項式から定数項を暗号文の状態で抜き出す
      - Key Switching: 定数項の暗号文の鍵を元の暗号文の鍵と一致させる

#### RLWEとRGSW

**RLWE暗号**
LWEの多項式版

**Gadget Decomposition**
10進と2進数の変換を思い出す$19 = 1\cdot 2^4+0\cdot2^3+0\cdot2^2+1\cdot2^1+1$。
これと似たようなことを整数の剰余に対してやるのがGadget Decomposition。
ある値$r$がmod $q$に対して、基数$B$を用いて$r = \Sigma_{i=1}^l r_1\frac{q}{B^i}$と表せるとき、$g^{-1}(r)=(r_1,r_2,\dots,r_l)$として、これをGadget Decompositionと呼ぶ。ベクトル$\mathbf{r}=(r_1,\dots,r_{k+1})$に対しては$G^{-1}(\mathbf{r})=(g^{-1}(r_1),\dots,g^{-1}(r_{k+1}))$とする。
多項式$f$に対しても同様のことを考えて、それぞれの項$a_ix^i$について$g^{-1}x^i$として、$\frac{q}{B^l}$について項をまとめ直して$f=\Sigma_{i=1}^lf_i\frac{q}{B^l}$として、$g^{-1}=(f_1,\dots,f_l)$とする。多項式のベクトル$\mathbf{f}=(f_1,\dots,f_{k+1})$についても同様に$G^{-1}(\mathbf{f})=(g^{-1}(f_1),\dots,g^{-1}(f_{k+1}))$とする。
また、以下の行列をGadget Matrixと呼ぶ。
$G^T=\begin{pmatrix}1/B & & &\\ \vdots & & &\\ 1/B^l & & &\\ & 1/B & \\ & \vdots & &\\ & 1/B^l & &\\ & & \ddots &\\ & & & 1/B\\ & & & \vdots \\ & & & 1/B^l\end{pmatrix}$

**RGSW暗号**

$\mathcal{Z}\gets \begin{pmatrix}\text{RLWE}_{\mathbf{s}}(0)\\ \text{RLWE}_{\mathbf{s}}(0)\\ \vdots \\ \text{RLWE}_{\mathbf{s}}(0)\end{pmatrix}\in \mathbb{F}_{n,q}[x]^{(k+1)l\times (k+1)}$

$\text{RGSW}_{\mathbf{s}}(m)=\mathcal{Z} + mG^T$
大雑把に言うとRLWEのリスト

**RLWEとRGSWによるexternal product**

**CMUX**
RLWEとRGSWを使うことで、$a_0,a_1\in\{0,1\}$に対して、ビット$b$によってどちらかを指定するマルチプレクサ$\text{MUX}(b,a_0,a_1)=a_b$を暗号文の状態で行えるCMUXが構成可能

#### Programmable Bootstrappingの流れ

**Blind Rotation** 暗号文の状態でのテスト多項式の回転

- 平文の状態での考え方
  - $\mathbf{a}=\left(a_0,a_1,\ldots,a_{k-1}\right),\mathbf{s}=\left(s_0,s_1,\ldots,s_{k-1}\right)$とすると、$\mathbf{as}=\Sigma_{i=0}^{k-1}a_is_i$と表せる。
  - $x^{-b+\mathbf{as}}v=x^{-b+\Sigma_{i=0}^{k-1}a_is_i}v=x^{a_{k-1}s_{k-1}}\left(x^{-b+\Sigma_{i=0}^{k-2}a_is_i}v\right)$ より、$Q_k:=x^{-b+\Sigma_{i=0}^{k-1}a_is_i}v$は$\ Q_0=x^{-b}v$として次の漸化式から求められる。$Q_j=x^{a_{j-1}s_{j-1}}Q_{j-1}=\left\{\begin{matrix}Q_{j-1}\ \ \ \ \ \ if\ s_j=0\\x^{a_j}Q_{j-1}if{\ s}_j=1\end{matrix}\right.$
  - よって$x^{-b+\mathbf{as}}v\;\text{mod}\;x^n+1$は以下のアルゴリズムから計算できる
    - $q_0 \gets x^{-b}v$
    - for $j=1\dots k$
      - $Q_j \gets \text{MUX}(s_{j-1}, Q_{j-1}, x^{a_j}Q_{j-1})$
    - return $Q_k(=x^{-b+\mathbf{as}}v)$
- これを準同型演算で記述する。すなわち、MUXをCMUXに置き換える。それに伴い、$s_j$をRGSWで暗号化し、$v$をRLWEで暗号化する
  - 正確に言うと$v$はノイズのない自明なRLWE暗号文として扱われる。すなわち、$v$を定数項以外の係数が0の多項式、aをゼロベクトルとすることで$v=\Sigma 0\cdot s + v+ 0\;\text{mod}\;x^n+1$とできるので、$v=\text{RLWE}_s(v)=(0,\dots,0,v)$とみなせる
  - $s_j$をRGSWで暗号化する鍵を$s'$とし、$(\text{RGSW}_{s'}(s_0),\dots,\text{RGSW}_{s'}(s_{k-1}))$をBootstrapping Keyと呼ぶ。
- アルゴリズム
  - $c_0 \gets x^{-b}\text{RLWE}_{s'}(v)$ (RLWE暗号文は多項式をかけることができる。)
  - for $j=1\dots k$
    - $Q_j \gets \text{CMUX}(\text{RGSW}_{s'}(s_{j-1}), Q_{j-1}, x^{a_j}Q_{j-1})$
  - return $Q_k(=\text{RLWE}_{s'}(x^{-b+\mathbf{as}}v))$

**Sample Extraction**

Blind Rotationによってテスト多項式が回転できて以下のような状態になっている。
$\text{RLWE}_{s'}(x^{-b+\mathbf{as}}v)=\text{RLWE}_{s'}(m+mx^{m+e_j}+mx^{m+e_{j+1}}+\dots+(m+1)x^{m+1+e_0}+\dots)$
これの定数項$m$を暗号文の状態で取り出す。
$\text{RLWE}_{s'}(x^{-b+\mathbf{as}}v)=(\mathbf{a}',b')$
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

**なぜ"Programmable" Bootstrappingなのか**
テスト多項式を工夫することで、ノイズを削減しながら任意の一変数関数$f$を評価できる。すなわち、
$v(x)=\Sigma_{i,j} f(\mu_i)x^{\mu_i+e_j} \;\text{mod}\; x^n+1$
のようにすると、$x^{-i}v(x)$が$0\le i \le n-1$である限り。
また、任意の多変数関数はKolmogorovの重ね合わせ定理により単変数多項式の線型結合で表現することができる

#### HomNAND

平文空間を{0,1,2,3}、暗号文空間を{0,1,2,3,4,5,6,7,8}とする。
今回は簡単のためにノイズは考えない。
二つの暗号文$c_0,c_1$に対して$(0,\dots,0,5)-c_0-c_1$を計算してからBootstrappingする。
この際、テスト多項式は
$v(x) = -1 - x + x^2 + x^3 \;\text{mod}\; x^4+1$
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
  -
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
- ホワイトボードセッションで扱ったテーマの深掘り

**少なくとも1つ選択**

1. 穴埋めしたコードの最適化とパフォーマンス比較（NTT、ビットシフトによるモジュロ演算など）
2. 既存ライブラリを使ったアプリケーションのモック作り

**オプション課題(気になる人だけ)**

- BFV/BGVの実装
- CKKSの実装

## 参考文献

### 論文

**textbook**
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

[岡本19] 岡本龍明，『現代暗号の誕生と発展』，近代科学社，2019年1月31日初版発行，初版第２刷，2020年3月31日．

### ライブラリ

### 技術ブログ

[松岡] (完全)準同型暗号の最前線1（入門編）. online: https://qiita.com/nindanaoto/items/98335ad4d32b927effa9
