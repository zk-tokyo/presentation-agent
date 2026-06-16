---
layout: default
---

# LeanVM の構成：最小 VM と leanISA

<div class="text-sm text-gray-500 mt-1 mb-3">LeanVM は <strong>2 つのプログラムだけ</strong>を動かす用途特化 VM。Cairo に着想し、命令と precompile を極小に絞って形式検証と速度を両立する。</div>

<div class="grid grid-cols-2 gap-4 max-w-6xl mx-auto mb-3">
<div class="p-3 bg-white rounded-xl border border-gray-200 shadow-sm">
<div class="font-black text-gray-900 mb-1">① Aggregate — XMSS 検証</div>
<div class="text-sm text-gray-700 leading-relaxed">bitfield 整合性 ｜ メッセージ + randomness 符号化 ｜ <strong>64 本の hash chain</strong> ｜ Merkle hash</div>
</div>
<div class="p-3 bg-white rounded-xl border border-gray-200 shadow-sm">
<div class="font-black text-gray-900 mb-1">② Merge — 再帰</div>
<div class="text-sm text-gray-700 leading-relaxed">Fiat-Shamir ｜ 拡張体の演算 ｜ 大量の Sumcheck ｜ <strong>WHIR opening</strong></div>
</div>
</div>

<div class="flex justify-center">
<img src="/images/leanvm_vm_overview.png" class="max-h-[250px] rounded-xl border border-gray-200" alt="LeanVM VM overview" />
</div>

<div class="text-center text-xs text-gray-500 mt-2 max-w-6xl mx-auto">レジスタは <strong>FP / PC のみ</strong>（AP なし）｜ メモリは <strong>read-only</strong>（public + runtime）｜ ISA は <strong>ADD / MUL / DEREF / JUMP</strong> の 4 命令だけ</div>

<div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">
Sources: leanEthereum "Lean VM" talk (Cambridge) ｜ github.com/leanEthereum/leanMultisig
</div>

<!--
Speaker Notes:
LeanVM 構成の深掘り 1/2。図は leanMultisig の VM Overview を引用。
【2 つの役割】LeanVM が動かすプログラムは実質 2 つ。① Aggregate = leanXMSS の署名検証(bitfield 整合性・メッセージ符号化・64 本の Winternitz hash chain・Merkle hash)。② Merge = 再帰(Fiat-Shamir・拡張体演算・多数の Sumcheck・WHIR の opening)。用途を絞るから VM を極小化できる。
【最小 VM】Cairo 着想。CPU レジスタは FP と PC のみで AP(allocation pointer)を持たない。メモリは read-only(public memory + runtime memory)で、書いた場所を上書きしないため整合性証明が単純(関数呼び出しもこの read-only 前提で組む)。ISA は ADD/MUL/DEREF/JUMP の 4 命令だけ。bytecode 例のとおり各命令は m[fp + const] を引数に取る。ループはコンパイル時に回数が小さければ unroll、そうでなければ再帰関数へ変換。
【狙い】命令と precompile を絞ることで AIR/制約が小さくなり、形式検証しやすく prover も速い。次ページで証明システムと性能を見る。
-->
