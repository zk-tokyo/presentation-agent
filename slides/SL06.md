---
layout: default
---

# special-purpose から programmable cryptography へ

<div class="grid grid-cols-2 gap-5 max-w-5xl mx-auto mt-3">
<div class="p-4 bg-white rounded-xl border border-gray-200 shadow-sm">
<div class="font-black text-gray-900 mb-1">special-purpose</div>
<div class="text-sm text-gray-700">1 つの操作だけを暗号的に保証（署名 / range proof / group signature）</div>
</div>
<div class="p-4 bg-amber-50 rounded-xl border border-amber-200">
<div class="font-black text-amber-700 mb-1">programmable</div>
<div class="text-sm text-gray-700">暗号の中で<strong>汎用計算</strong>（ZK / MPC / FHE / Witness Enc. / iO）</div>
</div>
</div>

<div class="flex justify-center mt-4">
<img src="/images/pc1_tech_tree.png" class="max-h-[300px] rounded-xl border border-gray-200" alt="programmable cryptography tech tree" />
</div>

<div class="text-center text-xs text-gray-500 mt-2">太字 = programmable cryptography ｜ 矢印は reduction（上ほど一般化・高度）</div>

<div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">
Sources: gubsheep "Programmable Cryptography (Part 1)" 0xPARC 2024 ｜ tech tree inspired by Complexity Zoo
</div>

<!--
Speaker Notes:
導入(2/2)。中心命題。暗号は special-purpose(1操作=署名/range proof)から programmable(汎用計算=ZK/MPC/FHE/WE/iO)へ世代交代している。tech tree は reduction の連なりで、Digital Signatures→NIZK→zkSNARK、Encryption→FHE/Threshold/WE、頂点に iO。アナロジー: 目覚まし時計(専用HW)→CPU(汎用HW)の飛躍が、いま「情報のレイヤー」で起きている。
-->
