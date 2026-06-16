---
layout: default
---

# LeanVM：zkVM で署名を集約し Ethereum を耐量子に

<div class="text-sm text-gray-500 mt-1 mb-4">zkVM の応用例。量子計算機は BLS（楕円曲線）を破るため、Ethereum は <strong>hash ベースの耐量子署名 leanXMSS</strong> へ移行する。だが署名が巨大なので、<strong>集約専用の最小 zkVM = LeanVM</strong> が要る。</div>

<div class="flex items-stretch justify-center gap-2 max-w-6xl mx-auto text-center mb-5">
<div class="flex-1 p-3 bg-white rounded-xl border border-gray-200 shadow-sm"><div class="font-black text-gray-900 text-sm">多数の leanXMSS 署名</div><div class="text-xs text-gray-500 mt-1">各 ~3,000 B（BLS は 96 B）</div></div>
<div class="self-center text-amber-500 font-black">&rarr;</div>
<div class="flex-1 p-3 bg-amber-50 rounded-xl border border-amber-200"><div class="font-black text-gray-900 text-sm">LeanVM で再帰集約</div><div class="text-xs text-gray-600 mt-1">verify を証明し束ねる</div></div>
<div class="self-center text-amber-500 font-black">&rarr;</div>
<div class="flex-1 p-3 bg-white rounded-xl border border-gray-200 shadow-sm"><div class="font-black text-gray-900 text-sm">1 つの小さな proof</div><div class="text-xs text-gray-500 mt-1">約 250x 圧縮</div></div>
</div>

<div class="grid grid-cols-3 gap-4 max-w-6xl mx-auto">
<div class="p-4 bg-white rounded-xl border border-gray-200 shadow-sm">
<div class="text-md font-black text-gray-900 mb-2">なぜ専用 VM か</div>
<div class="text-sm text-gray-700 leading-relaxed">hash ベース署名は安全だが巨大。数万の validator 署名を毎スロット集約するには、汎用 zkVM より<strong>用途特化の最小設計</strong>が速い。</div>
</div>
<div class="p-4 bg-white rounded-xl border border-gray-200 shadow-sm">
<div class="text-md font-black text-gray-900 mb-2">設計の要点</div>
<div class="text-sm text-gray-700 leading-relaxed">Cairo に着想した<strong>4 命令の最小 ISA</strong> + Poseidon precompile。read-only メモリで形式検証しやすい（構成は次ページ）。</div>
</div>
<div class="p-4 bg-amber-50 rounded-xl border border-amber-200">
<div class="text-md font-black text-gray-900 mb-2">位置づけ</div>
<div class="text-sm text-gray-700 leading-relaxed"><strong>Lean Consensus 2026 plan</strong> の中核。leanXMSS / leanSig / leanMultisig(=LeanVM) / leanSpec として ~10 client が実装中。</div>
</div>
</div>

<div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">
Sources: pq.ethereum.org ｜ Lean Consensus: 2026 Plan (hackmd @tcoratger) ｜ leanEthereum/leanMultisig (GitHub) ｜ ZK Podcast ep.394 ｜ leanXMSS ePrint 2025/055, 2025/1332
</div>

<!--
Speaker Notes:
アプリ紹介（証明・検証系）の深掘り 2 = zkVM の応用。LeanVM は「署名集約専用の最小 zkVM」。
【背景】量子計算機(Shor)は楕円曲線(BLS12-381)を破るので、Ethereum は hash ベースの耐量子署名 leanXMSS(XMSS 系)へ移行する。hash ベースは hash の安全性だけに依存するので量子耐性。
【課題】leanXMSS の署名は約 3,000 バイトと BLS(96 バイト)に比べ巨大。数万 validator 分を毎スロット扱うには集約が必須。
【解法】LeanVM が多数の署名検証を再帰的に集約し、1 つの小さな proof(約 250x 圧縮)にまとめる。汎用 zkVM ではなく、Cairo 風の 4 opcode + 2 precompile という極小設計にして形式検証と速度を両立。ベンチは M4 Max で ~1,000 XMSS 検証/秒、再帰証明 1 秒未満。
【位置づけ】Lean Consensus 2026 plan の構成要素。leanXMSS(署名), leanSig(Rust 実装), leanMultisig(=LeanVM, 集約), leanSpec(Python 仕様)。約 10 の client チームが実装中。zkVM が「汎用」から「用途特化の最小 VM」へ展開する好例として締める。
-->
