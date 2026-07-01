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
const phaseDurations = [3500, 4000, 4500, 4500, 5000, 5500]
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
  { code: 'Source chain  ←→  Destination chain   (no RPC trust)',                     note: '事前: ZK light client コントラクトが destination に deploy 済' },
  { code: 'User  burns  rsETH   on  source.block_N',                                  note: 'source chain で event 発生 — Kelp と同じトリガ' },
  { code: 'Prover  reads  source.state @ block_N   (cryptographic root)',             note: 'state root と Merkle proof から状態を取得 ─ RPC の応答は使わない' },
  { code: 'π  =  ZK { source.state @ block_N  ∧  burn(amount) ⊆ state }',             note: 'state proof を off-chain で生成 (Sumcheck 系 or zkVM)' },
  { code: 'destination.LightClient.verify(π)   →   ✓ on-chain',                        note: 'RPC ノードが嘘をついても proof が通らない ─ 暗号的に検証' },
  { code: 'release(user, amount)   /   if  KelpDAO  had  this :  not  exploitable',   note: '午後ホワイトボード議論: RPC が同じく侵害されたら? — 講師の突っ込み弾' },
]

const burnEvent       = computed(() => phase.value >= 1)
const proverReading   = computed(() => phase.value === 2)
const proofGenerated  = computed(() => phase.value >= 3)
const proofInFlight   = computed(() => phase.value === 3 || phase.value === 4)
const lightClientOk   = computed(() => phase.value >= 4)
const released        = computed(() => phase.value >= 5)
const kelpContrast    = computed(() => phase.value === 5)
</script>

<template>
  <div class="zb-root">
    <!-- Caption strip -->
    <div class="zb-cap">
      <transition name="zb-fade" mode="out-in">
        <div :key="phase" class="zb-cap-inner">
          <code class="zb-code">{{ captions[phase].code }}</code>
          <div class="zb-note">{{ captions[phase].note }}</div>
        </div>
      </transition>
    </div>

    <!-- Main SVG -->
    <svg class="zb-svg" viewBox="0 0 1200 400" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="zb-ar" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#94a3b8"/>
        </marker>
        <marker id="zb-ar-amber" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#b45309"/>
        </marker>
        <marker id="zb-ar-green" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#059669"/>
        </marker>
      </defs>

      <!-- Chain bands -->
      <g class="zb-chain">
        <rect x="50" y="40" width="400" height="180" rx="8"
              fill="rgba(99,102,241,0.05)" stroke="#94a3b8"
              stroke-width="1.5" stroke-dasharray="6 4"/>
        <text x="65" y="60" class="zb-chain-label">SOURCE CHAIN</text>
      </g>
      <g class="zb-chain">
        <rect x="750" y="40" width="400" height="180" rx="8"
              fill="rgba(107,114,128,0.05)" stroke="#d1d5db"
              stroke-width="1.5" stroke-dasharray="6 4"/>
        <text x="765" y="60" class="zb-chain-label zb-chain-label-dst">DESTINATION CHAIN</text>
      </g>

      <!-- Off-chain prover band -->
      <g class="zb-offchain">
        <rect x="475" y="245" width="250" height="120" rx="8"
              fill="rgba(180,83,9,0.06)" stroke="#fcd34d"
              stroke-width="1.5" stroke-dasharray="6 4"/>
        <text x="600" y="265" text-anchor="middle" class="zb-chain-label zb-chain-label-off">OFF-CHAIN (証明者)</text>
      </g>

      <!-- Source: User burns -->
      <g class="zb-node" :class="{ 'is-event': burnEvent && phase < 3 }">
        <rect x="80" y="90" width="160" height="100" rx="8" class="zb-node-bg"/>
        <g transform="translate(160, 122)" class="zb-icon">
          <circle cx="0" cy="-7" r="7" class="zb-icon-fill"/>
          <path d="M -10,4 Q 0,1 10,4 L 9,17 L -9,17 Z" class="zb-icon-fill"/>
        </g>
        <text x="160" y="165" text-anchor="middle" class="zb-node-title">User</text>
        <text x="160" y="183" text-anchor="middle" class="zb-node-sub">burns rsETH</text>
      </g>

      <!-- Source: state with merkle root -->
      <g class="zb-node" :class="{ 'is-pulled': proverReading }">
        <rect x="280" y="90" width="160" height="100" rx="8" class="zb-node-bg"/>
        <g transform="translate(360, 122)" class="zb-icon">
          <!-- merkle tree -->
          <circle cx="0" cy="-12" r="5" class="zb-icon-fill"/>
          <line x1="0" y1="-8" x2="-12" y2="0" stroke="#475569" stroke-width="1.5"/>
          <line x1="0" y1="-8" x2="12" y2="0" stroke="#475569" stroke-width="1.5"/>
          <circle cx="-12" cy="3" r="4" class="zb-icon-fill"/>
          <circle cx="12"  cy="3" r="4" class="zb-icon-fill"/>
          <line x1="-12" y1="7" x2="-18" y2="14" stroke="#475569" stroke-width="1.5"/>
          <line x1="-12" y1="7" x2="-6" y2="14"  stroke="#475569" stroke-width="1.5"/>
          <line x1="12"  y1="7" x2="6" y2="14"   stroke="#475569" stroke-width="1.5"/>
          <line x1="12"  y1="7" x2="18" y2="14"  stroke="#475569" stroke-width="1.5"/>
          <rect x="-19" y="15" width="6" height="6" class="zb-icon-fill"/>
          <rect x="-9"  y="15" width="6" height="6" class="zb-icon-fill"/>
          <rect x="3"   y="15" width="6" height="6" class="zb-icon-fill"/>
          <rect x="13"  y="15" width="6" height="6" class="zb-icon-fill"/>
        </g>
        <text x="360" y="165" text-anchor="middle" class="zb-node-title">State root</text>
        <text x="360" y="183" text-anchor="middle" class="zb-node-sub">block_N</text>
      </g>

      <!-- Off-chain Prover -->
      <g class="zb-node zb-prover"
         :class="{
           'is-reading': proverReading,
           'is-proving': proofGenerated,
         }">
        <rect x="500" y="280" width="200" height="78" rx="8" class="zb-node-bg"/>
        <g transform="translate(550, 314)" class="zb-icon">
          <!-- gear -->
          <circle cx="0" cy="0" r="14" fill="none" stroke="currentColor" stroke-width="2.2"/>
          <circle cx="0" cy="0" r="4" fill="currentColor"/>
          <g v-for="i in 6" :key="i">
            <rect x="-1.6" y="-18" width="3.2" height="6" rx="0.6"
                  :transform="`rotate(${i * 60})`" fill="currentColor"/>
          </g>
        </g>
        <text x="615" y="312" text-anchor="middle" class="zb-prover-title">ZK 証明者</text>
        <text x="615" y="332" text-anchor="middle" class="zb-prover-sub">Sumcheck / zkVM</text>
      </g>

      <!-- Destination: Light Client Contract -->
      <g class="zb-node" :class="{ 'is-ok': lightClientOk }">
        <rect x="790" y="90" width="200" height="100" rx="8" class="zb-node-bg"/>
        <g transform="translate(890, 124)" class="zb-icon">
          <!-- shield with check -->
          <path d="M 0,-15 L 13,-9 L 13,5 Q 13,16 0,20 Q -13,16 -13,5 L -13,-9 Z"
                class="zb-shield-fill"/>
          <path v-if="lightClientOk" d="M -5,2 L 0,7 L 7,-3"
                stroke="white" stroke-width="2.4" fill="none"
                stroke-linecap="round" stroke-linejoin="round"/>
        </g>
        <text x="890" y="165" text-anchor="middle" class="zb-node-title">Light Client</text>
        <text x="890" y="183" text-anchor="middle" class="zb-node-sub">on-chain 検証者</text>
      </g>

      <!-- Destination: Release -->
      <g class="zb-node" :class="{ 'is-released': released }">
        <rect x="1020" y="90" width="120" height="100" rx="8" class="zb-node-bg"/>
        <g transform="translate(1080, 122)" class="zb-icon">
          <!-- vault -->
          <rect x="-13" y="-12" width="26" height="24" rx="2" class="zb-icon-fill"/>
          <circle cx="0" cy="0" r="6" fill="none" stroke="white" stroke-width="1.6"/>
          <circle cx="0" cy="0" r="1.5" fill="white"/>
        </g>
        <text x="1080" y="165" text-anchor="middle" class="zb-node-title">Bridge</text>
        <text x="1080" y="183" text-anchor="middle" class="zb-node-sub">release</text>
      </g>

      <!-- Wire: User → State (burn) -->
      <transition name="zb-fade">
        <g v-if="burnEvent" class="zb-wire-burn">
          <line x1="240" y1="140" x2="280" y2="140"
                class="zb-wire-amber" marker-end="url(#zb-ar-amber)"/>
        </g>
      </transition>

      <!-- Wire: State root → Prover (state read, cryptographic) -->
      <transition name="zb-fade">
        <g v-if="phase >= 2" class="zb-wire-read">
          <line x1="360" y1="190" x2="540" y2="280"
                class="zb-wire-cryptographic" marker-end="url(#zb-ar-amber)"/>
          <rect x="380" y="225" width="170" height="22" rx="3"
                fill="#fffbeb" stroke="#b45309" stroke-width="1.2"/>
          <text x="465" y="241" text-anchor="middle" class="zb-wire-label">root + merkle proof</text>
        </g>
      </transition>

      <!-- Wire: Prover → Light Client (π) -->
      <transition name="zb-fade">
        <g v-if="proofInFlight || lightClientOk" class="zb-wire-pi">
          <line x1="690" y1="290" x2="850" y2="190"
                class="zb-wire-green" marker-end="url(#zb-ar-green)"/>
          <rect x="700" y="232" width="120" height="22" rx="3"
                fill="#dcfce7" stroke="#059669" stroke-width="1.5"/>
          <text x="760" y="248" text-anchor="middle" class="zb-wire-label-g">π : state proof</text>
        </g>
      </transition>

      <!-- Wire: Light Client → Bridge (release) -->
      <transition name="zb-fade">
        <g v-if="released" class="zb-wire-release">
          <line x1="990" y1="140" x2="1020" y2="140"
                class="zb-wire-green" marker-end="url(#zb-ar-green)"/>
        </g>
      </transition>

      <!-- Contrast banner (final phase) -->
      <transition name="zb-fade">
        <g v-if="kelpContrast" class="zb-contrast">
          <rect x="60" y="245" width="370" height="120" rx="8"
                fill="#fef2f2" stroke="#dc2626" stroke-width="2"/>
          <text x="245" y="270" text-anchor="middle" class="zb-contrast-title">vs. KelpDAO × LayerZero</text>
          <text x="78" y="296" class="zb-contrast-line">▸ Kelp: DVN は <tspan class="zb-emph-bad">RPC の応答を信頼</tspan></text>
          <text x="78" y="318" class="zb-contrast-line">▸ ZK Light Client: RPC が嘘でも <tspan class="zb-emph-good">π が通らない</tspan></text>
          <text x="78" y="340" class="zb-contrast-line">▸ ⚠ source の RPC が同じく侵害されたら?</text>
          <text x="78" y="358" class="zb-contrast-line zb-italic">    → 午後ホワイトボード議題</text>
        </g>
      </transition>
    </svg>
  </div>
</template>

<style scoped>
.zb-root {
  position: relative;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 6px;
  font-family: 'Noto Sans JP', sans-serif;
  color: #111827;
}

.zb-cap {
  padding: 9px 16px;
  background: #eef2ff;
  border: 1px solid #c7d2fe;
  border-radius: 0.5rem;
  min-height: 52px;
  display: flex;
  align-items: center;
}
.zb-cap-inner {
  display: flex;
  flex-direction: column;
  gap: 3px;
  width: 100%;
}
.zb-code {
  font-family: 'JetBrains Mono', monospace;
  font-size: 17px;
  color: #1e1b4b;
  font-weight: 700;
}
.zb-note {
  font-size: 14px;
  color: #4338ca;
  font-weight: 600;
}

.zb-svg {
  width: 100%;
  height: auto;
  display: block;
  font-family: 'Noto Sans JP', sans-serif;
}

.zb-chain-label {
  font-size: 13px;
  font-weight: 700;
  fill: #4f46e5;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.12em;
}
.zb-chain-label-dst { fill: #4b5563; }
.zb-chain-label-off { fill: #b45309; }

/* Nodes */
.zb-node-bg {
  fill: white;
  stroke: #94a3b8;
  stroke-width: 2;
  transition: fill 0.5s, stroke 0.5s, filter 0.5s, stroke-width 0.5s;
}
.zb-node.is-event .zb-node-bg {
  fill: #fffbeb;
  stroke: #d97706;
  stroke-width: 3;
  filter: drop-shadow(0 0 8px rgba(217, 119, 6, 0.4));
}
.zb-node.is-pulled .zb-node-bg {
  stroke: #b45309;
  stroke-width: 2.5;
}
.zb-node.is-ok .zb-node-bg {
  fill: #dcfce7;
  stroke: #059669;
  stroke-width: 3;
  filter: drop-shadow(0 0 8px rgba(5, 150, 105, 0.4));
}
.zb-node.is-released .zb-node-bg {
  fill: #dcfce7;
  stroke: #059669;
  stroke-width: 3;
}

.zb-prover { color: #94a3b8; transition: color 0.5s; }
.zb-prover.is-reading { color: #b45309; }
.zb-prover.is-proving { color: #059669; }
.zb-prover.is-proving .zb-node-bg,
.zb-prover.is-reading .zb-node-bg {
  fill: #fffbeb;
  stroke: #d97706;
  stroke-width: 2.5;
  filter: drop-shadow(0 0 8px rgba(217, 119, 6, 0.3));
}
.zb-prover.is-proving .zb-node-bg {
  fill: #f0fdf4;
  stroke: #059669;
}

.zb-icon-fill { fill: #475569; }
.zb-shield-fill { fill: #475569; transition: fill 0.5s; }
.zb-node.is-ok .zb-shield-fill { fill: #059669; }

.zb-node-title {
  font-size: 18px;
  font-weight: 700;
  fill: #111827;
  font-family: 'BIZ UDPMincho', serif;
}
.zb-node-sub {
  font-size: 13px;
  fill: #475569;
  font-family: 'JetBrains Mono', monospace;
  font-weight: 600;
}
.zb-prover-title {
  font-size: 18px;
  font-weight: 700;
  fill: #111827;
  font-family: 'BIZ UDPMincho', serif;
}
.zb-prover-sub {
  font-size: 13px;
  fill: #92400e;
  font-family: 'JetBrains Mono', monospace;
  font-weight: 700;
}

/* Wires */
.zb-wire-amber {
  stroke: #b45309;
  stroke-width: 2.5;
  stroke-dasharray: 6 3;
  animation: zb-flow 0.9s linear infinite;
  fill: none;
}
.zb-wire-cryptographic {
  stroke: #b45309;
  stroke-width: 2.5;
  stroke-dasharray: 6 3;
  animation: zb-flow 1s linear infinite;
  fill: none;
}
.zb-wire-green {
  stroke: #059669;
  stroke-width: 2.5;
  stroke-dasharray: 6 3;
  animation: zb-flow 0.9s linear infinite;
  fill: none;
}
@keyframes zb-flow { to { stroke-dashoffset: -18; } }

.zb-wire-label {
  font-size: 13px;
  fill: #78350f;
  font-weight: 700;
  font-family: 'JetBrains Mono', monospace;
}
.zb-wire-label-g {
  font-size: 13px;
  fill: #064e3b;
  font-weight: 800;
  font-family: 'JetBrains Mono', monospace;
}

/* Contrast banner */
.zb-contrast-title {
  font-size: 16px;
  font-weight: 800;
  fill: #7f1d1d;
  font-family: 'BIZ UDPMincho', serif;
}
.zb-contrast-line {
  font-size: 13px;
  fill: #991b1b;
  font-weight: 600;
  font-family: 'JetBrains Mono', monospace;
}
.zb-emph-bad { fill: #dc2626; font-weight: 800; }
.zb-emph-good { fill: #059669; font-weight: 800; }
.zb-italic { font-style: italic; fill: #b91c1c; }

/* Transitions */
.zb-fade-enter-active, .zb-fade-leave-active {
  transition: opacity 0.5s ease, transform 0.5s ease;
}
.zb-fade-enter-from { opacity: 0; transform: translateY(4px); }
.zb-fade-leave-to { opacity: 0; transform: translateY(-4px); }
</style>
