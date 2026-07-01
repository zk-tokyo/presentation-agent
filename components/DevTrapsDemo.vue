<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount, computed } from 'vue'

const totalPhases = 5

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
const phaseDurations = [4000, 5500, 5500, 5500, 6500]
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

// Stage states
// stages: 0=Spec, 1=System Choice, 2=Circuit, 3=Prove, 4=Verify
const allFixed = computed(() => phase.value === 4)
const trap1Active = computed(() => phase.value === 1)
const trap2Active = computed(() => phase.value === 2)
const trap3Active = computed(() => phase.value === 3)

const verifyState = computed(() => {
  if (phase.value === 0 || phase.value === 4) return 'ok'   // green ✓
  if (phase.value === 1) return 'warn'                       // amber ⚠ (setup-time)
  return 'broken'                                            // red ✗
})

const captions = [
  { tag: 'pipeline',  code: 'ZK service pipeline: 仕様 → 制約系/証明系 → 回路設計 → Prove → Verify' },
  { tag: '罠 #1 [設計]', code: 'R1CS / Plonkish / AIR / CCS  +  Groth16 / PLONK / Jolt / SP1 / Longfellow — 後から変えられない' },
  { tag: '罠 #2 [安全]', code: 'soundness ≠ zero-knowledge — Semaphore signal hash bug (public input が回路内未使用)' },
  { tag: '罠 #3 [安全]', code: 'Fiat-Shamir の RO instantiation — KRS25 が GKR-based SNARK の現実的攻撃 (eprint 2025/611)' },
  { tag: '✓ 3 罠回避',   code: '全 stage が安全に設計された ZK service — 監査時の必須チェック項目' },
]
const currentCaption = computed(() => captions[phase.value])

// Trap detail content
const traps = [
  null,
  {
    tag: '罠 #1', cat: '[設計]',
    title: '制約系 / 証明系の選択は後から変えられない',
    trapLines: [
      '制約系: R1CS / Plonkish / AIR / CCS',
      '証明系: Groth16 / PLONK / Halo2 / Jolt / SP1 / Longfellow',
      '検証コスト・対応言語・証明者メモリが桁違い',
    ],
    fixLines: [
      'ターゲット環境 (検証者 gas / 証明者 RAM / DSL) を最初に固定',
      'Jolt = 証明者メモリ大 → mobile / IoT には不向き',
    ],
  },
  {
    tag: '罠 #2', cat: '[安全性]',
    title: 'soundness ≠ zero-knowledge — 両方独立に壊れうる',
    trapLines: [
      '実例: Semaphore signal hash bug',
      'public input "signalHash" が回路内で実際に使われていなかった',
      'attacker は proof 取得後に signalHash を書き換えて任意 signal 偽装',
    ],
    fixLines: [
      'public input を必ず回路内で非線形制約に縛る',
      '修正: signalHashSquared = signalHash²  を制約として追加',
    ],
  },
  {
    tag: '罠 #3', cat: '[安全性]',
    title: 'Fiat-Shamir の Random Oracle instantiation',
    trapLines: [
      'KRS25 (eprint 2025/611) — GKR-based SNARK の現実的攻撃',
      'ハッシュ選択 / transcript design を雑に扱うと突破される',
      '「論文は安全」≠「実装は安全」',
    ],
    fixLines: [
      'domain separation を入れる ／ full transcript を challenge に hash',
      'Sumcheck / Jolt は Algebraic RO で証明可能な instantiation を選ぶ',
    ],
  },
  null,
]
const currentTrap = computed(() => traps[phase.value])
</script>

<template>
  <div class="dt-root">
    <!-- ===== Caption ===== -->
    <div class="dt-caption">
      <transition name="dt-cap" mode="out-in">
        <div :key="phase" class="dt-cap-inner">
          <span class="dt-cap-tag"
                :class="{
                  'is-p':  phase === 0,
                  'is-t1': phase === 1,
                  'is-t2': phase === 2,
                  'is-t3': phase === 3,
                  'is-ok': phase === 4,
                }">{{ currentCaption.tag }}</span>
          <span class="dt-cap-code">{{ currentCaption.code }}</span>
        </div>
      </transition>
    </div>

    <!-- ===== Main SVG ===== -->
    <svg class="dt-svg" viewBox="0 0 1200 430" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="dt-arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#64748b"/>
        </marker>
      </defs>

      <!-- ===== Pipeline ===== -->
      <g class="dt-pipeline">
        <!-- Stage 1: 仕様 (always green) -->
        <g class="dt-stage dt-stage-ok">
          <rect x="20" y="40" width="190" height="80" rx="8" class="dt-stage-bg"/>
          <text x="115" y="75" text-anchor="middle" class="dt-stage-num">①</text>
          <text x="115" y="98" text-anchor="middle" class="dt-stage-title">仕様</text>
          <text x="115" y="115" text-anchor="middle" class="dt-stage-sub">Spec</text>
        </g>
        <line x1="215" y1="80" x2="240" y2="80" class="dt-wire" marker-end="url(#dt-arrow)"/>

        <!-- Stage 2: 制約系 / 証明系 -->
        <g class="dt-stage"
           :class="{
             'is-trap-1': trap1Active,
             'is-fixed':  allFixed,
             'dt-stage-ok': !trap1Active && !allFixed,
           }">
          <rect x="245" y="40" width="220" height="80" rx="8" class="dt-stage-bg"/>
          <text x="355" y="75" text-anchor="middle" class="dt-stage-num">②</text>
          <text x="355" y="98" text-anchor="middle" class="dt-stage-title">制約系 / 証明系</text>
          <text x="355" y="115" text-anchor="middle" class="dt-stage-sub">choice</text>
          <!-- Trap badge -->
          <transition name="dt-badge">
            <g v-if="trap1Active" class="dt-trap-badge">
              <rect x="305" y="20" width="100" height="24" rx="12" class="dt-tb-bg"/>
              <text x="355" y="37" text-anchor="middle" class="dt-tb-text">⚠ 罠 #1</text>
            </g>
          </transition>
          <transition name="dt-badge">
            <g v-if="allFixed" class="dt-ok-badge">
              <circle cx="455" cy="48" r="11" class="dt-ok-circle"/>
              <text x="455" y="53" text-anchor="middle" class="dt-ok-text">✓</text>
            </g>
          </transition>
        </g>
        <line x1="470" y1="80" x2="495" y2="80" class="dt-wire" marker-end="url(#dt-arrow)"/>

        <!-- Stage 3: 回路設計 -->
        <g class="dt-stage"
           :class="{
             'is-trap-2': trap2Active,
             'is-fixed':  allFixed,
             'dt-stage-ok': !trap2Active && !allFixed,
           }">
          <rect x="500" y="40" width="200" height="80" rx="8" class="dt-stage-bg"/>
          <text x="600" y="75" text-anchor="middle" class="dt-stage-num">③</text>
          <text x="600" y="98" text-anchor="middle" class="dt-stage-title">回路設計</text>
          <text x="600" y="115" text-anchor="middle" class="dt-stage-sub">circuit + public inputs</text>
          <transition name="dt-badge">
            <g v-if="trap2Active" class="dt-trap-badge">
              <rect x="550" y="20" width="100" height="24" rx="12" class="dt-tb-bg"/>
              <text x="600" y="37" text-anchor="middle" class="dt-tb-text">⚠ 罠 #2</text>
            </g>
          </transition>
          <transition name="dt-badge">
            <g v-if="allFixed" class="dt-ok-badge">
              <circle cx="690" cy="48" r="11" class="dt-ok-circle"/>
              <text x="690" y="53" text-anchor="middle" class="dt-ok-text">✓</text>
            </g>
          </transition>
        </g>
        <line x1="705" y1="80" x2="730" y2="80" class="dt-wire" marker-end="url(#dt-arrow)"/>

        <!-- Stage 4: Prove (Fiat-Shamir) -->
        <g class="dt-stage"
           :class="{
             'is-trap-3': trap3Active,
             'is-fixed':  allFixed,
             'dt-stage-ok': !trap3Active && !allFixed,
           }">
          <rect x="735" y="40" width="200" height="80" rx="8" class="dt-stage-bg"/>
          <text x="835" y="75" text-anchor="middle" class="dt-stage-num">④</text>
          <text x="835" y="98" text-anchor="middle" class="dt-stage-title">Prove</text>
          <text x="835" y="115" text-anchor="middle" class="dt-stage-sub">+ Fiat-Shamir transcript</text>
          <transition name="dt-badge">
            <g v-if="trap3Active" class="dt-trap-badge">
              <rect x="785" y="20" width="100" height="24" rx="12" class="dt-tb-bg"/>
              <text x="835" y="37" text-anchor="middle" class="dt-tb-text">⚠ 罠 #3</text>
            </g>
          </transition>
          <transition name="dt-badge">
            <g v-if="allFixed" class="dt-ok-badge">
              <circle cx="925" cy="48" r="11" class="dt-ok-circle"/>
              <text x="925" y="53" text-anchor="middle" class="dt-ok-text">✓</text>
            </g>
          </transition>
        </g>
        <line x1="940" y1="80" x2="965" y2="80" class="dt-wire" marker-end="url(#dt-arrow)"/>

        <!-- Stage 5: Verify (status depends on phase) -->
        <g class="dt-stage dt-stage-verify"
           :class="{
             'is-ok':     verifyState === 'ok',
             'is-warn':   verifyState === 'warn',
             'is-broken': verifyState === 'broken',
           }">
          <rect x="970" y="40" width="200" height="80" rx="8" class="dt-stage-bg"/>
          <text x="1070" y="75" text-anchor="middle" class="dt-stage-num">⑤</text>
          <text x="1070" y="98" text-anchor="middle" class="dt-stage-title">Verify</text>
          <text x="1070" y="115" text-anchor="middle" class="dt-stage-sub">
            <tspan v-if="verifyState === 'ok'">✓ secure</tspan>
            <tspan v-else-if="verifyState === 'warn'">⚠ setup risk</tspan>
            <tspan v-else>✗ BROKEN</tspan>
          </text>
        </g>
      </g>

      <!-- ===== Trap detail panel (phases 1-3) ===== -->
      <transition name="dt-panel" mode="out-in">
        <g v-if="currentTrap" :key="phase" class="dt-panel">
          <rect x="20" y="170" width="1160" height="245" rx="10" class="dt-panel-bg"/>

          <!-- TRAP column -->
          <g class="dt-col-trap">
            <rect x="40" y="190" width="555" height="40" rx="6" class="dt-col-head-bg-trap"/>
            <text x="60" y="217" class="dt-col-head-tag">⚠ TRAP</text>
            <text x="155" y="217" class="dt-col-head-cat">{{ currentTrap.cat }}</text>
            <text x="60" y="261" class="dt-col-title">{{ currentTrap.title }}</text>
            <text x="60" y="298" class="dt-col-line">▸ {{ currentTrap.trapLines[0] }}</text>
            <text x="60" y="326" class="dt-col-line">▸ {{ currentTrap.trapLines[1] }}</text>
            <text v-if="currentTrap.trapLines[2]" x="60" y="354" class="dt-col-line">▸ {{ currentTrap.trapLines[2] }}</text>
          </g>

          <!-- FIX column -->
          <g class="dt-col-fix">
            <rect x="615" y="190" width="545" height="40" rx="6" class="dt-col-head-bg-fix"/>
            <text x="635" y="217" class="dt-col-head-tag-fix">✓ FIX</text>
            <text x="635" y="261" class="dt-col-title-fix">監査時の必須チェック</text>
            <text x="635" y="298" class="dt-col-line">▸ {{ currentTrap.fixLines[0] }}</text>
            <text x="635" y="326" class="dt-col-line">▸ {{ currentTrap.fixLines[1] }}</text>
            <text v-if="currentTrap.fixLines[2]" x="635" y="354" class="dt-col-line">▸ {{ currentTrap.fixLines[2] }}</text>
          </g>

          <!-- Phase tag (small) -->
          <text x="1140" y="200" text-anchor="end" class="dt-panel-tag">{{ currentTrap.tag }}</text>
        </g>
      </transition>

      <!-- ===== Phase 4: all-fixed summary ===== -->
      <transition name="dt-fixed">
        <g v-if="allFixed" class="dt-fixed-row">
          <rect x="20" y="180" width="1160" height="220" rx="10" class="dt-fixed-bg"/>
          <text x="600" y="218" text-anchor="middle" class="dt-fixed-head">✓ 3 罠を回避した ZK service</text>
          <text x="600" y="244" text-anchor="middle" class="dt-fixed-sub">監査時に必ず確認する 3 項目</text>

          <!-- 3 check pills aligned with their trap stages -->
          <g class="dt-check-pill" transform="translate(355, 280)">
            <circle cx="0" cy="0" r="22" class="dt-pill-circle"/>
            <text x="0" y="6" text-anchor="middle" class="dt-pill-num">①</text>
            <text x="0" y="48" text-anchor="middle" class="dt-pill-cat">[設計]</text>
            <text x="0" y="75" text-anchor="middle" class="dt-pill-title">制約系 / 証明系</text>
            <text x="0" y="95" text-anchor="middle" class="dt-pill-title">先に固定</text>
          </g>

          <g class="dt-check-pill" transform="translate(600, 280)">
            <circle cx="0" cy="0" r="22" class="dt-pill-circle"/>
            <text x="0" y="6" text-anchor="middle" class="dt-pill-num">②</text>
            <text x="0" y="48" text-anchor="middle" class="dt-pill-cat">[安全性]</text>
            <text x="0" y="75" text-anchor="middle" class="dt-pill-title">public input が</text>
            <text x="0" y="95" text-anchor="middle" class="dt-pill-title">回路内で制約される</text>
          </g>

          <g class="dt-check-pill" transform="translate(835, 280)">
            <circle cx="0" cy="0" r="22" class="dt-pill-circle"/>
            <text x="0" y="6" text-anchor="middle" class="dt-pill-num">③</text>
            <text x="0" y="48" text-anchor="middle" class="dt-pill-cat">[安全性]</text>
            <text x="0" y="75" text-anchor="middle" class="dt-pill-title">Fiat-Shamir RO の</text>
            <text x="0" y="95" text-anchor="middle" class="dt-pill-title">instantiation 検証</text>
          </g>
        </g>
      </transition>
    </svg>
  </div>
</template>

<style scoped>
.dt-root {
  position: relative;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 6px;
  font-family: 'Noto Sans JP', sans-serif;
  color: #111827;
}

/* ===== Caption ===== */
.dt-caption {
  padding: 9px 16px;
  background: #eef2ff;
  border: 1px solid #c7d2fe;
  border-radius: 0.5rem;
  min-height: 42px;
  display: flex;
  align-items: center;
}
.dt-cap-inner { display: flex; align-items: center; gap: 14px; width: 100%; }
.dt-cap-tag {
  flex-shrink: 0;
  padding: 4px 12px;
  border-radius: 999px;
  font-family: 'JetBrains Mono', monospace;
  font-size: 14px;
  font-weight: 900;
  letter-spacing: 0.04em;
  color: white;
  background: #4f46e5;
}
.dt-cap-tag.is-p  { background: #6b7280; }
.dt-cap-tag.is-t1 { background: #d97706; }
.dt-cap-tag.is-t2 { background: #dc2626; }
.dt-cap-tag.is-t3 { background: #dc2626; }
.dt-cap-tag.is-ok { background: #059669; }
.dt-cap-code {
  font-family: 'JetBrains Mono', monospace;
  font-size: 15px;
  font-weight: 700;
  color: #1e1b4b;
}
.dt-cap-enter-active, .dt-cap-leave-active {
  transition: opacity .35s ease, transform .35s ease;
}
.dt-cap-enter-from { opacity: 0; transform: translateY(6px); }
.dt-cap-leave-to   { opacity: 0; transform: translateY(-6px); }

/* ===== SVG ===== */
.dt-svg {
  width: 100%;
  height: auto;
  display: block;
  font-family: 'Noto Sans JP', sans-serif;
}

/* ===== Pipeline stages ===== */
.dt-stage-bg {
  fill: white;
  stroke: #94a3b8;
  stroke-width: 2;
  transition: fill .5s, stroke .5s, filter .5s;
}
.dt-stage-num {
  font-size: 14px;
  font-weight: 900;
  fill: #6366f1;
  font-family: 'JetBrains Mono', monospace;
}
.dt-stage-title {
  font-size: 17px;
  font-weight: 700;
  fill: #111827;
  font-family: 'BIZ UDPMincho', serif;
}
.dt-stage-sub {
  font-size: 12px;
  font-weight: 600;
  fill: #6b7280;
  font-family: 'JetBrains Mono', monospace;
}

.dt-stage.dt-stage-ok .dt-stage-bg {
  fill: #f0fdf4;
  stroke: #10b981;
}
.dt-stage.is-trap-1 .dt-stage-bg {
  fill: #fffbeb;
  stroke: #d97706;
  stroke-width: 3;
  filter: drop-shadow(0 0 7px rgba(217, 119, 6, 0.6));
}
.dt-stage.is-trap-2 .dt-stage-bg,
.dt-stage.is-trap-3 .dt-stage-bg {
  fill: #fef2f2;
  stroke: #dc2626;
  stroke-width: 3;
  filter: drop-shadow(0 0 7px rgba(220, 38, 38, 0.6));
}
.dt-stage.is-fixed .dt-stage-bg {
  fill: #ecfdf5;
  stroke: #059669;
  stroke-width: 2.5;
}

/* Verify stage states */
.dt-stage-verify.is-ok .dt-stage-bg {
  fill: #ecfdf5;
  stroke: #10b981;
  stroke-width: 2.5;
}
.dt-stage-verify.is-warn .dt-stage-bg {
  fill: #fffbeb;
  stroke: #f59e0b;
  stroke-width: 2.5;
}
.dt-stage-verify.is-broken .dt-stage-bg {
  fill: #fef2f2;
  stroke: #dc2626;
  stroke-width: 3;
  filter: drop-shadow(0 0 8px rgba(220, 38, 38, 0.7));
  animation: dt-broken-pulse 1.4s ease-in-out infinite;
}
@keyframes dt-broken-pulse {
  0%, 100% { filter: drop-shadow(0 0 8px rgba(220, 38, 38, 0.55)); }
  50%      { filter: drop-shadow(0 0 14px rgba(220, 38, 38, 0.95)); }
}
.dt-stage-verify .dt-stage-sub {
  font-weight: 900;
  font-size: 13px;
}
.dt-stage-verify.is-ok .dt-stage-sub     { fill: #059669; }
.dt-stage-verify.is-warn .dt-stage-sub   { fill: #b45309; }
.dt-stage-verify.is-broken .dt-stage-sub { fill: #991b1b; }

/* Wires between stages */
.dt-wire {
  stroke: #64748b;
  stroke-width: 2.5;
  stroke-linecap: round;
}

/* Trap badges over stages */
.dt-tb-bg {
  fill: #dc2626;
  stroke: #991b1b;
  stroke-width: 1.5;
}
.dt-stage.is-trap-1 .dt-tb-bg { fill: #d97706; stroke: #92400e; }
.dt-tb-text {
  font-size: 13px;
  font-weight: 900;
  fill: white;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.04em;
}
.dt-badge-enter-active { transition: opacity .4s ease, transform .4s ease; }
.dt-badge-enter-from   { opacity: 0; transform: translateY(-4px); }

/* OK badge on fixed stages */
.dt-ok-circle {
  fill: #059669;
  stroke: #065f46;
  stroke-width: 1.5;
}
.dt-ok-text {
  font-size: 14px;
  font-weight: 900;
  fill: white;
  font-family: 'JetBrains Mono', monospace;
}

/* ===== Trap detail panel ===== */
.dt-panel-bg {
  fill: #fafafa;
  stroke: #e5e7eb;
  stroke-width: 1.5;
  stroke-dasharray: 4 3;
}
.dt-col-head-bg-trap {
  fill: #fef2f2;
  stroke: #fca5a5;
  stroke-width: 1.2;
}
.dt-col-head-bg-fix {
  fill: #ecfdf5;
  stroke: #6ee7b7;
  stroke-width: 1.2;
}
.dt-col-head-tag {
  font-size: 17px;
  font-weight: 900;
  fill: #991b1b;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.06em;
}
.dt-col-head-tag-fix {
  font-size: 17px;
  font-weight: 900;
  fill: #065f46;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.06em;
}
.dt-col-head-cat {
  font-size: 14px;
  font-weight: 800;
  fill: #4b5563;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.04em;
}
.dt-col-title {
  font-size: 17px;
  font-weight: 800;
  fill: #111827;
  font-family: 'BIZ UDPMincho', serif;
}
.dt-col-title-fix {
  font-size: 16px;
  font-weight: 800;
  fill: #065f46;
  font-family: 'BIZ UDPMincho', serif;
}
.dt-col-line {
  font-size: 14px;
  font-weight: 600;
  fill: #1f2937;
  font-family: 'Noto Sans JP', sans-serif;
}
.dt-panel-tag {
  font-size: 13px;
  font-weight: 900;
  fill: #9ca3af;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.08em;
}

.dt-panel-enter-active { transition: opacity .5s ease, transform .5s ease; }
.dt-panel-leave-active { transition: opacity .35s ease, transform .35s ease; }
.dt-panel-enter-from   { opacity: 0; transform: translateY(10px); }
.dt-panel-leave-to     { opacity: 0; transform: translateY(-6px); }

/* ===== Fixed-row summary ===== */
.dt-fixed-bg {
  fill: #ecfdf5;
  stroke: #10b981;
  stroke-width: 2.5;
  stroke-dasharray: 0;
  filter: drop-shadow(0 0 8px rgba(16, 185, 129, 0.35));
}
.dt-fixed-head {
  font-size: 22px;
  font-weight: 900;
  fill: #065f46;
  font-family: 'BIZ UDPMincho', serif;
  letter-spacing: 0.04em;
}
.dt-fixed-sub {
  font-size: 14px;
  font-weight: 700;
  fill: #047857;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.06em;
}
.dt-pill-circle {
  fill: #10b981;
  stroke: #065f46;
  stroke-width: 2;
}
.dt-pill-num {
  font-size: 18px;
  font-weight: 900;
  fill: white;
  font-family: 'JetBrains Mono', monospace;
}
.dt-pill-cat {
  font-size: 13px;
  font-weight: 800;
  fill: #047857;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.04em;
}
.dt-pill-title {
  font-size: 15px;
  font-weight: 700;
  fill: #064e3b;
  font-family: 'Noto Sans JP', sans-serif;
}
.dt-fixed-enter-active { transition: opacity .5s ease, transform .5s ease; }
.dt-fixed-enter-from   { opacity: 0; transform: scale(0.95); }
</style>
