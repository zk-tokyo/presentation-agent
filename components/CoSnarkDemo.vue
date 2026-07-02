<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from 'vue'

const totalPhases = 4

function getInitialPhase(): { phase: number; play: boolean } {
  if (typeof window === 'undefined') return { phase: 0, play: true }
  const p = new URLSearchParams(window.location.search)
  const raw = p.get('phase') ?? p.get('stage')
  if (raw == null) return { phase: 0, play: true }
  const s = parseInt(raw, 10)
  if (!Number.isNaN(s) && s >= 0 && s < totalPhases) return { phase: s, play: false }
  return { phase: 0, play: true }
}

const initial = getInitialPhase()
const phase = ref(initial.phase)
const phaseDurations = [4000, 4500, 4000, 4500]
const isPlaying = ref(initial.play)
let timeoutId: ReturnType<typeof setTimeout> | null = null

function scheduleNext() {
  if (timeoutId) { clearTimeout(timeoutId); timeoutId = null }
  if (!isPlaying.value) return
  timeoutId = setTimeout(advance, phaseDurations[phase.value])
}
function advance() {
  phase.value = (phase.value + 1) % totalPhases
  scheduleNext()
}
onMounted(() => { if (isPlaying.value) scheduleNext() })
onBeforeUnmount(() => { if (timeoutId) clearTimeout(timeoutId) })

const captions = [
  { code: '① witness を秘密分散して配る', note: '各 party は自分の share だけ・誰も w 全体を知らない（信頼できる第三者なし）' },
  { code: '② SNARK prover を MPC で協調実行', note: '線形演算（MSM・FFT）は share 上でローカル＝無料・乗算だけ通信ラウンド' },
  { code: '③ share を結合して 1 つの proof に復元', note: 'group 要素を open・single-prover と byte-identical な succinct proof' },
  { code: '④ 誰でも検証（検証は無変更）', note: '通常の SNARK 検証と区別不能・ZK で witness は漏れない' },
]

// co-SNARK の実際のパイプライン。各 phase で対応行をハイライト（自然な上→下順）。
const formula = [
  { label: '分散', expr: '[w] ← Share(w)', com: '誰も w 全体を持たない（N 者へ秘密分散）' },
  { label: 'MPC', expr: 'Prove(pk, x; [w])', com: '線形 MSM·FFT = ローカル / 乗算のみ通信' },
  { label: 'open', expr: 'π ← Open(A, B, C)', com: 'single-prover と byte-identical な 1 proof' },
  { label: 'verify', expr: 'Verify(vk, x, π)', com: '検証者・vk・proof サイズは無変更' },
]
const phaseToLine = [0, 1, 2, 3]

const partyY = [75, 180, 285]
</script>

<template>
  <div class="cs-root">
    <div class="cs-cap">
      <transition name="cs-fade" mode="out-in">
        <div :key="phase" class="cs-cap-inner">
          <code class="cs-code">{{ captions[phase].code }}</code>
          <div class="cs-note">{{ captions[phase].note }}</div>
        </div>
      </transition>
    </div>

    <svg class="cs-svg" viewBox="0 0 1200 360" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="cs-ar" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#94a3b8"/>
        </marker>
      </defs>

      <!-- chain band: parties + MPC = off-chain proving -->
      <rect x="30" y="28" width="600" height="304" rx="12" fill="rgba(99,102,241,0.04)" stroke="#cbd5e1" stroke-width="1.5" stroke-dasharray="6 4"/>
      <text x="600" y="322" text-anchor="end" class="cs-band">分散した証明者 — 信頼できる第三者なし</text>

      <!-- party cards -->
      <g v-for="(py, i) in partyY" :key="'p'+i" class="cs-party" :class="{ 'is-on': phase >= 1 }">
        <rect x="55" :y="py-32" width="210" height="64" rx="9" class="cs-pcard"/>
        <g :transform="`translate(95,${py})`">
          <circle cx="0" cy="-9" r="9" fill="#475569"/>
          <path d="M -14,7 Q 0,2 14,7 L 13,22 L -13,22 Z" fill="#475569"/>
        </g>
        <text x="128" :y="py-4" class="cs-ptitle">Party {{ ['A','B','C'][i] }}</text>
        <!-- share lock -->
        <g :transform="`translate(228,${py})`" class="cs-share">
          <rect x="-16" y="-3" width="32" height="22" rx="3" fill="#fffbeb" stroke="#f59e0b" stroke-width="2"/>
          <path d="M -8,-3 v -6 a 8 8 0 0 1 16 0 v 6" fill="none" stroke="#f59e0b" stroke-width="2.5"/>
          <text x="0" y="13" text-anchor="middle" class="cs-wtxt">w{{ i+1 }}</text>
        </g>
        <!-- converging arrow to hub -->
        <line x1="266" :y1="py" x2="408" y2="180" class="cs-edge" :class="{ 'is-on': phase >= 1 }" marker-end="url(#cs-ar)"/>
        <circle v-if="phase === 1" r="5.5" class="cs-particle">
          <animateMotion dur="1.6s" :begin="`${-i*0.5}s`" repeatCount="indefinite"
            :path="`M 266,${py} L 408,180`"/>
        </circle>
      </g>

      <!-- MPC hub -->
      <g class="cs-hub" :class="{ 'is-on': phase >= 1, 'is-cur': phase === 1 }">
        <circle cx="460" cy="180" r="54" class="cs-hub-bg"/>
        <text x="460" y="174" text-anchor="middle" class="cs-hub-t">MPC</text>
        <text x="460" y="196" text-anchor="middle" class="cs-hub-s">協調 prove</text>
      </g>

      <!-- cost annotation: linear = local, mult = communication -->
      <g class="cs-anno" :class="{ 'is-on': phase >= 1 }">
        <text x="460" y="252" text-anchor="middle" class="cs-anno-l1">MSM · FFT → ローカル（無料）</text>
        <text x="460" y="272" text-anchor="middle" class="cs-anno-l2">乗算 → 通信ラウンド</text>
      </g>

      <!-- hub -> proof arrow -->
      <line x1="514" y1="180" x2="690" y2="180" class="cs-edge2" :class="{ 'is-on': phase >= 2 }" marker-end="url(#cs-ar)"/>
      <circle v-if="phase === 2" r="6" class="cs-particle">
        <animateMotion dur="1.5s" repeatCount="indefinite" path="M 514,180 L 690,180"/>
      </circle>

      <!-- proof -->
      <g class="cs-proof" :class="{ 'is-on': phase >= 2, 'is-cur': phase === 2 }">
        <g transform="translate(760,178)">
          <path d="M 0,-44 L 42,-27 L 42,10 C 42,37 22,50 0,57 C -22,50 -42,37 -42,10 L -42,-27 Z"
                class="cs-shield"/>
          <text x="0" y="8" text-anchor="middle" class="cs-pi">π</text>
        </g>
        <text x="760" y="262" text-anchor="middle" class="cs-plabel">1 つの proof</text>
      </g>

      <!-- proof -> verifier arrow -->
      <line x1="822" y1="180" x2="936" y2="180" class="cs-edge2" :class="{ 'is-on': phase >= 3 }" marker-end="url(#cs-ar)"/>
      <circle v-if="phase === 3" r="6" class="cs-particle cs-green">
        <animateMotion dur="1.4s" repeatCount="indefinite" path="M 822,180 L 936,180"/>
      </circle>

      <!-- verifier -->
      <g class="cs-verif" :class="{ 'is-on': phase >= 3 }">
        <g transform="translate(1010,178)">
          <circle cx="0" cy="0" r="42" :fill="phase >= 3 ? '#ecfdf5' : 'white'" :stroke="phase >= 3 ? '#10b981' : '#cbd5e1'" stroke-width="2.5"/>
          <path d="M -18,2 L -6,15 L 19,-13" fill="none" :stroke="phase >= 3 ? '#10b981' : '#cbd5e1'" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>
        </g>
        <text x="1010" y="262" text-anchor="middle" class="cs-plabel">誰でも検証</text>
      </g>
    </svg>

    <div class="cs-formula">
      <div v-for="(f, i) in formula" :key="'f'+i" class="cs-fline" :class="{ 'is-active': i === phaseToLine[phase] }">
        <span class="cs-flabel">{{ f.label }}</span>
        <span class="cs-fexpr">{{ f.expr }}</span>
        <span class="cs-fcom">{{ f.com }}</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.cs-root { position: relative; width: 100%; display: flex; flex-direction: column; gap: 8px; font-family: 'Noto Sans JP', sans-serif; color: #111827; }
.cs-cap { padding: 10px 18px; background: #eef2ff; border: 1px solid #c7d2fe; border-radius: 0.75rem; min-height: 56px; display: flex; align-items: center; }
.cs-cap-inner { display: flex; flex-direction: column; gap: 3px; width: 100%; }
.cs-code { font-family: 'JetBrains Mono', monospace; font-size: 16px; color: #1e1b4b; font-weight: 800; }
.cs-note { font-size: 14px; color: #4338ca; font-weight: 600; }
.cs-svg { width: 100%; height: auto; display: block; }

.cs-pcard { fill: white; stroke: #e2e8f0; stroke-width: 2; }
.cs-party.is-on .cs-pcard { stroke: #cbd5e1; }
.cs-ptitle { font-size: 16px; font-weight: 700; fill: #1f2937; font-family: 'JetBrains Mono', monospace; }
.cs-band { font-size: 13px; font-weight: 700; fill: #6366f1; letter-spacing: 0.1em; font-family: 'JetBrains Mono', monospace; }
.cs-wtxt { font-size: 11px; font-weight: 900; fill: #b45309; font-family: 'JetBrains Mono', monospace; }
.cs-share { transition: opacity 0.4s; }

.cs-edge { stroke: #cbd5e1; stroke-width: 2; fill: none; stroke-dasharray: 5 3; opacity: 0.4; transition: opacity 0.5s, stroke 0.4s; }
.cs-edge.is-on { opacity: 0.9; stroke: #94a3b8; }
.cs-edge2 { stroke: #cbd5e1; stroke-width: 2.5; fill: none; opacity: 0.4; transition: opacity 0.5s, stroke 0.4s; }
.cs-edge2.is-on { opacity: 1; stroke: #94a3b8; }
.cs-particle { fill: #f59e0b; filter: drop-shadow(0 0 5px rgba(245,158,11,0.8)); }
.cs-particle.cs-green { fill: #10b981; filter: drop-shadow(0 0 5px rgba(16,185,129,0.8)); }

.cs-hub { opacity: 0.4; transition: opacity 0.5s; }
.cs-hub.is-on { opacity: 1; }
.cs-hub-bg { fill: #eef2ff; stroke: #6366f1; stroke-width: 2.5; stroke-dasharray: 6 4; transition: filter 0.4s; }
.cs-hub.is-cur .cs-hub-bg { filter: drop-shadow(0 0 10px rgba(99,102,241,0.45)); stroke-dasharray: none; }
.cs-hub-t { font-size: 22px; font-weight: 900; fill: #4338ca; font-family: 'JetBrains Mono', monospace; }
.cs-hub-s { font-size: 12px; font-weight: 700; fill: #6366f1; }

.cs-anno { opacity: 0; transition: opacity 0.5s; }
.cs-anno.is-on { opacity: 1; }
.cs-anno-l1 { font-size: 14px; font-weight: 800; fill: #4338ca; font-family: 'JetBrains Mono', monospace; }
.cs-anno-l2 { font-size: 14px; font-weight: 800; fill: #b45309; font-family: 'JetBrains Mono', monospace; }

.cs-proof { opacity: 0.4; transition: opacity 0.5s; }
.cs-proof.is-on { opacity: 1; }
.cs-shield { fill: #fffbeb; stroke: #f59e0b; stroke-width: 2.5; transition: filter 0.4s; }
.cs-proof.is-cur .cs-shield { filter: drop-shadow(0 0 9px rgba(245,158,11,0.5)); }
.cs-pi { font-size: 26px; font-weight: 900; fill: #b45309; font-family: 'JetBrains Mono', monospace; }
.cs-plabel { font-size: 15px; font-weight: 700; fill: #374151; font-family: 'BIZ UDPMincho', serif; }

.cs-verif { opacity: 0.4; transition: opacity 0.5s; }
.cs-verif.is-on { opacity: 1; }

.cs-fade-enter-active, .cs-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.cs-fade-enter-from { opacity: 0; transform: translateY(4px); }
.cs-fade-leave-to { opacity: 0; transform: translateY(-4px); }

.cs-formula { display: flex; flex-direction: column; gap: 2px; padding: 10px 16px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 0.75rem; }
.cs-fline { display: flex; align-items: baseline; gap: 12px; padding: 3px 8px; border-radius: 6px; opacity: 0.4; transition: opacity 0.45s, background 0.45s; }
.cs-fline.is-active { opacity: 1; background: #fffbeb; }
.cs-flabel { flex: 0 0 82px; text-align: right; font-family: 'JetBrains Mono', monospace; font-size: 14px; font-weight: 700; color: #6366f1; }
.cs-fexpr { flex: 0 0 268px; font-family: 'JetBrains Mono', monospace; font-size: 16px; font-weight: 800; color: #374151; }
.cs-fline.is-active .cs-fexpr { color: #b45309; }
.cs-fcom { font-family: 'JetBrains Mono', monospace; font-size: 14px; color: #94a3b8; }
</style>
