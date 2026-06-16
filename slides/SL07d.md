---
layout: default
---

# LeanVM の証明システムと性能

<div class="text-sm text-gray-500 mt-1 mb-2">実行を複数のテーブルに分け、<strong>lookup</strong> で Memory に束ね、<strong>GKR grand product</strong> で結合して証明する。</div>

<div class="flex justify-center">
<img src="/images/leanvm_proof_system.png" class="max-h-[330px] rounded-xl border border-gray-200" alt="LeanVM proof system overview" />
</div>

<div class="text-center text-xs text-gray-500 mt-2 max-w-6xl mx-auto">4 テーブル（Execution / Poseidon-16 / Poseidon-24 / dot-product）を lookup で Memory に接続。<strong>Logup*</strong>（L. Soukhanov）で 1 サイクル<strong>わずか 5 要素</strong>のみコミット、多項式コミットは <strong>WHIR</strong>。<span class="inline-block w-3 h-3 align-middle rounded-sm" style="background:#cfe0f7"></span> = committed。</div>

<div class="mt-3 p-3 bg-gray-50 rounded-xl border border-gray-200 max-w-6xl mx-auto">
<div class="flex flex-wrap items-center justify-center gap-x-6 gap-y-1 text-sm text-gray-800">
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
LeanVM 構成の深掘り 2/2。証明システムと現状性能。図は leanMultisig の VM proof system overview を引用。
【テーブル分割】実行を 1 枚の巨大回路にせず、Execution table(PC/FP/メモリ index id0..id2・値 v0..v2・opcode flag)と、Poseidon-16 / Poseidon-24 / dot-product の専用テーブルに分ける。図の青セル = committed、黄 = memory 値、緑 = opcode flag(黄・緑は virtual で logup* 経由)。
【結合と圧縮】各テーブルは lookup で Memory に接続し、Grand Product を GKR で証明。Logup*(L. Soukhanov の改良 logup)により 1 サイクルで committed されるのは 5 個の field element だけ。AIR 制約は degree 5、各 opcode は 15 flag に分解。多項式コミットメントは WHIR。
【Precompiles】非交渉(必須)は Poseidon-16 と Poseidon-24(16/24 要素の置換、custom AIR table)。再帰用に dot-product(拡張体)と multilinear-eval を低複雑度で追加。
【状態と性能】compiler・feature-complete zkVM・WHIR opening の再帰プログラム・(trivial encoding 版の)XMSS 検証は実装済み。WIP は end-to-end 再帰、本番符号化(top of the hypercube)の XMSS、性能。数値: 1 再帰 WHIR opening = 0.68s、175 XMSS/s、目標 ≈5x。リポジトリ github.com/leanEthereum/leanMultisig。
-->
