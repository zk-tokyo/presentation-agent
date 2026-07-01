<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount, computed } from 'vue'

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
const phaseDurations = [4000, 5000, 6000]
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
  { code: 'Stage 1 — Source : 用途別の高級言語コード  (ZK 系 / MPC 系 / FHE 系)',
    note: '宣言する syntax (#[private], #[party], #[encrypted]) で「何を隠すか」が変わる' },
  { code: 'Stage 2 — Compile : 用途を問わず Circuit に集約',
    note: 'gates + wires ─ ZK/MPC/FHE 共通の中間表現 (arithmetic / boolean / その他)' },
  { code: 'Stage 3 — Execute : 暗号 backend に乗って実行可能なプログラムに',
    note: '同じ pipeline ─ Source の syntax だけが用途で分岐する' },
]

const showCompile  = computed(() => phase.value >= 1)
const showCircuit  = computed(() => phase.value >= 1)
const showRun      = computed(() => phase.value >= 2)
const showExec     = computed(() => phase.value >= 2)

const compileFlow  = computed(() => phase.value === 1)
const runFlow      = computed(() => phase.value === 2)
</script>

<template>
  <div class="cc-root">
    <!-- Caption strip -->
    <div class="cc-cap">
      <transition name="cc-fade" mode="out-in">
        <div :key="phase" class="cc-cap-inner">
          <code class="cc-code">{{ captions[phase].code }}</code>
          <div class="cc-note">{{ captions[phase].note }}</div>
        </div>
      </transition>
    </div>

    <!-- Main SVG: full-height 3 stages -->
    <svg class="cc-svg" viewBox="0 0 1200 410" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="cc-ar" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#475569"/>
        </marker>
        <marker id="cc-ar-green" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#059669"/>
        </marker>
      </defs>

      <!-- ==========================================================
           Stage 1: Source (3 mini editors stacked, FULL HEIGHT)
           ========================================================== -->
      <text x="175" y="20" text-anchor="middle" class="cc-stage-label">1. SOURCE  ─  用途別</text>

      <!-- ZK editor -->
      <g class="cc-mini-editor cc-mini-zk">
        <rect x="30" y="32" width="290" height="115" rx="7" class="cc-mini-bg"/>
        <rect x="30" y="32" width="290" height="20" rx="7" class="cc-mini-tb"/>
        <text x="45" y="46" class="cc-mini-fname">age_check.rs</text>
        <rect x="278" y="36" width="36" height="12" rx="2" class="cc-tag-zk"/>
        <text x="296" y="45" text-anchor="middle" class="cc-tag-txt">ZK</text>

        <text x="45" y="70" class="cc-mini-code"><tspan class="cc-comment">// 年齢証明</tspan></text>
        <text x="45" y="86" class="cc-mini-code"><tspan class="cc-kw">fn</tspan> <tspan class="cc-fn">age_check</tspan>(</text>
        <text x="45" y="102" class="cc-mini-code">&nbsp;&nbsp;<tspan class="cc-priv">#[private]</tspan> <tspan class="cc-var">dob</tspan>,</text>
        <text x="45" y="118" class="cc-mini-code">&nbsp;&nbsp;<tspan class="cc-pub">#[public]</tspan> <tspan class="cc-var">today</tspan>,</text>
        <text x="45" y="134" class="cc-mini-code">) <tspan class="cc-punc">{</tspan> <tspan class="cc-var">today</tspan> - <tspan class="cc-var">dob</tspan> &gt;= <tspan class="cc-num">18</tspan> <tspan class="cc-punc">}</tspan></text>
      </g>

      <!-- MPC editor -->
      <g class="cc-mini-editor cc-mini-mpc">
        <rect x="30" y="155" width="290" height="115" rx="7" class="cc-mini-bg"/>
        <rect x="30" y="155" width="290" height="20" rx="7" class="cc-mini-tb"/>
        <text x="45" y="169" class="cc-mini-fname">auction.rs</text>
        <rect x="274" y="159" width="40" height="12" rx="2" class="cc-tag-mpc"/>
        <text x="294" y="168" text-anchor="middle" class="cc-tag-txt">MPC</text>

        <text x="45" y="193" class="cc-mini-code"><tspan class="cc-comment">// 秘密入札</tspan></text>
        <text x="45" y="209" class="cc-mini-code"><tspan class="cc-kw">fn</tspan> <tspan class="cc-fn">auction</tspan>(</text>
        <text x="45" y="225" class="cc-mini-code">&nbsp;&nbsp;<tspan class="cc-mpc-attr">#[party]</tspan> <tspan class="cc-var">b1</tspan>, <tspan class="cc-mpc-attr">#[party]</tspan> <tspan class="cc-var">b2</tspan>,</text>
        <text x="45" y="241" class="cc-mini-code">&nbsp;&nbsp;<tspan class="cc-mpc-attr">#[party]</tspan> <tspan class="cc-var">b3</tspan>,</text>
        <text x="45" y="257" class="cc-mini-code">) <tspan class="cc-punc">{</tspan> <tspan class="cc-fn">max</tspan>(<tspan class="cc-var">b1</tspan>, <tspan class="cc-var">b2</tspan>, <tspan class="cc-var">b3</tspan>) <tspan class="cc-punc">}</tspan></text>
      </g>

      <!-- FHE editor -->
      <g class="cc-mini-editor cc-mini-fhe">
        <rect x="30" y="278" width="290" height="115" rx="7" class="cc-mini-bg"/>
        <rect x="30" y="278" width="290" height="20" rx="7" class="cc-mini-tb"/>
        <text x="45" y="292" class="cc-mini-fname">diagnose.rs</text>
        <rect x="278" y="282" width="36" height="12" rx="2" class="cc-tag-fhe"/>
        <text x="296" y="291" text-anchor="middle" class="cc-tag-txt">FHE</text>

        <text x="45" y="316" class="cc-mini-code"><tspan class="cc-comment">// AI 診断</tspan></text>
        <text x="45" y="332" class="cc-mini-code"><tspan class="cc-kw">fn</tspan> <tspan class="cc-fn">diagnose</tspan>(</text>
        <text x="45" y="348" class="cc-mini-code">&nbsp;&nbsp;<tspan class="cc-fhe-attr">#[encrypted]</tspan> <tspan class="cc-var">data</tspan>,</text>
        <text x="45" y="364" class="cc-mini-code">) -&gt; <tspan class="cc-type">Diagnosis</tspan> <tspan class="cc-punc">{</tspan></text>
        <text x="45" y="380" class="cc-mini-code">&nbsp;&nbsp;<tspan class="cc-fn">ml_infer</tspan>(<tspan class="cc-var">data</tspan>) <tspan class="cc-punc">}</tspan></text>
      </g>

      <!-- ==========================================================
           Convergent compile arrows: 3 → hub → circuit
           ========================================================== -->
      <g class="cc-compile-zone" :class="{ 'is-active': showCompile }">
        <!-- 3 fan-in curves toward central hub at (385, 213) -->
        <path d="M 320,89 C 355,89 365,200 385,213" class="cc-compile-edge cc-edge-zk"/>
        <path d="M 320,213 L 385,213" class="cc-compile-edge cc-edge-mpc"/>
        <path d="M 320,335 C 355,335 365,225 385,213" class="cc-compile-edge cc-edge-fhe"/>

        <!-- compile hub (gear) -->
        <circle cx="385" cy="213" r="18" class="cc-compile-hub"/>
        <text x="385" y="220" text-anchor="middle" class="cc-hub-icon">⚙</text>

        <!-- compile label -->
        <text x="385" y="178" text-anchor="middle" class="cc-arrow-label">compile</text>
        <text x="385" y="256" text-anchor="middle" class="cc-arrow-sub">circom / halo2</text>
        <text x="385" y="270" text-anchor="middle" class="cc-arrow-sub">noir / arkworks</text>

        <!-- single arrow out -->
        <line x1="403" y1="213" x2="440" y2="213" class="cc-arrow-line" marker-end="url(#cc-ar)"/>

        <!-- traveling particles per source language -->
        <g v-if="compileFlow">
          <circle r="5.5" class="cc-particle cc-p-zk">
            <animateMotion dur="1.8s" repeatCount="indefinite" path="M 320,89 C 355,89 365,200 385,213"/>
          </circle>
          <circle r="5.5" class="cc-particle cc-p-mpc">
            <animateMotion dur="1.8s" begin="-0.6s" repeatCount="indefinite" path="M 320,213 L 385,213"/>
          </circle>
          <circle r="5.5" class="cc-particle cc-p-fhe">
            <animateMotion dur="1.8s" begin="-1.2s" repeatCount="indefinite" path="M 320,335 C 355,335 365,225 385,213"/>
          </circle>
        </g>
      </g>

      <!-- ==========================================================
           Stage 2: Arithmetic Circuit (FULL HEIGHT, refined)
           ========================================================== -->
      <text x="625" y="20" text-anchor="middle" class="cc-stage-label">2. CIRCUIT  ─  共通の中間表現</text>

      <g class="cc-circuit" :class="{ 'is-active': showCircuit }">
        <!-- container -->
        <rect x="450" y="32" width="370" height="361" rx="12" class="cc-circuit-bg"/>

        <!-- formula at top -->
        <text x="635" y="58" text-anchor="middle" class="cc-circuit-formula">y = (a × b) + c</text>

        <!-- layer tags -->
        <text x="485" y="92" class="cc-layer-tag">inputs</text>
        <text x="775" y="92" text-anchor="end" class="cc-layer-tag">output</text>

        <!-- input nodes (left, vertical column) -->
        <g class="cc-inputs">
          <circle cx="495" cy="135" r="11" class="cc-input-node"/>
          <text x="478" y="140" text-anchor="end" class="cc-node-label">a</text>

          <circle cx="495" cy="215" r="11" class="cc-input-node"/>
          <text x="478" y="220" text-anchor="end" class="cc-node-label">b</text>

          <circle cx="495" cy="295" r="11" class="cc-input-node"/>
          <text x="478" y="300" text-anchor="end" class="cc-node-label">c</text>
        </g>

        <!-- × gate -->
        <g class="cc-gate cc-gate-mul">
          <rect x="585" y="155" width="72" height="60" rx="11" class="cc-gate-bg"/>
          <text x="621" y="201" text-anchor="middle" class="cc-gate-text">×</text>
        </g>

        <!-- + gate -->
        <g class="cc-gate cc-gate-add">
          <rect x="675" y="245" width="72" height="60" rx="11" class="cc-gate-bg cc-gate-add-bg"/>
          <text x="711" y="291" text-anchor="middle" class="cc-gate-text">+</text>
        </g>

        <!-- output node -->
        <g class="cc-output">
          <circle cx="785" cy="275" r="12" class="cc-output-node"/>
          <text x="803" y="280" class="cc-node-label">y</text>
        </g>

        <!-- wires (bezier curves) -->
        <path d="M 506,135 C 540,135 555,170 585,175" class="cc-wire"/>
        <path d="M 506,215 C 540,215 555,195 585,195" class="cc-wire"/>
        <path d="M 657,185 C 675,185 670,255 675,265" class="cc-wire"/>
        <path d="M 506,295 C 590,295 650,278 675,277" class="cc-wire"/>
        <path d="M 747,275 L 773,275" class="cc-wire cc-wire-final"/>

        <!-- annotation at bottom -->
        <text x="635" y="370" text-anchor="middle" class="cc-circuit-note">
          gates + wires  ─  低レベル数学的表現
        </text>
      </g>

      <!-- ==========================================================
           Run arrow
           ========================================================== -->
      <g class="cc-arrow-g" :class="{ 'is-active': showRun }">
        <text x="864" y="195" text-anchor="middle" class="cc-arrow-label">run</text>
        <text x="864" y="218" text-anchor="middle" class="cc-arrow-sub">証明者 / プロトコル</text>
        <text x="864" y="232" text-anchor="middle" class="cc-arrow-sub">/ FHE eval</text>
        <line x1="827" y1="247" x2="900" y2="247" class="cc-arrow-line" marker-end="url(#cc-ar-green)"/>

        <g v-if="runFlow">
          <circle r="6" class="cc-particle cc-p-green">
            <animateMotion dur="1.6s" repeatCount="indefinite" path="M 827,247 L 900,247"/>
          </circle>
        </g>
      </g>

      <!-- ==========================================================
           Stage 3: Executable (FULL HEIGHT)
           ========================================================== -->
      <text x="1040" y="20" text-anchor="middle" class="cc-stage-label">3. EXECUTABLE  ─  共通</text>

      <g class="cc-exec" :class="{ 'is-active': showExec }">
        <rect x="910" y="32" width="260" height="361" rx="12" class="cc-exec-bg"/>

        <!-- laptop (bigger, centered top) -->
        <g transform="translate(1040, 130)">
          <!-- screen housing -->
          <rect x="-78" y="-46" width="156" height="92" rx="5" fill="#1e293b" stroke="#475569" stroke-width="2"/>
          <!-- screen -->
          <rect x="-72" y="-40" width="144" height="80" rx="2" fill="#f1f5f9"/>
          <!-- mock app UI -->
          <rect x="-68" y="-36" width="136" height="10" rx="2" fill="#059669"/>
          <rect x="-66" y="-18" width="100" height="6" rx="1" fill="#cbd5e1"/>
          <rect x="-66" y="-6"  width="80" height="6" rx="1" fill="#cbd5e1"/>
          <rect x="-66" y="6"   width="110" height="6" rx="1" fill="#cbd5e1"/>
          <rect x="-66" y="18"  width="60" height="6" rx="1" fill="#cbd5e1"/>
          <rect x="-66" y="30"  width="48" height="10" rx="2" fill="#3b82f6"/>
          <!-- laptop base -->
          <path d="M -90,46 L 90,46 L 80,54 L -80,54 Z" fill="#475569"/>
        </g>

        <!-- 3 end users below (showing scale) -->
        <g transform="translate(960, 270)">
          <circle cx="0" cy="-9" r="8" fill="#475569"/>
          <path d="M -12,5 Q 0,1 12,5 L 11,20 L -11,20 Z" fill="#475569"/>
        </g>
        <g transform="translate(1040, 270)">
          <circle cx="0" cy="-9" r="8" fill="#475569"/>
          <path d="M -12,5 Q 0,1 12,5 L 11,20 L -11,20 Z" fill="#475569"/>
        </g>
        <g transform="translate(1120, 270)">
          <circle cx="0" cy="-9" r="8" fill="#475569"/>
          <path d="M -12,5 Q 0,1 12,5 L 11,20 L -11,20 Z" fill="#475569"/>
        </g>
        <text x="1040" y="313" text-anchor="middle" class="cc-actor-tag">end users</text>

        <!-- arrows users → laptop -->
        <line x1="960" y1="252" x2="990" y2="200" class="cc-use-arrow" marker-end="url(#cc-ar)"/>
        <line x1="1040" y1="252" x2="1040" y2="190" class="cc-use-arrow" marker-end="url(#cc-ar)"/>
        <line x1="1120" y1="252" x2="1090" y2="200" class="cc-use-arrow" marker-end="url(#cc-ar)"/>

        <!-- backend label at bottom -->
        <rect x="940" y="332" width="200" height="48" rx="7" fill="white" stroke="#86efac" stroke-width="1.8"/>
        <text x="1040" y="352" text-anchor="middle" class="cc-exec-label">backend が裏で動く</text>
        <text x="1040" y="370" text-anchor="middle" class="cc-exec-sub">(ZK / MPC / FHE …)</text>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.cc-root {
  position: relative;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 6px;
  font-family: 'Noto Sans JP', sans-serif;
  color: #111827;
}

.cc-cap {
  padding: 9px 16px;
  background: #eef2ff;
  border: 1px solid #c7d2fe;
  border-radius: 0.5rem;
  min-height: 52px;
  display: flex;
  align-items: center;
}
.cc-cap-inner {
  display: flex;
  flex-direction: column;
  gap: 3px;
  width: 100%;
}
.cc-code {
  font-family: 'JetBrains Mono', monospace;
  font-size: 15px;
  color: #1e1b4b;
  font-weight: 700;
}
.cc-note {
  font-size: 14px;
  color: #4338ca;
  font-weight: 600;
}

.cc-svg {
  width: 100%;
  height: auto;
  display: block;
  font-family: 'Noto Sans JP', sans-serif;
}

/* Stage labels */
.cc-stage-label {
  font-size: 12px;
  font-weight: 800;
  fill: #4338ca;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.08em;
}

/* Mini editors */
.cc-mini-bg {
  fill: #0f172a;
  stroke-width: 2;
  filter: drop-shadow(0 2px 5px rgba(15,23,42,0.2));
}
.cc-mini-zk .cc-mini-bg  { stroke: #fcd34d; }
.cc-mini-mpc .cc-mini-bg { stroke: #67e8f9; }
.cc-mini-fhe .cc-mini-bg { stroke: #c4b5fd; }

.cc-mini-tb { fill: #1e293b; }
.cc-mini-fname {
  font-size: 11px;
  font-weight: 700;
  fill: #94a3b8;
  font-family: 'JetBrains Mono', monospace;
}
.cc-tag-zk  { fill: #b45309; }
.cc-tag-mpc { fill: #0e7490; }
.cc-tag-fhe { fill: #6d28d9; }
.cc-tag-txt {
  font-size: 9px;
  font-weight: 900;
  fill: white;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.06em;
}

.cc-mini-code {
  font-family: 'JetBrains Mono', monospace;
  font-size: 13px;
  fill: #e2e8f0;
  font-weight: 600;
}
.cc-kw       { fill: #c084fc; font-weight: 800; }
.cc-fn       { fill: #60a5fa; font-weight: 700; }
.cc-priv     { fill: #fbbf24; font-weight: 700; }
.cc-pub      { fill: #34d399; font-weight: 700; }
.cc-mpc-attr { fill: #22d3ee; font-weight: 700; }
.cc-fhe-attr { fill: #a78bfa; font-weight: 700; }
.cc-var      { fill: #fcd34d; }
.cc-num      { fill: #fb923c; }
.cc-type     { fill: #f472b6; }
.cc-punc     { fill: #94a3b8; }
.cc-comment  { fill: #64748b; font-style: italic; }

/* Compile zone */
.cc-compile-zone { opacity: 0.4; transition: opacity 0.5s; }
.cc-compile-zone.is-active { opacity: 1; }
.cc-compile-edge {
  fill: none;
  stroke-width: 2;
  stroke-dasharray: 4 3;
}
.cc-edge-zk  { stroke: #d97706; }
.cc-edge-mpc { stroke: #0891b2; }
.cc-edge-fhe { stroke: #7c3aed; }

.cc-compile-hub {
  fill: #fff7ed;
  stroke: #b45309;
  stroke-width: 3;
  filter: drop-shadow(0 0 8px rgba(180,83,9,0.35));
}
.cc-hub-icon {
  font-size: 18px;
  font-weight: 900;
  fill: #b45309;
  font-family: 'JetBrains Mono', monospace;
}
.cc-arrow-label {
  font-size: 14px;
  font-weight: 800;
  fill: #1e1b4b;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.04em;
}
.cc-arrow-sub {
  font-size: 11px;
  fill: #6b7280;
  font-family: 'JetBrains Mono', monospace;
  font-weight: 600;
}
.cc-arrow-line {
  stroke: #475569;
  stroke-width: 2.5;
  fill: none;
}

.cc-particle {
  filter: drop-shadow(0 0 4px currentColor);
}
.cc-p-zk     { fill: #d97706; }
.cc-p-mpc    { fill: #0891b2; }
.cc-p-fhe    { fill: #7c3aed; }
.cc-p-green  { fill: #059669; }

/* Arrow group (run) */
.cc-arrow-g { opacity: 0.4; transition: opacity 0.5s; }
.cc-arrow-g.is-active { opacity: 1; }

/* Arithmetic circuit */
.cc-circuit { opacity: 0.55; transition: opacity 0.5s; }
.cc-circuit.is-active { opacity: 1; }
.cc-circuit-bg {
  fill: #fffbeb;
  stroke: #fcd34d;
  stroke-width: 2.5;
  filter: drop-shadow(0 2px 8px rgba(217,119,6,0.2));
}
.cc-circuit-formula {
  font-size: 19px;
  font-weight: 800;
  fill: #78350f;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.02em;
}
.cc-layer-tag {
  font-size: 10px;
  font-weight: 800;
  fill: #94a3b8;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.1em;
  text-transform: uppercase;
}
.cc-input-node {
  fill: #475569;
  stroke: #1f2937;
  stroke-width: 1.8;
}
.cc-output-node {
  fill: #059669;
  stroke: #065f46;
  stroke-width: 2.5;
  filter: drop-shadow(0 0 8px rgba(5,150,105,0.5));
}
.cc-node-label {
  font-size: 17px;
  font-weight: 800;
  fill: #1f2937;
  font-family: 'JetBrains Mono', monospace;
}
.cc-gate-bg {
  fill: #fef3c7;
  stroke: #d97706;
  stroke-width: 2.5;
  filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
}
.cc-gate-add-bg {
  fill: #dbeafe;
  stroke: #2563eb;
}
.cc-gate-text {
  font-size: 34px;
  font-weight: 900;
  fill: #1f2937;
  font-family: 'JetBrains Mono', monospace;
}
.cc-wire {
  stroke: #64748b;
  stroke-width: 2;
  fill: none;
}
.cc-wire-final {
  stroke: #059669;
  stroke-width: 2.5;
}
.cc-circuit-note {
  font-size: 12px;
  fill: #92400e;
  font-family: 'JetBrains Mono', monospace;
  font-weight: 700;
  font-style: italic;
  letter-spacing: 0.04em;
}

/* Executable */
.cc-exec { opacity: 0.55; transition: opacity 0.5s; }
.cc-exec.is-active { opacity: 1; }
.cc-exec-bg {
  fill: #f0fdf4;
  stroke: #86efac;
  stroke-width: 2.5;
  filter: drop-shadow(0 2px 8px rgba(5,150,105,0.2));
}
.cc-actor-tag {
  font-size: 12px;
  font-weight: 700;
  fill: #475569;
  font-family: 'JetBrains Mono', monospace;
}
.cc-use-arrow {
  stroke: #475569;
  stroke-width: 1.8;
  fill: none;
  stroke-dasharray: 4 3;
  opacity: 0.7;
}
.cc-exec-label {
  font-size: 13px;
  font-weight: 800;
  fill: #064e3b;
  font-family: 'JetBrains Mono', monospace;
}
.cc-exec-sub {
  font-size: 12px;
  fill: #047857;
  font-family: 'JetBrains Mono', monospace;
  font-weight: 700;
}

/* Transitions */
.cc-fade-enter-active, .cc-fade-leave-active {
  transition: opacity 0.4s ease, transform 0.4s ease;
}
.cc-fade-enter-from { opacity: 0; transform: translateY(4px); }
.cc-fade-leave-to { opacity: 0; transform: translateY(-4px); }
</style>
