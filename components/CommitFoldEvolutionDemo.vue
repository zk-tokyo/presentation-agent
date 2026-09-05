<script setup lang="ts">
// 時間軸 2 段構成 (キャプションなし、左余白活用、wider cards)
//   Row 1 (2010-2023 歴史):    上 = commitment / 下 = proving system
//   Row 2 (2024-2026 最新):    上 = commitment / 下 = proving system (zoom)
type Era = 'classic' | 'hash' | 'fold' | 'modern' | 'latest'
type Side = 'commit' | 'prove'

type Milestone = {
  id: string;
  side: Side;
  year: string;
  x: number;
  label: string;
  sub: string;
  era: Era;
}

// ===== Row 1: 2010-2023 歴史 (sparse, wider cards) =====
const row1: Milestone[] = [
  // commitment (above) — 3 cards, width 180, generous spacing
  { id: 'kzg',       side: 'commit', year: '2010', x: 250,  label: 'KZG',        sub: 'pairing / setup', era: 'classic' },
  { id: 'fri',       side: 'commit', year: '2017', x: 620,  label: 'FRI',        sub: 'hash-based',      era: 'hash'    },
  { id: 'brakedown', side: 'commit', year: '2023', x: 1010, label: 'Brakedown',  sub: 'linear-time',     era: 'hash'    },
  // proving (below) — 5 cards, width 170
  { id: 'groth16',   side: 'prove',  year: '2016', x: 240,  label: 'Groth16',    sub: 'pairing SNARK',   era: 'classic' },
  { id: 'stark',     side: 'prove',  year: '2018', x: 435,  label: 'STARK',      sub: 'hash-based',      era: 'hash'    },
  { id: 'plonk',     side: 'prove',  year: '2019', x: 625,  label: 'PLONK',      sub: 'universal',       era: 'hash'    },
  { id: 'halo2',     side: 'prove',  year: '2020', x: 820,  label: 'Halo2',      sub: 'accumulation',    era: 'hash'    },
  { id: 'nova',      side: 'prove',  year: '2022', x: 1015, label: 'Nova',       sub: 'folding / IVC',   era: 'fold'    },
]
const row1Commit = row1.filter(m => m.side === 'commit')
const row1Prove  = row1.filter(m => m.side === 'prove')

// ===== Row 2: 2024-2026 最新 (zoomed, per-research blocks, wider) =====
const row2: Milestone[] = [
  // commitment (above) — 6 cards, width 160, shorter sub texts
  { id: 'basefold',  side: 'commit', year: '2024', x: 220,  label: 'BaseFold',   sub: 'multilinear FRI',      era: 'modern' },
  { id: 'binius',    side: 'commit', year: '2024', x: 385,  label: 'Binius',     sub: 'small-field / 2 進',   era: 'modern' },
  { id: 'whir',      side: 'commit', year: '2024', x: 550,  label: 'WHIR',       sub: '高速な検証',        era: 'modern' },
  { id: 'fribin',    side: 'commit', year: '2024', x: 715,  label: 'FRI-Binius', sub: 'binary tower combo',   era: 'modern' },
  { id: 'frivail',   side: 'commit', year: '2025', x: 880,  label: 'FRIVail',    sub: 'DAS application',      era: 'latest' },
  { id: 'longfellow',side: 'commit', year: '2024', x: 1045, label: 'Longfellow', sub: 'Ligero / MPC-in-the-head', era: 'modern' },

  // proving (below) — 8 cards, width 128, spacing 128
  { id: 'hypernova', side: 'prove',  year: '2023', x: 215,  label: 'HyperNova',  sub: 'multi-folding',        era: 'fold'   },
  { id: 'protostar', side: 'prove',  year: '2023', x: 343,  label: 'ProtoStar',  sub: 'generic folding',      era: 'fold'   },
  { id: 'cyclefold', side: 'prove',  year: '2024', x: 471,  label: 'CycleFold',  sub: 'cycle of curves',      era: 'modern' },
  { id: 'jolt',      side: 'prove',  year: '2024', x: 599,  label: 'Jolt',       sub: 'sumcheck + Lasso',     era: 'modern' },
  { id: 'neut',      side: 'prove',  year: '2024', x: 727,  label: 'NeutronNova',sub: 'zero-check fold',      era: 'modern' },
  { id: 'mova',      side: 'prove',  year: '2024', x: 855,  label: 'Mova',       sub: 'no error commit',      era: 'modern' },
  { id: 'stwo',      side: 'prove',  year: '2025', x: 983,  label: 'Stwo',       sub: 'Circle STARK / M31',   era: 'latest' },
  { id: 'latfold',   side: 'prove',  year: '2025', x: 1111, label: 'LatticeFold+', sub: 'post-quantum',       era: 'latest' },
]
const row2Commit = row2.filter(m => m.side === 'commit')
const row2Prove  = row2.filter(m => m.side === 'prove')
</script>

<template>
  <div class="cf-root">
    <svg class="cf-svg" viewBox="0 0 1200 540" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="cf-ar" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#94a3b8"/>
        </marker>
      </defs>

      <!-- =========================================================
           ROW 1: 2010-2023 歴史
           ========================================================= -->
      <text x="20" y="22" class="cf-row-header">▸ 2010 → 2023  歴史</text>

      <text x="20" y="92" class="cf-side-label cf-side-commit">commitment</text>
      <text x="20" y="225" class="cf-side-label cf-side-prove">proving system</text>

      <!-- Commit cards (above, 180 wide) -->
      <g v-for="m in row1Commit" :key="m.id" :class="['cf-node', `cf-era-${m.era}`]">
        <line :x1="m.x" y1="135" :x2="m.x" y2="108" class="cf-stub"/>
        <rect :x="m.x - 90" y="40" width="180" height="68" rx="9" class="cf-card-bg"/>
        <text :x="m.x" y="68" text-anchor="middle" class="cf-card-title">{{ m.label }}</text>
        <text :x="m.x" y="92" text-anchor="middle" class="cf-card-sub">{{ m.sub }}</text>
        <text :x="m.x" y="156" text-anchor="middle" class="cf-year">{{ m.year }}</text>
      </g>

      <!-- Row 1 timeline -->
      <line x1="160" y1="135" x2="1175" y2="135" class="cf-track-line"/>
      <line x1="1140" y1="135" x2="1173" y2="135" class="cf-arrow-end" marker-end="url(#cf-ar)"/>

      <!-- Prove cards (below, 170 wide) -->
      <g v-for="m in row1Prove" :key="m.id" :class="['cf-node', `cf-era-${m.era}`]">
        <line :x1="m.x" y1="135" :x2="m.x" y2="168" class="cf-stub"/>
        <rect :x="m.x - 85" y="170" width="170" height="68" rx="9" class="cf-card-bg"/>
        <text :x="m.x" y="198" text-anchor="middle" class="cf-card-title">{{ m.label }}</text>
        <text :x="m.x" y="222" text-anchor="middle" class="cf-card-sub">{{ m.sub }}</text>
      </g>

      <!-- Separator between rows -->
      <line x1="0" y1="265" x2="1200" y2="265" stroke="#e5e7eb" stroke-width="1" stroke-dasharray="3 3"/>

      <!-- =========================================================
           ROW 2: 2024-2026 最新研究 (zoom)
           ========================================================= -->
      <text x="20" y="288" class="cf-row-header cf-row-header-latest">▸ 2024 → 2026  最新研究</text>

      <text x="20" y="358" class="cf-side-label cf-side-commit">commitment</text>
      <text x="20" y="490" class="cf-side-label cf-side-prove">proving system</text>

      <!-- Commit cards (above, 160 wide for 6-in-a-row) -->
      <g v-for="m in row2Commit" :key="m.id" :class="['cf-node', `cf-era-${m.era}`]">
        <line :x1="m.x" y1="408" :x2="m.x" y2="382" class="cf-stub"/>
        <rect :x="m.x - 80" y="312" width="160" height="68" rx="9" class="cf-card-bg"/>
        <text :x="m.x" y="340" text-anchor="middle" class="cf-card-title">{{ m.label }}</text>
        <text :x="m.x" y="364" text-anchor="middle" class="cf-card-sub-md">{{ m.sub }}</text>
        <text :x="m.x" y="427" text-anchor="middle" class="cf-year cf-year-latest">{{ m.year }}</text>
      </g>

      <!-- Row 2 timeline -->
      <line x1="160" y1="408" x2="1180" y2="408" class="cf-track-line cf-track-line-latest"/>
      <line x1="1145" y1="408" x2="1178" y2="408" class="cf-arrow-end cf-arrow-end-latest" marker-end="url(#cf-ar)"/>

      <!-- Prove cards (below, 128 wide for 8-in-a-row) -->
      <g v-for="m in row2Prove" :key="m.id" :class="['cf-node', `cf-era-${m.era}`]">
        <line :x1="m.x" y1="408" :x2="m.x" y2="440" class="cf-stub"/>
        <rect :x="m.x - 64" y="442" width="128" height="68" rx="9" class="cf-card-bg"/>
        <text :x="m.x" y="468" text-anchor="middle" class="cf-card-title-sm">{{ m.label }}</text>
        <text :x="m.x" y="492" text-anchor="middle" class="cf-card-sub-sm">{{ m.sub }}</text>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.cf-root {
  position: relative;
  width: 100%;
  display: flex;
  flex-direction: column;
  font-family: 'Noto Sans JP', sans-serif;
  color: #111827;
}

.cf-svg {
  width: 100%;
  height: auto;
  display: block;
  font-family: 'Noto Sans JP', sans-serif;
}

/* Row headers */
.cf-row-header {
  font-size: 16px;
  font-weight: 800;
  fill: #475569;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.04em;
}
.cf-row-header-latest { fill: #c2410c; }

/* Side labels */
.cf-side-label {
  font-size: 13px;
  font-weight: 800;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.06em;
  text-transform: uppercase;
}
.cf-side-commit { fill: #92400e; }
.cf-side-prove  { fill: #5b21b6; }

/* Timelines */
.cf-track-line {
  stroke: #cbd5e1;
  stroke-width: 2.5;
  stroke-dasharray: 5 3;
}
.cf-track-line-latest {
  stroke: #fb923c;
  stroke-width: 3;
}
.cf-arrow-end {
  stroke: #94a3b8;
  stroke-width: 2.5;
  fill: none;
}
.cf-arrow-end-latest { stroke: #fb923c; stroke-width: 3; }

/* Year markers */
.cf-year {
  font-size: 13px;
  fill: #94a3b8;
  font-weight: 700;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.04em;
}
.cf-year-latest { fill: #c2410c; font-weight: 800; }

/* Milestone cards */
.cf-stub {
  stroke: #94a3b8;
  stroke-width: 1.8;
}
.cf-card-bg {
  fill: white;
  stroke-width: 2.2;
  filter: drop-shadow(0 1px 3px rgba(0,0,0,0.07));
}
.cf-era-classic .cf-card-bg { fill: #fef2f2; stroke: #f87171; }
.cf-era-hash    .cf-card-bg { fill: #f0fdf4; stroke: #86efac; }
.cf-era-fold    .cf-card-bg { fill: #f5f3ff; stroke: #c4b5fd; }
.cf-era-modern  .cf-card-bg { fill: #ecfeff; stroke: #67e8f9; }
.cf-era-latest  .cf-card-bg {
  fill: #fff7ed;
  stroke: #fb923c;
  stroke-width: 3;
  filter: drop-shadow(0 0 8px rgba(251, 146, 60, 0.5));
}

.cf-card-title {
  font-size: 18px;
  font-weight: 800;
  fill: #1f2937;
  font-family: 'BIZ UDPMincho', serif;
}
.cf-card-title-sm {
  font-size: 15px;
  font-weight: 800;
  fill: #1f2937;
  font-family: 'BIZ UDPMincho', serif;
}
.cf-card-sub {
  font-size: 13px;
  fill: #475569;
  font-weight: 600;
  font-family: 'JetBrains Mono', monospace;
}
.cf-card-sub-md {
  font-size: 12px;
  fill: #475569;
  font-weight: 600;
  font-family: 'JetBrains Mono', monospace;
}
.cf-card-sub-sm {
  font-size: 11px;
  fill: #475569;
  font-weight: 600;
  font-family: 'JetBrains Mono', monospace;
}

.cf-era-latest .cf-card-title    { fill: #c2410c; }
.cf-era-latest .cf-card-title-sm { fill: #c2410c; }
</style>
