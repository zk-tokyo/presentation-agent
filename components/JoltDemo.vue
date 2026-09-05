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
const phaseDurations = [3500, 4000, 4500, 4500, 4500, 5500]
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
  { code: 'RISC-V program  P  →  exec  →  trace  T_P',                       note: 'CPU step を 1 つずつ追う ─ 任意の Rust / C プログラム' },
  { code: 'each CPU step  t_i  ←→  entry in lookup table  T (RISC-V ops)',  note: 'Jolt の中核設計: 全命令を巨大 lookup table に圧縮' },
  { code: 'Lasso :  prove  ∀i  ( t_i ∈ T )   in time  ∝  log|T|',           note: 'lookup argument — |T| に依存しない時間で会員性を証明' },
  { code: 'Sumcheck  verifies  Lasso  bundle  with  Fiat-Shamir',           note: '基盤プロトコル — 多項式の総和を verifier に確信させる' },
  { code: '✓  Groth16 / PLONK 比  2x  faster prover    (zkVM via lookups)', note: 'プログラムを書き直さずに証明できる' },
  { code: '⚠ precompute T のメモリ要求が大きい — mobile / IoT には不向き',     note: '罠 #1: 制約系・証明系の選択は後から変えられない' },
]

const showTrace        = computed(() => phase.value >= 1)
const showLookupArrows = computed(() => phase.value >= 2)
const showLassoBundle  = computed(() => phase.value >= 3)
const showSumcheck     = computed(() => phase.value >= 4)
const showAccept       = computed(() => phase.value >= 5)
const showWarn         = computed(() => phase.value === 5)

const steps = [
  { idx: 0, op: 'ADD',  tx: 320 },
  { idx: 1, op: 'LW',   tx: 410 },
  { idx: 2, op: 'BEQ',  tx: 500 },
  { idx: 3, op: 'XOR',  tx: 590 },
  { idx: 4, op: 'SLL',  tx: 680 },
  { idx: 5, op: 'JAL',  tx: 770 },
]

const tableCells = [
  { idx: 0, label: 'ADD',  x: 305 },
  { idx: 1, label: 'LW',   x: 388 },
  { idx: 2, label: 'BEQ',  x: 471 },
  { idx: 3, label: 'XOR',  x: 554 },
  { idx: 4, label: 'SLL',  x: 637 },
  { idx: 5, label: 'JAL',  x: 720 },
  { idx: 6, label: 'SUB',  x: 803 },
]
</script>

<template>
  <div class="jt-root">
    <!-- Caption strip -->
    <div class="jt-cap">
      <transition name="jt-fade" mode="out-in">
        <div :key="phase" class="jt-cap-inner">
          <code class="jt-code">{{ captions[phase].code }}</code>
          <div class="jt-note">{{ captions[phase].note }}</div>
        </div>
      </transition>
    </div>

    <!-- Main SVG -->
    <svg class="jt-svg" viewBox="0 0 1200 420" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="jt-ar" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#94a3b8"/>
        </marker>
        <marker id="jt-ar-amber" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#b45309"/>
        </marker>
      </defs>

      <!-- ============ Program (left column, light theme) ============ -->
      <g class="jt-prog">
        <rect x="50" y="30" width="220" height="190" rx="8"
              fill="#f8fafc" stroke="#cbd5e1" stroke-width="2"/>
        <text x="160" y="55" text-anchor="middle" class="jt-prog-title">RISC-V program</text>
        <g class="jt-prog-code">
          <text x="68" y="88"  class="jt-asm">main:</text>
          <text x="82" y="110" class="jt-asm-line"><tspan class="jt-asm-op">ADD</tspan> x1, x2, x3</text>
          <text x="82" y="128" class="jt-asm-line"><tspan class="jt-asm-op">LW</tspan>  x4, 0(x1)</text>
          <text x="82" y="146" class="jt-asm-line"><tspan class="jt-asm-op">BEQ</tspan> x4, x0, end</text>
          <text x="82" y="164" class="jt-asm-line"><tspan class="jt-asm-op">XOR</tspan> x5, x4, x1</text>
          <text x="82" y="182" class="jt-asm-line"><tspan class="jt-asm-op">SLL</tspan> x6, x5, x2</text>
          <text x="82" y="200" class="jt-asm-line"><tspan class="jt-asm-op">JAL</tspan> x0, main</text>
        </g>
      </g>

      <!-- Arrow program → trace -->
      <g v-if="showTrace" class="jt-prog-arrow">
        <line x1="270" y1="120" x2="295" y2="120" class="jt-wire"
              marker-end="url(#jt-ar)"/>
        <text x="282" y="108" text-anchor="middle" class="jt-wire-label">exec</text>
      </g>

      <!-- ============ Execution trace (middle row) ============ -->
      <g class="jt-trace-band">
        <text x="290" y="50" class="jt-band-label">Execution Trace</text>
        <line x1="290" y1="60" x2="820" y2="60" stroke="#cbd5e1" stroke-width="1" stroke-dasharray="3 3"/>
      </g>

      <g v-if="showTrace" class="jt-trace">
        <g v-for="(s, i) in steps" :key="s.idx" class="jt-step"
           :style="{ animationDelay: (i * 0.12) + 's' }">
          <rect :x="s.tx - 30" y="80" width="60" height="60" rx="6"
                fill="#fffbeb" stroke="#b45309" stroke-width="2"/>
          <text :x="s.tx" y="105" text-anchor="middle" class="jt-step-idx">t{{ s.idx + 1 }}</text>
          <text :x="s.tx" y="128" text-anchor="middle" class="jt-step-op">{{ s.op }}</text>
        </g>
      </g>

      <!-- Lookup arrows trace → table -->
      <g v-if="showLookupArrows" class="jt-lookup-arrows">
        <g v-for="(s, i) in steps" :key="`la-${s.idx}`">
          <line :x1="s.tx" y1="140" :x2="tableCells[s.idx].x + 30" y2="270"
                class="jt-lookup-line"
                :style="{ animationDelay: (i * 0.18) + 's' }"
                marker-end="url(#jt-ar-amber)"/>
        </g>
      </g>

      <!-- ============ Lookup table (bottom) ============ -->
      <g class="jt-table-band">
        <text x="290" y="240" class="jt-band-label">Lookup Table T  (RISC-V ops, |T| ≈ 2³² entries)</text>
      </g>

      <g class="jt-table">
        <rect x="290" y="265" width="530" height="100" rx="8"
              fill="#fef3c7" stroke="#d97706" stroke-width="2"/>
        <g v-for="(c, i) in tableCells" :key="c.idx" class="jt-cell"
           :class="{ 'is-hit': showLookupArrows }">
          <rect :x="c.x" y="278" width="60" height="50" rx="4"
                class="jt-cell-bg"/>
          <text :x="c.x + 30" y="307" text-anchor="middle" class="jt-cell-text">{{ c.label }}</text>
        </g>
        <text x="555" y="354" text-anchor="middle" class="jt-table-foot">
          全 RISC-V 命令を埋め込み済
        </text>
      </g>

      <!-- ============ Lasso bundle ring ============ -->
      <transition name="jt-fade">
        <g v-if="showLassoBundle" class="jt-lasso">
          <rect x="850" y="100" width="190" height="80" rx="10"
                fill="#ecfeff" stroke="#0891b2" stroke-width="2.5"
                style="filter: drop-shadow(0 0 8px rgba(8, 145, 178, 0.4));"/>
          <text x="945" y="128" text-anchor="middle" class="jt-lasso-title">Lasso</text>
          <text x="945" y="148" text-anchor="middle" class="jt-lasso-sub">lookup argument</text>
          <text x="945" y="168" text-anchor="middle" class="jt-lasso-sub">∝ log|T|</text>
        </g>
      </transition>

      <transition name="jt-fade">
        <g v-if="showLassoBundle" class="jt-lasso-collect">
          <line x1="820" y1="140" x2="850" y2="140" class="jt-wire"
                marker-end="url(#jt-ar)"/>
        </g>
      </transition>

      <!-- ============ Sumcheck verifier ============ -->
      <transition name="jt-fade">
        <g v-if="showSumcheck" class="jt-sumcheck">
          <rect x="1060" y="100" width="120" height="80" rx="10"
                fill="#f5f3ff" stroke="#7c3aed" stroke-width="2.5"
                style="filter: drop-shadow(0 0 8px rgba(124, 58, 237, 0.4));"/>
          <text x="1120" y="128" text-anchor="middle" class="jt-sc-title">Sumcheck</text>
          <text x="1120" y="148" text-anchor="middle" class="jt-sc-sub">verifies</text>
          <text x="1120" y="167" text-anchor="middle" class="jt-sc-sub">via Fiat-Shamir</text>

          <line x1="1040" y1="140" x2="1060" y2="140" class="jt-wire"
                marker-end="url(#jt-ar)"/>
        </g>
      </transition>

      <!-- ============ Accept stamp ============ -->
      <transition name="jt-fade">
        <g v-if="showAccept" class="jt-accept">
          <rect x="850" y="265" width="330" height="100" rx="10"
                fill="#dcfce7" stroke="#059669" stroke-width="3"
                style="filter: drop-shadow(0 0 10px rgba(5, 150, 105, 0.5));"/>
          <text x="1015" y="295" text-anchor="middle" class="jt-accept-title">✓ zkVM proof</text>
          <text x="1015" y="320" text-anchor="middle" class="jt-accept-sub">Groth16 / PLONK 比 証明生成 2x 高速</text>
          <text x="1015" y="345" text-anchor="middle" class="jt-accept-sub-em">プログラムを書き直さず証明できる</text>
        </g>
      </transition>

      <!-- ============ Warning overlay (last phase) ============ -->
      <transition name="jt-fade">
        <g v-if="showWarn" class="jt-warn">
          <rect x="50" y="285" width="220" height="80" rx="8"
                fill="#fee2e2" stroke="#dc2626" stroke-width="2.5"/>
          <text x="160" y="310" text-anchor="middle" class="jt-warn-title">⚠ 実装注意</text>
          <text x="160" y="332" text-anchor="middle" class="jt-warn-sub">precompute T が大きい</text>
          <text x="160" y="352" text-anchor="middle" class="jt-warn-sub">mobile / IoT 不向き</text>
        </g>
      </transition>
    </svg>
  </div>
</template>

<style scoped>
.jt-root {
  position: relative;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 6px;
  font-family: 'Noto Sans JP', sans-serif;
  color: #111827;
}

.jt-cap {
  padding: 9px 16px;
  background: #eef2ff;
  border: 1px solid #c7d2fe;
  border-radius: 0.5rem;
  min-height: 52px;
  display: flex;
  align-items: center;
}
.jt-cap-inner {
  display: flex;
  flex-direction: column;
  gap: 3px;
  width: 100%;
}
.jt-code {
  font-family: 'JetBrains Mono', monospace;
  font-size: 17px;
  color: #1e1b4b;
  font-weight: 700;
}
.jt-note {
  font-size: 14px;
  color: #4338ca;
  font-weight: 600;
}

.jt-svg {
  width: 100%;
  height: auto;
  display: block;
  font-family: 'Noto Sans JP', sans-serif;
}

/* Program panel (light theme) */
.jt-prog-title {
  font-size: 14px;
  fill: #475569;
  font-weight: 800;
  letter-spacing: 0.08em;
  font-family: 'JetBrains Mono', monospace;
}
.jt-asm {
  font-size: 14px;
  fill: #6b7280;
  font-weight: 700;
  font-family: 'JetBrains Mono', monospace;
}
.jt-asm-line {
  font-size: 13px;
  fill: #1f2937;
  font-family: 'JetBrains Mono', monospace;
}
.jt-asm-op {
  fill: #b45309;
  font-weight: 800;
}

.jt-wire {
  stroke: #94a3b8;
  stroke-width: 2;
  stroke-dasharray: 4 3;
  fill: none;
}
.jt-wire-label {
  font-size: 12px;
  fill: #94a3b8;
  font-weight: 700;
  font-family: 'JetBrains Mono', monospace;
}

/* Trace */
.jt-band-label {
  font-size: 13px;
  fill: #94a3b8;
  font-weight: 700;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.08em;
}
/* steps appear via v-if; no opacity animation to avoid screenshot timing issues */
.jt-step-idx {
  font-size: 13px;
  fill: #b45309;
  font-weight: 700;
  font-family: 'JetBrains Mono', monospace;
}
.jt-step-op {
  font-size: 16px;
  fill: #7c2d12;
  font-weight: 800;
  font-family: 'JetBrains Mono', monospace;
}

/* Lookup arrows */
.jt-lookup-line {
  stroke: #b45309;
  stroke-width: 1.5;
  stroke-dasharray: 4 3;
  opacity: 0.7;
  fill: none;
  animation: jt-arrow-flow 1.5s linear infinite;
}
@keyframes jt-arrow-flow {
  to { stroke-dashoffset: -14; }
}

/* Table */
.jt-cell-bg {
  fill: white;
  stroke: #fcd34d;
  stroke-width: 1.5;
  transition: stroke 0.5s, fill 0.5s, stroke-width 0.5s;
}
.jt-cell.is-hit .jt-cell-bg {
  fill: #fef3c7;
  stroke: #d97706;
  stroke-width: 2;
}
.jt-cell-text {
  font-size: 15px;
  font-weight: 700;
  fill: #78350f;
  font-family: 'JetBrains Mono', monospace;
}
.jt-table-foot {
  font-size: 12px;
  fill: #92400e;
  font-style: italic;
  font-family: 'JetBrains Mono', monospace;
}

/* Lasso */
.jt-lasso-title {
  font-size: 19px;
  font-weight: 800;
  fill: #155e75;
  font-family: 'BIZ UDPMincho', serif;
}
.jt-lasso-sub {
  font-size: 13px;
  fill: #0e7490;
  font-weight: 600;
  font-family: 'JetBrains Mono', monospace;
}

/* Sumcheck */
.jt-sc-title {
  font-size: 18px;
  font-weight: 800;
  fill: #5b21b6;
  font-family: 'BIZ UDPMincho', serif;
}
.jt-sc-sub {
  font-size: 12px;
  fill: #6d28d9;
  font-weight: 600;
  font-family: 'JetBrains Mono', monospace;
}

/* Accept */
.jt-accept-title {
  font-size: 22px;
  fill: #064e3b;
  font-weight: 900;
  font-family: 'BIZ UDPMincho', serif;
}
.jt-accept-sub {
  font-size: 14px;
  fill: #047857;
  font-weight: 700;
  font-family: 'JetBrains Mono', monospace;
}
.jt-accept-sub-em {
  font-size: 14px;
  fill: #065f46;
  font-weight: 700;
  font-family: 'BIZ UDPMincho', serif;
}

/* Warn */
.jt-warn-title {
  font-size: 17px;
  fill: #7f1d1d;
  font-weight: 800;
  font-family: 'BIZ UDPMincho', serif;
}
.jt-warn-sub {
  font-size: 13px;
  fill: #991b1b;
  font-weight: 600;
  font-family: 'JetBrains Mono', monospace;
}

/* Transitions */
.jt-fade-enter-active, .jt-fade-leave-active {
  transition: opacity 0.5s ease, transform 0.5s ease;
}
.jt-fade-enter-from { opacity: 0; transform: translateY(6px); }
.jt-fade-leave-to { opacity: 0; transform: translateY(-4px); }
</style>
