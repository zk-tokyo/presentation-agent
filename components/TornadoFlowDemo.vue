<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from 'vue'

const totalPhases = 4

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
const phaseDurations = [4500, 4000, 4500, 5000]
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
  { code: '① deposit: send(1 ETH, C = H(k, r))', note: '秘密 note (k, r) は手元に保存・チェーンに出るのは commitment C だけ' },
  { code: '② anonymity set が育つ: { C₁ … C … Cₙ }', note: '同じ固定額の預入が 1 本の Merkle tree に集まり、どれが誰の C か埋もれる' },
  { code: '③ withdraw: π ← Prove{ ∃ leaf C ∈ tree ∧ nullifierHash = H(r) }', note: 'どの葉かは伏せたまま・無関係な新アドレス A′ から提出（ガスは relayer）' },
  { code: '④ payout: verify(π) ∧ nullifierHash 未使用 → 1 ETH → A′', note: '預入 A と引出 A′ のオンチェーン・リンクは切れる／同じ note の二重引出も不可' },
]

// leaves of the commitment tree; index 1 is the depositor's own C
const leaves = [
  { x: 468, label: 'C₁' },
  { x: 556, label: 'C' },
  { x: 644, label: 'C₃' },
  { x: 732, label: 'C₄' },
]
</script>

<template>
  <div class="tf-root">
    <div class="tf-cap">
      <transition name="tf-fade" mode="out-in">
        <div :key="phase" class="tf-cap-inner">
          <code class="tf-code">{{ captions[phase].code }}</code>
          <div class="tf-note">{{ captions[phase].note }}</div>
        </div>
      </transition>
    </div>

    <svg class="tf-svg" viewBox="0 0 1200 430" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="tf-ar" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#94a3b8"/>
        </marker>
      </defs>

      <!-- ===== depositor (left) ===== -->
      <g class="tf-actor" :class="{ 'is-cur': phase === 0 }">
        <rect x="46" y="100" width="176" height="104" rx="10" class="tf-card tf-blue"/>
        <g transform="translate(134,132)">
          <circle cx="0" cy="-8" r="9" fill="#1d4ed8"/>
          <path d="M -13,7 Q 0,2 13,7 L 12,21 L -12,21 Z" fill="#1d4ed8"/>
        </g>
        <text x="134" y="172" class="tf-title" text-anchor="middle">User A</text>
        <text x="134" y="192" class="tf-sub" text-anchor="middle">預入アドレス（公開）</text>
      </g>

      <!-- private note (k, r) kept locally -->
      <g class="tf-note-card" :class="{ 'is-hot': phase === 0 || phase === 2 }">
        <rect x="58" y="228" width="152" height="52" rx="9" class="tf-note-bg"/>
        <g transform="translate(84,254)">
          <rect x="-11" y="-2" width="22" height="16" rx="2.5" fill="#fffbeb" stroke="#d97706" stroke-width="2"/>
          <path d="M -6,-2 v -4 a 6 6 0 0 1 12 0 v 4" fill="none" stroke="#d97706" stroke-width="2.2"/>
        </g>
        <text x="145" y="250" class="tf-note-t" text-anchor="middle">note (k, r)</text>
        <text x="145" y="269" class="tf-note-s" text-anchor="middle">手元だけ・秘密</text>
      </g>

      <!-- deposit lane: A -> pool -->
      <line x1="228" y1="140" x2="388" y2="140" class="tf-edge" :class="{ 'is-on': phase >= 0 }" marker-end="url(#tf-ar)"/>
      <text x="308" y="128" class="tf-lane" text-anchor="middle" :class="{ 'is-on': phase === 0 }">1 ETH + C</text>
      <circle v-if="phase === 0" r="6" class="tf-p tf-green">
        <animateMotion dur="1.7s" repeatCount="indefinite" path="M 228,140 L 388,140"/>
      </circle>

      <!-- ===== Tornado pool (center) ===== -->
      <rect x="392" y="70" width="416" height="300" rx="14" class="tf-pool"/>
      <text x="600" y="100" class="tf-pool-t" text-anchor="middle">Tornado Cash プール</text>
      <text x="600" y="120" class="tf-pool-s" text-anchor="middle">固定額 1 ETH の commitments の Merkle tree</text>

      <!-- merkle tree -->
      <g class="tf-tree">
        <circle cx="600" cy="168" r="15" class="tf-root-node"/>
        <text x="600" y="173" class="tf-root-t" text-anchor="middle">root</text>
        <line x1="589" y1="177" x2="533" y2="214" class="tf-branch"/>
        <line x1="611" y1="177" x2="667" y2="214" class="tf-branch"/>
        <line x1="527" y1="224" x2="490" y2="286" class="tf-branch"/>
        <line x1="539" y1="224" x2="578" y2="286" class="tf-branch"/>
        <line x1="661" y1="224" x2="622" y2="286" class="tf-branch"/>
        <line x1="673" y1="224" x2="710" y2="286" class="tf-branch"/>
        <circle cx="528" cy="220" r="12" class="tf-inode"/>
        <circle cx="672" cy="220" r="12" class="tf-inode"/>

        <!-- leaves; the depositor's own C (index 1) is spotlighted only at phase 0 -->
        <g v-for="(lf, i) in leaves" :key="'lf'+i"
           class="tf-leaf"
           :class="{
             'is-mine': i === 1,
             'spot': i === 1 && phase === 0,
             'grown': i !== 1 && phase >= 1
           }">
          <rect :x="lf.x - 22" y="286" width="44" height="30" rx="6" class="tf-leaf-bg"/>
          <text :x="lf.x" y="306" class="tf-leaf-t" text-anchor="middle">{{ lf.label }}</text>
        </g>
      </g>

      <!-- hidden-leaf question at withdraw -->
      <g v-if="phase >= 2" class="tf-hide">
        <circle cx="600" cy="352" r="15" class="tf-hide-bg"/>
        <text x="600" y="358" class="tf-hide-t" text-anchor="middle">?</text>
      </g>

      <!-- ===== fresh address A' (right) ===== -->
      <g class="tf-fresh-g" :class="{ 'show': phase >= 2, 'is-paid': phase === 3 }">
        <rect x="978" y="100" width="176" height="104" rx="10" class="tf-card tf-fresh"
              :class="{ 'paid': phase === 3 }"/>
        <g transform="translate(1066,132)">
          <rect x="-13" y="-9" width="26" height="19" rx="3" :fill="phase===3 ? '#047857' : '#334155'"/>
          <circle cx="7" cy="1.5" r="3" fill="#fff"/>
        </g>
        <text x="1066" y="172" class="tf-title" text-anchor="middle">新アドレス A′</text>
        <text x="1066" y="192" class="tf-sub" text-anchor="middle">引出アドレス（公開）</text>
      </g>

      <!-- withdraw lanes between pool and A' -->
      <!-- proof submission: A' -> pool (phase 2) -->
      <line x1="972" y1="158" x2="810" y2="158" class="tf-edge" :class="{ 'is-on': phase >= 2 }" marker-end="url(#tf-ar)"/>
      <text x="891" y="148" class="tf-lane tf-purple-t" text-anchor="middle" :class="{ 'is-on': phase === 2 }">π (proof)</text>
      <circle v-if="phase === 2" r="6" class="tf-p tf-purple">
        <animateMotion dur="1.5s" repeatCount="indefinite" path="M 972,158 L 810,158"/>
      </circle>
      <!-- payout: pool -> A' (phase 3) -->
      <line x1="810" y1="200" x2="972" y2="200" class="tf-edge" :class="{ 'is-on': phase >= 3 }" marker-end="url(#tf-ar)"/>
      <text x="891" y="222" class="tf-lane tf-green-t" text-anchor="middle" :class="{ 'is-on': phase === 3 }">1 ETH</text>
      <circle v-if="phase === 3" r="6" class="tf-p tf-green">
        <animateMotion dur="1.6s" repeatCount="indefinite" path="M 810,200 L 972,200"/>
      </circle>

      <!-- severed link between A and A' -->
      <g class="tf-link" :class="{ 'is-cut': phase === 3 }">
        <line x1="150" y1="405" x2="1082" y2="405" class="tf-link-line"/>
        <text x="600" y="398" class="tf-link-t" text-anchor="middle">
          {{ phase === 3 ? '✂ 預入 A と引出 A′ のリンクは切れている' : 'A ↔ A′ のリンクを暗号的に断ち切る' }}
        </text>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.tf-root { position: relative; width: 100%; display: flex; flex-direction: column; gap: 8px; font-family: 'Noto Sans JP', sans-serif; color: #111827; }
.tf-cap { padding: 10px 18px; background: #eef2ff; border: 1px solid #c7d2fe; border-radius: 0.75rem; min-height: 56px; display: flex; align-items: center; }
.tf-cap-inner { display: flex; flex-direction: column; gap: 3px; width: 100%; }
.tf-code { font-family: 'JetBrains Mono', monospace; font-size: 16px; color: #1e1b4b; font-weight: 800; }
.tf-note { font-size: 14px; color: #4338ca; font-weight: 600; }
.tf-svg { width: 100%; height: auto; display: block; }

.tf-card { fill: #fff; stroke: #cbd5e1; stroke-width: 2; }
.tf-blue { fill: #eff6ff; stroke: #bfdbfe; }
.tf-fresh { fill: #f8fafc; stroke: #cbd5e1; transition: stroke 0.5s, fill 0.5s; }
.tf-fresh.paid { fill: #ecfdf5; stroke: #10b981; }
.tf-fresh-g { opacity: 0.4; transition: opacity 0.5s, filter 0.4s; }
.tf-fresh-g.show { opacity: 1; }
.tf-fresh-g.is-paid { filter: drop-shadow(0 0 9px rgba(16,185,129,0.45)); }
.tf-actor { transition: filter 0.4s; }
.tf-actor.is-cur { filter: drop-shadow(0 0 7px rgba(37,99,235,0.35)); }
.tf-title { font-size: 19px; font-weight: 700; fill: #111827; font-family: 'BIZ UDPMincho', serif; }
.tf-sub { font-size: 14px; fill: #64748b; font-weight: 600; }
.tf-sub2 { font-size: 13px; fill: #94a3b8; }

.tf-note-card { transition: filter 0.4s; }
.tf-note-bg { fill: #fffbeb; stroke: #f59e0b; stroke-width: 2; }
.tf-note-card.is-hot { filter: drop-shadow(0 0 7px rgba(245,158,11,0.55)); }
.tf-note-t { font-size: 15px; font-weight: 800; fill: #b45309; font-family: 'JetBrains Mono', monospace; }
.tf-note-s { font-size: 12px; fill: #a16207; }

.tf-edge { stroke: #cbd5e1; stroke-width: 2.5; fill: none; opacity: 0.35; transition: opacity 0.5s, stroke 0.4s; }
.tf-edge.is-on { opacity: 1; stroke: #94a3b8; }
.tf-lane { font-size: 14px; font-weight: 700; fill: #94a3b8; letter-spacing: 0.03em; font-family: 'JetBrains Mono', monospace; opacity: 0.5; transition: opacity 0.4s, fill 0.4s; }
.tf-lane.is-on { opacity: 1; }
.tf-green-t.is-on { fill: #059669; }
.tf-purple-t.is-on { fill: #7c3aed; }
.tf-p { filter: drop-shadow(0 0 5px rgba(0,0,0,0.25)); }
.tf-green { fill: #10b981; filter: drop-shadow(0 0 5px rgba(16,185,129,0.8)); }
.tf-purple { fill: #8b5cf6; filter: drop-shadow(0 0 5px rgba(139,92,246,0.8)); }

.tf-pool { fill: rgba(245,158,11,0.05); stroke: #fcd34d; stroke-width: 2; stroke-dasharray: 7 4; }
.tf-pool-t { font-size: 18px; font-weight: 800; fill: #b45309; font-family: 'BIZ UDPMincho', serif; }
.tf-pool-s { font-size: 13px; fill: #a16207; }
.tf-root-node { fill: #f59e0b; stroke: #b45309; stroke-width: 2; }
.tf-root-t { font-size: 12px; font-weight: 800; fill: #fff; font-family: 'JetBrains Mono', monospace; }
.tf-inode { fill: #fde68a; stroke: #d97706; stroke-width: 1.5; }
.tf-branch { stroke: #d97706; stroke-width: 1.5; opacity: 0.7; }

.tf-leaf-bg { fill: #fff; stroke: #d97706; stroke-width: 1.5; transition: fill 0.5s, stroke 0.5s, opacity 0.5s; }
.tf-leaf-t { font-size: 13px; font-weight: 700; fill: #92400e; font-family: 'JetBrains Mono', monospace; }
/* siblings fade in as the anonymity set grows */
.tf-leaf.grown .tf-leaf-bg { opacity: 1; }
.tf-leaf:not(.is-mine) .tf-leaf-bg { opacity: 0.25; }
.tf-leaf:not(.is-mine).grown .tf-leaf-bg { opacity: 1; }
/* depositor's own C: spotlighted at deposit, then blends into the set */
.tf-leaf.spot .tf-leaf-bg { fill: #fee2e2; stroke: #dc2626; stroke-width: 2.5; filter: drop-shadow(0 0 6px rgba(220,38,38,0.5)); }
.tf-leaf.spot .tf-leaf-t { fill: #991b1b; font-weight: 900; }

.tf-hide-bg { fill: #ede9fe; stroke: #7c3aed; stroke-width: 2; }
.tf-hide-t { font-size: 18px; font-weight: 900; fill: #6d28d9; font-family: 'JetBrains Mono', monospace; }

.tf-link { transition: opacity 0.4s; }
.tf-link-line { stroke: #cbd5e1; stroke-width: 2; stroke-dasharray: 8 6; transition: stroke 0.5s; }
.tf-link.is-cut .tf-link-line { stroke: #dc2626; }
.tf-link-t { font-size: 15px; font-weight: 700; fill: #64748b; font-family: 'BIZ UDPMincho', serif; transition: fill 0.5s; }
.tf-link.is-cut .tf-link-t { fill: #dc2626; }

.tf-fade-enter-active, .tf-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.tf-fade-enter-from { opacity: 0; transform: translateY(4px); }
.tf-fade-leave-to { opacity: 0; transform: translateY(-4px); }
</style>
