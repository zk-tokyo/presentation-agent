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
const phaseDurations = [4000, 4500, 4500, 5000]
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
  { code: '① ユーザがデータを暗号化して送る', note: 'E(x) — サーバには中身が見えない' },
  { code: '② サーバが暗号文のまま f を計算（FHE）', note: 'E(f(x)) を得る。だが「正しく計算したか」は不明' },
  { code: '③ 計算の正しさを ZK 証明 π で添える（+ ZK）', note: 'vFHE = FHE（機密性）+ ZK（正しさ）' },
  { code: '④ ユーザが復号 + π を検証', note: '機密性（FHE）AND 計算の正しさ（ZK）を同時に得る' },
]
</script>

<template>
  <div class="vf-root">
    <div class="vf-cap">
      <transition name="vf-fade" mode="out-in">
        <div :key="phase" class="vf-cap-inner">
          <code class="vf-code">{{ captions[phase].code }}</code>
          <div class="vf-note">{{ captions[phase].note }}</div>
        </div>
      </transition>
    </div>

    <svg class="vf-svg" viewBox="0 0 1200 360" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="vf-ar" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#7c3aed"/>
        </marker>
        <marker id="vf-ar-b" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#059669"/>
        </marker>
      </defs>

      <!-- ===== User (left) ===== -->
      <g class="vf-actor" :class="{ 'is-cur': phase === 0 || phase === 3 }">
        <rect x="70" y="95" width="200" height="170" rx="12" class="vf-card vf-card-user"/>
        <g transform="translate(170,150)">
          <circle cx="0" cy="-11" r="12" fill="#6d28d9"/>
          <path d="M -17,8 Q 0,2 17,8 L 16,30 L -16,30 Z" fill="#6d28d9"/>
        </g>
        <text x="170" y="212" text-anchor="middle" class="vf-title">User</text>
        <text x="170" y="236" text-anchor="middle" class="vf-sub">秘密データ x 🔒</text>
        <!-- result badge (phase 3) -->
        <g v-if="phase >= 3" transform="translate(170,258)">
          <rect x="-72" y="-2" width="144" height="22" rx="6" fill="#ecfdf5" stroke="#10b981" stroke-width="1.5"/>
          <text x="0" y="14" text-anchor="middle" class="vf-badge">✓ 機密性 + 正しさ</text>
        </g>
      </g>

      <!-- ===== Server (right) ===== -->
      <g class="vf-actor" :class="{ 'is-cur': phase === 1 || phase === 2 }">
        <rect x="930" y="95" width="200" height="170" rx="12" class="vf-card vf-card-server"/>
        <g transform="translate(1030,150)" class="vf-gear" :class="{ 'spin': phase === 1 }">
          <circle cx="0" cy="0" r="20" fill="none" stroke="#6d28d9" stroke-width="3"/>
          <circle cx="0" cy="0" r="6" fill="#6d28d9"/>
          <g v-for="i in 8" :key="i">
            <rect x="-2.2" y="-27" width="4.4" height="9" rx="1" :transform="`rotate(${i*45})`" fill="#6d28d9"/>
          </g>
        </g>
        <text x="1030" y="212" text-anchor="middle" class="vf-title">Server</text>
        <text x="1030" y="236" text-anchor="middle" class="vf-sub">中身は見えない</text>
      </g>

      <!-- forward wire: E(x) -->
      <line x1="272" y1="150" x2="928" y2="150" class="vf-wire" :class="{ 'is-on': phase >= 0 }" marker-end="url(#vf-ar)"/>
      <g>
        <rect x="565" y="138" width="70" height="24" rx="4" fill="white" stroke="#7c3aed" stroke-width="1.4"/>
        <text x="600" y="155" text-anchor="middle" class="vf-tag">E(x)</text>
      </g>
      <circle v-if="phase === 0" r="6" class="vf-particle">
        <animateMotion dur="1.7s" repeatCount="indefinite" path="M 300,150 L 560,150"/>
      </circle>

      <!-- FHE label under server (phase >=1) -->
      <g class="vf-fhe-label" :class="{ 'is-on': phase >= 1 }">
        <text x="1030" y="300" text-anchor="middle" class="vf-fhe-t">FHE: 暗号文のまま f を評価</text>
      </g>

      <!-- ZK proof shield (phase >=2) -->
      <g v-if="phase >= 2" class="vf-proof" :class="{ 'is-cur': phase === 2 }">
        <g transform="translate(740,210)">
          <path d="M 0,-26 L 22,-16 L 22,6 C 22,22 11,30 0,34 C -11,30 -22,22 -22,6 L -22,-16 Z"
                fill="#fffbeb" stroke="#f59e0b" stroke-width="2.5"/>
          <text x="0" y="8" text-anchor="middle" class="vf-pi">π</text>
        </g>
        <text x="740" y="262" text-anchor="middle" class="vf-zk-t">ZK: 正しく計算した証明</text>
      </g>

      <!-- backward wire: E(f(x)) + π -->
      <line x1="928" y1="210" x2="272" y2="210" class="vf-wire vf-wire-b" :class="{ 'is-on': phase >= 3 }" marker-end="url(#vf-ar-b)"/>
      <g v-if="phase >= 3">
        <rect x="540" y="178" width="120" height="24" rx="4" fill="white" stroke="#059669" stroke-width="1.4"/>
        <text x="600" y="195" text-anchor="middle" class="vf-tag vf-tag-g">E(f(x)) + π</text>
      </g>
      <circle v-if="phase === 3" r="6" class="vf-particle vf-particle-g">
        <animateMotion dur="1.7s" repeatCount="indefinite" path="M 900,210 L 320,210"/>
      </circle>
    </svg>
  </div>
</template>

<style scoped>
.vf-root { position: relative; width: 100%; display: flex; flex-direction: column; gap: 8px; font-family: 'Noto Sans JP', sans-serif; color: #111827; }
.vf-cap { padding: 10px 18px; background: #f5f3ff; border: 1px solid #ddd6fe; border-radius: 0.75rem; min-height: 56px; display: flex; align-items: center; }
.vf-cap-inner { display: flex; flex-direction: column; gap: 3px; width: 100%; }
.vf-code { font-family: 'JetBrains Mono', monospace; font-size: 16px; color: #4c1d95; font-weight: 800; }
.vf-note { font-size: 14px; color: #6d28d9; font-weight: 600; }
.vf-svg { width: 100%; height: auto; display: block; }

.vf-actor { transition: opacity 0.4s; }
.vf-card { fill: white; stroke: #e2e8f0; stroke-width: 2; transition: stroke 0.4s, filter 0.4s; }
.vf-card-user { fill: #f5f3ff; stroke: #c4b5fd; }
.vf-card-server { fill: #f5f3ff; stroke: #c4b5fd; }
.vf-actor.is-cur .vf-card { stroke: #7c3aed; stroke-width: 3; filter: drop-shadow(0 0 10px rgba(124,58,237,0.3)); }
.vf-title { font-size: 19px; font-weight: 800; fill: #1f2937; font-family: 'BIZ UDPMincho', serif; }
.vf-sub { font-size: 14px; fill: #6b7280; font-weight: 600; }
.vf-badge { font-size: 13px; font-weight: 800; fill: #047857; font-family: 'JetBrains Mono', monospace; }

.vf-gear.spin { animation: vf-spin 3s linear infinite; transform-origin: center; transform-box: fill-box; }
@keyframes vf-spin { to { transform: rotate(360deg); } }

.vf-wire { stroke: #c4b5fd; stroke-width: 2.5; fill: none; transition: stroke 0.4s; }
.vf-wire.is-on { stroke: #7c3aed; stroke-dasharray: 6 3; animation: vf-flow 1s linear infinite; }
.vf-wire-b.is-on { stroke: #059669; }
@keyframes vf-flow { to { stroke-dashoffset: -18; } }
.vf-tag { font-size: 14px; font-weight: 800; fill: #5b21b6; font-family: 'JetBrains Mono', monospace; }
.vf-tag-g { fill: #065f46; }
.vf-particle { fill: #7c3aed; filter: drop-shadow(0 0 5px rgba(124,58,237,0.8)); }
.vf-particle-g { fill: #059669; filter: drop-shadow(0 0 5px rgba(5,150,105,0.8)); }

.vf-fhe-label { opacity: 0; transition: opacity 0.5s; }
.vf-fhe-label.is-on { opacity: 1; }
.vf-fhe-t { font-size: 15px; font-weight: 700; fill: #6d28d9; font-family: 'BIZ UDPMincho', serif; }

.vf-proof { transition: opacity 0.4s; }
.vf-pi { font-size: 20px; font-weight: 900; fill: #b45309; font-family: 'JetBrains Mono', monospace; }
.vf-proof.is-cur .vf-pi { animation: vf-pulse 1.2s ease-in-out infinite; }
@keyframes vf-pulse { 0%,100% { opacity: 1; } 50% { opacity: 0.55; } }
.vf-zk-t { font-size: 15px; font-weight: 700; fill: #b45309; font-family: 'BIZ UDPMincho', serif; }

.vf-fade-enter-active, .vf-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.vf-fade-enter-from { opacity: 0; transform: translateY(4px); }
.vf-fade-leave-to { opacity: 0; transform: translateY(-4px); }
</style>
