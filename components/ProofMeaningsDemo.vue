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

const mathActive = computed(() => phase.value === 1)
const infoActive = computed(() => phase.value === 2)
const compActive = computed(() => phase.value === 3 || phase.value === 4)
const bridgePhase = computed(() => phase.value === 4)

const codeFragments = computed(() => {
  switch (phase.value) {
    case 0: return '// 3 つの「証明」概念 — 強さ・敵対前提・例を区別する'
    case 1: return 'Theorem φ   ⊢   Axioms (ZF)  ⊨  formal derivation tree   ∴ QED  ∎'
    case 2: return 'Pr[ Adv(c) → m  |  runtime(Adv) = ∞ ] = 0      // OTP, Σ-protocols'
    case 3: return 'Pr[ Adv(x) → π* |  runtime(Adv) = poly ] ≤ negl(λ)   // ⇐ DL hardness'
    case 4: return '// 2026: ZK / 署名 / MAC / SNARK / Longfellow — すべて ③ に賭けている'
    default: return ''
  }
})
</script>

<template>
  <div class="pm-root">
    <!-- ===== Code/formula strip (top) ===== -->
    <div class="pm-config">
      <transition name="pm-fade" mode="out-in">
        <code class="pm-cfg-code" :key="phase">{{ codeFragments }}</code>
      </transition>
    </div>

    <!-- ===== Main SVG ===== -->
    <svg class="pm-svg" viewBox="0 0 1200 430" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="pm-arrow-end" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" class="pm-marker"/>
        </marker>
      </defs>

      <!-- ============ Panel 1: Mathematical Proof ============ -->
      <g class="pm-panel pm-panel-math" :class="{ 'is-active': mathActive, 'is-dim': !mathActive }">
        <rect x="40" y="30" width="360" height="370" rx="10" class="pm-panel-bg"/>
        <text x="220" y="62" text-anchor="middle" class="pm-panel-num">①</text>
        <text x="220" y="92" text-anchor="middle" class="pm-panel-title">数学的証明</text>
        <text x="220" y="112" text-anchor="middle" class="pm-panel-subtitle">formal logic · peer-review</text>

        <!-- Proof chain: Axioms → Lemma → Theorem (QED) -->
        <g class="pm-math-chain">
          <g class="pm-math-node pm-math-axioms">
            <rect x="55" y="160" width="92" height="58" rx="6" class="pm-math-bg"/>
            <text x="101" y="185" text-anchor="middle" class="pm-math-label-l">Axioms</text>
            <text x="101" y="205" text-anchor="middle" class="pm-math-sublabel">ZF · ZFC</text>
          </g>
          <line x1="147" y1="189" x2="175" y2="189" class="pm-math-arrow pm-math-arrow-1" marker-end="url(#pm-arrow-end)"/>
          <g class="pm-math-node pm-math-lemma">
            <rect x="175" y="160" width="92" height="58" rx="6" class="pm-math-bg"/>
            <text x="221" y="185" text-anchor="middle" class="pm-math-label-l">Lemma</text>
            <text x="221" y="205" text-anchor="middle" class="pm-math-sublabel">補題</text>
          </g>
          <line x1="267" y1="189" x2="295" y2="189" class="pm-math-arrow pm-math-arrow-2" marker-end="url(#pm-arrow-end)"/>
          <g class="pm-math-node pm-math-theorem">
            <rect x="295" y="160" width="92" height="58" rx="6" class="pm-math-bg"/>
            <text x="341" y="185" text-anchor="middle" class="pm-math-label-l">Theorem</text>
            <text x="341" y="205" text-anchor="middle" class="pm-math-sublabel">∴ QED ∎</text>
          </g>
        </g>

        <!-- (no adversary — truth has no adversary, only reviewers) -->
        <g class="pm-math-note">
          <text x="220" y="270" text-anchor="middle" class="pm-math-note-text">敵対者なし — 真偽は人類が共有する命題</text>
        </g>

        <!-- Property + example tags -->
        <g class="pm-tags">
          <rect x="55" y="298" width="330" height="32" rx="5" class="pm-tag-bg pm-tag-prop"/>
          <text x="220" y="319" text-anchor="middle" class="pm-tag-text">Pr[wrong] = 0  ｜  証明は時間に依らない</text>
          <rect x="55" y="340" width="330" height="32" rx="5" class="pm-tag-bg pm-tag-example"/>
          <text x="220" y="361" text-anchor="middle" class="pm-tag-example-text">例: Fermat (Wiles 1995), Gödel, Euclid</text>
        </g>
      </g>

      <!-- ============ Panel 2: Information-theoretic ============ -->
      <g class="pm-panel pm-panel-info" :class="{ 'is-active': infoActive, 'is-dim': !infoActive }">
        <rect x="420" y="30" width="360" height="370" rx="10" class="pm-panel-bg"/>
        <text x="600" y="62" text-anchor="middle" class="pm-panel-num">②</text>
        <text x="600" y="92" text-anchor="middle" class="pm-panel-title">情報論的暗号証明</text>
        <text x="600" y="112" text-anchor="middle" class="pm-panel-subtitle">information-theoretic</text>

        <!-- Prover -->
        <g class="pm-actor pm-actor-prover">
          <rect x="445" y="155" width="80" height="62" rx="6" class="pm-actor-bg"/>
          <g transform="translate(485, 178)">
            <circle cx="0" cy="-5" r="6.5" class="pm-actor-icon"/>
            <path d="M -9,4 Q 0,1 9,4 L 8,16 L -8,16 Z" class="pm-actor-icon"/>
          </g>
          <text x="485" y="234" text-anchor="middle" class="pm-actor-label">証明者</text>
        </g>

        <!-- Verifier -->
        <g class="pm-actor pm-actor-verifier">
          <rect x="675" y="155" width="80" height="62" rx="6" class="pm-actor-bg"/>
          <g transform="translate(715, 180)">
            <path d="M 0,-12 L 10,-7 L 10,5 Q 10,14 0,16 Q -10,14 -10,5 L -10,-7 Z" class="pm-actor-shield"/>
            <path d="M -5,1 L 0,6 L 6,-4" class="pm-actor-check" fill="none"/>
          </g>
          <text x="715" y="234" text-anchor="middle" class="pm-actor-label">検証者</text>
          <!-- OK ✓ chip when active -->
          <transition name="pm-pop">
            <g v-if="infoActive" class="pm-ok-chip">
              <circle cx="760" cy="162" r="11" class="pm-ok-circle"/>
              <path d="M 755,162 L 759,166 L 765,158" class="pm-ok-check" fill="none"/>
            </g>
          </transition>
        </g>

        <!-- Wire P→V -->
        <line x1="525" y1="186" x2="670" y2="186" class="pm-wire" marker-end="url(#pm-arrow-end)"/>

        <!-- Assumption badge (above actors, top of stack) — info-theoretic = no assumption -->
        <transition name="pm-pop">
          <g v-if="infoActive" class="pm-assume-badge pm-assume-none">
            <rect x="470" y="119" width="260" height="20" rx="4" class="pm-assume-bg"/>
            <text x="600" y="133" text-anchor="middle" class="pm-assume-text">✓ no assumption — unconditional</text>
          </g>
        </transition>

        <!-- π hex (proof = big number, below assumption badge, above actors) -->
        <transition name="pm-pop">
          <g v-if="infoActive" class="pm-proof-hex-g">
            <text x="600" y="152" text-anchor="middle" class="pm-proof-hex">π = 0xA4 7B 3F C8 9E 2D … 4F 19</text>
          </g>
        </transition>

        <!-- Verify-logic box (specific check formula, separate from π) -->
        <transition name="pm-pop">
          <g v-if="infoActive" class="pm-verify-logic">
            <rect x="450" y="245" width="300" height="28" rx="5" class="pm-verify-bg"/>
            <text x="600" y="263" text-anchor="middle" class="pm-verify-text">Verify: g^z = a · y^c   → ✓</text>
          </g>
        </transition>

        <!-- Adversary with ∞ -->
        <g class="pm-actor pm-actor-adv pm-adv-info">
          <rect x="455" y="285" width="90" height="48" rx="6" class="pm-adv-bg"/>
          <text x="500" y="314" text-anchor="middle" class="pm-adv-inf">∞</text>
          <text x="500" y="348" text-anchor="middle" class="pm-adv-label">Adversary</text>
        </g>
        <transition name="pm-pop">
          <g v-if="infoActive" class="pm-adv-fail">
            <text x="555" y="315" class="pm-adv-cross-text">→ ✗ break impossible</text>
          </g>
        </transition>

        <!-- Property tag -->
        <g class="pm-tags">
          <rect x="435" y="365" width="330" height="28" rx="5" class="pm-tag-bg pm-tag-prop"/>
          <text x="600" y="384" text-anchor="middle" class="pm-tag-text">Pr[break] = 0  ⇐  ∞-compute でも</text>
        </g>
      </g>

      <!-- ============ Panel 3: Computational ============ -->
      <g class="pm-panel pm-panel-comp" :class="{ 'is-active': compActive, 'is-bridge': bridgePhase, 'is-dim': !compActive }">
        <rect x="800" y="30" width="360" height="370" rx="10" class="pm-panel-bg"/>
        <text x="980" y="62" text-anchor="middle" class="pm-panel-num">③</text>
        <text x="980" y="92" text-anchor="middle" class="pm-panel-title">計算論的暗号証明</text>
        <text x="980" y="112" text-anchor="middle" class="pm-panel-subtitle">computational</text>

        <!-- Prover -->
        <g class="pm-actor pm-actor-prover">
          <rect x="825" y="155" width="80" height="62" rx="6" class="pm-actor-bg"/>
          <g transform="translate(865, 178)">
            <circle cx="0" cy="-5" r="6.5" class="pm-actor-icon"/>
            <path d="M -9,4 Q 0,1 9,4 L 8,16 L -8,16 Z" class="pm-actor-icon"/>
          </g>
          <text x="865" y="234" text-anchor="middle" class="pm-actor-label">証明者</text>
        </g>

        <!-- Verifier -->
        <g class="pm-actor pm-actor-verifier">
          <rect x="1055" y="155" width="80" height="62" rx="6" class="pm-actor-bg"/>
          <g transform="translate(1095, 180)">
            <path d="M 0,-12 L 10,-7 L 10,5 Q 10,14 0,16 Q -10,14 -10,5 L -10,-7 Z" class="pm-actor-shield"/>
            <path d="M -5,1 L 0,6 L 6,-4" class="pm-actor-check" fill="none"/>
          </g>
          <text x="1095" y="234" text-anchor="middle" class="pm-actor-label">検証者</text>
          <!-- OK ✓ chip when active -->
          <transition name="pm-pop">
            <g v-if="compActive" class="pm-ok-chip">
              <circle cx="1140" cy="162" r="11" class="pm-ok-circle"/>
              <path d="M 1135,162 L 1139,166 L 1145,158" class="pm-ok-check" fill="none"/>
            </g>
          </transition>
        </g>

        <!-- Wire P→V -->
        <line x1="905" y1="186" x2="1050" y2="186" class="pm-wire" marker-end="url(#pm-arrow-end)"/>

        <!-- Assumption badge (above actors, top of stack) — computational depends on hardness -->
        <transition name="pm-pop">
          <g v-if="compActive" class="pm-assume-badge pm-assume-hard">
            <rect x="850" y="119" width="260" height="20" rx="4" class="pm-assume-bg"/>
            <text x="980" y="133" text-anchor="middle" class="pm-assume-text">⚠ assuming: DL · RSA · LWE hard</text>
          </g>
        </transition>

        <!-- π hex (proof = big number, below assumption badge, above actors) -->
        <transition name="pm-pop">
          <g v-if="compActive" class="pm-proof-hex-g">
            <text x="980" y="152" text-anchor="middle" class="pm-proof-hex">π = 0x7a3f c8e2 d4 19 … 8c b1 4e</text>
          </g>
        </transition>

        <!-- Verify-logic box (specific check formula, separate from π) -->
        <transition name="pm-pop">
          <g v-if="compActive" class="pm-verify-logic">
            <rect x="830" y="245" width="300" height="28" rx="5" class="pm-verify-bg"/>
            <text x="980" y="263" text-anchor="middle" class="pm-verify-text">Verify: e(a, b) = e(g, vk)   → ✓</text>
          </g>
        </transition>

        <!-- Adversary with clock -->
        <g class="pm-actor pm-actor-adv pm-adv-comp">
          <rect x="835" y="285" width="90" height="48" rx="6" class="pm-adv-bg"/>
          <g transform="translate(880, 309)">
            <circle cx="0" cy="0" r="11" fill="none" class="pm-clock-face"/>
            <line x1="0" y1="0" x2="0" y2="-8" class="pm-clock-min"/>
            <line x1="0" y1="0" x2="5.5" y2="0" class="pm-clock-hr"/>
            <circle cx="0" cy="0" r="1.5" class="pm-clock-center"/>
          </g>
          <text x="880" y="348" text-anchor="middle" class="pm-adv-label">Adversary</text>
        </g>
        <transition name="pm-pop">
          <g v-if="compActive" class="pm-adv-fail">
            <text x="935" y="315" class="pm-adv-cross-text">→ ✗ negl(λ)</text>
          </g>
        </transition>

        <!-- Property tag -->
        <g class="pm-tags">
          <rect x="815" y="365" width="330" height="28" rx="5" class="pm-tag-bg pm-tag-prop"/>
          <text x="980" y="384" text-anchor="middle" class="pm-tag-text">Pr[break] ≤ negl(λ)  ⇐  hardness 仮定下</text>
        </g>

        <!-- "今ここ" badge (phase 4) — moved outside panel bottom -->
        <transition name="pm-pop">
          <g v-if="bridgePhase" class="pm-here-badge">
            <rect x="826" y="402" width="308" height="26" rx="5" class="pm-here-bg"/>
            <text x="980" y="421" text-anchor="middle" class="pm-here-text">★ 2026 社会実装はすべてここ</text>
          </g>
        </transition>
      </g>

      <!-- ===== Particles (when respective panel active) ===== -->
      <g v-if="infoActive" class="pm-particle-g">
        <circle cx="525" cy="186" r="6" class="pm-particle pm-particle-info"/>
        <circle cx="525" cy="186" r="6" class="pm-particle pm-particle-info" style="animation-delay: -1.2s"/>
      </g>
      <g v-if="compActive" class="pm-particle-g">
        <circle cx="905" cy="186" r="6" class="pm-particle pm-particle-comp"/>
        <circle cx="905" cy="186" r="6" class="pm-particle pm-particle-comp" style="animation-delay: -1.2s"/>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.pm-root {
  position: relative;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 8px;
  font-family: 'Noto Sans JP', sans-serif;
  color: #111827;
}

/* ===== Code strip ===== */
.pm-config {
  padding: 10px 16px;
  background: #eef2ff;
  border: 1px solid #c7d2fe;
  border-radius: 0.5rem;
  min-height: 44px;
  display: flex;
  align-items: center;
}
.pm-cfg-code {
  font-family: 'JetBrains Mono', monospace;
  font-size: 17px;
  font-weight: 600;
  color: #1e1b4b;
}

/* ===== SVG ===== */
.pm-svg {
  width: 100%;
  height: auto;
  display: block;
  font-family: 'Noto Sans JP', sans-serif;
}

/* ===== Panel base ===== */
.pm-panel { transition: opacity 0.5s; }
.pm-panel.is-dim    { opacity: 0.52; }
.pm-panel.is-active { opacity: 1; }
.pm-panel-bg {
  fill: #fafafa;
  stroke: #e5e7eb;
  stroke-width: 2;
  transition: fill 0.5s, stroke 0.5s, stroke-width 0.5s, filter 0.5s;
}
.pm-panel-math.is-active .pm-panel-bg {
  stroke: #7c3aed; stroke-width: 3; fill: #faf5ff;
  filter: drop-shadow(0 0 10px rgba(124, 58, 237, 0.4));
}
.pm-panel-info.is-active .pm-panel-bg {
  stroke: #0d9488; stroke-width: 3; fill: #f0fdfa;
  filter: drop-shadow(0 0 10px rgba(13, 148, 136, 0.4));
}
.pm-panel-comp.is-active .pm-panel-bg {
  stroke: #d97706; stroke-width: 3; fill: #fffbeb;
  filter: drop-shadow(0 0 10px rgba(217, 119, 6, 0.4));
}
.pm-panel-comp.is-bridge .pm-panel-bg {
  stroke: #b45309; stroke-width: 4; fill: #fef3c7;
  filter: drop-shadow(0 0 18px rgba(180, 83, 9, 0.55));
}

/* panel headers */
.pm-panel-num {
  font-size: 32px;
  font-weight: 900;
  fill: #94a3b8;
  font-family: 'BIZ UDPMincho', serif;
  transition: fill 0.5s;
}
.pm-panel-math.is-active .pm-panel-num { fill: #7c3aed; }
.pm-panel-info.is-active .pm-panel-num { fill: #0d9488; }
.pm-panel-comp.is-active .pm-panel-num { fill: #d97706; }
.pm-panel-title {
  font-size: 20px;
  font-weight: 700;
  fill: #1f2937;
  font-family: 'BIZ UDPMincho', serif;
}
.pm-panel-subtitle {
  font-size: 13px;
  font-weight: 600;
  fill: #64748b;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.05em;
}

/* ===== Math panel: proof chain ===== */
.pm-math-bg {
  fill: white;
  stroke: #cbd5e1;
  stroke-width: 1.5;
  transition: stroke 0.4s, fill 0.4s, filter 0.4s;
}
.pm-math-label-l {
  font-size: 15px;
  font-weight: 700;
  fill: #1f2937;
  font-family: 'BIZ UDPMincho', serif;
}
.pm-math-sublabel {
  font-size: 11px;
  font-weight: 600;
  fill: #64748b;
  font-family: 'JetBrains Mono', monospace;
}
.pm-math-arrow {
  stroke: #cbd5e1;
  stroke-width: 2;
  transition: stroke 0.4s, stroke-width 0.4s;
}
.pm-math-note-text {
  font-size: 13px;
  font-weight: 600;
  fill: #94a3b8;
  font-family: 'BIZ UDPMincho', serif;
  transition: fill 0.4s;
}
.pm-panel-math.is-active .pm-math-bg {
  stroke: #a78bfa;
  fill: #f5f3ff;
}
.pm-panel-math.is-active .pm-math-theorem .pm-math-bg {
  stroke: #7c3aed;
  stroke-width: 2.5;
  fill: #ede9fe;
  filter: drop-shadow(0 0 8px rgba(124, 58, 237, 0.55));
  animation: pm-glow-pulse 2s ease-in-out infinite;
}
.pm-panel-math.is-active .pm-math-arrow {
  stroke: #7c3aed;
  stroke-width: 2.5;
  stroke-dasharray: 5 3;
  animation: pm-flow-line 1.5s linear infinite;
}
.pm-panel-math.is-active .pm-math-note-text { fill: #7c3aed; }
@keyframes pm-flow-line { to { stroke-dashoffset: -16; } }
@keyframes pm-glow-pulse {
  0%, 100% { filter: drop-shadow(0 0 6px rgba(124, 58, 237, 0.5)); }
  50%      { filter: drop-shadow(0 0 14px rgba(124, 58, 237, 0.85)); }
}

/* ===== Actor (Prover / Verifier) ===== */
.pm-actor-bg {
  fill: white;
  stroke: #cbd5e1;
  stroke-width: 1.5;
  transition: stroke 0.4s, fill 0.4s;
}
.pm-actor-icon  { fill: #64748b; transition: fill 0.4s; }
.pm-actor-shield{ fill: #64748b; transition: fill 0.4s; }
.pm-actor-check { stroke: white; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
.pm-actor-label {
  font-size: 14px;
  font-weight: 700;
  fill: #1f2937;
  font-family: 'BIZ UDPMincho', serif;
}
.pm-wire {
  stroke: #cbd5e1;
  stroke-width: 2;
  transition: stroke 0.4s, stroke-width 0.4s;
}
.pm-wire-label {
  font-size: 12px;
  font-weight: 700;
  fill: #64748b;
  font-family: 'JetBrains Mono', monospace;
  transition: fill 0.4s;
}
/* Assumption badge (above actors) — green for info-th (no assumption), amber for comp (hardness) */
.pm-assume-bg {
  fill: white;
  stroke: #cbd5e1;
  stroke-width: 1;
  transition: fill 0.4s, stroke 0.4s, filter 0.4s;
}
.pm-assume-text {
  font-size: 12px;
  font-weight: 700;
  fill: #475569;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.02em;
  transition: fill 0.4s;
}

/* proof hex (standalone, between assumption badge and actors) */
.pm-proof-hex {
  font-size: 12px;
  font-weight: 700;
  fill: #64748b;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.04em;
  transition: fill 0.4s;
}
.pm-panel-info.is-active .pm-proof-hex { fill: #0f766e; }
.pm-panel-comp.is-active .pm-proof-hex { fill: #b45309; }
.pm-assume-none .pm-assume-bg {
  fill: #ecfdf5;
  stroke: #059669;
  filter: drop-shadow(0 0 5px rgba(5, 150, 105, 0.45));
}
.pm-assume-none .pm-assume-text { fill: #047857; }
.pm-assume-hard .pm-assume-bg {
  fill: #fef2f2;
  stroke: #dc2626;
  filter: drop-shadow(0 0 5px rgba(220, 38, 38, 0.4));
}
.pm-assume-hard .pm-assume-text { fill: #991b1b; }

/* Verify-logic box (specific check formula, single-line) */
.pm-verify-bg {
  fill: white;
  stroke: #cbd5e1;
  stroke-width: 1.5;
  transition: stroke 0.4s, fill 0.4s, filter 0.4s;
}
.pm-verify-text {
  font-size: 13px;
  font-weight: 800;
  fill: #1f2937;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.02em;
}
.pm-panel-info.is-active .pm-verify-bg {
  stroke: #0d9488;
  fill: #f0fdfa;
  filter: drop-shadow(0 0 5px rgba(13, 148, 136, 0.35));
}
.pm-panel-comp.is-active .pm-verify-bg {
  stroke: #d97706;
  fill: #fffbeb;
  filter: drop-shadow(0 0 5px rgba(217, 119, 6, 0.35));
}

/* OK chip on Verifier (small green check) */
.pm-ok-circle {
  fill: #059669;
  stroke: #047857;
  stroke-width: 1.5;
  filter: drop-shadow(0 0 5px rgba(5, 150, 105, 0.6));
}
.pm-ok-check {
  stroke: white;
  stroke-width: 2.4;
  stroke-linecap: round;
  stroke-linejoin: round;
}
.pm-panel-info.is-active .pm-actor-bg  { stroke: #0d9488; fill: #f0fdfa; }
.pm-panel-info.is-active .pm-wire       { stroke: #0d9488; stroke-width: 2.5; }
.pm-panel-info.is-active .pm-actor-icon,
.pm-panel-info.is-active .pm-actor-shield { fill: #0d9488; }
.pm-panel-info.is-active .pm-wire-label { fill: #0f766e; }
.pm-panel-comp.is-active .pm-actor-bg  { stroke: #d97706; fill: #fffbeb; }
.pm-panel-comp.is-active .pm-wire       { stroke: #d97706; stroke-width: 2.5; }
.pm-panel-comp.is-active .pm-actor-icon,
.pm-panel-comp.is-active .pm-actor-shield { fill: #d97706; }
.pm-panel-comp.is-active .pm-wire-label { fill: #b45309; }

/* ===== Adversary ===== */
.pm-adv-bg {
  fill: #1f2937;
  stroke: #4b5563;
  stroke-width: 1.5;
  transition: fill 0.4s, stroke 0.4s, stroke-width 0.4s;
}
.pm-adv-inf {
  font-size: 26px;
  font-weight: 900;
  fill: #f87171;
  font-family: 'JetBrains Mono', monospace;
}
.pm-adv-label {
  font-size: 12px;
  font-weight: 700;
  fill: #475569;
  font-family: 'BIZ UDPMincho', serif;
}
.pm-panel-info.is-active .pm-adv-bg,
.pm-panel-comp.is-active .pm-adv-bg {
  stroke: #dc2626;
  stroke-width: 2.5;
}
.pm-panel-info.is-active .pm-adv-inf {
  animation: pm-pulse 1.4s ease-in-out infinite;
  transform-origin: center;
}

/* clock for computational adversary */
.pm-clock-face   { stroke: #f87171; stroke-width: 1.8; transition: stroke 0.4s; }
.pm-clock-center { fill: #f87171; transition: fill 0.4s; }
.pm-clock-min    { stroke: #f87171; stroke-width: 1.8; stroke-linecap: round;
                   transform-origin: 0 0; transition: stroke 0.4s; }
.pm-clock-hr     { stroke: #f87171; stroke-width: 1.8; stroke-linecap: round;
                   transform-origin: 0 0; transition: stroke 0.4s; }
.pm-panel-comp.is-active .pm-clock-min { animation: pm-clock-tick 2.4s linear infinite; }
.pm-panel-comp.is-active .pm-clock-hr  { animation: pm-clock-tick 12s linear infinite; }
@keyframes pm-clock-tick { to { transform: rotate(360deg); } }
@keyframes pm-pulse {
  0%, 100% { transform: scale(1); }
  50%      { transform: scale(1.18); }
}

/* ✗ result text next to adversary */
.pm-adv-cross-text {
  font-size: 13px;
  font-weight: 800;
  fill: #dc2626;
  font-family: 'JetBrains Mono', monospace;
  filter: drop-shadow(0 0 4px rgba(220, 38, 38, 0.5));
  animation: pm-blink 1.4s ease-in-out infinite;
}
@keyframes pm-blink {
  0%, 100% { opacity: 1; }
  50%      { opacity: 0.4; }
}

/* ===== Tags ===== */
.pm-tag-bg {
  fill: white;
  stroke: #cbd5e1;
  stroke-width: 1;
  transition: stroke 0.4s, fill 0.4s;
}
.pm-tag-text {
  font-size: 13px;
  font-weight: 700;
  fill: #1f2937;
  font-family: 'JetBrains Mono', monospace;
}
.pm-tag-example-text {
  font-size: 13px;
  font-weight: 600;
  fill: #64748b;
  font-family: 'BIZ UDPMincho', serif;
}
.pm-panel-math.is-active .pm-tag-prop { stroke: #7c3aed; fill: #f5f3ff; }
.pm-panel-info.is-active .pm-tag-prop { stroke: #0d9488; fill: #f0fdfa; }
.pm-panel-comp.is-active .pm-tag-prop { stroke: #d97706; fill: #fffbeb; }

/* ===== Particles ===== */
.pm-particle-info {
  fill: #0d9488;
  filter: drop-shadow(0 0 6px rgba(13, 148, 136, 0.8));
  animation: pm-fly 2s linear infinite;
}
.pm-particle-comp {
  fill: #d97706;
  filter: drop-shadow(0 0 6px rgba(217, 119, 6, 0.8));
  animation: pm-fly 2s linear infinite;
}
@keyframes pm-fly {
  0%   { transform: translateX(0); opacity: 0; }
  10%  { opacity: 1; }
  90%  { opacity: 1; }
  100% { transform: translateX(150px); opacity: 0; }
}

/* ===== "今ここ" badge ===== */
.pm-here-bg {
  fill: #fbbf24;
  stroke: #92400e;
  stroke-width: 2;
  filter: drop-shadow(0 0 10px rgba(146, 64, 14, 0.55));
}
.pm-here-text {
  font-size: 17px;
  font-weight: 900;
  fill: #7c2d12;
  font-family: 'BIZ UDPMincho', serif;
  letter-spacing: 0.04em;
}

/* ===== transitions ===== */
.pm-fade-enter-active, .pm-fade-leave-active {
  transition: opacity 0.4s ease, transform 0.4s ease;
}
.pm-fade-enter-from, .pm-fade-leave-to {
  opacity: 0; transform: translateY(-4px);
}
.pm-pop-enter-active {
  transition: transform 0.45s cubic-bezier(0.34, 1.56, 0.64, 1), opacity 0.3s;
}
.pm-pop-leave-active {
  transition: transform 0.25s ease, opacity 0.25s;
}
.pm-pop-enter-from { opacity: 0; transform: scale(0.5); }
.pm-pop-leave-to   { opacity: 0; transform: scale(0.5); }

.pm-marker { fill: #cbd5e1; }
</style>
