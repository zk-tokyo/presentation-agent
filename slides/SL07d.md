---
layout: default
---

# LeanVM の証明システムと性能

<div class="text-sm text-gray-500 mt-1 mb-3">実行を複数のテーブルに分け、<strong>lookup</strong> で結合して証明する。コミット量を絞る工夫で prover を軽くしている。</div>

<div class="grid grid-cols-3 gap-4 max-w-6xl mx-auto">
<div class="p-4 bg-white rounded-xl border border-gray-200 shadow-sm">
<div class="font-black text-gray-900 mb-1">テーブル分割</div>
<div class="text-sm text-gray-700 leading-relaxed">Execution table（PC / FP / メモリ index・値 / opcode flag）と、専用の <strong>Poseidon-16 / Poseidon-24 / dot-product</strong> テーブル。</div>
</div>
<div class="p-4 bg-white rounded-xl border border-gray-200 shadow-sm">
<div class="font-black text-gray-900 mb-1">結合と圧縮</div>
<div class="text-sm text-gray-700 leading-relaxed">テーブルを <strong>lookup + GKR grand product</strong> で接続。<strong>Logup*</strong>（L. Soukhanov）で 1 サイクルあたり<strong>わずか 5 要素</strong>だけコミット。多項式コミットは WHIR。</div>
</div>
<div class="p-4 bg-amber-50 rounded-xl border border-amber-200">
<div class="font-black text-amber-700 mb-1">Precompiles</div>
<div class="text-sm text-gray-700 leading-relaxed">必須 = <strong>Poseidon-16 / Poseidon-24</strong>（16・24 要素の置換）。再帰用に dot-product と multilinear-eval を低複雑度で追加。</div>
</div>
</div>

<div class="mt-4 p-4 bg-gray-50 rounded-xl border border-gray-200 max-w-6xl mx-auto">
<div class="flex flex-wrap items-center gap-x-6 gap-y-1 text-sm text-gray-800">
<span><span class="text-green-600 font-black mr-1">&#10003;</span>feature-complete な zkVM・コンパイラを実装済み</span>
<span><span class="text-amber-600 font-black mr-1">&#9654;</span>再帰 WHIR opening = <strong>0.68 秒</strong></span>
<span><span class="text-amber-600 font-black mr-1">&#9654;</span>現状 <strong>175 XMSS/秒</strong>、目標は <strong>約 5x 高速化</strong></span>
</div>
</div>

<div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">
Sources: leanEthereum "Lean VM" talk (Cambridge) ｜ Logup* (L. Soukhanov) ｜ WHIR ｜ github.com/leanEthereum/leanMultisig
</div>

<!--
Speaker Notes:
LeanVM 構成の深掘り 2/2。証明システムと現状性能。
【テーブル分割】実行を 1 枚の巨大回路にせず、Execution table(PC/FP/メモリ index id0..id2・値 v0..v2・opcode flag)と、Poseidon-16 / Poseidon-24 / dot-product の専用テーブルに分ける。
【結合と圧縮】各テーブルは lookup で結び、Grand Product を GKR で証明。Logup*(L. Soukhanov の改良 logup)により 1 サイクルで committed されるのは 5 個の field element だけ(memory index と opcode は logup* で memory / bytecode に流す)。AIR 制約は degree 5、各 opcode は 15 flag に分解。多項式コミットメントは WHIR。
【Precompiles】非交渉(必須)は Poseidon-16 と Poseidon-24(16/24 要素の置換、custom AIR table)。再帰のために dot-product(拡張体)と multilinear-eval を追加するが、1 再帰あたり multilinear-eval は 2 回だけ等、低複雑度に保つ。
【状態と性能】compiler・feature-complete zkVM・WHIR opening の再帰プログラム・(trivial encoding 版の)XMSS 検証は実装済み。WIP は end-to-end 再帰、本番符号化(top of the hypercube)の XMSS、性能。数値: 1 再帰 WHIR opening = 0.68s、175 XMSS/s、目標 ≈5x。リポジトリ github.com/leanEthereum/leanMultisig。
-->
