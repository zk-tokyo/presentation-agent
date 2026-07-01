<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount, computed } from 'vue'

const totalPhases = 6

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
const phaseDurations = [3500, 4500, 4500, 4500, 4500, 5000]
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
  { code: 'H = Σ_{x∈{0,1}³} f(x₁, x₂, x₃)', note: '主張: 多変数多項式の総和' },
  { code: 'P → V :  g₁(X) = Σ_{x₂,x₃} f(X, x₂, x₃)', note: 'Round 1 — 1 変数 X についての partial sum' },
  { code: 'V → P :  r₁  ←$  𝔽    /    check  g₁(0)+g₁(1) = H', note: 'Round 1 challenge — 検証者がランダム点を返す' },
  { code: 'P → V :  g₂(X) = Σ_{x₃} f(r₁, X, x₃)', note: 'Round 2 — r₁ を固定して同じ操作' },
  { code: 'P → V :  g₃(X) = f(r₁, r₂, X)', note: 'Round 3 — 残り 1 変数' },
  { code: '✓  V evaluates  f(r₁, r₂, r₃)  at single point', note: 'soundness error ≤ d·n / |𝔽|  (Schwartz-Zippel)' },
]

const verifierAccepted = computed(() => phase.value === 5)
const rounds = [
  { idx: 0, label: 'g₁(X)', sub: 'Σ over x₂, x₃' },
  { idx: 1, label: 'g₂(X)', sub: 'Σ over x₃' },
  { idx: 2, label: 'g₃(X)', sub: '= f(r₁,r₂,X)' },
]
// At phase p:
//   p=0  : nothing sent
//   p=1  : round 1 prover msg in flight / settled
//   p=2  : r1 sent back, round 1 done
//   p=3  : round 2 prover msg
//   p=4  : round 3 prover msg
//   p=5  : final eval

function roundState(i: number) {
  // 0: idle, 1: prover msg active, 2: challenge active, 3: settled (done)
  if (i === 0) {
    if (phase.value === 0) return 'idle'
    if (phase.value === 1) return 'proverMsg'
    return 'done'
  }
  if (i === 1) {
    if (phase.value <= 2) return 'idle'
    if (phase.value === 3) return 'proverMsg'
    return 'done'
  }
  // i === 2 (Round 3)
  if (phase.value <= 3) return 'idle'
  if (phase.value === 4) return 'proverMsg'
  return 'done'
}

const dimsRemaining = computed(() => {
  // 3, 3, 2, 2, 1, 0
  if (phase.value === 0) return 3
  if (phase.value === 1) return 3
  if (phase.value === 2) return 2
  if (phase.value === 3) return 2
  if (phase.value === 4) return 1
  return 0
})

const pinnedVars = computed(() => {
  // which r's locked
  if (phase.value <= 1) return []
  if (phase.value === 2 || phase.value === 3) return ['r₁']
  if (phase.value === 4) return ['r₁', 'r₂']
  return ['r₁', 'r₂', 'r₃']
})
</script>

<template>
  <div class="sc-root">
    <!-- Formula strip -->
    <div class="sc-formula">
      <transition name="sc-fade" mode="out-in">
        <div :key="phase" class="sc-formula-inner">
          <code class="sc-code">{{ captions[phase].code }}</code>
          <div class="sc-note">{{ captions[phase].note }}</div>
        </div>
      </transition>
    </div>

    <!-- Main SVG -->
    <svg class="sc-svg" viewBox="0 0 1200 410" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="sc-arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#475569"/>
        </marker>
        <marker id="sc-arrow-amber" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#b45309"/>
        </marker>
        <marker id="sc-arrow-green" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#059669"/>
        </marker>
      </defs>

      <!-- Side labels -->
      <g class="sc-side">
        <rect x="40" y="40" width="240" height="60" rx="8" class="sc-side-bg sc-side-bg-p"/>
        <g transform="translate(80, 70)">
          <circle cx="0" cy="-2" r="7" fill="#475569"/>
          <path d="M -10,9 Q 0,5 10,9 L 9,18 L -9,18 Z" fill="#475569"/>
        </g>
        <text x="160" y="68" text-anchor="middle" class="sc-side-title">証明者</text>
        <text x="160" y="88" text-anchor="middle" class="sc-side-sub">f を知っている</text>
      </g>

      <g class="sc-side">
        <rect x="920" y="40" width="240" height="60" rx="8" class="sc-side-bg sc-side-bg-v"
              :class="{ 'is-accepted': verifierAccepted }"/>
        <g transform="translate(960, 70)">
          <!-- shield icon -->
          <path d="M 0,-13 L 11,-8 L 11,5 Q 11,14 0,16 Q -11,14 -11,5 L -11,-8 Z"
                :fill="verifierAccepted ? '#059669' : '#475569'"/>
          <path v-if="verifierAccepted" d="M -4,2 L 0,6 L 6,-3"
                stroke="white" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
        </g>
        <text x="1040" y="68" text-anchor="middle" class="sc-side-title">検証者</text>
        <text x="1040" y="88" text-anchor="middle" class="sc-side-sub">{{ verifierAccepted ? 'accepted ✓' : '少ない通信で確信' }}</text>
      </g>

      <!-- Round lanes -->
      <g v-for="(rnd, i) in rounds" :key="rnd.idx" :transform="`translate(0, ${130 + i * 65})`">
        <g class="sc-lane" :class="`is-${roundState(rnd.idx)}`">
          <!-- lane bg -->
          <rect x="40" y="0" width="1120" height="50" rx="6" class="sc-lane-bg"/>
          <text x="55" y="29" class="sc-round-label">Round {{ i + 1 }}</text>

          <!-- prover msg (top half) -->
          <g class="sc-msg sc-msg-p">
            <line x1="280" y1="18" x2="920" y2="18" class="sc-wire-p"
                  marker-end="url(#sc-arrow-amber)"/>
            <rect x="540" y="6" width="130" height="24" rx="4" class="sc-msg-box sc-msg-box-p"/>
            <text x="605" y="22" text-anchor="middle" class="sc-msg-text sc-msg-text-p">{{ rnd.label }}</text>
          </g>

          <!-- challenge (bottom half) -->
          <g class="sc-msg sc-msg-v">
            <line x1="920" y1="38" x2="280" y2="38" class="sc-wire-v"
                  marker-end="url(#sc-arrow-green)"/>
            <rect x="540" y="26" width="130" height="20" rx="4" class="sc-msg-box sc-msg-box-v"/>
            <text x="605" y="40" text-anchor="middle" class="sc-msg-text sc-msg-text-v">r{{ i + 1 }} ←$ 𝔽</text>
          </g>
        </g>
      </g>

      <!-- Final evaluation row -->
      <g transform="translate(0, 335)">
        <g class="sc-final" :class="{ 'is-active': phase >= 5 }">
          <rect x="40" y="0" width="1120" height="56" rx="6" class="sc-final-bg"/>
          <text x="55" y="34" class="sc-round-label sc-final-label">Final</text>
          <!-- center evaluation point -->
          <rect x="450" y="10" width="310" height="36" rx="6" class="sc-final-eval"/>
          <text x="605" y="34" text-anchor="middle" class="sc-final-text">f(r₁, r₂, r₃) — 1 点で実評価</text>
        </g>
      </g>

      <!-- Dim-collapse indicator (right side) -->
      <g transform="translate(870, 130)">
        <text x="0" y="-6" class="sc-dim-label">残り変数</text>
        <g v-for="(d, i) in [3,2,1,0]" :key="d">
          <rect :x="i * 14" y="0" width="10" height="22" rx="2"
                class="sc-dim-cell" :class="{ 'is-on': d > dimsRemaining - 1 && d < 4 - 0, 'is-current': d === dimsRemaining }"/>
        </g>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.sc-root {
  position: relative;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 8px;
  font-family: 'Noto Sans JP', sans-serif;
  color: #111827;
}

.sc-formula {
  padding: 10px 16px;
  background: #eef2ff;
  border: 1px solid #c7d2fe;
  border-radius: 0.5rem;
  min-height: 56px;
  display: flex;
  align-items: center;
}
.sc-formula-inner {
  display: flex;
  flex-direction: column;
  gap: 4px;
  width: 100%;
}
.sc-code {
  font-family: 'JetBrains Mono', 'Menlo', monospace;
  font-size: 18px;
  color: #1e1b4b;
  font-weight: 700;
}
.sc-note {
  font-size: 15px;
  color: #4338ca;
  font-weight: 600;
}

.sc-svg {
  width: 100%;
  height: auto;
  display: block;
  font-family: 'Noto Sans JP', sans-serif;
}

/* Sides */
.sc-side-bg {
  fill: white;
  stroke: #94a3b8;
  stroke-width: 2;
  transition: fill 0.4s, stroke 0.4s, filter 0.4s;
}
.sc-side-bg-p { fill: #fff7ed; stroke: #fdba74; }
.sc-side-bg-v { fill: #f0fdf4; stroke: #86efac; }
.sc-side-bg-v.is-accepted {
  fill: #dcfce7;
  stroke: #059669;
  stroke-width: 3;
  filter: drop-shadow(0 0 8px rgba(5, 150, 105, 0.5));
}
.sc-side-title {
  font-size: 19px;
  font-weight: 700;
  fill: #111827;
  font-family: 'BIZ UDPMincho', serif;
}
.sc-side-sub {
  font-size: 14px;
  fill: #475569;
  font-weight: 600;
  font-family: 'JetBrains Mono', monospace;
}

/* Lanes */
.sc-lane-bg {
  fill: #f8fafc;
  stroke: #cbd5e1;
  stroke-width: 1.5;
  stroke-dasharray: 4 3;
  transition: stroke 0.5s, fill 0.5s;
}
.sc-lane.is-proverMsg .sc-lane-bg,
.sc-lane.is-done .sc-lane-bg {
  fill: #fffbeb;
  stroke: #fcd34d;
  stroke-dasharray: 0;
}
.sc-lane.is-done .sc-lane-bg {
  fill: #f0fdf4;
  stroke: #86efac;
}

.sc-round-label {
  font-size: 14px;
  font-weight: 700;
  fill: #475569;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.05em;
}

/* Messages */
.sc-msg { opacity: 0; transition: opacity 0.5s; }
.sc-lane.is-proverMsg .sc-msg-p { opacity: 1; }
.sc-lane.is-proverMsg .sc-msg-v { opacity: 0; }
.sc-lane.is-done .sc-msg-p { opacity: 0.55; }
.sc-lane.is-done .sc-msg-v { opacity: 0.85; }

.sc-wire-p {
  stroke: #b45309;
  stroke-width: 2;
  stroke-dasharray: 5 3;
  animation: sc-flow 0.9s linear infinite;
  fill: none;
}
.sc-wire-v {
  stroke: #059669;
  stroke-width: 2;
  stroke-dasharray: 5 3;
  animation: sc-flow-rev 0.9s linear infinite;
  fill: none;
}
@keyframes sc-flow { to { stroke-dashoffset: -16; } }
@keyframes sc-flow-rev { to { stroke-dashoffset: 16; } }

.sc-msg-box-p {
  fill: #fffbeb;
  stroke: #b45309;
  stroke-width: 1.5;
}
.sc-msg-box-v {
  fill: #f0fdf4;
  stroke: #059669;
  stroke-width: 1.5;
}
.sc-msg-text {
  font-family: 'JetBrains Mono', monospace;
  font-weight: 700;
}
.sc-msg-text-p { font-size: 15px; fill: #78350f; }
.sc-msg-text-v { font-size: 14px; fill: #064e3b; }

/* Final eval */
.sc-final-bg {
  fill: #f8fafc;
  stroke: #cbd5e1;
  stroke-width: 1.5;
  stroke-dasharray: 4 3;
  transition: fill 0.5s, stroke 0.5s;
}
.sc-final.is-active .sc-final-bg {
  fill: #dcfce7;
  stroke: #059669;
  stroke-dasharray: 0;
  stroke-width: 2;
}
.sc-final-label { fill: #475569; }
.sc-final.is-active .sc-final-label { fill: #064e3b; }
.sc-final-eval {
  fill: white;
  stroke: #cbd5e1;
  stroke-width: 1.5;
  transition: fill 0.5s, stroke 0.5s, filter 0.5s;
}
.sc-final.is-active .sc-final-eval {
  fill: white;
  stroke: #059669;
  stroke-width: 2;
  filter: drop-shadow(0 0 6px rgba(5, 150, 105, 0.4));
}
.sc-final-text {
  font-size: 17px;
  font-weight: 700;
  fill: #475569;
  font-family: 'JetBrains Mono', monospace;
  transition: fill 0.5s;
}
.sc-final.is-active .sc-final-text { fill: #064e3b; }

/* Dim indicator */
.sc-dim-label {
  font-size: 12px;
  font-weight: 700;
  fill: #6b7280;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.06em;
}
.sc-dim-cell {
  fill: #e5e7eb;
  stroke: #cbd5e1;
  stroke-width: 1;
  transition: fill 0.5s, stroke 0.5s;
}
.sc-dim-cell.is-on {
  fill: #fcd34d;
  stroke: #b45309;
}
.sc-dim-cell.is-current {
  fill: #059669;
  stroke: #047857;
}

/* Transitions */
.sc-fade-enter-active, .sc-fade-leave-active {
  transition: opacity 0.4s ease, transform 0.4s ease;
}
.sc-fade-enter-from { opacity: 0; transform: translateY(4px); }
.sc-fade-leave-to { opacity: 0; transform: translateY(-4px); }
</style>
