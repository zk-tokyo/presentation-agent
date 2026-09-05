<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount, computed } from 'vue'

// Cycling climax — each line ties one column's anxiety to PC's answer
const climaxes = [
  '監査済みコードでも防げない時代 — 攻撃面が「運用」に移った',
  'data 層が解けたら、次のボトルネックは証明者の cost',
  '機関マネーは「全公開」で取引できず、「全秘密」では監査できない',
]
const climaxIdx = ref(0)
let climaxTimer: ReturnType<typeof setInterval> | null = null

onMounted(() => {
  climaxTimer = setInterval(() => {
    climaxIdx.value = (climaxIdx.value + 1) % climaxes.length
  }, 4200)
})
onBeforeUnmount(() => {
  if (climaxTimer) clearInterval(climaxTimer)
})

const currentClimax = computed(() => climaxes[climaxIdx.value])

// Static content (always visible — parallel layout)
// Each column = 共感 (trend) → 不安 (evidence + stat) → 期待 (answer + techs)
const columns = [
  {
    n: '①',
    cat: 'AI × システム運用検証',
    color: 'p',
    trend1: '監査済みコードは無傷でも、',
    trend2: '攻撃面は「運用」に移行している',
    ev1: 'Bybit $1.5B (2025/2) — Safe コードは無傷、',
    ev1b: 'UI が偽装 (Safe 開発者の AWS セッション奪取)',
    ev2: 'Lazarus 2025: $2B+ 盗難',
    ev2b: '(DPRK = service compromise の 76%)',
    ev3: 'DeFi 監査は成熟、攻撃面は UI / Custody / Off-chain ops',
    stat: '$3.4B',
    statLabel: '2025 クリプト総流出',
    statSrc: 'Chainalysis 2025 報告',
    answer: '「運用そのもの」を暗号的に検証',
    techs: ['Proof-of-Exploit', 'verifiable exec', 'zkML'],
  },
  {
    n: '②',
    cat: 'Ethereum scaling × ZK rollup 競争',
    color: 'g',
    trend1: 'Pectra (2025/5) → Fusaka (2025/12) で',
    trend2: 'data 層が解け、競争軸は証明者に移動',
    ev1: 'Fusaka PeerDAS で validator DL 85% 削減',
    ev1b: '(1 日 750 MB → 112 MB)',
    ev2: 'L2 fee 下落予想 −40〜60% (post-Fusaka)',
    ev2b: '次のボトルネック = 証明者 throughput',
    ev3: 'Linea / Scroll / Polygon / Taiko が証明者の速度競争',
    stat: '−50%',
    statLabel: 'L2 fee 下落予想 (Fusaka 後)',
    statSrc: 'Crypto.com Research / Fidelity 2026',
    answer: 'proving cost 圧縮 = L2 競争の支配項',
    techs: ['Sumcheck', 'Jolt', 'folding/IVC'],
  },
  {
    n: '③',
    cat: '機関マネー × 規制プライバシー',
    color: 'a',
    trend1: '$320B Stablecoin + $32B RWA',
    trend2: '機関マネーが本格的に on-chain 化',
    ev1: 'USDT $190B + USDC $78B (2026/4)',
    ev1b: 'Stripe / Visa / Mastercard / PayPal が決済統合',
    ev2: 'BlackRock BUIDL $2.4B / RWA +200% YoY',
    ev2b: '(Ondo, Franklin, Apollo, KKR が tokenize)',
    ev3: 'GENIUS Act 2026/7/18 施行 — 1:1 担保 + 月次監査',
    stat: '$320B',
    statLabel: 'Stablecoin 流通 (2026/4)',
    statSrc: 'Bitrue / Cointelegraph 2026',
    answer: '「全公開 ⇔ 全秘密」を超える規制プライバシー',
    techs: ['Privacy Pools', 'Longfellow', 'zk-KYC'],
  },
]
</script>

<template>
  <div class="hd-root">
    <!-- ===== Main SVG (3 parallel columns + convergence) ===== -->
    <svg class="hd-svg" viewBox="0 0 1200 520" preserveAspectRatio="xMidYMid meet">
      <defs>
        <radialGradient id="hd-pc-glow" cx="0.5" cy="0.5" r="0.5">
          <stop offset="0%"   stop-color="#fbbf24" stop-opacity="0.9"/>
          <stop offset="60%"  stop-color="#f59e0b" stop-opacity="0.45"/>
          <stop offset="100%" stop-color="#f59e0b" stop-opacity="0"/>
        </radialGradient>
        <filter id="hd-pc-blur" x="-50%" y="-50%" width="200%" height="200%">
          <feGaussianBlur stdDeviation="4"/>
        </filter>
        <marker id="hd-d3-arrow" viewBox="0 0 10 10" refX="6" refY="5" markerWidth="5" markerHeight="5" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#7c3aed"/>
        </marker>
      </defs>

      <!-- ===== Convergence rays (column bottom → PC) ===== -->
      <g class="hd-rays">
        <line x1="205" y1="370" x2="600" y2="425" class="hd-ray hd-ray-p"/>
        <line x1="595" y1="370" x2="600" y2="425" class="hd-ray hd-ray-g"/>
        <line x1="985" y1="370" x2="600" y2="425" class="hd-ray hd-ray-a"/>
      </g>

      <!-- ===== Particles flowing column → PC ===== -->
      <g class="hd-particles">
        <circle cx="205" cy="370" r="4" class="hd-particle hd-particle-p"/>
        <circle cx="205" cy="370" r="4" class="hd-particle hd-particle-p" style="animation-delay: -1.2s"/>
        <circle cx="595" cy="370" r="4" class="hd-particle hd-particle-g"/>
        <circle cx="595" cy="370" r="4" class="hd-particle hd-particle-g" style="animation-delay: -1.5s"/>
        <circle cx="985" cy="370" r="4" class="hd-particle hd-particle-a"/>
        <circle cx="985" cy="370" r="4" class="hd-particle hd-particle-a" style="animation-delay: -0.9s"/>
      </g>

      <!-- ===== 3 parallel columns ===== -->
      <g v-for="(c, i) in columns" :key="c.n"
         class="hd-col" :class="`hd-col-${c.color}`"
         :transform="`translate(${20 + i * 390}, 10)`">

        <!-- Column outline + header band -->
        <rect x="0" y="0" width="370" height="360" rx="12" class="hd-col-bg"/>
        <rect x="0" y="0" width="370" height="46" rx="12" class="hd-col-header"/>
        <!-- mask bottom corners of header so only top is rounded -->
        <rect x="0" y="24" width="370" height="22" class="hd-col-header"/>

        <!-- Header: number circle + category -->
        <circle cx="30" cy="23" r="14" class="hd-num-circle"/>
        <text x="30" y="30" text-anchor="middle" class="hd-num">{{ c.n }}</text>
        <text x="56" y="30" class="hd-cat">{{ c.cat }}</text>

        <!-- ===== Mini concept diagram (visualizing the problem) ===== -->
        <!-- Col 1: Attacker hits Builders, but ソースコード (audited) is safe — speech bubble asks operational integrity -->
        <g v-if="c.n === '①'" class="hd-mini">
          <!-- Speech bubble above builders (positioned high, below header) -->
          <g transform="translate(185, 85)" class="hd-d1-bubble">
            <rect x="-90" y="-18" width="180" height="38" rx="19" class="hd-d1-bubble-bg"/>
            <path d="M -10,16 L -4,32 L 8,18 Z" class="hd-d1-bubble-bg"/>
            <text x="0" y="-3" text-anchor="middle" class="hd-d1-bubble-t1">「運用」が正しいことを</text>
            <text x="0" y="12" text-anchor="middle" class="hd-d1-bubble-t2">どう証明する？</text>
          </g>

          <!-- Tinted backgrounds for each actor group (positioned below bubble) -->
          <rect x="10" y="145" width="100" height="190" rx="10" class="hd-d1-bg-atk"/>
          <rect x="130" y="145" width="110" height="190" rx="10" class="hd-d1-bg-builders"/>
          <rect x="260" y="145" width="100" height="190" rx="10" class="hd-d1-bg-sc"/>

          <!-- ATTACKER (left) -->
          <g transform="translate(60, 240)" class="hd-d1-attacker">
            <!-- hood/cape -->
            <path d="M -22,-30 Q 0,-44 22,-30 L 18,-4 L -18,-4 Z" fill="#1f2937"/>
            <!-- face shadow -->
            <ellipse cx="0" cy="-18" rx="13" ry="16" fill="#0f172a"/>
            <!-- glowing red eyes -->
            <circle cx="-5" cy="-20" r="2.5" fill="#dc2626" class="hd-d1-eye"/>
            <circle cx="5" cy="-20" r="2.5" fill="#dc2626" class="hd-d1-eye"/>
            <!-- evil grin -->
            <path d="M -4,-12 L 0,-10 L 4,-12" stroke="#dc2626" stroke-width="1.2" fill="none"/>
            <!-- body/torso -->
            <path d="M -18,-4 L 18,-4 L 16,28 L -16,28 Z" fill="#1f2937"/>
            <!-- arms -->
            <line x1="-15" y1="2" x2="-22" y2="20" stroke="#1f2937" stroke-width="5" stroke-linecap="round"/>
            <line x1="15" y1="2" x2="22" y2="20" stroke="#1f2937" stroke-width="5" stroke-linecap="round"/>
          </g>
          <text x="60" y="320" text-anchor="middle" class="hd-d1-actor-label">Attacker</text>

          <!-- Lightning bolt (attack arrow attacker → builders) -->
          <g class="hd-d1-attack">
            <path d="M 110,238 L 122,230 L 119,240 L 134,232 L 131,245 L 152,238"
                  stroke="#dc2626" stroke-width="4" fill="none"
                  stroke-linecap="round" stroke-linejoin="round"/>
            <polygon points="152,238 142,232 145,246" fill="#dc2626"/>
          </g>

          <!-- BUILDERS (center, 2 person icons) -->
          <g transform="translate(185, 240)" class="hd-d1-builders">
            <g v-for="(_, bi) in 2" :key="bi" :transform="`translate(${(bi - 0.5) * 36 - 18}, 0)`">
              <!-- hard hat -->
              <path d="M -10,-20 Q -10,-32 0,-32 Q 10,-32 10,-20 Z" fill="#f59e0b"/>
              <rect x="-12" y="-21" width="24" height="3.5" fill="#d97706"/>
              <!-- head -->
              <circle cx="0" cy="-13" r="6" fill="#fbbf24"/>
              <!-- body -->
              <path d="M -10,-6 L 10,-6 L 8,28 L -8,28 Z" fill="#475569"/>
              <!-- arms -->
              <line x1="-9" y1="0" x2="-15" y2="13" stroke="#475569" stroke-width="3.5" stroke-linecap="round"/>
              <line x1="9" y1="0" x2="15" y2="13" stroke="#475569" stroke-width="3.5" stroke-linecap="round"/>
            </g>
          </g>
          <text x="185" y="320" text-anchor="middle" class="hd-d1-actor-label">Builders / 運用</text>

          <!-- ソースコード (right) — document with code lines + green ✓ stamp -->
          <g transform="translate(310, 240)" class="hd-d1-sourcecode">
            <!-- Document with folded corner -->
            <path d="M -28,-36 L 18,-36 L 30,-24 L 30,32 L -28,32 Z"
                  fill="white" stroke="#10b981" stroke-width="2"/>
            <path d="M 18,-36 L 18,-24 L 30,-24" fill="white" stroke="#10b981" stroke-width="2"/>
            <!-- Code lines (varied widths to mimic code) -->
            <line x1="-22" y1="-22" x2="6" y2="-22" stroke="#059669" stroke-width="2"/>
            <line x1="-22" y1="-14" x2="14" y2="-14" stroke="#10b981" stroke-width="2"/>
            <line x1="-18" y1="-6" x2="0" y2="-6" stroke="#10b981" stroke-width="2"/>
            <line x1="-22" y1="2" x2="12" y2="2" stroke="#059669" stroke-width="2"/>
            <line x1="-18" y1="10" x2="6" y2="10" stroke="#10b981" stroke-width="2"/>
            <line x1="-22" y1="18" x2="-2" y2="18" stroke="#059669" stroke-width="2"/>
            <line x1="-22" y1="26" x2="10" y2="26" stroke="#10b981" stroke-width="2"/>
            <!-- ✓ stamp (green badge) -->
            <circle cx="22" cy="22" r="11" fill="#10b981" stroke="#065f46" stroke-width="2"/>
            <path d="M 17,22 L 21,26 L 27,18" stroke="white" stroke-width="2.5" fill="none"
                  stroke-linecap="round" stroke-linejoin="round"/>
          </g>
          <text x="310" y="320" text-anchor="middle" class="hd-d1-actor-label hd-d1-actor-label-ok">ソースコード ✓ 監査済</text>
        </g>

        <!-- Col 2: Consensus + Execution nodes BOTH dispatch prove requests to zkVM (bottleneck) -->
        <g v-else-if="c.n === '②'" class="hd-mini">
          <!-- 2 top nodes -->
          <!-- CONSENSUS NODE (top-left) -->
          <g transform="translate(85, 130)" class="hd-d2-node">
            <rect x="-36" y="-26" width="72" height="52" rx="26" fill="#dbeafe" stroke="#2563eb" stroke-width="2"/>
            <!-- validator dots (network) -->
            <circle cx="-22" cy="-12" r="3" fill="#2563eb"/>
            <circle cx="-8" cy="-15" r="3" fill="#2563eb"/>
            <circle cx="8" cy="-13" r="3" fill="#2563eb"/>
            <circle cx="22" cy="-12" r="3" fill="#2563eb"/>
            <circle cx="-16" cy="0" r="3" fill="#2563eb"/>
            <circle cx="0" cy="-2" r="3" fill="#2563eb"/>
            <circle cx="16" cy="0" r="3" fill="#2563eb"/>
            <circle cx="-22" cy="13" r="3" fill="#2563eb"/>
            <circle cx="-6" cy="14" r="3" fill="#2563eb"/>
            <circle cx="10" cy="13" r="3" fill="#2563eb"/>
            <circle cx="22" cy="14" r="3" fill="#2563eb"/>
            <!-- mesh lines -->
            <line x1="-22" y1="-12" x2="-8" y2="-15" stroke="#60a5fa" stroke-width="0.7"/>
            <line x1="-8" y1="-15" x2="8" y2="-13" stroke="#60a5fa" stroke-width="0.7"/>
            <line x1="8" y1="-13" x2="22" y2="-12" stroke="#60a5fa" stroke-width="0.7"/>
            <line x1="-16" y1="0" x2="0" y2="-2" stroke="#60a5fa" stroke-width="0.7"/>
            <line x1="0" y1="-2" x2="16" y2="0" stroke="#60a5fa" stroke-width="0.7"/>
            <line x1="-22" y1="13" x2="-6" y2="14" stroke="#60a5fa" stroke-width="0.7"/>
            <line x1="-6" y1="14" x2="10" y2="13" stroke="#60a5fa" stroke-width="0.7"/>
            <line x1="10" y1="13" x2="22" y2="14" stroke="#60a5fa" stroke-width="0.7"/>
          </g>
          <text x="85" y="190" text-anchor="middle" class="hd-d2-actor-label">Consensus Node</text>
          <text x="85" y="206" text-anchor="middle" class="hd-d2-actor-label-sub">(validators)</text>

          <!-- EXECUTION NODE (top-right) — server rack -->
          <g transform="translate(285, 130)" class="hd-d2-node">
            <rect x="-36" y="-26" width="72" height="52" rx="6" fill="#f1f5f9" stroke="#475569" stroke-width="2"/>
            <!-- server stack -->
            <rect x="-26" y="-19" width="52" height="9" rx="1.5" fill="#475569"/>
            <rect x="-26" y="-7" width="52" height="9" rx="1.5" fill="#475569"/>
            <rect x="-26" y="5" width="52" height="9" rx="1.5" fill="#475569"/>
            <!-- LEDs -->
            <circle cx="-20" cy="-14.5" r="1.6" fill="#10b981"/>
            <circle cx="-20" cy="-2.5" r="1.6" fill="#10b981"/>
            <circle cx="-20" cy="9.5" r="1.6" fill="#10b981"/>
            <!-- "EVM" label inside -->
            <text x="6" y="-12" text-anchor="middle" class="hd-d2-rack-text">EVM</text>
            <text x="6" y="0" text-anchor="middle" class="hd-d2-rack-text">OP</text>
            <text x="6" y="12" text-anchor="middle" class="hd-d2-rack-text">···</text>
          </g>
          <text x="285" y="190" text-anchor="middle" class="hd-d2-actor-label">Execution Node</text>
          <text x="285" y="206" text-anchor="middle" class="hd-d2-actor-label-sub">(EVM ops)</text>

          <!-- Arrows from BOTH top nodes down to zkVM (request flows) -->
          <line x1="100" y1="215" x2="170" y2="305" class="hd-d2-arrow-down hd-d2-wire-bottle"/>
          <polygon points="170,305 162,299 167,311" class="hd-d2-arrow-head"/>
          <line x1="270" y1="215" x2="200" y2="305" class="hd-d2-arrow-down hd-d2-wire-bottle"/>
          <polygon points="200,305 203,311 208,299" class="hd-d2-arrow-head"/>

          <!-- Arrow labels -->
          <text x="115" y="263" class="hd-d2-arrow-label">prove req</text>
          <text x="225" y="263" class="hd-d2-arrow-label">prove req</text>

          <!-- Particles flowing on arrows -->
          <circle r="3" cx="0" cy="0" class="hd-d2-data hd-d2-data-1"/>
          <circle r="3" cx="0" cy="0" class="hd-d2-data hd-d2-data-2"/>

          <!-- zkVM at bottom (bottleneck) — chip + queue + slow spinner -->
          <g transform="translate(185, 320)" class="hd-d2-node hd-d2-zkvm">
            <!-- chip body -->
            <rect x="-36" y="-18" width="72" height="36" rx="6" fill="#fef2f2" stroke="#dc2626" stroke-width="3"/>
            <!-- chip pins (left & right) -->
            <line x1="-36" y1="-10" x2="-42" y2="-10" stroke="#dc2626" stroke-width="2"/>
            <line x1="-36" y1="0" x2="-42" y2="0" stroke="#dc2626" stroke-width="2"/>
            <line x1="-36" y1="10" x2="-42" y2="10" stroke="#dc2626" stroke-width="2"/>
            <line x1="36" y1="-10" x2="42" y2="-10" stroke="#dc2626" stroke-width="2"/>
            <line x1="36" y1="0" x2="42" y2="0" stroke="#dc2626" stroke-width="2"/>
            <line x1="36" y1="10" x2="42" y2="10" stroke="#dc2626" stroke-width="2"/>
            <!-- zkVM label inside chip -->
            <text x="0" y="5" text-anchor="middle" class="hd-d2-zkvm-text">zkVM</text>
            <!-- Slow rotating ring (showing slow processing) -->
            <g class="hd-d2-zkvm-spinner">
              <circle cx="0" cy="0" r="32" fill="none" stroke="#dc2626" stroke-width="1.5"
                      stroke-dasharray="14 180" opacity="0.7"/>
            </g>
            <!-- Queue of pending requests on right side -->
            <g class="hd-d2-queue-blocks" transform="translate(46, 0)">
              <rect x="0" y="-8" width="8" height="16" rx="1.5" fill="#fee2e2" stroke="#dc2626" stroke-width="1"/>
              <rect x="11" y="-8" width="8" height="16" rx="1.5" fill="#fee2e2" stroke="#dc2626" stroke-width="1" opacity="0.7"/>
              <rect x="22" y="-8" width="8" height="16" rx="1.5" fill="#fee2e2" stroke="#dc2626" stroke-width="1" opacity="0.4"/>
            </g>
          </g>
          <text x="185" y="350" text-anchor="middle" class="hd-d2-actor-label hd-d2-actor-label-bad">⚠ ボトルネック</text>
        </g>

        <!-- Col 3: Institution → DeFi flow (main), with on-chain TX attachment showing privacy/compliance issues -->
        <g v-else class="hd-mini">
          <!-- TOP: Institution → $ flow → DeFi (the actual transaction happening) -->

          <!-- Institution (bank, left) -->
          <g transform="translate(60, 130)" class="hd-d3-institution">
            <!-- Roof triangle -->
            <path d="M -30,-18 L 0,-30 L 30,-18 Z" fill="#92400e"/>
            <rect x="-28" y="-18" width="56" height="4" fill="#78350f"/>
            <!-- Columns -->
            <rect x="-22" y="-14" width="7" height="26" fill="#d97706"/>
            <rect x="-8" y="-14" width="7" height="26" fill="#d97706"/>
            <rect x="2" y="-14" width="7" height="26" fill="#d97706"/>
            <rect x="15" y="-14" width="7" height="26" fill="#d97706"/>
            <!-- Floor -->
            <rect x="-30" y="12" width="60" height="5" fill="#78350f"/>
          </g>
          <text x="60" y="195" text-anchor="middle" class="hd-d3-actor-label">機関 (BlackRock 等)</text>

          <!-- $ flow institution → DeFi -->
          <line x1="100" y1="130" x2="270" y2="130" class="hd-d3-flow-wire"/>
          <text class="hd-d3-money hd-d3-money-mini" font-family="JetBrains Mono" font-weight="900" fill="#10b981">$</text>
          <text class="hd-d3-money hd-d3-money-mini hd-d3-money-2" font-family="JetBrains Mono" font-weight="900" fill="#10b981">$</text>

          <!-- DeFi protocol (right) -->
          <g transform="translate(310, 130)" class="hd-d3-defi">
            <!-- gear teeth (slow spin) -->
            <g class="hd-d3-gear-spin">
              <rect x="-3" y="-28" width="6" height="7" fill="#7c3aed"/>
              <rect x="-3" y="21" width="6" height="7" fill="#7c3aed"/>
              <rect x="-28" y="-3" width="7" height="6" fill="#7c3aed"/>
              <rect x="21" y="-3" width="7" height="6" fill="#7c3aed"/>
              <rect x="-20" y="-20" width="6" height="6" fill="#7c3aed" transform="rotate(45)"/>
              <rect x="14" y="-20" width="6" height="6" fill="#7c3aed" transform="rotate(45)"/>
              <rect x="-20" y="14" width="6" height="6" fill="#7c3aed" transform="rotate(45)"/>
              <rect x="14" y="14" width="6" height="6" fill="#7c3aed" transform="rotate(45)"/>
            </g>
            <circle cx="0" cy="0" r="22" fill="#faf5ff" stroke="#7c3aed" stroke-width="2.5"/>
            <path d="M -9,-7 A 11,11 0 0,1 9,-7" stroke="#7c3aed" stroke-width="2.2"
                  fill="none" marker-end="url(#hd-d3-arrow)"/>
            <path d="M 9,7 A 11,11 0 0,1 -9,7" stroke="#7c3aed" stroke-width="2.2"
                  fill="none" marker-end="url(#hd-d3-arrow)"/>
          </g>
          <text x="310" y="195" text-anchor="middle" class="hd-d3-actor-label">DeFi (Aave / Uniswap)</text>

          <!-- "↓ on-chain で記録" connector down to TX card -->
          <line x1="185" y1="205" x2="185" y2="232" class="hd-d3-onchain-line"/>
          <polygon points="185,235 180,225 190,225" class="hd-d3-onchain-head"/>
          <text x="200" y="220" class="hd-d3-onchain-label">on-chain</text>

          <!-- BOTTOM: on-chain TX card (showing the problematic fields) -->
          <foreignObject x="14" y="240" width="244" height="115">
            <div xmlns="http://www.w3.org/1999/xhtml" class="hd-d3-tx-card hd-d3-tx-card-compact">
              <div class="hd-d3-tx-header">
                <span class="hd-d3-tx-title">on-chain TX</span>
                <span class="hd-d3-tx-hash">tx#0x9f3a</span>
              </div>
              <div class="hd-d3-tx-body hd-d3-tx-body-compact">
                <div class="hd-d3-tx-row hd-d3-tx-row-bad">
                  <span class="hd-d3-tx-label">from:</span>
                  <span class="hd-d3-tx-bad">0xBlackRock…A1</span>
                </div>
                <div class="hd-d3-tx-row hd-d3-tx-row-bad">
                  <span class="hd-d3-tx-label">amount:</span>
                  <span class="hd-d3-tx-amount">$500M USDC</span>
                </div>
                <div class="hd-d3-tx-row hd-d3-tx-row-bad">
                  <span class="hd-d3-tx-label">KYC:</span>
                  <span class="hd-d3-tx-bad">∅ (none)</span>
                </div>
              </div>
            </div>
          </foreignObject>

          <!-- Worry bubbles on right side -->
          <foreignObject x="262" y="248" width="100" height="48" class="hd-d3-worry hd-d3-worry-1">
            <div xmlns="http://www.w3.org/1999/xhtml" class="hd-d3-bubble-html">
              <div class="hd-d3-bubble-title">プライバシー</div>
              <div class="hd-d3-bubble-sub">戦略漏洩</div>
            </div>
          </foreignObject>

          <foreignObject x="262" y="305" width="100" height="48" class="hd-d3-worry hd-d3-worry-2">
            <div xmlns="http://www.w3.org/1999/xhtml" class="hd-d3-bubble-html">
              <div class="hd-d3-bubble-title">コンプラ</div>
              <div class="hd-d3-bubble-sub">監査不能</div>
            </div>
          </foreignObject>
        </g>

      </g>

      <!-- ===== Bottom convergence + climax ===== -->
      <!-- PC glow halo -->
      <circle cx="600" cy="425" r="60" fill="url(#hd-pc-glow)" filter="url(#hd-pc-blur)"/>

      <!-- PC emblem (rotating ring + core) -->
      <g class="hd-pc-emblem">
        <circle cx="600" cy="425" r="28" class="hd-pc-ring"/>
        <circle cx="600" cy="425" r="21" class="hd-pc-core"/>
        <text x="600" y="431" text-anchor="middle" class="hd-pc-text">PC</text>
      </g>

      <!-- PC label "= Programmable Cryptography" -->
      <text x="600" y="480" text-anchor="middle" class="hd-pc-label">
        = Programmable Cryptography
      </text>
    </svg>
  </div>
</template>

<style scoped>
.hd-root {
  position: relative;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 8px;
  font-family: 'Noto Sans JP', sans-serif;
  color: #111827;
}

/* ===== Top hook ===== */
.hd-hook {
  padding: 10px 16px;
  background: linear-gradient(90deg, #eef2ff 0%, #fffbeb 100%);
  border: 1px solid #c7d2fe;
  border-radius: 0.5rem;
  display: flex;
  align-items: center;
  gap: 14px;
  min-height: 44px;
}
.hd-hook-eyebrow {
  flex-shrink: 0;
  padding: 4px 12px;
  border-radius: 999px;
  font-family: 'JetBrains Mono', monospace;
  font-size: 12px;
  font-weight: 900;
  letter-spacing: 0.18em;
  color: white;
  background: #1e1b4b;
}
.hd-hook-text {
  font-size: 17px;
  font-weight: 700;
  color: #1e1b4b;
  font-family: 'BIZ UDPMincho', serif;
}
.hd-hook-em {
  color: #b45309;
  font-weight: 900;
  border-bottom: 2px solid #fbbf24;
  padding-bottom: 1px;
}

/* ===== SVG ===== */
.hd-svg {
  width: 100%;
  height: auto;
  display: block;
  font-family: 'Noto Sans JP', sans-serif;
}

/* ===== Columns ===== */
.hd-col-bg {
  fill: white;
  stroke: #e5e7eb;
  stroke-width: 1.5;
  transition: stroke .4s;
}
.hd-col-header {
  transition: fill .4s;
}
.hd-num-circle {
  fill: white;
  stroke: white;
  stroke-width: 0;
}
.hd-num {
  font-size: 20px;
  font-weight: 900;
  font-family: 'JetBrains Mono', monospace;
}
.hd-cat {
  font-size: 14px;
  font-weight: 800;
  fill: white;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.08em;
  dominant-baseline: middle;
}

/* per-column color */
.hd-col-p .hd-col-header { fill: #7c3aed; }
.hd-col-p .hd-col-bg     { stroke: #c4b5fd; }
.hd-col-p .hd-num        { fill: #7c3aed; }
.hd-col-p .hd-trend-em   { fill: #6d28d9; }
.hd-col-p .hd-ev-tag     { fill: #7c3aed; }
.hd-col-p .hd-stat       { fill: #6d28d9; }
.hd-col-p .hd-answer-arrow { fill: #7c3aed; }
.hd-col-p .hd-answer     { fill: #4c1d95; }
.hd-col-p .hd-pill-bg    { fill: #faf5ff; stroke: #c4b5fd; }
.hd-col-p .hd-pill-text-mini { fill: #5b21b6; }

.hd-col-g .hd-col-header { fill: #059669; }
.hd-col-g .hd-col-bg     { stroke: #6ee7b7; }
.hd-col-g .hd-num        { fill: #059669; }
.hd-col-g .hd-trend-em   { fill: #047857; }
.hd-col-g .hd-ev-tag     { fill: #059669; }
.hd-col-g .hd-stat       { fill: #047857; }
.hd-col-g .hd-answer-arrow { fill: #059669; }
.hd-col-g .hd-answer     { fill: #064e3b; }
.hd-col-g .hd-pill-bg    { fill: #f0fdf4; stroke: #6ee7b7; }
.hd-col-g .hd-pill-text-mini { fill: #065f46; }

.hd-col-a .hd-col-header { fill: #d97706; }
.hd-col-a .hd-col-bg     { stroke: #fcd34d; }
.hd-col-a .hd-num        { fill: #d97706; }
.hd-col-a .hd-trend-em   { fill: #b45309; }
.hd-col-a .hd-ev-tag     { fill: #d97706; }
.hd-col-a .hd-stat       { fill: #b45309; }
.hd-col-a .hd-answer-arrow { fill: #d97706; }
.hd-col-a .hd-answer     { fill: #78350f; }
.hd-col-a .hd-pill-bg    { fill: #fffbeb; stroke: #fcd34d; }
.hd-col-a .hd-pill-text-mini { fill: #92400e; }

/* ===== Mini concept diagrams ===== */

/* Col 1 tinted backgrounds */
.hd-d1-bg-atk {
  fill: #fef2f2;
  stroke: #fca5a5;
  stroke-width: 1;
  stroke-dasharray: 3 3;
}
.hd-d1-bg-builders {
  fill: #fffbeb;
  stroke: #fcd34d;
  stroke-width: 1;
  stroke-dasharray: 3 3;
}
.hd-d1-bg-sc {
  fill: #ecfdf5;
  stroke: #6ee7b7;
  stroke-width: 1;
  stroke-dasharray: 3 3;
}

/* Actor labels */
.hd-d1-actor-label {
  font-size: 11px;
  font-weight: 800;
  fill: #374151;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.04em;
}
.hd-d1-actor-label-ok {
  fill: #065f46;
}
.hd-d2-actor-label {
  font-size: 11px;
  font-weight: 800;
  fill: #374151;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.04em;
}
.hd-d2-actor-label-sub {
  font-size: 9px;
  font-weight: 600;
  fill: #6b7280;
  font-family: 'JetBrains Mono', monospace;
}
.hd-d2-actor-label-bad {
  fill: #991b1b;
}
.hd-d3-actor-label {
  font-size: 10px;
  font-weight: 800;
  fill: #374151;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.04em;
}

/* Source code (Col 1) */
.hd-d1-sourcecode {
  /* no special animation */
}

/* zkVM spinner ring (Col 2) */
.hd-d2-zkvm-spinner {
  animation: hd-d2-spinner-rotate 4s linear infinite;
  transform-box: fill-box;
  transform-origin: center;
}
@keyframes hd-d2-spinner-rotate {
  to { transform: rotate(360deg); }
}

/* zkVM queue blocks (Col 2) */
.hd-d2-queue-blocks {
  animation: hd-d2-queue-pulse 1.6s ease-in-out infinite;
}
@keyframes hd-d2-queue-pulse {
  0%, 100% { opacity: 0.8; }
  50%      { opacity: 1; filter: drop-shadow(0 0 4px rgba(220, 38, 38, 0.4)); }
}

/* Worry bubble labels (Col 3) */
.hd-d3-worry-label {
  font-size: 11px;
  font-weight: 900;
  fill: #991b1b;
  font-family: 'BIZ UDPMincho', serif;
}
.hd-d3-worry-q {
  font-size: 16px;
  font-weight: 900;
  fill: #dc2626;
  font-family: 'JetBrains Mono', monospace;
}
.hd-d3-worry-q-small {
  font-size: 10px;
  font-weight: 900;
  fill: #991b1b;
  font-family: 'Noto Sans JP', sans-serif;
}

/* Col 2 arrow styles */
.hd-d2-arrow-down {
  stroke: #dc2626;
  stroke-width: 2.5;
  stroke-linecap: round;
  filter: drop-shadow(0 0 4px rgba(220, 38, 38, 0.4));
}
.hd-d2-arrow-head {
  fill: #dc2626;
}
.hd-d2-arrow-label {
  font-size: 9px;
  font-weight: 800;
  fill: #991b1b;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.04em;
}
.hd-d2-rack-text {
  font-size: 8px;
  font-weight: 900;
  fill: white;
  font-family: 'JetBrains Mono', monospace;
}
.hd-d2-zkvm-text {
  font-size: 14px;
  font-weight: 900;
  fill: #dc2626;
  font-family: 'JetBrains Mono', monospace;
}

/* Col 3 highlight pulse (TX fields with privacy/compliance issues) */
.hd-d3-highlight {
  animation: hd-d3-highlight-pulse 2s ease-in-out infinite;
}
@keyframes hd-d3-highlight-pulse {
  0%, 100% { opacity: 0.6; }
  50%      { opacity: 1; fill: rgba(220, 38, 38, 0.18); }
}

/* ===== TX request card (foreignObject HTML) ===== */
.hd-d3-tx-card {
  width: 100%;
  height: 100%;
  background: white;
  border: 2px solid #7c3aed;
  border-radius: 6px;
  overflow: hidden;
  font-family: 'Noto Sans JP', sans-serif;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
}
.hd-d3-tx-card-compact {
  font-size: 10px;
}
.hd-d3-tx-header {
  background: #7c3aed;
  color: white;
  padding: 5px 10px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-family: 'JetBrains Mono', monospace;
}
.hd-d3-tx-title {
  font-size: 12px;
  font-weight: 900;
  letter-spacing: 0.1em;
}
.hd-d3-tx-hash {
  font-size: 10px;
  font-weight: 700;
  opacity: 0.85;
}
.hd-d3-tx-body {
  padding: 8px 10px;
  flex: 1;
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px;
  line-height: 1.4;
}
.hd-d3-tx-body-compact {
  padding: 4px 8px;
  font-size: 10px;
  line-height: 1.3;
}
.hd-d3-tx-body-compact .hd-d3-tx-row {
  padding: 1px 4px;
}
.hd-d3-tx-row {
  display: flex;
  align-items: baseline;
  gap: 8px;
  padding: 2.5px 4px;
  border-radius: 3px;
}
.hd-d3-tx-row-bad {
  background: rgba(220, 38, 38, 0.08);
  animation: hd-d3-row-pulse 2.2s ease-in-out infinite;
}
.hd-d3-tx-row-bad:nth-child(3) { animation-delay: -0.7s; }
.hd-d3-tx-row-bad:nth-child(6) { animation-delay: -1.4s; }
@keyframes hd-d3-row-pulse {
  0%, 100% { background: rgba(220, 38, 38, 0.08); }
  50%      { background: rgba(220, 38, 38, 0.20); }
}
.hd-d3-tx-label {
  font-size: 10px;
  font-weight: 700;
  color: #6b7280;
  min-width: 58px;
}
.hd-d3-tx-value {
  font-size: 11px;
  font-weight: 800;
  color: #1f2937;
}
.hd-d3-tx-bad {
  font-size: 12px;
  color: #dc2626;
  font-weight: 900;
}
.hd-d3-tx-amount {
  font-size: 13px;
  font-weight: 900;
  color: #dc2626;
}
.hd-d3-tx-divider {
  height: 0;
  border-top: 1px dashed #d1d5db;
  margin: 5px 0;
}

/* On-chain connector (institution+DeFi → TX card) */
.hd-d3-onchain-line {
  stroke: #7c3aed;
  stroke-width: 2;
  stroke-dasharray: 4 3;
  animation: hd-d3-onchain-flow 1s linear infinite;
}
@keyframes hd-d3-onchain-flow {
  to { stroke-dashoffset: -14; }
}
.hd-d3-onchain-head {
  fill: #7c3aed;
}
.hd-d3-onchain-label {
  font-size: 10px;
  font-weight: 800;
  fill: #5b21b6;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.06em;
}

/* Smaller money packets for compact flow */
.hd-d3-money-mini {
  font-size: 14px !important;
}

/* ===== Warning bubbles (foreignObject HTML) ===== */
.hd-d3-bubble-html {
  width: 100%;
  height: 100%;
  background: white;
  border: 2px solid #dc2626;
  border-radius: 10px;
  padding: 5px 6px;
  font-family: 'Noto Sans JP', sans-serif;
  text-align: center;
  box-sizing: border-box;
  filter: drop-shadow(0 1px 4px rgba(0,0,0,0.1));
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 1px;
}
.hd-d3-bubble-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 14px;
}
.hd-d3-bubble-title {
  font-size: 11px;
  font-weight: 900;
  color: #991b1b;
  font-family: 'BIZ UDPMincho', serif;
  letter-spacing: 0.02em;
}
.hd-d3-bubble-sub {
  font-size: 10px;
  font-weight: 700;
  color: #7f1d1d;
}

/* ===== Col 1: Attacker → Builders, Contract safe, speech bubble ===== */
.hd-d1-attacker {
  /* keep SVG transform attribute (translate 60, 170); only filter animates */
  animation: hd-d1-atk-glow 1.6s ease-in-out infinite;
}
@keyframes hd-d1-atk-glow {
  0%, 100% { filter: drop-shadow(0 0 0 transparent); }
  50%      { filter: drop-shadow(0 0 8px rgba(220, 38, 38, 0.5)); }
}
.hd-d1-attack path {
  filter: drop-shadow(0 0 4px rgba(220, 38, 38, 0.7));
  animation: hd-d1-zap 1.1s ease-in-out infinite;
}
@keyframes hd-d1-zap {
  0%, 100% { opacity: 0.55; }
  50%      { opacity: 1; filter: drop-shadow(0 0 10px rgba(220, 38, 38, 0.95)); }
}
.hd-d1-builders {
  animation: hd-d1-shake 0.22s linear infinite;
}
@keyframes hd-d1-shake {
  0%, 100% { transform: translate(185px, 240px); }
  25%      { transform: translate(184px, 240px); }
  75%      { transform: translate(186px, 240px); }
}
.hd-d1-bubble-bg {
  fill: white;
  stroke: #dc2626;
  stroke-width: 1.8;
  filter: drop-shadow(0 1px 3px rgba(0,0,0,0.1));
}
.hd-d1-bubble {
  /* keep SVG transform translate(185, 75); animate only stroke pulse on bg */
}
.hd-d1-bubble .hd-d1-bubble-bg {
  animation: hd-d1-bubble-pulse 1.8s ease-in-out infinite;
}
@keyframes hd-d1-bubble-pulse {
  0%, 100% { stroke-width: 1.8; }
  50%      { stroke-width: 2.6; filter: drop-shadow(0 0 6px rgba(220, 38, 38, 0.4)); }
}
.hd-d1-bubble-t1 {
  font-size: 10px;
  font-weight: 800;
  fill: #6b7280;
  font-family: 'Noto Sans JP', sans-serif;
}
.hd-d1-bubble-t2 {
  font-size: 12px;
  font-weight: 900;
  fill: #991b1b;
  font-family: 'BIZ UDPMincho', serif;
  letter-spacing: 0.04em;
}

/* ===== Col 2: Consensus + Builder + zkVM triangle ===== */
.hd-d2-wire {
  stroke: #94a3b8;
  stroke-width: 1.8;
  stroke-dasharray: 4 3;
}
.hd-d2-wire-bottle {
  stroke: #dc2626;
  stroke-width: 2;
  animation: hd-d2-wire-bottle 1.5s linear infinite;
}
@keyframes hd-d2-wire-bottle {
  to { stroke-dashoffset: -14; }
}
.hd-d2-data {
  fill: #10b981;
  filter: drop-shadow(0 0 4px rgba(16, 185, 129, 0.6));
}
/* Particles from Consensus → zkVM and Execution → zkVM */
.hd-d2-data-1 {
  fill: #dc2626;
  animation: hd-d2-data-1 2.4s linear infinite;
}
@keyframes hd-d2-data-1 {
  0%   { transform: translate(100px, 215px); opacity: 0; }
  15%  { opacity: 1; }
  90%  { opacity: 1; }
  100% { transform: translate(170px, 305px); opacity: 0; }
}
.hd-d2-data-2 {
  fill: #dc2626;
  animation: hd-d2-data-2 2.4s linear infinite;
  animation-delay: -1.2s;
}
@keyframes hd-d2-data-2 {
  0%   { transform: translate(270px, 215px); opacity: 0; }
  15%  { opacity: 1; }
  90%  { opacity: 1; }
  100% { transform: translate(200px, 305px); opacity: 0; }
}
.hd-d2-zkvm circle {
  animation: hd-d2-zkvm-glow 1.6s ease-in-out infinite;
}
@keyframes hd-d2-zkvm-glow {
  0%, 100% { filter: drop-shadow(0 0 4px rgba(220, 38, 38, 0.5)); }
  50%      { filter: drop-shadow(0 0 14px rgba(220, 38, 38, 0.95)); }
}
.hd-d2-hourglass {
  animation: hd-d2-hour-spin 2.4s ease-in-out infinite;
  transform-box: fill-box;
  transform-origin: center;
}
@keyframes hd-d2-hour-spin {
  0%, 45%   { transform: rotate(0deg); }
  50%, 95%  { transform: rotate(180deg); }
  100%      { transform: rotate(180deg); }
}
.hd-d2-block {
  animation: hd-d2-block-form 3s ease-in-out infinite;
  transform-box: fill-box;
  transform-origin: center;
}
@keyframes hd-d2-block-form {
  0%, 100% { opacity: 0.5; transform: translate(180px, 110px) scale(0.92); }
  50%      { opacity: 1;   transform: translate(180px, 110px) scale(1); }
}

/* ===== Col 3: Institution → DeFi, worry bubbles ===== */
.hd-d3-flow-wire {
  stroke: #d97706;
  stroke-width: 2.5;
  stroke-dasharray: 6 4;
  animation: hd-d3-flow-anim 1.4s linear infinite;
}
@keyframes hd-d3-flow-anim {
  to { stroke-dashoffset: -20; }
}
.hd-d3-money {
  animation: hd-d3-money-fly 2.2s linear infinite;
  filter: drop-shadow(0 0 4px rgba(16, 185, 129, 0.5));
}
.hd-d3-money-2 {
  animation-delay: -1.1s;
}
@keyframes hd-d3-money-fly {
  0%   { transform: translate(100px, 135px); opacity: 0; }
  10%  { opacity: 1; }
  90%  { opacity: 1; }
  100% { transform: translate(265px, 135px); opacity: 0; }
}
.hd-d3-gear-spin {
  animation: hd-d3-spin 8s linear infinite;
  transform-box: fill-box;
  transform-origin: center;
}
@keyframes hd-d3-spin {
  to { transform: rotate(360deg); }
}
.hd-d3-bubble-bg {
  fill: white;
  stroke: #dc2626;
  stroke-width: 1.8;
  filter: drop-shadow(0 1px 3px rgba(0,0,0,0.1));
}
.hd-d3-worry-1, .hd-d3-worry-2 {
  animation: hd-d3-worry-pulse 1.6s ease-in-out infinite;
}
.hd-d3-worry-2 {
  animation-delay: -0.8s;
}
@keyframes hd-d3-worry-pulse {
  0%, 100% { filter: drop-shadow(0 0 0 transparent); }
  50%      { filter: drop-shadow(0 0 8px rgba(220, 38, 38, 0.55)); }
}

/* Evidence (不安) */
.hd-ev-tag {
  font-size: 11px;
  font-weight: 900;
  letter-spacing: 0.14em;
  font-family: 'JetBrains Mono', monospace;
}
.hd-ev {
  font-size: 13px;
  font-weight: 700;
  fill: #1f2937;
  font-family: 'Noto Sans JP', sans-serif;
}
.hd-ev-sub {
  font-size: 12px;
  font-weight: 500;
  fill: #6b7280;
  font-family: 'Noto Sans JP', sans-serif;
}
.hd-ev-third {
  font-weight: 600;
  fill: #374151;
}

/* Divider */
.hd-divider {
  stroke: #e5e7eb;
  stroke-width: 1;
  stroke-dasharray: 3 3;
}

/* Answer (期待) */
.hd-answer {
  font-size: 14px;
  font-weight: 800;
  font-family: 'Noto Sans JP', sans-serif;
}
.hd-answer-arrow {
  font-weight: 900;
  font-family: 'JetBrains Mono', monospace;
}

/* Pill mini */
.hd-pill-text-mini {
  font-size: 12px;
  font-weight: 800;
  font-family: 'JetBrains Mono', monospace;
}

/* Tech pills */
.hd-pill-bg {
  stroke-width: 1.5;
}
.hd-pill-text {
  font-size: 14px;
  font-weight: 800;
  font-family: 'JetBrains Mono', monospace;
}

/* Concrete fact */
.hd-fact-tag {
  font-size: 11px;
  font-weight: 900;
  letter-spacing: 0.16em;
  font-family: 'JetBrains Mono', monospace;
}
.hd-fact {
  font-size: 14px;
  font-weight: 700;
  fill: #1f2937;
  font-family: 'Noto Sans JP', sans-serif;
}
.hd-fact-sub {
  font-size: 13px;
  font-weight: 600;
  fill: #6b7280;
  font-family: 'Noto Sans JP', sans-serif;
}

/* Big stat */
.hd-stat {
  font-size: 38px;
  font-weight: 900;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.02em;
  animation: hd-stat-pulse 3s ease-in-out infinite;
  transform-origin: 90px 280px;
}
.hd-col-g .hd-stat { animation-delay: -1s; }
.hd-col-a .hd-stat { animation-delay: -2s; }
@keyframes hd-stat-pulse {
  0%, 100% { opacity: 0.9; filter: drop-shadow(0 0 4px rgba(217, 119, 6, 0.25)); }
  50%      { opacity: 1;   filter: drop-shadow(0 0 12px rgba(217, 119, 6, 0.55)); }
}
.hd-stat-label {
  font-size: 13px;
  font-weight: 800;
  fill: #1f2937;
  font-family: 'Noto Sans JP', sans-serif;
}
.hd-stat-src {
  font-size: 11px;
  font-weight: 600;
  fill: #9ca3af;
  font-family: 'JetBrains Mono', monospace;
}

/* ===== Rays (column → PC) ===== */
.hd-ray {
  stroke-width: 2.5;
  stroke-linecap: round;
  stroke-dasharray: 6 4;
  opacity: 0.65;
  animation: hd-ray-flow 1.6s linear infinite;
}
.hd-ray-p { stroke: #a78bfa; }
.hd-ray-g { stroke: #34d399; }
.hd-ray-a { stroke: #fbbf24; }
@keyframes hd-ray-flow {
  to { stroke-dashoffset: -20; }
}

/* ===== Particles ===== */
.hd-particle {
  filter: drop-shadow(0 0 5px currentColor);
}
.hd-particle-p {
  fill: #7c3aed;
  color: #7c3aed;
  animation: hd-flow-p 2.4s linear infinite;
}
.hd-particle-g {
  fill: #059669;
  color: #059669;
  animation: hd-flow-g 2.4s linear infinite;
}
.hd-particle-a {
  fill: #d97706;
  color: #d97706;
  animation: hd-flow-a 2.4s linear infinite;
}
@keyframes hd-flow-p {
  0%   { transform: translate(0, 0);     opacity: 0; }
  15%  { opacity: 1; }
  90%  { opacity: 1; }
  100% { transform: translate(395px, 55px); opacity: 0; }
}
@keyframes hd-flow-g {
  0%   { transform: translate(0, 0);   opacity: 0; }
  15%  { opacity: 1; }
  90%  { opacity: 1; }
  100% { transform: translate(5px, 55px); opacity: 0; }
}
@keyframes hd-flow-a {
  0%   { transform: translate(0, 0);      opacity: 0; }
  15%  { opacity: 1; }
  90%  { opacity: 1; }
  100% { transform: translate(-385px, 55px); opacity: 0; }
}

/* ===== PC emblem ===== */
.hd-pc-emblem { pointer-events: none; }
.hd-pc-ring {
  fill: none;
  stroke: #f59e0b;
  stroke-width: 3;
  stroke-dasharray: 8 5;
  transform-origin: 600px 425px;
  animation: hd-pc-rotate 18s linear infinite;
}
.hd-pc-core {
  fill: #d97706;
  stroke: #92400e;
  stroke-width: 2;
  filter: drop-shadow(0 0 14px rgba(217, 119, 6, 0.7));
  animation: hd-pc-breathe 2.6s ease-in-out infinite;
  transform-origin: 600px 425px;
}
@keyframes hd-pc-rotate {
  to { transform: rotate(360deg); }
}
@keyframes hd-pc-breathe {
  0%, 100% { transform: scale(1); }
  50%      { transform: scale(1.06); }
}
.hd-pc-text {
  font-size: 22px;
  font-weight: 900;
  fill: white;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.08em;
}
.hd-pc-label {
  font-size: 22px;
  font-weight: 900;
  fill: #92400e;
  font-family: 'BIZ UDPMincho', serif;
  letter-spacing: 0.04em;
}

/* ===== Cycling climax (foreignObject) ===== */
.hd-climax-wrap {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: 'BIZ UDPMincho', serif;
}
.hd-climax {
  font-size: 17px;
  font-weight: 700;
  color: #1e1b4b;
  letter-spacing: 0.02em;
  text-align: center;
}
.hd-climax-enter-active, .hd-climax-leave-active {
  transition: opacity .55s ease, transform .55s ease;
}
.hd-climax-enter-from { opacity: 0; transform: translateY(8px); }
.hd-climax-leave-to   { opacity: 0; transform: translateY(-8px); }
</style>
