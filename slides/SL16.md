---
layout: default
---

# zkVM の仕組み：実行トレースを算術化して証明する

<div class="bg-gray-50 rounded-xl border border-gray-200 px-5 py-3 max-w-6xl mx-auto mt-2 text-sm leading-relaxed" style="font-family:'JetBrains Mono',monospace">
<div class="text-gray-800">trace T &#8712; F<sup>n&#215;w</sup><span class="text-gray-400 ml-3">// n steps &#215; w cols (pc, regs, mem-ops, flags)</span></div>
<div class="text-gray-800">&#8704;i: C(T[i], T[i+1]) = 0<span class="text-gray-400 ml-3">// transition: 隣接行が ISA 規則に従う</span></div>
<div class="text-gray-800">&nbsp;&nbsp;&nbsp;&nbsp;T[0]=init,&nbsp;&nbsp;out(T[n&#8722;1])=y<span class="text-gray-400 ml-3">// boundary: 入出力を固定</span></div>
<div class="text-gray-900 font-bold mt-1">正しい実行 &#10231; 制約多項式が Z<sub>H</sub>(X)=&#8719;(X&#8722;&#969;<sup>i</sup>) で割り切れる</div>
</div>

<div class="grid grid-cols-3 gap-4 max-w-6xl mx-auto mt-4">
<div class="p-4 bg-white rounded-xl border border-gray-200 shadow-sm">
<div class="text-md font-black text-gray-900 mb-2">① 実行 → トレース表</div>
<div class="text-sm text-gray-700 leading-relaxed">エミュレータが普通のコードを 1 命令ずつ実行し、各ステップの VM 状態（PC・レジスタ・メモリ操作）を <strong>1 行</strong>として記録。n&#215;w の表になる。</div>
</div>
<div class="p-4 bg-white rounded-xl border border-gray-200 shadow-sm">
<div class="text-md font-black text-gray-900 mb-2">② 算術化（AIR）</div>
<div class="text-sm text-gray-700 leading-relaxed">各列を有限体 F 上の多項式とみなす。「正しい実行」を <strong>制約多項式の整除性</strong>に帰着 —— 隣接行制約 + 境界制約が消失多項式 Z<sub>H</sub> で割り切れるか。</div>
</div>
<div class="p-4 bg-amber-50 rounded-xl border border-amber-200">
<div class="text-md font-black text-gray-900 mb-2">③ 証明（STARK / SNARK）</div>
<div class="text-sm text-gray-700 leading-relaxed">多項式コミット + <strong>low-degree test（FRI）</strong>で整除性を簡潔に証明。verify は<strong>数点の評価のみ</strong>で再実行不要 → 小さく安価、on-chain も可。</div>
</div>
</div>

<div class="mt-4 p-3 bg-gray-50 rounded-xl border border-gray-200 max-w-6xl mx-auto text-sm text-gray-800">
<span class="text-amber-600 font-black mr-1">&#9654;</span>要点：prover は native 実行の <strong>10<sup>3</sup>&#8211;10<sup>6</sup> 倍</strong>重いのが課題。continuations / precompiles / recursion / GPU proving で実用化が進む。verify 側は一貫して軽い。
</div>

<div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">
Sources: Ben-Sasson et al. "Scalable, transparent, and post-quantum secure computational integrity (STARKs)" eprint 2018/046 ｜ RISC Zero ｜ Succinct SP1 ｜ a16zcrypto "Understanding Jolt" (2024)
</div>

<!--
Speaker Notes:
zkVM 深掘り 2/2 = 中身（前ページのアニメ pipeline を数式で裏打ちする）。
【トレース】zkVM の出発点は「実行を 1 枚の表にする」こと。エミュレータが命令を 1 つ実行するたびに、その瞬間の VM 状態（program counter, レジスタ, メモリの読み書き, opcode flag）を 1 行に書き出す。n 命令なら n 行、列数 w は VM の状態幅。
【算術化】この表の各列を有限体 F 上の多項式に補間する。「正しい実行」とは (a) 隣接する 2 行が ISA の規則どおり遷移している（transition 制約 C(T[i],T[i+1])=0）、(b) 最初と最後の行が入出力に固定されている（boundary 制約）の 2 つ。これらの制約を多項式で表すと、「制約が全行で 0 ⟺ 制約多項式が消失多項式 Z_H(X)=∏(X−ω^i) で割り切れる」に帰着する。ω は評価領域の原始根。
【証明】あとは「割り切れる（= 商多項式が存在し、しかも低次数）」ことを証明すればよい。STARK は多項式コミット + FRI による low-degree test で hash ベース・透明（trusted setup 不要）・耐量子に実現。verifier は多項式を数点だけ評価して確認するので、元の実行を再現せず安価に検証でき、proof も小さい（on-chain 可）。RISC0 は最後に Groth16 で wrap して on-chain verify をさらに安くする。
【強調】従来 ZK は回路を手書き（R1CS）していたが、zkVM は「普通のコード → トレース → 算術化」を自動化したのが画期。コストは prover の重さ（native の 10^3〜10^6 倍）。precompile（hash/楕円曲線の専用 AIR）、continuations（長い実行を分割）、recursion（多数 proof を 1 つに集約）、GPU で実用化。断定は避け「概ねこの桁」と説明。
-->
