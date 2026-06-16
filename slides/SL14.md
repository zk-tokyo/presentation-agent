---
layout: default
---

# zkVM：任意プログラムの実行を証明する

<div class="text-sm text-gray-500 mt-1 mb-4">回路を手書きせず、<strong>普通のコード（Rust など）の実行</strong>を succinct proof に変換。verifier は<strong>再実行せず</strong>正しさを検証できる。</div>

<div class="flex items-stretch justify-center gap-2 max-w-6xl mx-auto text-center">
<div class="flex-1 p-3 bg-white rounded-xl border border-gray-200 shadow-sm"><div class="font-black text-gray-900 text-sm">Rust / C</div><div class="text-xs text-gray-500 mt-1">普通のプログラム</div></div>
<div class="self-center text-amber-500 font-black">&rarr;</div>
<div class="flex-1 p-3 bg-white rounded-xl border border-gray-200 shadow-sm"><div class="font-black text-gray-900 text-sm">RISC-V ELF</div><div class="text-xs text-gray-500 mt-1">VM ISA にコンパイル</div></div>
<div class="self-center text-amber-500 font-black">&rarr;</div>
<div class="flex-1 p-3 bg-white rounded-xl border border-gray-200 shadow-sm"><div class="font-black text-gray-900 text-sm">実行トレース</div><div class="text-xs text-gray-500 mt-1">1 命令ずつ記録</div></div>
<div class="self-center text-amber-500 font-black">&rarr;</div>
<div class="flex-1 p-3 bg-amber-50 rounded-xl border border-amber-200"><div class="font-black text-gray-900 text-sm">STARK/SNARK 証明</div><div class="text-xs text-gray-600 mt-1">算術化して prove</div></div>
<div class="self-center text-amber-500 font-black">&rarr;</div>
<div class="flex-1 p-3 bg-white rounded-xl border border-gray-200 shadow-sm"><div class="font-black text-gray-900 text-sm">proof を検証</div><div class="text-xs text-gray-500 mt-1">on-chain で安価に</div></div>
</div>

<div class="grid grid-cols-3 gap-4 max-w-6xl mx-auto mt-5">
<div class="p-4 bg-white rounded-xl border border-gray-200 shadow-sm">
<div class="text-md font-black text-gray-900 mb-2">なぜ画期的か</div>
<div class="text-sm text-gray-700 leading-relaxed">回路手書き（旧来の ZK）が不要に。<strong>普通の開発者が ZK を使える</strong>ように democratize した。</div>
</div>
<div class="p-4 bg-white rounded-xl border border-gray-200 shadow-sm">
<div class="text-md font-black text-gray-900 mb-2">高速化の鍵</div>
<div class="text-sm text-gray-700 leading-relaxed">continuations（分割）/ precompiles（hash・楕円曲線）/ recursion / GPU proving。prover は重い（native 比 10³⁺）が verify は安価。</div>
</div>
<div class="p-4 bg-amber-50 rounded-xl border border-amber-200">
<div class="text-md font-black text-gray-900 mb-2">代表実装</div>
<div class="text-sm text-gray-700 leading-relaxed"><strong>RISC0 / SP1 / Jolt</strong>（RISC-V 系）。Cairo は ZK 専用 ISA。zkEVM は EVM に特化した zkVM。</div>
</div>
</div>

<div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">
Sources: RISC Zero ｜ Succinct SP1 ｜ a16zcrypto "Understanding Jolt" (2024) ｜ StarkWare Cairo
</div>

<!--
Speaker Notes:
アプリ紹介（証明・検証系）の深掘り 1。zkVM = 任意プログラムの実行を証明する汎用 ZK。パイプライン: 普通のコード(Rust/C) → VM の ISA(多くは RISC-V; StarkNet は Cairo) にコンパイル → エミュレータが実行トレースを生成 → トレースを算術化して STARK/SNARK で証明 → 小さな proof を verifier が再実行せず安価に検証(on-chain も可)。
【画期性】従来の ZK は回路を手書き(R1CS/制約)していたが、zkVM は普通のコードがそのまま証明対象になる → ZK の民主化。
【性能】prover は native 実行の 10^3〜10^6 倍重いのが課題。continuations(長い実行を分割)、precompiles(hash や楕円曲線の専用回路)、recursion/aggregation(多数の proof を 1 つに)、GPU proving で実用化。verify 側は小さく安価。
【実装】RISC0(RISC-V, STARK→Groth16 wrap)、SP1(Succinct, RISC-V, 普及)、Jolt(a16z, lookup 中心)。zkEVM は EVM 専用の zkVM、次の leanVM は署名集約専用の最小 zkVM。
-->
