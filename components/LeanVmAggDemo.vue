<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from 'vue'

const totalPhases = 3

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
const phaseDurations = [4000, 4500, 4500]
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
  { code: '① 多数の leanXMSS 署名 — 各 ~3,000 B（BLS は 96 B）', note: '耐量子 hash 署名は巨大。毎スロット数万個を扱う' },
  { code: '② LeanVM で再帰的に集約', note: '署名検証を証明して束ねる（用途特化の最小 zkVM）' },
  { code: '③ 1 つの小さな proof — 約 250x 圧縮', note: '検証コストを劇的に圧縮して Ethereum を耐量子に' },
]

const sigY = [70, 130, 190, 250]
</script>

<template>
  <div class="la-root">
    <div class="la-cap">
      <transition name="la-fade" mode="out-in">
        <div :key="phase" class="la-cap-inner">
          <code class="la-code">{{ captions[phase].code }}</code>
          <div class="la-note">{{ captions[phase].note }}</div>
        </div>
      </transition>
    </div>

    <svg class="la-svg" viewBox="0 0 1200 340" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="la-ar" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#94a3b8"/>
        </marker>
      </defs>

      <!-- big signatures (left) -->
      <text x="155" y="40" text-anchor="middle" class="la-grouplabel">leanXMSS 署名</text>
      <g v-for="(y, i) in sigY" :key="'s'+i" class="la-sig">
        <rect x="55" :y="y" width="200" height="44" rx="6" class="la-sigbox"/>
        <g :transform="`translate(78,${y+22})`">
          <rect x="-10" y="-3" width="20" height="16" rx="2" fill="#fee2e2" stroke="#ef4444" stroke-width="1.6"/>
          <path d="M -5,-3 v -4 a 5 5 0 0 1 10 0 v 4" fill="none" stroke="#ef4444" stroke-width="1.8"/>
        </g>
        <text x="100" :y="y+27" class="la-sigtxt">sig {{ i+1 }} · ~3,000 B</text>
        <line x1="255" :y1="y+22" x2="430" y2="170" class="la-edge" :class="{ 'is-on': phase >= 1 }" marker-end="url(#la-ar)"/>
        <circle v-if="phase === 1" r="5" class="la-particle">
          <animateMotion dur="1.6s" :begin="`${-i*0.45}s`" repeatCount="indefinite" :path="`M 255,${y+22} L 430,170`"/>
        </circle>
      </g>
      <text x="155" y="312" text-anchor="middle" class="la-sub">各 ~3,000 B（BLS は 96 B）</text>

      <!-- LeanVM core -->
      <g class="la-vm" :class="{ 'is-on': phase >= 1, 'is-cur': phase === 1 }">
        <rect x="430" y="118" width="200" height="104" rx="14" class="la-vmbg"/>
        <text x="530" y="160" text-anchor="middle" class="la-vmt">LeanVM</text>
        <text x="530" y="184" text-anchor="middle" class="la-vms">再帰集約</text>
        <text x="530" y="204" text-anchor="middle" class="la-vms2">verify ∘ verify ∘ …</text>
      </g>

      <!-- arrow VM -> proof -->
      <line x1="630" y1="170" x2="800" y2="170" class="la-edge2" :class="{ 'is-on': phase >= 2 }" marker-end="url(#la-ar)"/>
      <circle v-if="phase === 2" r="6" class="la-particle la-green">
        <animateMotion dur="1.4s" repeatCount="indefinite" path="M 630,170 L 800,170"/>
      </circle>

      <!-- single small proof -->
      <g class="la-proof" :class="{ 'is-on': phase >= 2, 'is-cur': phase === 2 }">
        <g transform="translate(880,170)">
          <path d="M 0,-40 L 36,-25 L 36,8 C 36,32 18,42 0,48 C -18,42 -36,32 -36,8 L -36,-25 Z"
                :fill="phase >= 2 ? '#ecfdf5' : 'white'" :stroke="phase >= 2 ? '#10b981' : '#cbd5e1'" stroke-width="2.5"/>
          <text x="0" y="8" text-anchor="middle" class="la-pi">π</text>
        </g>
        <text x="880" y="246" text-anchor="middle" class="la-plabel">1 つの proof</text>
      </g>

      <!-- compression badge -->
      <g class="la-badge" :class="{ 'is-on': phase >= 2 }">
        <rect x="985" y="150" width="150" height="42" rx="9" fill="#fffbeb" stroke="#f59e0b" stroke-width="2"/>
        <text x="1060" y="177" text-anchor="middle" class="la-badget">≈ 250x 圧縮</text>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.la-root { position: relative; width: 100%; display: flex; flex-direction: column; gap: 8px; font-family: 'Noto Sans JP', sans-serif; color: #111827; }
.la-cap { padding: 10px 18px; background: #fffbeb; border: 1px solid #fde68a; border-radius: 0.75rem; min-height: 56px; display: flex; align-items: center; }
.la-cap-inner { display: flex; flex-direction: column; gap: 3px; width: 100%; }
.la-code { font-family: 'JetBrains Mono', monospace; font-size: 16px; color: #78350f; font-weight: 800; }
.la-note { font-size: 14px; color: #b45309; font-weight: 600; }
.la-svg { width: 100%; height: auto; display: block; }

.la-grouplabel { font-size: 14px; font-weight: 800; fill: #b91c1c; font-family: 'JetBrains Mono', monospace; letter-spacing: 0.04em; }
.la-sub { font-size: 13px; font-weight: 600; fill: #6b7280; }
.la-sigbox { fill: #fef2f2; stroke: #fecaca; stroke-width: 2; }
.la-sigtxt { font-size: 14px; font-weight: 700; fill: #7f1d1d; font-family: 'JetBrains Mono', monospace; }

.la-edge { stroke: #cbd5e1; stroke-width: 2; fill: none; stroke-dasharray: 5 3; opacity: 0.35; transition: opacity 0.5s, stroke 0.4s; }
.la-edge.is-on { opacity: 0.9; stroke: #94a3b8; }
.la-edge2 { stroke: #cbd5e1; stroke-width: 2.5; fill: none; opacity: 0.35; transition: opacity 0.5s, stroke 0.4s; }
.la-edge2.is-on { opacity: 1; stroke: #94a3b8; }
.la-particle { fill: #f59e0b; filter: drop-shadow(0 0 5px rgba(245,158,11,0.8)); }
.la-particle.la-green { fill: #10b981; filter: drop-shadow(0 0 5px rgba(16,185,129,0.8)); }

.la-vm { opacity: 0.4; transition: opacity 0.5s; }
.la-vm.is-on { opacity: 1; }
.la-vmbg { fill: #eef2ff; stroke: #6366f1; stroke-width: 2.5; transition: filter 0.4s; }
.la-vm.is-cur .la-vmbg { filter: drop-shadow(0 0 11px rgba(99,102,241,0.45)); }
.la-vmt { font-size: 21px; font-weight: 900; fill: #4338ca; font-family: 'BIZ UDPMincho', serif; }
.la-vms { font-size: 14px; font-weight: 700; fill: #4f46e5; }
.la-vms2 { font-size: 12px; font-weight: 600; fill: #818cf8; font-family: 'JetBrains Mono', monospace; }

.la-proof { opacity: 0.4; transition: opacity 0.5s; }
.la-proof.is-on { opacity: 1; }
.la-pi { font-size: 22px; font-weight: 900; fill: #047857; font-family: 'JetBrains Mono', monospace; }
.la-plabel { font-size: 15px; font-weight: 700; fill: #374151; font-family: 'BIZ UDPMincho', serif; }

.la-badge { opacity: 0; transition: opacity 0.5s; }
.la-badge.is-on { opacity: 1; }
.la-badget { font-size: 16px; font-weight: 900; fill: #b45309; font-family: 'JetBrains Mono', monospace; }

.la-fade-enter-active, .la-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.la-fade-enter-from { opacity: 0; transform: translateY(4px); }
.la-fade-leave-to { opacity: 0; transform: translateY(-4px); }
</style>
