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
const phaseDurations = [3500, 4000, 4500, 5000, 5000, 5500]
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
  { code: 'Issuer  signs  mDOC/JWT/VC   with  ECDSA + SHA-256',                         note: '既存の運転免許局 / 銀行 / 大学はそのままの方式で署名 (何も変えない)' },
  { code: 'wallet ← VC                                                                  ',  note: 'ユーザは Google Wallet / EUDI Wallet に既存 ID を保持' },
  { code: 'verifier  asks  : "age ≥ 18 ?"   (predicate over VC)',                       note: 'EC サイト・銀行・年齢制限が必要なサービスからの問い合わせ' },
  { code: 'wallet  →  π  =  ZK { ∃ VC : Sig(VC) ✓  ∧  age(VC) ≥ 18 }',                 note: 'MPC-in-the-head (Ligero 系) + Σ-protocol で既存署名を ZK 化' },
  { code: 'verifier  receives  ✓ ≥18    only                                            ',  note: '生年月日・氏名・原本 ID は一切漏れない' },
  { code: 'deployed: Google Wallet ｜ Bumble auth ｜ EUDI Wallet 候補 ｜ IETF CFRG 議論', note: 'Trail of Bits + Ligero 監査済 (2025)' },
]

const showVcAtUser    = computed(() => phase.value >= 1)
const showQuery       = computed(() => phase.value >= 2)
const showZkGen       = computed(() => phase.value >= 3)
const showVerifyOk    = computed(() => phase.value >= 4)
const showDeployStat  = computed(() => phase.value === 5)

const issuerActive   = computed(() => phase.value === 0)
const userActive     = computed(() => phase.value === 1 || phase.value === 3)
const verifierActive = computed(() => phase.value === 2)
const verifierAccept = computed(() => phase.value >= 4)
</script>

<template>
  <div class="lf-root">
    <!-- Caption strip -->
    <div class="lf-cap">
      <transition name="lf-fade" mode="out-in">
        <div :key="phase" class="lf-cap-inner">
          <code class="lf-code">{{ captions[phase].code }}</code>
          <div class="lf-note">{{ captions[phase].note }}</div>
        </div>
      </transition>
    </div>

    <!-- Main SVG -->
    <svg class="lf-svg" viewBox="0 0 1200 380" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="lf-ar" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#94a3b8"/>
        </marker>
        <marker id="lf-ar-amber" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#b45309"/>
        </marker>
        <marker id="lf-ar-green" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#059669"/>
        </marker>
      </defs>

      <!-- ===== Existing standards band (top) ===== -->
      <g class="lf-band-existing">
        <rect x="50" y="20" width="1100" height="46" rx="6"
              fill="rgba(99,102,241,0.05)" stroke="#94a3b8"
              stroke-width="1.5" stroke-dasharray="6 4"/>
        <text x="70" y="46" class="lf-band-label">EXISTING ID STANDARDS  (no change)</text>
        <text x="1135" y="46" text-anchor="end" class="lf-band-label">ECDSA / SHA-256 / mDOC / JWT</text>
      </g>

      <!-- ===== Issuer ===== -->
      <g class="lf-node lf-issuer" :class="{ 'is-active': issuerActive, 'is-past': phase > 0 }">
        <rect x="60" y="100" width="190" height="120" rx="10" class="lf-node-bg"/>
        <!-- building icon (gov / university / bank) -->
        <g transform="translate(155, 135)" class="lf-icon">
          <rect x="-22" y="-2" width="44" height="22" rx="0" class="lf-icon-fill"/>
          <path d="M -25,-2 L 0,-16 L 25,-2 Z" class="lf-icon-fill"/>
          <line x1="-15" y1="2" x2="-15" y2="18" stroke="white" stroke-width="1.5"/>
          <line x1="-5" y1="2"  x2="-5" y2="18"  stroke="white" stroke-width="1.5"/>
          <line x1="5" y1="2"   x2="5" y2="18"   stroke="white" stroke-width="1.5"/>
          <line x1="15" y1="2"  x2="15" y2="18"  stroke="white" stroke-width="1.5"/>
        </g>
        <text x="155" y="180" text-anchor="middle" class="lf-node-title">Issuer</text>
        <text x="155" y="202" text-anchor="middle" class="lf-node-sub">運転局 / 銀行 / 大学</text>
      </g>

      <!-- ===== User (wallet) ===== -->
      <g class="lf-node lf-user" :class="{ 'is-active': userActive }">
        <rect x="455" y="100" width="290" height="120" rx="10" class="lf-node-bg"/>
        <!-- wallet icon -->
        <g transform="translate(515, 138)" class="lf-icon">
          <rect x="-18" y="-12" width="36" height="26" rx="3" class="lf-icon-fill"/>
          <circle cx="12" cy="0" r="3" fill="white"/>
        </g>
        <!-- user figure beside wallet -->
        <g transform="translate(570, 138)" class="lf-icon">
          <circle cx="0" cy="-7" r="6" class="lf-icon-fill"/>
          <path d="M -9,3 Q 0,0 9,3 L 8,15 L -8,15 Z" class="lf-icon-fill"/>
        </g>
        <text x="600" y="180" text-anchor="middle" class="lf-node-title">User wallet</text>
        <text x="600" y="202" text-anchor="middle" class="lf-node-sub">Google Wallet / EUDI Wallet</text>

        <!-- VC chip inside wallet (appears at phase 1) -->
        <transition name="lf-fade">
          <g v-if="showVcAtUser" class="lf-vc-chip">
            <rect x="630" y="115" width="100" height="48" rx="5" fill="#fef3c7" stroke="#d97706" stroke-width="1.5"/>
            <text x="680" y="134" text-anchor="middle" class="lf-vc-title">VC</text>
            <text x="680" y="151" text-anchor="middle" class="lf-vc-sub">mDOC / JWT</text>
          </g>
        </transition>
      </g>

      <!-- ===== Verifier ===== -->
      <g class="lf-node lf-verifier"
         :class="{ 'is-active': verifierActive, 'is-accept': verifierAccept }">
        <rect x="950" y="100" width="200" height="120" rx="10" class="lf-node-bg"/>
        <!-- shield icon -->
        <g transform="translate(1050, 140)" class="lf-icon">
          <path d="M 0,-18 L 16,-11 L 16,6 Q 16,18 0,22 Q -16,18 -16,6 L -16,-11 Z" class="lf-shield-fill"/>
          <path v-if="verifierAccept" d="M -6,3 L 0,9 L 9,-4"
                stroke="white" stroke-width="2.6" fill="none"
                stroke-linecap="round" stroke-linejoin="round"/>
          <text v-else x="0" y="6" text-anchor="middle" fill="white"
                font-size="18" font-weight="900">?</text>
        </g>
        <text x="1050" y="180" text-anchor="middle" class="lf-node-title">検証者</text>
        <text x="1050" y="202" text-anchor="middle" class="lf-node-sub">EC site / 銀行</text>
      </g>

      <!-- ===== Wire 1: Issuer → User (VC) ===== -->
      <transition name="lf-fade">
        <g v-if="phase >= 1" class="lf-wire-issue">
          <line x1="250" y1="160" x2="455" y2="160" class="lf-wire-amber"
                marker-end="url(#lf-ar-amber)"/>
          <rect x="295" y="135" width="115" height="20" rx="3" fill="#fffbeb" stroke="#b45309" stroke-width="1.2"/>
          <text x="353" y="150" text-anchor="middle" class="lf-wire-label">VC (signed)</text>
        </g>
      </transition>

      <!-- ===== Wire 2: Verifier → User (query) ===== -->
      <transition name="lf-fade">
        <g v-if="showQuery && phase < 4" class="lf-wire-query">
          <line x1="950" y1="155" x2="745" y2="155" class="lf-wire-amber"
                marker-end="url(#lf-ar-amber)"/>
          <rect x="800" y="132" width="140" height="20" rx="3" fill="#fffbeb" stroke="#b45309" stroke-width="1.2"/>
          <text x="870" y="147" text-anchor="middle" class="lf-wire-label">"age ≥ 18 ?"</text>
        </g>
      </transition>

      <!-- ===== ZK gen ring around User ===== -->
      <transition name="lf-fade">
        <g v-if="phase === 3" class="lf-zk-gen">
          <rect x="450" y="95" width="300" height="130" rx="13"
                fill="none" stroke="#b45309" stroke-width="3"
                stroke-dasharray="6 4"
                style="filter: drop-shadow(0 0 10px rgba(180, 83, 9, 0.5));
                       animation: lf-zk-rotate 8s linear infinite;
                       transform-origin: 600px 160px;"/>
          <text x="600" y="92" text-anchor="middle" class="lf-zk-label">π を生成中  ─  MPC-in-the-head + Σ</text>
        </g>
      </transition>

      <!-- ===== Wire 3: User → Verifier (proof) ===== -->
      <transition name="lf-fade">
        <g v-if="showVerifyOk" class="lf-wire-proof">
          <line x1="745" y1="170" x2="950" y2="170" class="lf-wire-green"
                marker-end="url(#lf-ar-green)"/>
          <rect x="795" y="148" width="155" height="20" rx="3" fill="#dcfce7" stroke="#059669" stroke-width="1.5"/>
          <text x="872" y="163" text-anchor="middle" class="lf-wire-label-g">π : age ≥ 18  ✓</text>
        </g>
      </transition>

      <!-- ===== Deployment status (bottom) ===== -->
      <transition name="lf-fade">
        <g v-if="showDeployStat" class="lf-deploy">
          <rect x="60" y="260" width="1090" height="86" rx="8"
                fill="#f0fdf4" stroke="#059669" stroke-width="2"/>
          <text x="80" y="284" class="lf-deploy-label">DEPLOYMENT STATUS</text>
          <g class="lf-deploy-chips">
            <g transform="translate(80, 300)">
              <rect x="0" y="0" width="190" height="30" rx="5" fill="white" stroke="#86efac" stroke-width="1.5"/>
              <text x="95" y="20" text-anchor="middle" class="lf-chip-text">Google Wallet ▸ deploy 済</text>
            </g>
            <g transform="translate(290, 300)">
              <rect x="0" y="0" width="170" height="30" rx="5" fill="white" stroke="#86efac" stroke-width="1.5"/>
              <text x="85" y="20" text-anchor="middle" class="lf-chip-text">Bumble ▸ 認証稼働</text>
            </g>
            <g transform="translate(480, 300)">
              <rect x="0" y="0" width="200" height="30" rx="5" fill="white" stroke="#86efac" stroke-width="1.5"/>
              <text x="100" y="20" text-anchor="middle" class="lf-chip-text">EUDI Wallet ▸ 採用検討</text>
            </g>
            <g transform="translate(700, 300)">
              <rect x="0" y="0" width="195" height="30" rx="5" fill="white" stroke="#86efac" stroke-width="1.5"/>
              <text x="97" y="20" text-anchor="middle" class="lf-chip-text">IETF CFRG ▸ 標準化議論</text>
            </g>
            <g transform="translate(915, 300)">
              <rect x="0" y="0" width="225" height="30" rx="5" fill="white" stroke="#86efac" stroke-width="1.5"/>
              <text x="112" y="20" text-anchor="middle" class="lf-chip-text">Trail of Bits + Ligero 監査済</text>
            </g>
          </g>
        </g>
      </transition>
    </svg>
  </div>
</template>

<style scoped>
.lf-root {
  position: relative;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 6px;
  font-family: 'Noto Sans JP', sans-serif;
  color: #111827;
}

.lf-cap {
  padding: 9px 16px;
  background: #eef2ff;
  border: 1px solid #c7d2fe;
  border-radius: 0.5rem;
  min-height: 52px;
  display: flex;
  align-items: center;
}
.lf-cap-inner {
  display: flex;
  flex-direction: column;
  gap: 3px;
  width: 100%;
}
.lf-code {
  font-family: 'JetBrains Mono', monospace;
  font-size: 17px;
  color: #1e1b4b;
  font-weight: 700;
}
.lf-note {
  font-size: 14px;
  color: #4338ca;
  font-weight: 600;
}

.lf-svg {
  width: 100%;
  height: auto;
  display: block;
  font-family: 'Noto Sans JP', sans-serif;
}

.lf-band-label {
  font-size: 13px;
  font-weight: 700;
  fill: #4f46e5;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.08em;
}

/* Nodes */
.lf-node-bg {
  fill: white;
  stroke: #94a3b8;
  stroke-width: 2;
  transition: fill 0.5s, stroke 0.5s, filter 0.5s, stroke-width 0.5s;
}
.lf-node.is-active .lf-node-bg {
  fill: #fffbeb;
  stroke: #d97706;
  stroke-width: 3;
  filter: drop-shadow(0 0 8px rgba(217, 119, 6, 0.45));
}
.lf-node.is-past .lf-node-bg {
  fill: #f9fafb;
}
.lf-verifier.is-accept .lf-node-bg {
  fill: #dcfce7;
  stroke: #059669;
  stroke-width: 3;
  filter: drop-shadow(0 0 8px rgba(5, 150, 105, 0.5));
}

.lf-icon-fill { fill: #475569; transition: fill 0.5s; }
.lf-shield-fill { fill: #475569; transition: fill 0.5s; }
.lf-verifier.is-accept .lf-shield-fill { fill: #059669; }

.lf-node-title {
  font-size: 19px;
  font-weight: 700;
  fill: #111827;
  font-family: 'BIZ UDPMincho', serif;
}
.lf-node-sub {
  font-size: 14px;
  fill: #475569;
  font-family: 'JetBrains Mono', monospace;
  font-weight: 600;
}

/* VC chip */
.lf-vc-title {
  font-size: 16px;
  font-weight: 800;
  fill: #78350f;
  font-family: 'BIZ UDPMincho', serif;
}
.lf-vc-sub {
  font-size: 12px;
  fill: #92400e;
  font-family: 'JetBrains Mono', monospace;
  font-weight: 700;
}

/* Wires */
.lf-wire-amber {
  stroke: #b45309;
  stroke-width: 2.5;
  stroke-dasharray: 6 3;
  animation: lf-flow 1s linear infinite;
  fill: none;
}
.lf-wire-green {
  stroke: #059669;
  stroke-width: 2.5;
  stroke-dasharray: 6 3;
  animation: lf-flow 1s linear infinite;
  fill: none;
}
@keyframes lf-flow { to { stroke-dashoffset: -18; } }
.lf-wire-label {
  font-size: 13px;
  fill: #78350f;
  font-weight: 700;
  font-family: 'JetBrains Mono', monospace;
}
.lf-wire-label-g {
  font-size: 13px;
  fill: #064e3b;
  font-weight: 800;
  font-family: 'JetBrains Mono', monospace;
}

/* ZK gen ring */
.lf-zk-label {
  font-size: 14px;
  fill: #78350f;
  font-weight: 800;
  font-family: 'JetBrains Mono', monospace;
}
@keyframes lf-zk-rotate {
  to { stroke-dashoffset: -100; }
}

/* Deployment status */
.lf-deploy-label {
  font-size: 13px;
  font-weight: 800;
  fill: #047857;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.08em;
}
.lf-chip-text {
  font-size: 12px;
  font-weight: 700;
  fill: #065f46;
  font-family: 'JetBrains Mono', monospace;
}

/* Transitions */
.lf-fade-enter-active, .lf-fade-leave-active {
  transition: opacity 0.5s ease, transform 0.5s ease;
}
.lf-fade-enter-from { opacity: 0; transform: translateY(4px); }
.lf-fade-leave-to { opacity: 0; transform: translateY(-4px); }
</style>
