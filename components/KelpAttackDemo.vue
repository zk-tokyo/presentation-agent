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
const phaseDurations = [3500, 4500, 3500, 4500, 5000, 4500]
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

const dvnCount        = computed(() => phase.value === 0 ? 3 : 1)
const showExtraDVNs   = computed(() => phase.value === 0)
const rpcCompromised  = computed(() => phase.value >= 2)
const rpcOffline      = computed(() => phase.value >= 3)
const pollActive      = computed(() => phase.value >= 4)
const attestationActive = computed(() => phase.value >= 4)
const drained         = computed(() => phase.value >= 5)
const showHealthyFlow = computed(() => phase.value === 0)
const showHealthyPoll = computed(() => phase.value <= 1)

const rpcs = [0, 1, 2, 3, 4].map(i => ({
  idx: i,
  kind: i < 2 ? 'internal' : 'external',
  x: 285 + i * 125,
  cx: 340 + i * 125,
}))
</script>

<template>
  <div class="kf-root">
    <!-- ===== Config strip (top) — big and central ===== -->
    <div class="kf-config">
      <code class="kf-cfg-code">
        setConfig(ulnConfig.<span class="kf-cfg-key">requiredDVNCount</span>:&nbsp;<transition name="kf-num" mode="out-in">
          <span :key="dvnCount" class="kf-cfg-num" :class="{ 'is-fatal': phase >= 1 }">{{ dvnCount }}</span>
        </transition>)
      </code>
      <transition name="kf-fade">
        <div v-if="phase >= 1" class="kf-cfg-note">
          ⚠ 1-of-1 — 1 票で release
        </div>
      </transition>
    </div>

    <!-- ===== Main SVG diagram ===== -->
    <svg class="kf-svg" viewBox="0 0 1200 430" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="kf-arrow-end" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" class="kf-marker"/>
        </marker>
        <marker id="kf-arrow-bad" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" class="kf-marker-bad"/>
        </marker>
      </defs>

      <!-- ===== chain bands ===== -->
      <g class="kf-chain">
        <rect x="50" y="30" width="395" height="125" rx="8" class="kf-chain-bg"/>
        <text x="65" y="50" class="kf-chain-label">KARAK L2</text>
      </g>
      <g class="kf-chain">
        <rect x="270" y="285" width="660" height="140" rx="8" class="kf-chain-bg"/>
        <text x="285" y="304" class="kf-chain-label">KARAK L2 RPC</text>
      </g>
      <g class="kf-chain">
        <rect x="755" y="30" width="425" height="125" rx="8" class="kf-chain-bg-eth"/>
        <text x="770" y="50" class="kf-chain-label kf-chain-label-eth">ETHEREUM</text>
      </g>

      <!-- ===== bridge highway wires (longer for breathing room) ===== -->
      <g class="kf-wires">
        <line class="kf-wire" x1="222" y1="110" x2="270" y2="110" marker-end="url(#kf-arrow-end)"/>
        <line class="kf-wire" x1="437" y1="110" x2="485" y2="110" marker-end="url(#kf-arrow-end)"/>
        <line class="kf-wire kf-wire-out" :class="{ 'is-bad': attestationActive }"
              x1="712" y1="110" x2="760" y2="110"
              :marker-end="attestationActive ? 'url(#kf-arrow-bad)' : 'url(#kf-arrow-end)'"/>
        <line class="kf-wire kf-wire-out" :class="{ 'is-bad': attestationActive }"
              x1="937" y1="110" x2="985" y2="110"
              :marker-end="attestationActive ? 'url(#kf-arrow-bad)' : 'url(#kf-arrow-end)'"/>
      </g>

      <!-- ===== poll connection (DVN ↔ RPC pool) ===== -->
      <g class="kf-poll-info">
        <line class="kf-poll-wire" :class="{ 'is-active': pollActive }"
              x1="590" y1="262" x2="590" y2="285"
              :marker-end="pollActive ? 'url(#kf-arrow-bad)' : 'url(#kf-arrow-end)'"/>
        <line class="kf-poll-resp" :class="{ 'is-bad': pollActive, 'is-active': showHealthyPoll }"
              x1="620" y1="285" x2="620" y2="262"
              :marker-end="pollActive ? 'url(#kf-arrow-bad)' : 'url(#kf-arrow-end)'"/>
      </g>

      <!-- Healthy poll dots -->
      <g v-if="showHealthyPoll" class="kf-poll-traffic">
        <circle cx="590" cy="262" r="3" class="kf-poll-dot-down"/>
        <circle cx="620" cy="285" r="3" class="kf-poll-dot-up"/>
      </g>

      <!-- ===== Source / User (Karak L2) ===== -->
      <g class="kf-node">
        <rect x="60" y="65" width="160" height="90" rx="8" class="kf-node-bg"/>
        <g class="kf-node-icon" transform="translate(140, 90)">
          <circle cx="0" cy="-9" r="7" class="kf-icon-stroke"/>
          <path d="M -10,3 Q 0,0 10,3 L 9,17 L -9,17 Z" class="kf-icon-fill"/>
        </g>
        <text x="140" y="138" text-anchor="middle" class="kf-node-title">User</text>
      </g>

      <!-- ===== L0 Endpoint ===== -->
      <g class="kf-node">
        <rect x="275" y="65" width="160" height="90" rx="8" class="kf-node-bg"/>
        <g class="kf-node-icon" transform="translate(355, 92)">
          <rect x="-16" y="-10" width="32" height="20" rx="2.5" class="kf-icon-fill"/>
          <path d="M -16,-10 L 0,3 L 16,-10" class="kf-icon-line-light" fill="none"/>
        </g>
        <text x="355" y="138" text-anchor="middle" class="kf-node-title">L0 Endpoint</text>
      </g>

      <!-- ===== DVN cluster ===== -->
      <g class="kf-cluster">
        <rect x="490" y="35" width="220" height="225" rx="10" class="kf-cluster-bg"/>
        <text x="600" y="56" text-anchor="middle" class="kf-cluster-label">DVN multisig</text>

        <!-- DVN #1 — primary, always visible -->
        <g class="kf-dvn kf-dvn-primary" :class="{ 'is-poll': pollActive }">
          <rect x="505" y="78" width="190" height="52" rx="7" class="kf-dvn-bg"/>
          <g class="kf-dvn-icon" transform="translate(535, 104)">
            <path d="M 0,-13 L 11,-8 L 11,5 Q 11,14 0,16 Q -11,14 -11,5 L -11,-8 Z" class="kf-shield"/>
            <path d="M -4,2 L 0,6 L 6,-3" stroke="white" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
          </g>
          <text x="620" y="111" text-anchor="middle" class="kf-dvn-name">DVN #1</text>
        </g>

        <!-- DVN #2 — fades out at phase 1 -->
        <g class="kf-dvn kf-dvn-extra" :class="{ 'is-removed': !showExtraDVNs }">
          <rect x="505" y="140" width="190" height="52" rx="7" class="kf-dvn-bg"/>
          <g class="kf-dvn-icon" transform="translate(535, 166)">
            <path d="M 0,-13 L 11,-8 L 11,5 Q 11,14 0,16 Q -11,14 -11,5 L -11,-8 Z" class="kf-shield"/>
            <path d="M -4,2 L 0,6 L 6,-3" stroke="white" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
          </g>
          <text x="620" y="173" text-anchor="middle" class="kf-dvn-name">DVN #2</text>
          <g v-if="!showExtraDVNs" class="kf-x-mark-g">
            <line x1="510" y1="145" x2="690" y2="187" class="kf-x-mark"/>
            <line x1="690" y1="145" x2="510" y2="187" class="kf-x-mark"/>
          </g>
        </g>

        <!-- DVN #3 — fades out at phase 1 -->
        <g class="kf-dvn kf-dvn-extra" :class="{ 'is-removed': !showExtraDVNs }">
          <rect x="505" y="202" width="190" height="52" rx="7" class="kf-dvn-bg"/>
          <g class="kf-dvn-icon" transform="translate(535, 228)">
            <path d="M 0,-13 L 11,-8 L 11,5 Q 11,14 0,16 Q -11,14 -11,5 L -11,-8 Z" class="kf-shield"/>
            <path d="M -4,2 L 0,6 L 6,-3" stroke="white" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
          </g>
          <text x="620" y="235" text-anchor="middle" class="kf-dvn-name">DVN #3</text>
          <g v-if="!showExtraDVNs" class="kf-x-mark-g">
            <line x1="510" y1="207" x2="690" y2="249" class="kf-x-mark"/>
            <line x1="690" y1="207" x2="510" y2="249" class="kf-x-mark"/>
          </g>
        </g>

        <!-- "1-of-1" badge -->
        <g v-if="!showExtraDVNs" class="kf-1of1-badge">
          <rect x="645" y="38" width="58" height="22" rx="4" class="kf-1of1-bg"/>
          <text x="674" y="54" text-anchor="middle" class="kf-1of1-text">1-of-1</text>
        </g>
      </g>

      <!-- ===== ULN302 ===== -->
      <g class="kf-node">
        <rect x="765" y="65" width="170" height="90" rx="8" class="kf-node-bg"/>
        <g class="kf-node-icon" transform="translate(850, 92)">
          <rect x="-13" y="-13" width="26" height="26" rx="3" class="kf-icon-fill"/>
          <path d="M -5,1 L -1,5 L 5,-3" stroke="white" stroke-width="2.4" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
        </g>
        <text x="850" y="138" text-anchor="middle" class="kf-node-title">ULN302</text>
      </g>

      <!-- ===== rsETH Bridge ===== -->
      <g class="kf-node" :class="{ 'kf-node-drained': drained }">
        <rect x="990" y="65" width="180" height="90" rx="8" class="kf-node-bg"/>
        <g class="kf-node-icon" transform="translate(1080, 92)">
          <rect x="-15" y="-14" width="30" height="28" rx="3" class="kf-icon-fill"/>
          <circle cx="0" cy="0" r="8" fill="none" stroke="white" stroke-width="2"/>
          <circle cx="0" cy="0" r="1.8" fill="white"/>
          <line x1="0" y1="-12" x2="0" y2="-9" stroke="white" stroke-width="1.8"/>
          <line x1="0" y1="9" x2="0" y2="12" stroke="white" stroke-width="1.8"/>
          <line x1="-12" y1="0" x2="-9" y2="0" stroke="white" stroke-width="1.8"/>
          <line x1="9" y1="0" x2="12" y2="0" stroke="white" stroke-width="1.8"/>
        </g>
        <text x="1080" y="138" text-anchor="middle" class="kf-node-title">rsETH Bridge</text>
      </g>

      <!-- Drain consequence (below Bridge) -->
      <transition name="kf-fade">
        <g v-if="drained" class="kf-drain-g">
          <rect x="990" y="165" width="180" height="44" rx="6" class="kf-drain-box"/>
          <text x="1080" y="194" text-anchor="middle" class="kf-drain-amount">−116,500 rsETH</text>
        </g>
      </transition>

      <!-- ===== RPC pool nodes ===== -->
      <g class="kf-pool">
        <g v-for="rpc in rpcs" :key="rpc.idx"
           class="kf-rpc"
           :class="[
             rpc.kind === 'internal' ? 'kf-rpc-internal' : 'kf-rpc-external',
             { 'is-compromised': rpc.kind === 'internal' && rpcCompromised,
               'is-lying':       rpc.kind === 'internal' && pollActive,
               'is-offline':     rpc.kind === 'external' && rpcOffline }
           ]">
          <rect :x="rpc.x" y="318" width="110" height="100" rx="7" class="kf-rpc-bg"/>
          <g class="kf-rpc-icon" :transform="`translate(${rpc.cx}, 348)`">
            <rect x="-15" y="-11" width="30" height="7" rx="1" class="kf-server-shelf"/>
            <rect x="-15" y="-1" width="30" height="7" rx="1" class="kf-server-shelf"/>
            <rect x="-15" y="9"  width="30" height="7" rx="1" class="kf-server-shelf"/>
            <circle cx="-11" cy="-7.5" r="1.5" class="kf-server-led"/>
            <circle cx="-11" cy="2.5"  r="1.5" class="kf-server-led"/>
            <circle cx="-11" cy="12.5" r="1.5" class="kf-server-led"/>
          </g>
          <text :x="rpc.cx" y="386" text-anchor="middle" class="kf-rpc-id">RPC #{{ rpc.idx + 1 }}</text>
          <text :x="rpc.cx" y="409" text-anchor="middle" class="kf-rpc-state">
            <template v-if="rpc.kind === 'internal'">
              <tspan v-if="pollActive">"BURN ✓"</tspan>
              <tspan v-else-if="rpcCompromised">🔓 hijacked</tspan>
              <tspan v-else>healthy</tspan>
            </template>
            <template v-else>
              <tspan v-if="rpcOffline">⊗ DDoS'd</tspan>
              <tspan v-else>healthy</tspan>
            </template>
          </text>

          <!-- DDoS ⊗ overlay on offline external RPCs -->
          <g v-if="rpc.kind === 'external' && rpcOffline" class="kf-rpc-offline-overlay">
            <line :x1="rpc.x + 8"  y1="322" :x2="rpc.x + 102" y2="414" class="kf-rpc-x"/>
            <line :x1="rpc.x + 102" y1="322" :x2="rpc.x + 8" y2="414" class="kf-rpc-x"/>
          </g>
        </g>

        <!-- DDoS bursts hitting external RPCs (phase 3 entrance) -->
        <g v-if="phase === 3" class="kf-ddos-bursts">
          <circle v-for="(rpc, i) in rpcs.filter(r => r.kind === 'external')" :key="'b1-' + i"
                  :cx="rpc.cx" cy="368" r="0" class="kf-burst" :style="{ animationDelay: (i * 0.18) + 's' }"/>
          <circle v-for="(rpc, i) in rpcs.filter(r => r.kind === 'external')" :key="'b2-' + i"
                  :cx="rpc.cx" cy="368" r="0" class="kf-burst" :style="{ animationDelay: (i * 0.18 + 0.4) + 's' }"/>
        </g>
      </g>

      <!-- ===== Healthy message flow (phase 0 only) ===== -->
      <g v-if="showHealthyFlow" class="kf-healthy">
        <circle cx="140" cy="110" r="6" class="kf-msg-particle"/>
        <circle cx="140" cy="110" r="6" class="kf-msg-particle" style="animation-delay: -1s"/>
        <circle cx="140" cy="110" r="6" class="kf-msg-particle" style="animation-delay: -2s"/>
      </g>

      <!-- ===== False attestation particles (phase 4+) ===== -->
      <g v-if="attestationActive" class="kf-attest">
        <circle cx="700" cy="110" r="7" class="kf-attest-particle"/>
        <circle cx="700" cy="110" r="7" class="kf-attest-particle" style="animation-delay: -1s"/>
      </g>

      <!-- ===== Lie-response arrows from internal RPCs → DVN (phase 4) ===== -->
      <g v-if="pollActive" class="kf-lies">
        <line x1="340" y1="318" x2="585" y2="120" class="kf-lie-arrow"/>
        <line x1="465" y1="318" x2="600" y2="120" class="kf-lie-arrow"/>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.kf-root {
  position: relative;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 8px;
  font-family: 'Noto Sans JP', sans-serif;
  color: #111827;
}

/* ===== Config strip ===== */
.kf-config {
  padding: 10px 16px;
  background: #eef2ff;
  border: 1px solid #c7d2fe;
  border-radius: 0.5rem;
  display: flex;
  align-items: center;
  gap: 16px;
  flex-wrap: wrap;
  min-height: 44px;
}
.kf-cfg-code {
  font-family: 'JetBrains Mono', 'Menlo', monospace;
  font-size: 18px;
  color: #1e1b4b;
  display: inline-flex;
  align-items: center;
  gap: 3px;
  font-weight: 600;
}
.kf-cfg-key { color: #4f46e5; font-weight: 700; }
.kf-cfg-num {
  display: inline-block;
  min-width: 30px;
  padding: 2px 12px;
  border-radius: 5px;
  color: #be185d;
  font-weight: 900;
  font-size: 22px;
  background: white;
  border: 1px solid #e9d5ff;
  text-align: center;
}
.kf-cfg-num.is-fatal {
  color: white;
  background: #dc2626;
  border-color: #991b1b;
  box-shadow: 0 0 0 2px rgba(220, 38, 38, 0.25);
  animation: kf-pulse 1.5s ease-in-out infinite;
}
@keyframes kf-pulse {
  0%, 100% { box-shadow: 0 0 0 2px rgba(220, 38, 38, 0.25); }
  50%      { box-shadow: 0 0 0 6px rgba(220, 38, 38, 0.45); }
}
.kf-cfg-note {
  font-size: 15px;
  font-weight: 700;
  color: #7f1d1d;
  background: #fee2e2;
  border-left: 4px solid #dc2626;
  padding: 5px 12px;
  border-radius: 4px;
}

/* ===== SVG diagram ===== */
.kf-svg {
  width: 100%;
  height: auto;
  display: block;
  font-family: 'Noto Sans JP', sans-serif;
}

/* chain bands */
.kf-chain-bg {
  fill: rgba(99, 102, 241, 0.05);
  stroke: #c7d2fe;
  stroke-width: 1.5;
  stroke-dasharray: 6 4;
}
.kf-chain-bg-eth {
  fill: rgba(107, 114, 128, 0.05);
  stroke: #d1d5db;
  stroke-width: 1.5;
  stroke-dasharray: 6 4;
}
.kf-chain-label {
  font-size: 14px;
  font-weight: 700;
  fill: #4f46e5;
  letter-spacing: 0.12em;
}
.kf-chain-label-eth { fill: #4b5563; }

/* wires & markers */
.kf-wire {
  stroke: #94a3b8;
  stroke-width: 2.5;
  stroke-linecap: round;
  transition: stroke 0.4s, stroke-width 0.4s;
}
.kf-wire-out.is-bad {
  stroke: #dc2626;
  stroke-width: 3.5;
  filter: drop-shadow(0 0 5px rgba(220, 38, 38, 0.6));
  stroke-dasharray: 5 3;
  animation: kf-wire-flow 0.8s linear infinite;
}
@keyframes kf-wire-flow { to { stroke-dashoffset: -16; } }
.kf-marker { fill: #94a3b8; }
.kf-marker-bad { fill: #dc2626; }

/* poll wires */
.kf-poll-wire {
  stroke: #94a3b8;
  stroke-width: 2.5;
  stroke-dasharray: 5 3;
  transition: stroke 0.4s;
}
.kf-poll-wire.is-active {
  stroke: #dc2626;
  animation: kf-wire-flow 0.8s linear infinite;
}
.kf-poll-resp {
  stroke: #94a3b8;
  stroke-width: 2.5;
  stroke-dasharray: 5 3;
  transition: stroke 0.4s;
}
.kf-poll-resp.is-active {
  stroke: #10b981;
  animation: kf-wire-flow-rev 1.2s linear infinite;
}
.kf-poll-resp.is-bad {
  stroke: #dc2626;
  animation: kf-wire-flow-rev 0.8s linear infinite;
}
@keyframes kf-wire-flow-rev { to { stroke-dashoffset: 16; } }

/* poll dots */
.kf-poll-dot-down {
  fill: #6b7280;
  animation: kf-poll-down 1.8s linear infinite;
}
.kf-poll-dot-up {
  fill: #10b981;
  animation: kf-poll-up 1.8s linear infinite;
  animation-delay: 0.9s;
}
@keyframes kf-poll-down {
  0%   { opacity: 0; transform: translateY(0); }
  10%  { opacity: 1; }
  90%  { opacity: 1; }
  100% { opacity: 0; transform: translateY(26px); }
}
@keyframes kf-poll-up {
  0%   { opacity: 0; transform: translateY(0); }
  10%  { opacity: 1; }
  90%  { opacity: 1; }
  100% { opacity: 0; transform: translateY(-26px); }
}

/* node boxes */
.kf-node-bg {
  fill: white;
  stroke: #94a3b8;
  stroke-width: 2;
  transition: fill 0.4s, stroke 0.4s, filter 0.4s;
}
.kf-node-drained .kf-node-bg {
  fill: #fef2f2;
  stroke: #dc2626;
  filter: drop-shadow(0 0 10px rgba(220, 38, 38, 0.5));
}
.kf-node-title {
  font-size: 19px;
  font-weight: 700;
  fill: #111827;
  font-family: 'BIZ UDPMincho', serif;
}

/* node icons */
.kf-icon-fill { fill: #475569; }
.kf-icon-stroke { fill: #475569; stroke: #1e293b; stroke-width: 0.5; }
.kf-icon-line-light { stroke: white; stroke-width: 1.5; }

/* DVN cluster */
.kf-cluster-bg {
  fill: #f1f5f9;
  stroke: #94a3b8;
  stroke-width: 2;
  stroke-dasharray: 5 4;
}
.kf-cluster-label {
  font-size: 14px;
  font-weight: 700;
  fill: #475569;
  letter-spacing: 0.08em;
}
.kf-dvn { transition: opacity 0.7s ease, transform 0.7s ease; }
.kf-dvn-bg {
  fill: white;
  stroke: #94a3b8;
  stroke-width: 2;
  transition: stroke 0.4s, fill 0.4s, filter 0.4s;
}
.kf-shield {
  fill: #475569;
  transition: fill 0.4s;
}
.kf-dvn-name {
  font-size: 18px;
  font-weight: 700;
  fill: #1f2937;
  font-family: 'JetBrains Mono', monospace;
}
.kf-dvn-primary.is-poll .kf-dvn-bg {
  stroke: #dc2626;
  stroke-width: 3;
  fill: #fef2f2;
  filter: drop-shadow(0 0 8px rgba(220, 38, 38, 0.5));
}
.kf-dvn-primary.is-poll .kf-shield { fill: #dc2626; }
.kf-dvn-extra.is-removed { opacity: 0.16; }
.kf-x-mark {
  stroke: #dc2626;
  stroke-width: 3;
  stroke-linecap: round;
  opacity: 0.78;
}
.kf-1of1-bg {
  fill: #dc2626;
  stroke: #991b1b;
  stroke-width: 1.5;
}
.kf-1of1-text {
  font-size: 13px;
  font-weight: 900;
  fill: white;
  letter-spacing: 0.06em;
  font-family: 'JetBrains Mono', monospace;
}

/* RPC pool */
.kf-rpc { transition: all 0.5s; }
.kf-rpc-bg {
  fill: white;
  stroke: #10b981;
  stroke-width: 2;
  transition: stroke 0.5s, fill 0.5s, stroke-width 0.5s, filter 0.5s;
}
.kf-server-shelf {
  fill: #475569;
  transition: fill 0.5s;
}
.kf-server-led {
  fill: #10b981;
  transition: fill 0.5s;
}
.kf-rpc-id {
  font-size: 17px;
  font-weight: 700;
  fill: #1f2937;
  font-family: 'JetBrains Mono', monospace;
}
.kf-rpc-state {
  font-size: 14px;
  font-weight: 700;
  fill: #10b981;
  font-family: 'JetBrains Mono', monospace;
  transition: fill 0.5s;
}

.kf-rpc.is-compromised .kf-rpc-bg {
  stroke: #f59e0b;
  fill: #fffbeb;
}
.kf-rpc.is-compromised .kf-server-led { fill: #f59e0b; }
.kf-rpc.is-compromised .kf-rpc-state { fill: #b45309; }

.kf-rpc.is-lying .kf-rpc-bg {
  stroke: #dc2626;
  stroke-width: 2.5;
  fill: #fee2e2;
  filter: drop-shadow(0 0 6px rgba(220, 38, 38, 0.5));
}
.kf-rpc.is-lying .kf-server-led {
  fill: #dc2626;
  animation: kf-blink 0.6s linear infinite;
}
.kf-rpc.is-lying .kf-server-shelf { fill: #991b1b; }
.kf-rpc.is-lying .kf-rpc-state { fill: #991b1b; }
@keyframes kf-blink {
  0%, 100% { opacity: 1; }
  50%      { opacity: 0.25; }
}

.kf-rpc.is-offline .kf-rpc-bg {
  fill: #1f2937;
  stroke: #4b5563;
}
.kf-rpc.is-offline .kf-server-shelf { fill: #4b5563; }
.kf-rpc.is-offline .kf-server-led { fill: #4b5563; }
.kf-rpc.is-offline .kf-rpc-id { fill: #9ca3af; }
.kf-rpc.is-offline .kf-rpc-state { fill: #dc2626; }
.kf-rpc-x {
  stroke: #dc2626;
  stroke-width: 3.5;
  stroke-linecap: round;
  opacity: 0.85;
}

.kf-burst {
  fill: #dc2626;
  opacity: 0;
  transform-origin: center;
  animation: kf-burst 1s ease-out infinite;
}
@keyframes kf-burst {
  0%   { r: 0;  opacity: 0.9; }
  100% { r: 55; opacity: 0;   }
}

.kf-lie-arrow {
  stroke: #dc2626;
  stroke-width: 2;
  stroke-dasharray: 5 3;
  opacity: 0.75;
  animation: kf-lie-flow 0.9s linear infinite;
  fill: none;
}
@keyframes kf-lie-flow { to { stroke-dashoffset: -16; } }

.kf-msg-particle {
  fill: #10b981;
  filter: drop-shadow(0 0 5px rgba(16, 185, 129, 0.75));
  animation: kf-flow-healthy 3s linear infinite;
}
@keyframes kf-flow-healthy {
  0%   { transform: translateX(0); opacity: 0; }
  5%   { opacity: 1; }
  95%  { opacity: 1; }
  100% { transform: translateX(940px); opacity: 0; }
}
.kf-attest-particle {
  fill: #dc2626;
  filter: drop-shadow(0 0 10px rgba(220, 38, 38, 0.9));
  animation: kf-flow-attest 1.8s ease-out infinite;
}
@keyframes kf-flow-attest {
  0%   { transform: translateX(0); opacity: 0; }
  10%  { opacity: 1; }
  90%  { opacity: 1; }
  100% { transform: translateX(380px); opacity: 0; }
}

/* drain box */
.kf-drain-box {
  fill: #7f1d1d;
  stroke: #991b1b;
  stroke-width: 2;
}
.kf-drain-amount {
  font-size: 21px;
  font-weight: 900;
  fill: #fee2e2;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.02em;
}

/* transitions */
.kf-num-enter-active, .kf-num-leave-active {
  transition: transform 0.3s ease, opacity 0.3s ease;
}
.kf-num-enter-from { opacity: 0; transform: translateY(8px) scale(0.7); }
.kf-num-leave-to   { opacity: 0; transform: translateY(-8px) scale(0.7); }
.kf-fade-enter-active, .kf-fade-leave-active {
  transition: opacity 0.4s ease, transform 0.4s ease;
}
.kf-fade-enter-from, .kf-fade-leave-to {
  opacity: 0; transform: translateY(-4px);
}
</style>
