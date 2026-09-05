---
layout: default
---

# World ID のユースケース

<div class="flex items-stretch gap-4 max-w-6xl mx-auto mt-4">

<div class="flex-1 p-3 bg-white rounded-xl border border-gray-200 shadow-sm">
<img src="/images/worldid_tinder.png" class="w-full rounded-xl border border-gray-200" alt="Tinder profile verification with World ID" />
<div class="mt-2.5 text-sm font-black text-gray-900">マッチングアプリ ｜ Tinder (Match Group)</div>
<div class="mt-1.5 space-y-1 text-[13px] text-gray-700 leading-snug">
<div><span class="text-amber-500 font-black mr-1">&#9654;</span>Orb 登録済みユーザーが World ID を Tinder アカウントに紐付けると、プロフィールに <strong>Verified Human バッジ</strong>が付く（利用は任意）</div>
<div><span class="text-amber-500 font-black mr-1">&#9654;</span><strong>日本のユーザー向けパイロット</strong>から開始し、その後グローバルへ展開</div>
<div><span class="text-amber-500 font-black mr-1">&#9654;</span>狙いは bot・なりすましアカウント対策と年齢確認</div>
</div>
</div>

<div class="flex-1 p-3 bg-white rounded-xl border border-gray-200 shadow-sm">
<img src="/images/worldid_robot.png" class="w-full rounded-xl border border-gray-200" alt="Delivery robot verifying a human with World ID" />
<div class="mt-2.5 text-sm font-black text-gray-900">配送ロボット ｜ peaq (PeaqOS)</div>
<div class="mt-1.5 space-y-1 text-[13px] text-gray-700 leading-snug">
<div><span class="text-amber-500 font-black mr-1">&#9654;</span>2026-08、PeaqOS が World ID を統合。<strong>ロボットが ZK 証明を検証</strong>して相手が人間かを確かめる</div>
<div><span class="text-amber-500 font-black mr-1">&#9654;</span>機械側は氏名も顔も受け取らず、<strong>「実在する一意の人間」だけ</strong>を確認する</div>
<div><span class="text-amber-500 font-black mr-1">&#9654;</span>医薬品配送では 注文時・積込時・受取時 の 3 回検証し、コンパートメントを解錠</div>
</div>
</div>

</div>

<div class="absolute bottom-3 left-6 text-[10px] text-gray-400 leading-tight max-w-3xl">
Sources: World "Experience Real Connections with World ID and Match Group" ｜ ID Tech "World ID Badge Rolls Out Globally on Tinder After Japan Pilot" ｜ Biometric Update "peaq integrates World ID to enable personhood verification by robots" (2026-08) ｜ 画像は各社の公開素材
</div>

<!--
Speaker Notes:
World ID が実際にどこで使われているかを 2 例で示す。SL22 で説明した Semaphore + nullifier が、そのまま製品として動いている姿。
【Tinder / Match Group】Match Group が World と提携し、まず日本の Tinder ユーザーを対象にパイロットを実施。Orb 登録を済ませたユーザーが World ID を Tinder アカウントに紐付けると、プロフィールに Verified Human バッジが表示され、閲覧・マッチング時に他ユーザーから見える。利用は任意。その後 World の Lift Off イベント (4/17) で米国ほかへのグローバル展開が発表された。動機は bot・なりすまし・ロマンス詐欺対策と年齢確認。スクリーンショット左端の "Verify with World ID" ボタンが実際の導線。
【peaq / 配送ロボット】2026-08-21 に PeaqOS が World ID を統合し、robotic.sh 経由でロボットが ZK 証明を検証できるようになった。機械は World App から proof を受け取って検証するだけで、氏名・顔・その他の個人情報は一切受け取らない。デモは (a) 医薬品配送ロボット — 患者が注文時に検証、薬剤師が積込時に検証、到着時に患者がもう一度検証してコンパートメントが解錠される、(b) 1 人 1 個の配布ロボット、(c) アカウント登録なしで借りられるロボット。
【講義での位置づけ】どちらも受け取る情報は「実在する一意の人間である」だけで、誰かは分からない。SL22 の nullifier が「1 人 1 アクション」を身元を明かさず強制する仕組みだったことと対応させて話す。(b) の "1 人 1 個" はまさに nullifier の用途そのもの。
【留意点】いずれも World / peaq 側の発表に基づく。生体認証を用いる点で各国の privacy 規制上の議論が続いていることは SL22 で触れたとおりで、ユースケースが広がるほどその論点も大きくなる。
-->
