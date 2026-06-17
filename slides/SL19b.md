---
layout: default
---

# co-SNARK の構成：witness を秘密分散したまま prover を回す

<div class="bg-gray-50 rounded-xl border border-gray-200 px-5 py-3 max-w-6xl mx-auto mt-2 text-sm leading-relaxed" style="font-family:'JetBrains Mono',monospace">
<div class="text-gray-800">通常:&nbsp;&nbsp;&nbsp;&nbsp;&#960; &#8592; Prove(pk, x; w)<span class="text-gray-400 ml-3">// 単一 prover が witness w 全体を保持</span></div>
<div class="text-gray-800">co-SNARK: [w] = (w<sub>1</sub>, &#8230;, w<sub>N</sub>)<span class="text-gray-400 ml-3">// witness を N 者へ秘密分散</span></div>
<div class="text-gray-800">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&#960; &#8592; MPC-Prove(pk, x; [w])<span class="text-gray-400 ml-3">// share 上で同じ &#960; を協調生成</span></div>
<div class="text-gray-900 font-bold mt-1">verify:&nbsp;&nbsp;Verify(vk, x, &#960;)<span class="text-gray-400 ml-3 font-normal">// 通常 SNARK と全く同一（無変更）</span></div>
</div>

<div class="grid grid-cols-3 gap-4 max-w-6xl mx-auto mt-4">
<div class="p-4 bg-white rounded-xl border border-gray-200 shadow-sm">
<div class="text-md font-black text-gray-900 mb-2">なぜ MPC に乗るか</div>
<div class="text-sm text-gray-700 leading-relaxed">SNARK prover の主計算は体 F 上の<strong>線形演算（MSM / FFT）</strong>。線形演算は秘密分散値の上で<strong>無料</strong>、乗算だけ通信が要る。代数構造を活かし暗号を非ブラックボックスに使わず効率化。</div>
</div>
<div class="p-4 bg-white rounded-xl border border-gray-200 shadow-sm">
<div class="text-md font-black text-gray-900 mb-2">何が守られるか</div>
<div class="text-sm text-gray-700 leading-relaxed">各 party は他者の share を見ず、witness w は誰にも集約されない。出力 &#960; は<strong>単一 prover 版と同一</strong>で、ZK なので verifier も w を学ばない。</div>
</div>
<div class="p-4 bg-amber-50 rounded-xl border border-amber-200">
<div class="text-md font-black text-gray-900 mb-2">敵対モデルの注意</div>
<div class="text-sm text-gray-700 leading-relaxed">Ozdemir&#8211;Boneh は <strong>semi-honest</strong> が基本。malicious party 耐性・完全分散・スケーラブル化は後続研究（ePrint 2024/143 等）で進展。</div>
</div>
</div>

<div class="mt-4 p-3 bg-gray-50 rounded-xl border border-gray-200 max-w-6xl mx-auto text-sm text-gray-800">
<span class="text-amber-600 font-black mr-1">&#9654;</span>要点：<strong>証明する人を分散できる</strong>。単一 prover に witness を集める必要がなくなり、データ保有者をまたいだ証明が現実的になる。
</div>

<div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">
Sources: Ozdemir & Boneh "Experimenting with Collaborative zk-SNARKs" USENIX Security 2022 ｜ Scalable Collaborative zk-SNARK ePrint 2024/143 ｜ TACEO coSNARKs
</div>

<!--
Speaker Notes:
co-SNARK 深掘り 2/2 = 構成（SL19 の散文を数式で裏打ち）。前ページ SL19 は仕組み概要/コスト/用途、本ページは「式でどう変わるか」。
【中核】通常の zk-SNARK は prover アルゴリズム Prove(pk, x; w) を 1 名が回し、witness w 全体を持つ前提。co-SNARK は w を秘密分散 [w]=(w_1,…,w_N) したまま、N 者が MPC として prover を協調実行し、単一 prover 版と「同一の」π を出力する。verifier 側は vk と x と π だけ受け取り、通常 SNARK と全く区別がつかない（Verify は無変更）。
【なぜ乗るか】Ozdemir-Boneh の鍵は「SNARK prover の主計算は体 F 上の線形代数（MSM = multi-scalar multiplication, FFT/多項式評価）」という観察。MPC では線形演算は share 上でローカルに無料、乗算だけが通信ラウンドを要する。だから prover を MPC にマップしても通信は乗算箇所に限定でき、暗号をブラックボックス的に MPC に投げる素朴構成より遥かに効率的。Groth16 / Plonk などに適用可能。
【保証】各 party は自分の share しか見ないので witness は秘匿、かつ ZK なので最終 verifier も w を学ばない。proof のサイズ・検証コストは単一 prover 版と同じ。
【敵対モデル】注意点として元論文の標準設定は semi-honest（honest-but-curious）MPC。malicious party（プロトコルを逸脱する参加者）への頑健性、完全分散・大規模スケール化は後続研究（ePrint 2024/143、TACEO の coSNARKs 実装等）が扱う。CLAUDE.md §9 の「ZK の敵対モデルは soundness（malicious prover）と ZK（malicious verifier）の二重性」も併せて口頭で。
-->
