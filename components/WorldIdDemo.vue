<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount, computed } from 'vue'

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
const phaseDurations = [4000, 4000, 4000, 4500]
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
  { code: '① Orb が虹彩をスキャン', note: '専用ハードで人間性と一意性を読み取る' },
  { code: '② iris code 化', note: '生の虹彩画像は保持しない（ハッシュ/分散で一意性のみ）' },
  { code: '③ 一意性を判定し登録', note: '検証済み人間の集合（Merkle tree）へ' },
  { code: '④ World ID を発行', note: '匿名で使えるクレデンシャル（Semaphore + nullifier）' },
]

const cx = [165, 455, 745, 1035]
const lit = [0, 1, 2, 3].map(i => computed(() => phase.value >= i))
function isCur(i: number) { return phase.value === i }
</script>

<template>
  <div class="wi-root">
    <div class="wi-cap">
      <transition name="wi-fade" mode="out-in">
        <div :key="phase" class="wi-cap-inner">
          <code class="wi-code">{{ captions[phase].code }}</code>
          <div class="wi-note">{{ captions[phase].note }}</div>
        </div>
      </transition>
    </div>

    <svg class="wi-svg" viewBox="0 0 1200 360" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="wi-ar" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#94a3b8"/>
        </marker>
      </defs>

      <!-- arrows -->
      <g v-for="i in 3" :key="'a'+i">
        <line :x1="cx[i-1]+100" y1="172" :x2="cx[i]-100" y2="172"
              class="wi-arrow" :class="{ 'is-on': phase >= i }" marker-end="url(#wi-ar)"/>
        <circle v-if="phase === i" r="6" class="wi-particle">
          <animateMotion dur="1.5s" repeatCount="indefinite" :path="`M ${cx[i-1]+100},172 L ${cx[i]-100},172`"/>
        </circle>
      </g>

      <!-- stage 1: Orb scan -->
      <g class="wi-stage" :class="{ 'is-lit': lit[0].value, 'is-cur': isCur(0) }">
        <rect :x="cx[0]-100" y="60" width="200" height="225" rx="12" class="wi-card"/>
        <g :transform="`translate(${cx[0]},128)`">
          <circle cx="0" cy="0" r="32" fill="#1e293b" stroke="#475569" stroke-width="2"/>
          <circle cx="0" cy="0" r="20" fill="#0ea5e9" opacity="0.85"/>
          <circle cx="0" cy="0" r="9" fill="#0f172a"/>
          <circle cx="-4" cy="-4" r="3" fill="#bae6fd"/>
        </g>
        <!-- person below being scanned -->
        <g :transform="`translate(${cx[0]},212)`">
          <circle cx="0" cy="-8" r="8" fill="#475569"/>
          <path d="M -12,6 Q 0,2 12,6 L 11,20 L -11,20 Z" fill="#475569"/>
        </g>
        <line :x1="cx[0]" y1="160" :x2="cx[0]" y2="196" class="wi-beam" :class="{ 'is-cur': isCur(0) }"/>
        <text :x="cx[0]" y="258" text-anchor="middle" class="wi-title">Orb スキャン</text>
      </g>

      <!-- stage 2: iris code -->
      <g class="wi-stage" :class="{ 'is-lit': lit[1].value, 'is-cur': isCur(1) }">
        <rect :x="cx[1]-100" y="60" width="200" height="225" rx="12" class="wi-card"/>
        <g :transform="`translate(${cx[1]},135)`">
          <rect x="-58" y="-32" width="116" height="64" rx="7" fill="#0f172a" stroke="#475569" stroke-width="2"/>
          <text x="0" y="-8" text-anchor="middle" class="wi-code-line">1011 0110</text>
          <text x="0" y="12" text-anchor="middle" class="wi-code-line">0x9af3…</text>
          <text x="0" y="28" text-anchor="middle" class="wi-code-dim">iris code</text>
        </g>
        <text :x="cx[1]" y="258" text-anchor="middle" class="wi-title">iris code 化</text>
      </g>

      <!-- stage 3: verified set (tree) -->
      <g class="wi-stage" :class="{ 'is-lit': lit[2].value, 'is-cur': isCur(2) }">
        <rect :x="cx[2]-100" y="60" width="200" height="225" rx="12" class="wi-card"/>
        <g :transform="`translate(${cx[2]},120)`">
          <circle cx="0" cy="0" r="9" fill="#6366f1"/>
          <line x1="0" y1="9" x2="-34" y2="34" stroke="#a5b4fc" stroke-width="2"/>
          <line x1="0" y1="9" x2="34" y2="34" stroke="#a5b4fc" stroke-width="2"/>
          <circle cx="-34" cy="42" r="7" fill="#a5b4fc"/>
          <circle cx="34" cy="42" r="7" fill="#a5b4fc"/>
          <line x1="-34" y1="49" x2="-50" y2="68" stroke="#c7d2fe" stroke-width="1.8"/>
          <line x1="-34" y1="49" x2="-18" y2="68" stroke="#c7d2fe" stroke-width="1.8"/>
          <line x1="34" y1="49" x2="18" y2="68" stroke="#c7d2fe" stroke-width="1.8"/>
          <line x1="34" y1="49" x2="50" y2="68" stroke="#c7d2fe" stroke-width="1.8"/>
          <circle v-for="(lx, k) in [-50,-18,18,50]" :key="k" :cx="lx" cy="74" r="5.5" :fill="k===1 ? '#f59e0b' : '#c7d2fe'"/>
        </g>
        <text :x="cx[2]" y="258" text-anchor="middle" class="wi-title">検証済み集合</text>
      </g>

      <!-- stage 4: World ID badge -->
      <g class="wi-stage" :class="{ 'is-lit': lit[3].value, 'is-cur': isCur(3), 'is-final': phase >= 3 }">
        <rect :x="cx[3]-100" y="60" width="200" height="225" rx="12" class="wi-card wi-card-final"/>
        <g :transform="`translate(${cx[3]},132)`">
          <rect x="-56" y="-38" width="112" height="76" rx="9" :fill="phase >= 3 ? '#ecfdf5' : 'white'" :stroke="phase >= 3 ? '#10b981' : '#cbd5e1'" stroke-width="2.5"/>
          <circle cx="-32" cy="-6" r="13" :fill="phase >= 3 ? '#10b981' : '#cbd5e1'"/>
          <path d="M -38,-2 q 6,8 12,0" fill="none" stroke="white" stroke-width="2"/>
          <line x1="-12" y1="-12" x2="40" y2="-12" :stroke="phase >= 3 ? '#34d399' : '#e2e8f0'" stroke-width="4" stroke-linecap="round"/>
          <line x1="-12" y1="0" x2="34" y2="0" :stroke="phase >= 3 ? '#a7f3d0' : '#eef2f6'" stroke-width="4" stroke-linecap="round"/>
          <line x1="-12" y1="12" x2="40" y2="12" :stroke="phase >= 3 ? '#a7f3d0' : '#eef2f6'" stroke-width="4" stroke-linecap="round"/>
        </g>
        <text :x="cx[3]" y="258" text-anchor="middle" class="wi-title">World ID</text>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.wi-root { position: relative; width: 100%; display: flex; flex-direction: column; gap: 8px; font-family: 'Noto Sans JP', sans-serif; color: #111827; }
.wi-cap { padding: 10px 18px; background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 0.75rem; min-height: 56px; display: flex; align-items: center; }
.wi-cap-inner { display: flex; flex-direction: column; gap: 3px; width: 100%; }
.wi-code { font-family: 'JetBrains Mono', monospace; font-size: 16px; color: #1e3a8a; font-weight: 800; }
.wi-note { font-size: 14px; color: #2563eb; font-weight: 600; }
.wi-svg { width: 100%; height: auto; display: block; }

.wi-stage { opacity: 0.4; transition: opacity 0.5s; }
.wi-stage.is-lit { opacity: 1; }
.wi-card { fill: white; stroke: #e2e8f0; stroke-width: 2; transition: stroke 0.4s, filter 0.4s; }
.wi-stage.is-lit .wi-card { stroke: #cbd5e1; }
.wi-stage.is-cur .wi-card { stroke: #2563eb; stroke-width: 3; filter: drop-shadow(0 0 10px rgba(37,99,235,0.3)); }
.wi-stage.is-final .wi-card-final { stroke: #10b981; }

.wi-title { font-size: 19px; font-weight: 800; fill: #1f2937; font-family: 'BIZ UDPMincho', serif; }
.wi-code-line { font-size: 13px; font-weight: 700; fill: #67e8f9; font-family: 'JetBrains Mono', monospace; }
.wi-code-dim { font-size: 11px; font-weight: 600; fill: #64748b; font-family: 'JetBrains Mono', monospace; }

.wi-arrow { stroke: #cbd5e1; stroke-width: 2.5; fill: none; transition: stroke 0.4s; }
.wi-arrow.is-on { stroke: #94a3b8; }
.wi-particle { fill: #2563eb; filter: drop-shadow(0 0 5px rgba(37,99,235,0.8)); }
.wi-beam { stroke: #38bdf8; stroke-width: 2.5; stroke-dasharray: 4 3; opacity: 0; }
.wi-beam.is-cur { opacity: 0.9; animation: wi-scan 1.2s linear infinite; }
@keyframes wi-scan { 0%,100% { opacity: 0.3; } 50% { opacity: 1; } }

.wi-fade-enter-active, .wi-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.wi-fade-enter-from { opacity: 0; transform: translateY(4px); }
.wi-fade-leave-to { opacity: 0; transform: translateY(-4px); }
</style>
