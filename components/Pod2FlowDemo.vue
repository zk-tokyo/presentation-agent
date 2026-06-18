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
const phaseDurations = [4000, 4000, 4200, 5000, 4800, 5200]
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

// phase: 0 発行 / 1 保有 / 2 要求 / 3 証明 / 4 検証 / 5 合成
const issuerActive = computed(() => phase.value === 0)
const issuerDone   = computed(() => phase.value >= 1)
const podFresh     = computed(() => phase.value === 0)
const holderActive = computed(() => phase.value >= 1)
const holderBusy   = computed(() => phase.value === 3)
const requesting   = computed(() => phase.value === 2)
const proving      = computed(() => phase.value === 3)
const proofDone    = computed(() => phase.value >= 4)
const verified     = computed(() => phase.value >= 4)
const composing    = computed(() => phase.value >= 5)
const localHot     = computed(() => phase.value === 3)

const captions = [
  { code: 'issuer.sign({ event:"Devcon", age:25 })  →  SignedPOD', tag: '発行' },
  { code: 'pod.verifySignature(issuerPubKey)   // EdDSA + Merkle root', tag: '保有' },
  { code: 'request:  Prove{ age ≥ 18  ∧  signedBy(issuer) }', tag: '要求' },
  { code: 'MainPOD ← GPC.prove(pod, predicate)   // 秘密はローカル', tag: '証明' },
  { code: 'verify(MainPOD) → ✓   age≥18 のみ開示・他は秘匿', tag: '検証' },
  { code: 'MainPOD は POD → 別の MainPOD へ再投入（再帰合成）', tag: '合成' },
]
const cap = computed(() => captions[phase.value])
</script>

<template>
  <div class="pf-root">
    <!-- ===== caption strip (top) ===== -->
    <div class="pf-strip">
      <transition name="pf-fade" mode="out-in">
        <code :key="phase" class="pf-code">{{ cap.code }}</code>
      </transition>
      <transition name="pf-fade" mode="out-in">
        <span :key="phase" class="pf-tag">{{ cap.tag }}</span>
      </transition>
    </div>

    <!-- ===== main SVG ===== -->
    <svg class="pf-svg" viewBox="0 -8 1200 218" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="pf-arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" class="pf-marker"/>
        </marker>
        <marker id="pf-arrow-amber" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" class="pf-marker-amber"/>
        </marker>
        <marker id="pf-arrow-indigo" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" class="pf-marker-indigo"/>
        </marker>
      </defs>

      <!-- ===== trust bands ===== -->
      <g class="pf-band" :class="{ 'is-hot': localHot }">
        <rect x="498" y="42" width="404" height="128" rx="10" class="pf-band-local"/>
        <text x="514" y="62" class="pf-band-label">ローカル — 秘密データは外に出ない</text>
        <!-- lock glyph -->
        <g transform="translate(880, 55)" class="pf-lock">
          <rect x="-7" y="-3" width="14" height="11" rx="2" class="pf-lock-body"/>
          <path d="M -4,-3 L -4,-7 A 4 4 0 0 1 4,-7 L 4,-3" class="pf-lock-shackle" fill="none"/>
        </g>
      </g>
      <g class="pf-band">
        <rect x="945" y="42" width="176" height="128" rx="10" class="pf-band-verifier"/>
        <text x="961" y="62" class="pf-band-label pf-band-label-v">Verifier（アプリ / on-chain）</text>
      </g>

      <!-- ===== highway wires ===== -->
      <g class="pf-wires">
        <line class="pf-wire" :class="{ 'is-on': phase === 0 }" x1="230" y1="110" x2="290" y2="110" marker-end="url(#pf-arrow)"/>
        <line class="pf-wire" :class="{ 'is-on': phase === 1 }" x1="450" y1="110" x2="510" y2="110" marker-end="url(#pf-arrow)"/>
        <line class="pf-wire" :class="{ 'is-on': phase === 3 }" x1="670" y1="110" x2="730" y2="110" marker-end="url(#pf-arrow)"/>
        <line class="pf-wire pf-wire-proof" :class="{ 'is-on': proofDone }"
              x1="890" y1="110" x2="950" y2="110"
              :marker-end="proofDone ? 'url(#pf-arrow-indigo)' : 'url(#pf-arrow)'"/>
      </g>

      <!-- proof π badge crossing boundary -->
      <transition name="pf-fade">
        <g v-if="proofDone" class="pf-pi">
          <circle cx="920" cy="92" r="11" class="pf-pi-bg"/>
          <text x="920" y="97" text-anchor="middle" class="pf-pi-text">π</text>
        </g>
      </transition>

      <!-- request arc (verifier → holder) -->
      <transition name="pf-fade">
        <g v-if="requesting" class="pf-req">
          <path d="M 1030,64 Q 810,24 590,64" class="pf-req-arc" marker-end="url(#pf-arrow-amber)"/>
          <text x="810" y="20" text-anchor="middle" class="pf-req-label">Prove&#123; age ≥ 18 &#125; ?</text>
        </g>
      </transition>

      <!-- ===== Issuer (key holder / authority) ===== -->
      <g class="pf-node" :class="{ 'is-active': issuerActive, 'is-done': issuerDone }">
        <rect x="70" y="65" width="160" height="90" rx="8" class="pf-node-bg"/>
        <g class="pf-node-icon" transform="translate(150, 92)">
          <circle cx="-8" cy="0" r="7" fill="none" class="pf-ic-stroke"/>
          <line x1="-1" y1="0" x2="15" y2="0" class="pf-ic-stroke"/>
          <line x1="10" y1="0" x2="10" y2="6" class="pf-ic-stroke"/>
          <line x1="15" y1="0" x2="15" y2="5" class="pf-ic-stroke"/>
        </g>
        <text x="150" y="138" text-anchor="middle" class="pf-node-title">Issuer</text>
      </g>

      <!-- ===== SignedPOD (issued credential) ===== -->
      <g class="pf-node pf-pod" :class="{ 'is-fresh': podFresh }">
        <rect x="290" y="65" width="160" height="90" rx="8" class="pf-node-bg"/>
        <g class="pf-node-icon" transform="translate(370, 90)">
          <rect x="-17" y="-14" width="34" height="28" rx="3" class="pf-ic-fill"/>
          <line x1="-11" y1="-6" x2="7" y2="-6" class="pf-ic-line-light"/>
          <line x1="-11" y1="0" x2="11" y2="0" class="pf-ic-line-light"/>
          <line x1="-11" y1="6" x2="3" y2="6" class="pf-ic-line-light"/>
          <circle cx="12" cy="10" r="3.4" class="pf-seal"/>
        </g>
        <text x="370" y="138" text-anchor="middle" class="pf-node-title pf-mono">SignedPOD</text>
      </g>

      <!-- ===== Holder (wallet) ===== -->
      <g class="pf-node" :class="{ 'is-active': holderActive, 'is-busy': holderBusy }">
        <rect x="510" y="65" width="160" height="90" rx="8" class="pf-node-bg"/>
        <g class="pf-node-icon" transform="translate(590, 91)">
          <rect x="-17" y="-12" width="34" height="24" rx="4" class="pf-ic-fill"/>
          <path d="M -17,-4 L 17,-4" class="pf-ic-line-light"/>
          <circle cx="9" cy="4" r="3.2" class="pf-ic-clasp"/>
        </g>
        <text x="590" y="138" text-anchor="middle" class="pf-node-title">Holder</text>
      </g>

      <!-- ===== GPC / MainPOD prover ===== -->
      <g class="pf-node" :class="{ 'is-proving': proving, 'is-done': proofDone }">
        <rect x="730" y="65" width="160" height="90" rx="8" class="pf-node-bg"/>
        <g class="pf-node-icon" transform="translate(810, 91)">
          <path d="M 0,-14 L 12,-7 L 12,7 L 0,14 L -12,7 L -12,-7 Z" class="pf-ic-hex" :class="{ 'is-spin': proving }"/>
          <circle cx="0" cy="0" r="5.5" class="pf-ic-hex-core"/>
          <circle cx="0" cy="0" r="2.2" class="pf-ic-fill"/>
        </g>
        <text x="810" y="138" text-anchor="middle" class="pf-node-title pf-mono">GPC → MainPOD</text>
      </g>

      <!-- recursion self-loop (phase 5) -->
      <transition name="pf-fade">
        <g v-if="composing" class="pf-loop">
          <path d="M 858,72 C 930,8 690,8 762,72" class="pf-loop-arc" marker-end="url(#pf-arrow-indigo)"/>
          <text x="810" y="6" text-anchor="middle" class="pf-loop-label">再帰合成</text>
        </g>
      </transition>

      <!-- ===== Verifier ===== -->
      <g class="pf-node" :class="{ 'is-requesting': requesting, 'is-verified': verified }">
        <rect x="950" y="65" width="160" height="90" rx="8" class="pf-node-bg"/>
        <g class="pf-node-icon" transform="translate(1030, 91)">
          <path d="M 0,-14 L 12,-9 L 12,5 Q 12,15 0,17 Q -12,15 -12,5 L -12,-9 Z" class="pf-ic-shield"/>
          <path d="M -5,1 L -1,5 L 6,-4" class="pf-ic-check" fill="none"/>
        </g>
        <text x="1030" y="138" text-anchor="middle" class="pf-node-title">Verifier</text>
      </g>

      <!-- accepted badge -->
      <transition name="pf-fade">
        <g v-if="verified" class="pf-accept">
          <rect x="966" y="163" width="128" height="34" rx="6" class="pf-accept-box"/>
          <text x="1030" y="186" text-anchor="middle" class="pf-accept-text">✓ accepted</text>
        </g>
      </transition>

      <!-- ===== traveling particles ===== -->
      <g v-if="phase === 0" class="pf-flow">
        <circle cx="150" cy="110" r="6" class="pf-dot pf-dot-green"/>
        <circle cx="150" cy="110" r="6" class="pf-dot pf-dot-green" style="animation-delay:-1.4s"/>
      </g>
      <g v-if="phase === 1" class="pf-flow">
        <circle cx="370" cy="110" r="6" class="pf-dot pf-dot-amber"/>
        <circle cx="370" cy="110" r="6" class="pf-dot pf-dot-amber" style="animation-delay:-1.4s"/>
      </g>
      <g v-if="phase === 3" class="pf-flow">
        <circle cx="590" cy="110" r="6" class="pf-dot pf-dot-indigo"/>
        <circle cx="590" cy="110" r="6" class="pf-dot pf-dot-indigo" style="animation-delay:-1.4s"/>
      </g>
      <g v-if="phase === 4" class="pf-flow-cross">
        <circle cx="810" cy="110" r="6.5" class="pf-dot pf-dot-indigo"/>
        <circle cx="810" cy="110" r="6.5" class="pf-dot pf-dot-indigo" style="animation-delay:-1.4s"/>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.pf-root {
  position: relative;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 8px;
  font-family: 'Noto Sans JP', sans-serif;
  color: #111827;
}

/* ===== caption strip ===== */
.pf-strip {
  padding: 10px 16px;
  background: #eef2ff;
  border: 1px solid #c7d2fe;
  border-radius: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  min-height: 44px;
}
.pf-code {
  font-family: 'JetBrains Mono', 'Menlo', monospace;
  font-size: 18px;
  color: #1e1b4b;
  font-weight: 600;
}
.pf-tag {
  flex: none;
  font-size: 16px;
  font-weight: 900;
  color: #92400e;
  background: #fef3c7;
  border: 1px solid #fcd34d;
  border-radius: 6px;
  padding: 3px 14px;
  letter-spacing: 0.08em;
}

/* ===== SVG ===== */
.pf-svg {
  width: 100%;
  height: auto;
  display: block;
  font-family: 'Noto Sans JP', sans-serif;
}

/* trust bands */
.pf-band-local {
  fill: rgba(16, 185, 129, 0.05);
  stroke: #6ee7b7;
  stroke-width: 1.5;
  stroke-dasharray: 6 4;
  transition: fill 0.5s, stroke 0.5s;
}
.pf-band.is-hot .pf-band-local {
  fill: rgba(16, 185, 129, 0.12);
  stroke: #10b981;
}
.pf-band-verifier {
  fill: rgba(99, 102, 241, 0.05);
  stroke: #c7d2fe;
  stroke-width: 1.5;
  stroke-dasharray: 6 4;
}
.pf-band-label {
  font-size: 14px;
  font-weight: 700;
  fill: #047857;
  letter-spacing: 0.06em;
}
.pf-band-label-v { fill: #4f46e5; }
.pf-lock-body { fill: #10b981; }
.pf-lock-shackle { stroke: #10b981; stroke-width: 2; }

/* wires */
.pf-wire {
  stroke: #cbd5e1;
  stroke-width: 2.5;
  stroke-linecap: round;
  transition: stroke 0.4s, stroke-width 0.4s;
}
.pf-wire.is-on {
  stroke: #f59e0b;
  stroke-width: 3.5;
}
.pf-wire-proof.is-on {
  stroke: #6366f1;
  stroke-width: 3.5;
  filter: drop-shadow(0 0 5px rgba(99, 102, 241, 0.55));
}
.pf-marker { fill: #cbd5e1; }
.pf-marker-amber { fill: #f59e0b; }
.pf-marker-indigo { fill: #6366f1; }

/* proof π badge */
.pf-pi-bg {
  fill: #6366f1;
  stroke: #4338ca;
  stroke-width: 1.5;
  filter: drop-shadow(0 0 6px rgba(99, 102, 241, 0.6));
}
.pf-pi-text {
  font-size: 15px;
  font-weight: 900;
  fill: white;
  font-family: 'JetBrains Mono', monospace;
}

/* request arc */
.pf-req-arc {
  fill: none;
  stroke: #f59e0b;
  stroke-width: 2.5;
  stroke-dasharray: 6 4;
  animation: pf-dash 0.8s linear infinite;
}
@keyframes pf-dash { to { stroke-dashoffset: -20; } }
.pf-req-label {
  font-size: 15px;
  font-weight: 700;
  fill: #b45309;
  font-family: 'JetBrains Mono', monospace;
}

/* nodes */
.pf-node-bg {
  fill: white;
  stroke: #94a3b8;
  stroke-width: 2;
  transition: fill 0.4s, stroke 0.4s, filter 0.4s;
}
.pf-node-title {
  font-size: 19px;
  font-weight: 700;
  fill: #111827;
  font-family: 'BIZ UDPMincho', serif;
}
.pf-mono {
  font-size: 17px;
  font-family: 'JetBrains Mono', monospace;
  font-weight: 700;
}
.pf-ic-fill { fill: #475569; }
.pf-ic-stroke { stroke: #475569; stroke-width: 2.2; fill: none; stroke-linecap: round; }
.pf-ic-line-light { stroke: white; stroke-width: 1.6; stroke-linecap: round; }
.pf-ic-clasp { fill: #cbd5e1; }
.pf-seal { fill: #f59e0b; }
.pf-ic-hex { fill: #475569; transition: fill 0.4s; transform-origin: center; transform-box: fill-box; }
.pf-ic-hex-core { fill: white; }
.pf-ic-shield { fill: #475569; transition: fill 0.4s; }
.pf-ic-check { stroke: white; stroke-width: 2.4; stroke-linecap: round; stroke-linejoin: round; }

/* node active/done states */
.pf-node.is-active .pf-node-bg { stroke: #f59e0b; fill: #fffbeb; }
.pf-node.is-done .pf-node-bg { stroke: #10b981; fill: #f0fdf4; }
.pf-node.is-busy .pf-node-bg { stroke: #6366f1; fill: #eef2ff; }
.pf-pod.is-fresh .pf-node-bg {
  stroke: #f59e0b;
  fill: #fffbeb;
  filter: drop-shadow(0 0 8px rgba(245, 158, 11, 0.45));
}
.pf-node.is-proving .pf-node-bg {
  stroke: #6366f1;
  stroke-width: 3;
  fill: #eef2ff;
  filter: drop-shadow(0 0 9px rgba(99, 102, 241, 0.5));
}
.pf-node.is-proving .pf-ic-hex { fill: #6366f1; }
.pf-node.is-requesting .pf-node-bg { stroke: #f59e0b; fill: #fffbeb; }
.pf-node.is-verified .pf-node-bg {
  stroke: #10b981;
  stroke-width: 3;
  fill: #f0fdf4;
  filter: drop-shadow(0 0 8px rgba(16, 185, 129, 0.45));
}
.pf-node.is-verified .pf-ic-shield { fill: #10b981; }

/* gear spin while proving */
.pf-ic-hex.is-spin { animation: pf-spin 2.4s linear infinite; }
@keyframes pf-spin { to { transform: rotate(360deg); } }

/* recursion loop */
.pf-loop-arc {
  fill: none;
  stroke: #6366f1;
  stroke-width: 2.5;
  stroke-dasharray: 6 4;
  animation: pf-dash 0.9s linear infinite;
}
.pf-loop-label {
  font-size: 15px;
  font-weight: 700;
  fill: #4338ca;
}

/* accepted badge */
.pf-accept-box { fill: #047857; stroke: #065f46; stroke-width: 2; }
.pf-accept-text {
  font-size: 17px;
  font-weight: 900;
  fill: #ecfdf5;
  font-family: 'JetBrains Mono', monospace;
}

/* particles */
.pf-dot { animation: pf-flow 2.8s linear infinite; }
.pf-dot-green  { fill: #10b981; filter: drop-shadow(0 0 5px rgba(16,185,129,0.7)); }
.pf-dot-amber  { fill: #f59e0b; filter: drop-shadow(0 0 5px rgba(245,158,11,0.7)); }
.pf-dot-indigo { fill: #6366f1; filter: drop-shadow(0 0 6px rgba(99,102,241,0.8)); }
@keyframes pf-flow {
  0%   { transform: translateX(0); opacity: 0; }
  8%   { opacity: 1; }
  92%  { opacity: 1; }
  100% { transform: translateX(220px); opacity: 0; }
}

/* transitions */
.pf-fade-enter-active, .pf-fade-leave-active {
  transition: opacity 0.4s ease, transform 0.4s ease;
}
.pf-fade-enter-from, .pf-fade-leave-to { opacity: 0; transform: translateY(-4px); }
</style>
