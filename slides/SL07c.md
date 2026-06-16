---
layout: default
---

# LeanVM の構成：最小 VM と leanISA

<div class="text-sm text-gray-500 mt-1 mb-3">LeanVM は <strong>2 つのプログラムだけ</strong>を動かす用途特化 VM。Cairo に着想し、命令と precompile を極小に絞って形式検証と速度を両立する。</div>

<div class="grid grid-cols-2 gap-4 max-w-6xl mx-auto mb-4">
<div class="p-4 bg-white rounded-xl border border-gray-200 shadow-sm">
<div class="font-black text-gray-900 mb-1">① Aggregate — XMSS 検証</div>
<div class="text-sm text-gray-700 leading-relaxed">bitfield の整合性 ｜ メッセージ + randomness の符号化 ｜ <strong>64 本の hash chain</strong> ｜ Merkle hash</div>
</div>
<div class="p-4 bg-white rounded-xl border border-gray-200 shadow-sm">
<div class="font-black text-gray-900 mb-1">② Merge — 再帰</div>
<div class="text-sm text-gray-700 leading-relaxed">Fiat-Shamir ｜ 拡張体での演算 ｜ 大量の Sumcheck ｜ <strong>WHIR opening</strong>（Merkle・folding）</div>
</div>
</div>

<div class="grid grid-cols-3 gap-4 max-w-6xl mx-auto">
<div class="p-4 bg-amber-50 rounded-xl border border-amber-200">
<div class="font-black text-amber-700 mb-1">CPU</div>
<div class="text-sm text-gray-700 leading-relaxed">レジスタは <strong>FP（frame pointer）+ PC（program counter）</strong>のみ。AP（allocation pointer）を持たない。</div>
</div>
<div class="p-4 bg-amber-50 rounded-xl border border-amber-200">
<div class="font-black text-amber-700 mb-1">Memory</div>
<div class="text-sm text-gray-700 leading-relaxed"><strong>read-only</strong>（public + runtime）。一度書いた領域を上書きしないので証明が単純になる。</div>
</div>
<div class="p-4 bg-amber-50 rounded-xl border border-amber-200">
<div class="font-black text-amber-700 mb-1">ISA = 4 命令</div>
<div class="text-sm text-gray-700 leading-relaxed"><strong>ADD / MUL / DEREF / JUMP</strong> だけ。loop は unroll か再帰関数へ変換する。</div>
</div>
</div>

<div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">
Sources: leanEthereum "Lean VM" talk (Cambridge) ｜ github.com/leanEthereum/leanMultisig
</div>

<!--
Speaker Notes:
LeanVM 構成の深掘り 1/2。
【2 つの役割】LeanVM が動かすプログラムは実質 2 つだけ。① Aggregate = leanXMSS の署名検証(bitfield 整合性・メッセージ符号化・64 本の Winternitz hash chain・Merkle hash)。② Merge = 再帰(Fiat-Shamir・拡張体演算・多数の Sumcheck・WHIR の opening)。用途を絞るから VM を極小化できる。
【最小 VM】Cairo 着想。CPU レジスタは FP と PC のみで AP(allocation pointer)を持たない。メモリは read-only(public memory + runtime memory)で、書いた場所を上書きしないため整合性証明が単純になる(関数呼び出しもこの read-only 前提で組む)。ISA は ADD/MUL/DEREF/JUMP の 4 命令だけ。ループはコンパイル時に回数が分かり少なければ unroll、そうでなければ再帰関数へ変換する。
【狙い】命令と precompile を絞ることで AIR/制約が小さくなり、形式検証しやすく prover も速い。次ページで証明システムと性能を見る。
-->
