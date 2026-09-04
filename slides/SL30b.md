---
layout: default
---

# パフォーマンス：ZK はモバイルで実用段階に入った

<div class="text-sm text-gray-500 mt-1 mb-2">同じ3つの主張 (パスポート検証・WebAuthn・OPRF) を、同じ端末で3方式に証明させた実測。<strong>手元の端末で証明を作る</strong>ことが現実的なコストに収まりつつある。</div>

<div class="flex items-center justify-center gap-5 text-[11px] text-gray-600 mb-2">
<div class="flex items-center gap-1.5"><span class="inline-block w-3 h-3 rounded-sm" style="background:#DE00FF"></span>Circom + Groth16</div>
<div class="flex items-center gap-1.5"><span class="inline-block w-3 h-3 rounded-sm" style="background:#E91900"></span>Noir + Barretenberg</div>
<div class="flex items-center gap-1.5"><span class="inline-block w-3 h-3 rounded-sm" style="background:#0D74FF"></span>ProveKit v1</div>
</div>

<div class="flex items-stretch gap-3 max-w-6xl mx-auto">

<div class="flex-1 bg-white rounded-xl border border-gray-200 shadow-sm p-3">
<div class="text-xs font-black text-gray-900">証明生成時間 — 最低スペック端末</div>
<div class="text-[10px] text-gray-400 mb-1">Moto E15 ｜ 2GB RAM / 32-bit / Android 14 Go</div>
<img src="/images/provekit_moto_time.svg" class="w-full" alt="Moto E15 proving time" />
<div class="mt-1.5 text-[11px] text-gray-700 leading-snug"><span class="text-amber-600 font-black mr-1">&#9654;</span>Passport P1 は <span class="font-black text-gray-900">241.6s &rarr; 22.0s</span>。WebAuthn は Groth16 が <strong>OOM で完走せず</strong>。</div>
</div>

<div class="flex-1 bg-white rounded-xl border border-gray-200 shadow-sm p-3">
<div class="text-xs font-black text-gray-900">証明に必要なダウンロード量</div>
<div class="text-[10px] text-gray-400 mb-1">重複排除後のペイロード ｜ 単位 MB</div>
<img src="/images/provekit_download.svg" class="w-full" alt="Download required to prove" />
<div class="mt-1.5 text-[11px] text-gray-700 leading-snug"><span class="text-amber-600 font-black mr-1">&#9654;</span>WebAuthn は <span class="font-black text-gray-900">1,753MB &rarr; 2.4MB</span>。回路ごとの巨大な鍵配布が消える。</div>
</div>

<div class="flex-1 bg-white rounded-xl border border-red-200 shadow-sm p-3">
<div class="text-xs font-black text-gray-900">直列化した proof のサイズ</div>
<div class="text-[10px] text-gray-400 mb-1">単位 KB ｜ <span class="text-red-600 font-bold">ここだけ逆転する</span></div>
<img src="/images/provekit_proofsize.svg" class="w-full" alt="Serialized proof size" />
<div class="mt-1.5 text-[11px] text-gray-700 leading-snug"><span class="text-amber-600 font-black mr-1">&#9654;</span>Passport P1 は <span class="font-black text-red-700">0.93KB &rarr; 716KB</span>。約 770 倍に膨らむ。</div>
</div>

</div>

<div class="flex items-stretch gap-3 max-w-6xl mx-auto mt-2.5 text-[11px]">
<div class="flex-1 p-2 bg-white rounded-xl border border-gray-200 shadow-sm text-gray-700 leading-snug"><span class="text-amber-600 font-black mr-1">&#9654;</span><strong>iPhone SE 3</strong> (A15 / 4GB) でも同じ傾向：Passport P1 <span class="font-black text-gray-900">14.3s &rarr; 2.4s</span>、WebAuthn <span class="font-black text-gray-900">151.4s &rarr; 3.0s</span>。</div>
<div class="flex-1 p-2 bg-white rounded-xl border border-gray-200 shadow-sm text-gray-700 leading-snug"><span class="text-amber-600 font-black mr-1">&#9654;</span><strong>Chrome / M4 Max</strong> では差が縮む：Passport P1 は Groth16 12.6s &rarr; ProveKit 5.5s、ただし <strong>Noir 4.95s が最速</strong>。</div>
</div>

<div class="mt-3 p-3 bg-gray-50 rounded-xl border border-gray-200 max-w-6xl mx-auto text-sm text-gray-800">
<span class="text-amber-600 font-black mr-1">&#9654;</span>教訓：<strong>速くなった代わりに proof が重くなった</strong>。手元での証明生成は実用域に入ったが、その proof をオンチェーンで検証するなら 0.93KB の Groth16 が今も優位。<strong>「一番速い方式」は存在せず、証明を誰がどこで検証するかで方式が決まる</strong>。
</div>

<div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">
Sources: ProveKit v1.0.0 Benchmarks (provekit.org/benchmarks, source pin 9b2a6f37) — ProveKit チーム自身による自社計測、第三者の追試ではない ｜ 1 warmup + 5 samples の cold median、witness 生成を含む input&rarr;proof 全体 ｜ グラフは原典より引用 (棒の高さ・比率・配色は原典のまま、投影用に文字サイズと数値ラベルのみ調整)
</div>

<!--
Speaker Notes:
注意点の深掘り・パフォーマンス。SL30 で挙げた4観点のうち「パフォーマンス」の実例。セキュリティ (次ページ Zcash)、法律 (次々ページ Tornado Cash) と同じ深掘りの並び。
【何を測ったか】ProveKit が公開した v1.0.0 ベンチマーク。3つの「主張 (claim)」— Passport P1 (電子パスポートの署名検証)、WebAuthn (パスキー署名の検証)、OPRF (小さい回路) — を、Circom+Groth16 / Noir+Barretenberg / ProveKit v1 の3方式で証明させ、iPhone SE3・Moto E15・Chrome (M4 Max) の3環境で計測している。時計は「構造化済み入力」から「直列化された proof バイト列」まで、つまり witness 生成を含む。1 回 warmup してから5回計測し、cold median を報告。各実装は「正しい proof を受理し、改ざんされた proof を拒否する」ことを確認済み。
【なぜ Moto E15 を出すか】2GB RAM / 32-bit / Android 14 Go という、世界で最も普及価格帯に近い端末。ここで動くなら大半の端末で動く、という下限の証拠になる。Passport P1 で Groth16 が 241.6s (4分) かかるのに対し ProveKit は 22.0s。WebAuthn に至っては Groth16 は OOM で完走すらしない。「ZK は重いからサーバでやるしかない」という前提が、この価格帯の端末でも崩れ始めている。
【ダウンロード量が本命かもしれない】Groth16 は回路ごとに proving key を配る必要があり、WebAuthn では 1,753MB。モバイルアプリに載せられる量ではない。ProveKit は 2.4MB。証明生成時間より、この配布コストの消滅の方がプロダクト上のインパクトは大きいことがある。ProveKit は trusted setup を必要としない点も併せて触れる。
【正直に負けを見せる】proof サイズは Passport P1 で Groth16 0.93KB に対し ProveKit 715.9KB。約770倍。Groth16 の proof が定数サイズで極小なのは、オンチェーン検証 (SL のソリディティ verifier の話と接続) のために設計された性質であり、そこは今も揺らいでいない。ProveKit が有利なのは「証明する側の端末が貧弱で、検証はサーバやブラウザで行う」構図。逆に「証明はサーバででき、検証をコントラクトで安く行いたい」なら Groth16。
【小回路では話が変わる】OPRF のような小さい回路では Groth16 が proving time でも最速 (Moto E15 で 11.5s、ProveKit 12.68s) で、DL も 26.8MB と現実的。方式の優劣は回路サイズに強く依存する、という点も押さえる。
【出典の扱い方の注意】これは ProveKit チーム自身による自社ベンチマークである。数値そのものは source pin (9b2a6f37) 付きで公開され再現手順も示されているが、比較対象の設定 (相手方の最適化度合い) は公開者の裁量に依存する。第三者による追試ではない点を明示するのが誠実。受講者が自分のユースケースで判断するときは、自分の回路で測り直すのが原則。
【SL30 との接続】SL30 で「ZK: 証明生成 (prover) は重いが検証 (verify) は軽い」と書いた。このスライドはその「重い」がどこまで軽くなったかの現在地であり、同時に「軽い検証」を捨てると proof が膨らむというトレードオフの実例でもある。
-->
