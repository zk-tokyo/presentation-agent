<script setup lang="ts">
type Pattern = {
  index: string;
  app: string;
  recipe: string;
  desc: string;
  hue: 'amber' | 'cyan' | 'purple' | 'pink' | 'blue' | 'green';
}

const patterns: Pattern[] = [
  { index: '①', app: 'Longfellow',         recipe: 'ZK ∘ ECDSA(mDOC)',         desc: '既存 ID 標準 (mDOC / JWT) を ZK 化',     hue: 'amber'  },
  { index: '②', app: 'Verifiable FHE',     recipe: 'ZK + FHE',                  desc: 'FHE の計算正しさを ZK で保証',            hue: 'purple' },
  { index: '③', app: 'threshold FHE',      recipe: 'MPC + FHE',                 desc: 'FHE の鍵を MPC で分散管理',              hue: 'cyan'   },
  { index: '④', app: 'POD2',               recipe: 'ZK + 署名データ',            desc: '署名済みデータを証明し組み合わせる',       hue: 'pink'   },
  { index: '⑤', app: 'leanVM',             recipe: 'ZK + XMSS',                 desc: '耐量子署名を再帰集約して 1 proof に',      hue: 'blue'   },
  { index: '⑥', app: 'co-SNARK',           recipe: 'ZK + MPC',                  desc: '入力を秘匿したまま協調証明 (World ID)',   hue: 'amber'  },
]
</script>

<template>
  <div class="cp-root">
    <!-- Top caption -->
    <div class="cp-cap">
      <div class="cp-cap-title">6 つの代表的合成パターン</div>
      <div class="cp-cap-sub">各 app は crypto primitive どうし、または既存 system との合成として現れる</div>
    </div>

    <!-- Grid: 4 cols × 2 rows (last cell empty) -->
    <div class="cp-grid">
      <div v-for="p in patterns" :key="p.index" :class="['cp-card', `cp-card-${p.hue}`]">
        <div class="cp-card-head">
          <span class="cp-index">{{ p.index }}</span>
          <span class="cp-app">{{ p.app }}</span>
        </div>
        <div class="cp-recipe">{{ p.recipe }}</div>
        <div class="cp-desc">{{ p.desc }}</div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.cp-root {
  position: relative;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 10px;
  font-family: 'Noto Sans JP', sans-serif;
  color: #111827;
}

/* Top caption */
.cp-cap {
  padding: 9px 16px;
  background: #eef2ff;
  border: 1px solid #c7d2fe;
  border-radius: 0.5rem;
  display: flex;
  flex-direction: column;
  gap: 3px;
}
.cp-cap-title {
  font-size: 17px;
  font-weight: 800;
  color: #1e1b4b;
  font-family: 'BIZ UDPMincho', serif;
}
.cp-cap-sub {
  font-size: 13px;
  color: #4338ca;
  font-weight: 600;
  font-family: 'BIZ UDPMincho', serif;
}

/* Grid */
.cp-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-template-rows: repeat(2, 1fr);
  gap: 12px;
}

/* Card */
.cp-card {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  gap: 6px;
  padding: 14px 12px;
  border-radius: 10px;
  border: 2px solid;
  background: white;
  min-height: 130px;
  text-align: center;
  filter: drop-shadow(0 2px 6px rgba(0,0,0,0.06));
}

.cp-card-amber  { border-color: #fcd34d; background: linear-gradient(180deg, #fffbeb 0%, white 60%); }
.cp-card-cyan   { border-color: #67e8f9; background: linear-gradient(180deg, #ecfeff 0%, white 60%); }
.cp-card-purple { border-color: #c4b5fd; background: linear-gradient(180deg, #f5f3ff 0%, white 60%); }
.cp-card-pink   { border-color: #fbcfe8; background: linear-gradient(180deg, #fdf2f8 0%, white 60%); }
.cp-card-blue   { border-color: #93c5fd; background: linear-gradient(180deg, #eff6ff 0%, white 60%); }
.cp-card-green  { border-color: #86efac; background: linear-gradient(180deg, #f0fdf4 0%, white 60%); }

/* Card head: index + app name */
.cp-card-head {
  display: flex;
  align-items: baseline;
  justify-content: center;
  gap: 6px;
}
.cp-index {
  font-size: 16px;
  font-weight: 900;
  font-family: 'JetBrains Mono', monospace;
  color: #94a3b8;
}
.cp-card-amber  .cp-index { color: #d97706; }
.cp-card-cyan   .cp-index { color: #0891b2; }
.cp-card-purple .cp-index { color: #7c3aed; }
.cp-card-pink   .cp-index { color: #db2777; }
.cp-card-blue   .cp-index { color: #2563eb; }
.cp-card-green  .cp-index { color: #059669; }

.cp-app {
  font-size: 18px;
  font-weight: 900;
  color: #1f2937;
  font-family: 'BIZ UDPMincho', serif;
  line-height: 1.2;
}

/* Recipe (the formula) */
.cp-recipe {
  font-size: 14px;
  font-weight: 700;
  color: #475569;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.01em;
  padding: 3px 10px;
  border-radius: 4px;
  background: rgba(255,255,255,0.7);
  border: 1px dashed #cbd5e1;
}

/* Description (short Japanese line) */
.cp-desc {
  font-size: 12.5px;
  color: #475569;
  font-family: 'BIZ UDPMincho', serif;
  font-weight: 600;
  line-height: 1.4;
  max-width: 96%;
}

/* Ghost slot */
.cp-card-ghost {
  border-style: dashed;
  border-color: #e5e7eb;
  background: #fafafa;
  filter: none;
}
.cp-ghost-text {
  font-size: 24px;
  font-weight: 700;
  color: #cbd5e1;
  font-family: 'JetBrains Mono', monospace;
}
</style>
