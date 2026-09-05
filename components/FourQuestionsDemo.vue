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
const phaseDurations = [4000, 4500, 5500, 5000, 7000]
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

const q1Filled  = computed(() => phase.value >= 1)
const q2Filled  = computed(() => phase.value >= 2)
const q2Spot    = computed(() => phase.value === 2)
const q34Filled = computed(() => phase.value >= 3)
const verdict   = computed(() => phase.value >= 4)

const captions = [
  { tag: 'Template',     code: '「4 つの問い」共通テンプレート  →  2 つのサービスに同時適用' },
  { tag: '① 何を守る?',  code: 'SMBC: クライアント口座 + 取引履歴  ／  結婚: 各ユーザのプロフィール' },
  { tag: '② 誰が計算?',  code: 'SMBC: 単一組織 (オフチェーン)  ／  結婚: 全参加者 — ★ ZK/MPC の分岐' },
  { tag: '③ いつ? ④ 検証?', code: 'リアルタイム + 監査  vs リアルタイム  ／  規制 + Client vs User 自身' },
  { tag: '∴ 結論',       code: '同じ問いから ZK と MPC、別々の最適解 (FHE はどちらにも該当せず)' },
]
const currentCaption = computed(() => captions[phase.value])
</script>

<template>
  <div class="fq-root">
    <!-- ===== Caption strip ===== -->
    <div class="fq-caption">
      <transition name="fq-cap" mode="out-in">
        <div :key="phase" class="fq-cap-inner">
          <span class="fq-cap-tag"
                :class="{
                  'is-t':  phase === 0,
                  'is-q1': phase === 1,
                  'is-q2': phase === 2,
                  'is-q3': phase === 3,
                  'is-r':  phase === 4,
                }">{{ currentCaption.tag }}</span>
          <span class="fq-cap-code">{{ currentCaption.code }}</span>
        </div>
      </transition>
    </div>

    <!-- ===== Main SVG ===== -->
    <svg class="fq-svg" viewBox="0 0 1200 430" preserveAspectRatio="xMidYMid meet">
      <!-- ===== Q2 vertical spotlight (phase 2) ===== -->
      <transition name="fq-spot">
        <rect v-if="q2Spot" x="378" y="0" width="228" height="395"
              rx="8" class="fq-q2-spot"/>
      </transition>

      <!-- ===== Headers row ===== -->
      <g class="fq-header">
        <text x="268"  y="26" text-anchor="middle" class="fq-q-text">① 何を守る?</text>
        <text x="492"  y="26" text-anchor="middle" class="fq-q-text">② 誰が計算?</text>
        <text x="716"  y="26" text-anchor="middle" class="fq-q-text">③ いつ?</text>
        <text x="940"  y="26" text-anchor="middle" class="fq-q-text">④ 誰が検証?</text>
        <text x="1123" y="26" text-anchor="middle" class="fq-q-text fq-q-text-verdict">→ Tech</text>
      </g>

      <!-- ===== SMBC row ===== -->
      <!-- Label band -->
      <g class="fq-band fq-band-smbc">
        <rect x="10" y="50" width="140" height="160" rx="8"/>
        <text x="80" y="100" text-anchor="middle" class="fq-band-eyebrow">Service A</text>
        <text x="80" y="135" text-anchor="middle" class="fq-band-title">SMBC</text>
        <text x="80" y="160" text-anchor="middle" class="fq-band-sub">DeFi API</text>
        <text x="80" y="180" text-anchor="middle" class="fq-band-sub">privacy</text>
      </g>

      <!-- Q1 SMBC -->
      <g class="fq-cell fq-cell-smbc" :class="{ 'is-filled': q1Filled }">
        <rect x="160" y="50" width="216" height="160" rx="8" class="fq-cell-bg"/>
        <transition name="fq-fill">
          <text v-if="q1Filled" x="268" y="120" text-anchor="middle" class="fq-cell-text">
            <tspan x="268" dy="0">クライアント口座情報</tspan>
            <tspan x="268" dy="24">+ DeFi 取引履歴</tspan>
          </text>
        </transition>
      </g>

      <!-- Q2 SMBC -->
      <g class="fq-cell fq-cell-smbc" :class="{ 'is-filled': q2Filled, 'is-key': q2Filled }">
        <rect x="384" y="50" width="216" height="160" rx="8" class="fq-cell-bg"/>
        <transition name="fq-fill">
          <text v-if="q2Filled" x="492" y="120" text-anchor="middle" class="fq-cell-text">
            <tspan x="492" dy="0">SMBC オフチェーン</tspan>
            <tspan x="492" dy="24" class="fq-cell-em">単一組織</tspan>
          </text>
        </transition>
      </g>

      <!-- Q3 SMBC -->
      <g class="fq-cell fq-cell-smbc" :class="{ 'is-filled': q34Filled }">
        <rect x="608" y="50" width="216" height="160" rx="8" class="fq-cell-bg"/>
        <transition name="fq-fill">
          <text v-if="q34Filled" x="716" y="120" text-anchor="middle" class="fq-cell-text">
            <tspan x="716" dy="0">リアルタイム</tspan>
            <tspan x="716" dy="24">+ 監査時に後追い</tspan>
          </text>
        </transition>
      </g>

      <!-- Q4 SMBC -->
      <g class="fq-cell fq-cell-smbc" :class="{ 'is-filled': q34Filled }">
        <rect x="832" y="50" width="216" height="160" rx="8" class="fq-cell-bg"/>
        <transition name="fq-fill">
          <text v-if="q34Filled" x="940" y="120" text-anchor="middle" class="fq-cell-text">
            <tspan x="940" dy="0">規制当局</tspan>
            <tspan x="940" dy="24">+ クライアント</tspan>
          </text>
        </transition>
      </g>

      <!-- SMBC verdict -->
      <g class="fq-verdict fq-verdict-smbc" :class="{ 'is-on': verdict }">
        <rect x="1056" y="50" width="134" height="160" rx="8" class="fq-verdict-bg"/>
        <transition name="fq-verdict-pop">
          <g v-if="verdict" key="smbc-v">
            <text x="1123" y="105" text-anchor="middle" class="fq-verdict-big">ZK</text>
            <text x="1123" y="138" text-anchor="middle" class="fq-verdict-sub">proof of</text>
            <text x="1123" y="156" text-anchor="middle" class="fq-verdict-sub">compliance</text>
            <text x="1123" y="180" text-anchor="middle" class="fq-verdict-sub">+ audit trail</text>
          </g>
        </transition>
      </g>

      <!-- ===== Matching row ===== -->
      <!-- Label band -->
      <g class="fq-band fq-band-match">
        <rect x="10" y="220" width="140" height="160" rx="8"/>
        <text x="80" y="270" text-anchor="middle" class="fq-band-eyebrow">Service B</text>
        <text x="80" y="305" text-anchor="middle" class="fq-band-title">結婚</text>
        <text x="80" y="330" text-anchor="middle" class="fq-band-sub">Matching</text>
        <text x="80" y="350" text-anchor="middle" class="fq-band-sub">Service</text>
      </g>

      <!-- Q1 Matching -->
      <g class="fq-cell fq-cell-match" :class="{ 'is-filled': q1Filled }">
        <rect x="160" y="220" width="216" height="160" rx="8" class="fq-cell-bg"/>
        <transition name="fq-fill">
          <text v-if="q1Filled" x="268" y="304" text-anchor="middle" class="fq-cell-text">
            <tspan x="268" dy="0">各ユーザの</tspan>
            <tspan x="268" dy="24">プロフィール</tspan>
          </text>
        </transition>
      </g>

      <!-- Q2 Matching -->
      <g class="fq-cell fq-cell-match" :class="{ 'is-filled': q2Filled, 'is-key': q2Filled }">
        <rect x="384" y="220" width="216" height="160" rx="8" class="fq-cell-bg"/>
        <transition name="fq-fill">
          <text v-if="q2Filled" x="492" y="304" text-anchor="middle" class="fq-cell-text">
            <tspan x="492" dy="0" class="fq-cell-em">全参加者</tspan>
            <tspan x="492" dy="24">(相互マッチング)</tspan>
          </text>
        </transition>
      </g>

      <!-- Q3 Matching -->
      <g class="fq-cell fq-cell-match" :class="{ 'is-filled': q34Filled }">
        <rect x="608" y="220" width="216" height="160" rx="8" class="fq-cell-bg"/>
        <transition name="fq-fill">
          <text v-if="q34Filled" x="716" y="316" text-anchor="middle" class="fq-cell-text">
            <tspan x="716" dy="0">リアルタイム</tspan>
          </text>
        </transition>
      </g>

      <!-- Q4 Matching -->
      <g class="fq-cell fq-cell-match" :class="{ 'is-filled': q34Filled }">
        <rect x="832" y="220" width="216" height="160" rx="8" class="fq-cell-bg"/>
        <transition name="fq-fill">
          <text v-if="q34Filled" x="940" y="316" text-anchor="middle" class="fq-cell-text">
            <tspan x="940" dy="0">ユーザ自身</tspan>
          </text>
        </transition>
      </g>

      <!-- Matching verdict -->
      <g class="fq-verdict fq-verdict-match" :class="{ 'is-on': verdict }">
        <rect x="1056" y="220" width="134" height="160" rx="8" class="fq-verdict-bg"/>
        <transition name="fq-verdict-pop">
          <g v-if="verdict" key="match-v">
            <text x="1123" y="275" text-anchor="middle" class="fq-verdict-big">MPC</text>
            <text x="1123" y="308" text-anchor="middle" class="fq-verdict-sub">相互計算</text>
            <text x="1123" y="328" text-anchor="middle" class="fq-verdict-sub">(複数当事者</text>
            <text x="1123" y="348" text-anchor="middle" class="fq-verdict-sub"> の合算)</text>
          </g>
        </transition>
      </g>

      <!-- FHE excluded annotation (phase 4) -->
      <transition name="fq-fade">
        <g v-if="verdict" class="fq-fhe-note-g">
          <text x="600" y="412" text-anchor="middle" class="fq-fhe-note">
            <tspan class="fq-fhe-strong">FHE</tspan> — 今回どちらにも該当しない (片方は ZK、片方は MPC が最適、FHE は重すぎる)
          </text>
        </g>
      </transition>
    </svg>
  </div>
</template>

<style scoped>
.fq-root {
  position: relative;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 6px;
  font-family: 'Noto Sans JP', sans-serif;
  color: #111827;
}

/* ===== Caption ===== */
.fq-caption {
  padding: 9px 16px;
  background: #eef2ff;
  border: 1px solid #c7d2fe;
  border-radius: 0.5rem;
  min-height: 42px;
  display: flex;
  align-items: center;
}
.fq-cap-inner {
  display: flex; align-items: center; gap: 14px; width: 100%;
}
.fq-cap-tag {
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
.fq-cap-tag.is-t  { background: #6b7280; }
.fq-cap-tag.is-q1 { background: #2563eb; }
.fq-cap-tag.is-q2 { background: #dc2626; }
.fq-cap-tag.is-q3 { background: #d97706; }
.fq-cap-tag.is-r  { background: #059669; }
.fq-cap-code {
  font-family: 'JetBrains Mono', monospace;
  font-size: 15px;
  font-weight: 700;
  color: #1e1b4b;
}
.fq-cap-enter-active, .fq-cap-leave-active {
  transition: opacity .35s ease, transform .35s ease;
}
.fq-cap-enter-from { opacity: 0; transform: translateY(6px); }
.fq-cap-leave-to   { opacity: 0; transform: translateY(-6px); }

/* ===== SVG ===== */
.fq-svg {
  width: 100%;
  height: auto;
  display: block;
  font-family: 'Noto Sans JP', sans-serif;
}

/* ===== Q2 spotlight ===== */
.fq-q2-spot {
  fill: rgba(254, 215, 170, 0.35);
  stroke: #f97316;
  stroke-width: 2.5;
  stroke-dasharray: 6 3;
  animation: fq-spot-pulse 1.6s ease-in-out infinite;
}
@keyframes fq-spot-pulse {
  0%, 100% { opacity: 0.55; }
  50%      { opacity: 1; }
}
.fq-spot-enter-active, .fq-spot-leave-active { transition: opacity .4s ease; }
.fq-spot-enter-from, .fq-spot-leave-to { opacity: 0; }

/* ===== Headers ===== */
.fq-q-text {
  font-size: 17px;
  font-weight: 700;
  fill: #1e1b4b;
  font-family: 'BIZ UDPMincho', serif;
  letter-spacing: 0.02em;
}
.fq-q-text-verdict {
  font-size: 16px;
  fill: #6b7280;
  letter-spacing: 0.06em;
}

/* ===== Label bands ===== */
.fq-band-smbc rect {
  fill: #1d4ed8;
  stroke: #1e40af;
  stroke-width: 1.5;
}
.fq-band-match rect {
  fill: #047857;
  stroke: #065f46;
  stroke-width: 1.5;
}
.fq-band-eyebrow {
  font-size: 12px;
  font-weight: 700;
  fill: rgba(255,255,255,0.78);
  letter-spacing: 0.16em;
  font-family: 'JetBrains Mono', monospace;
}
.fq-band-title {
  font-size: 26px;
  font-weight: 900;
  fill: white;
  font-family: 'BIZ UDPMincho', serif;
  letter-spacing: 0.04em;
}
.fq-band-sub {
  font-size: 14px;
  font-weight: 700;
  fill: rgba(255,255,255,0.88);
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.02em;
}

/* ===== Cells ===== */
.fq-cell-bg {
  fill: white;
  stroke: #cbd5e1;
  stroke-width: 1.8;
  stroke-dasharray: 4 3;
  transition: stroke .4s, stroke-width .4s, fill .4s, stroke-dasharray .4s;
}
.fq-cell.is-filled .fq-cell-bg {
  stroke-dasharray: 0;
  stroke-width: 2;
}
.fq-cell-smbc.is-filled .fq-cell-bg {
  stroke: #2563eb;
  fill: #eff6ff;
}
.fq-cell-match.is-filled .fq-cell-bg {
  stroke: #059669;
  fill: #ecfdf5;
}
.fq-cell.is-key .fq-cell-bg {
  stroke-width: 3;
  filter: drop-shadow(0 0 5px rgba(249, 115, 22, 0.5));
}
.fq-cell-text {
  font-size: 16px;
  font-weight: 700;
  fill: #111827;
  font-family: 'Noto Sans JP', sans-serif;
}
.fq-cell-em {
  font-weight: 900;
  fill: #b91c1c;
  font-size: 17px;
}

.fq-fill-enter-active { transition: opacity .4s ease, transform .4s ease; }
.fq-fill-enter-from   { opacity: 0; transform: translateY(8px); }

/* ===== Verdict ===== */
.fq-verdict-bg {
  fill: #f3f4f6;
  stroke: #d1d5db;
  stroke-width: 1.8;
  stroke-dasharray: 4 3;
  transition: stroke .5s, fill .5s, stroke-dasharray .5s, filter .5s;
}
.fq-verdict-smbc.is-on .fq-verdict-bg {
  fill: #dbeafe;
  stroke: #1d4ed8;
  stroke-width: 3;
  stroke-dasharray: 0;
  filter: drop-shadow(0 0 8px rgba(29, 78, 216, 0.5));
}
.fq-verdict-match.is-on .fq-verdict-bg {
  fill: #d1fae5;
  stroke: #047857;
  stroke-width: 3;
  stroke-dasharray: 0;
  filter: drop-shadow(0 0 8px rgba(4, 120, 87, 0.5));
}
.fq-verdict-big {
  font-size: 38px;
  font-weight: 900;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.06em;
}
.fq-verdict-smbc .fq-verdict-big  { fill: #1d4ed8; }
.fq-verdict-match .fq-verdict-big { fill: #047857; }
.fq-verdict-sub {
  font-size: 13px;
  font-weight: 700;
  fill: #374151;
  font-family: 'JetBrains Mono', monospace;
}
.fq-verdict-pop-enter-active { transition: opacity .55s ease .15s, transform .55s ease .15s; }
.fq-verdict-pop-enter-from   { opacity: 0; transform: scale(0.7); }

/* ===== FHE note ===== */
.fq-fhe-note {
  font-size: 14px;
  font-weight: 600;
  fill: #6b7280;
  font-family: 'Noto Sans JP', sans-serif;
}
.fq-fhe-strong {
  font-weight: 900;
  fill: #4b5563;
  font-family: 'JetBrains Mono', monospace;
  font-size: 15px;
}
.fq-fade-enter-active { transition: opacity .5s ease .2s; }
.fq-fade-enter-from   { opacity: 0; }
</style>
