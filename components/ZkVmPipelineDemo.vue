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
const phaseDurations = [3500, 3500, 4000, 4500, 4500]
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
  { code: '① Source — Rust / C で普通のプログラムを書く', note: '回路を手書きしない。暗号の知識は不要' },
  { code: '② Compile — RISC-V ELF にコンパイル', note: 'VM の ISA に落とす (StarkNet は Cairo)' },
  { code: '③ Execute — エミュレータが実行トレースを生成', note: '1 命令ずつ状態を記録する' },
  { code: '④ Prove — トレースを算術化して STARK/SNARK 証明', note: 'prover は重い (native 比 10³⁺) / verify は軽い' },
  { code: '⑤ Verify — 小さな proof を再実行せず検証', note: 'on-chain でも安価に検証できる' },
]

// stage i is lit when phase >= i ; current when phase === i
const stages = [0, 1, 2, 3, 4]
const cx = [140, 370, 600, 830, 1060]
function lit(i: number) { return computed(() => phase.value >= i) }
const litArr = stages.map(lit)
function isCurrent(i: number) { return phase.value === i }
</script>

<template>
  <div class="zv-root">
    <div class="zv-cap">
      <transition name="zv-fade" mode="out-in">
        <div :key="phase" class="zv-cap-inner">
          <code class="zv-code">{{ captions[phase].code }}</code>
          <div class="zv-note">{{ captions[phase].note }}</div>
        </div>
      </transition>
    </div>

    <svg class="zv-svg" viewBox="0 0 1200 360" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="zv-ar" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
          <path d="M 0,0 L 10,5 L 0,10 z" fill="#94a3b8"/>
        </marker>
      </defs>

      <!-- arrows between stages -->
      <g v-for="i in 4" :key="'arr'+i">
        <line :x1="cx[i-1]+90" y1="178" :x2="cx[i]-90" y2="178"
              class="zv-arrow" :class="{ 'is-on': phase >= i }" marker-end="url(#zv-ar)"/>
        <circle v-if="phase === i" r="6" class="zv-particle">
          <animateMotion dur="1.5s" repeatCount="indefinite"
            :path="`M ${cx[i-1]+90},178 L ${cx[i]-90},178`"/>
        </circle>
      </g>

      <!-- ===== stage 1: Source ===== -->
      <g class="zv-stage" :class="{ 'is-lit': litArr[0].value, 'is-cur': isCurrent(0) }">
        <rect :x="cx[0]-90" y="68" width="180" height="220" rx="12" class="zv-card"/>
        <g :transform="`translate(${cx[0]},132)`">
          <rect x="-46" y="-34" width="92" height="68" rx="6" fill="#0f172a" stroke="#475569" stroke-width="2"/>
          <rect x="-46" y="-34" width="92" height="14" rx="6" fill="#1e293b"/>
          <rect x="-38" y="-12" width="34" height="5" rx="2" fill="#c084fc"/>
          <rect x="0" y="-12" width="28" height="5" rx="2" fill="#fcd34d"/>
          <rect x="-38" y="0" width="20" height="5" rx="2" fill="#60a5fa"/>
          <rect x="-12" y="0" width="40" height="5" rx="2" fill="#34d399"/>
          <rect x="-38" y="12" width="48" height="5" rx="2" fill="#94a3b8"/>
        </g>
        <text :x="cx[0]" y="232" text-anchor="middle" class="zv-title">Rust / C</text>
        <text :x="cx[0]" y="258" text-anchor="middle" class="zv-sub">普通のプログラム</text>
      </g>

      <!-- ===== stage 2: ELF ===== -->
      <g class="zv-stage" :class="{ 'is-lit': litArr[1].value, 'is-cur': isCurrent(1) }">
        <rect :x="cx[1]-90" y="68" width="180" height="220" rx="12" class="zv-card"/>
        <g :transform="`translate(${cx[1]},132)`">
          <rect x="-34" y="-34" width="68" height="68" rx="6" fill="#334155" stroke="#64748b" stroke-width="2"/>
          <rect x="-20" y="-20" width="40" height="40" rx="3" fill="#1e293b"/>
          <text x="0" y="6" text-anchor="middle" class="zv-isa">ISA</text>
          <g stroke="#64748b" stroke-width="2.5">
            <line x1="-46" y1="-18" x2="-34" y2="-18"/><line x1="-46" y1="0" x2="-34" y2="0"/><line x1="-46" y1="18" x2="-34" y2="18"/>
            <line x1="34" y1="-18" x2="46" y2="-18"/><line x1="34" y1="0" x2="46" y2="0"/><line x1="34" y1="18" x2="46" y2="18"/>
          </g>
        </g>
        <text :x="cx[1]" y="232" text-anchor="middle" class="zv-title">RISC-V ELF</text>
        <text :x="cx[1]" y="258" text-anchor="middle" class="zv-sub">VM ISA にコンパイル</text>
      </g>

      <!-- ===== stage 3: Trace ===== -->
      <g class="zv-stage" :class="{ 'is-lit': litArr[2].value, 'is-cur': isCurrent(2) }">
        <rect :x="cx[2]-90" y="68" width="180" height="220" rx="12" class="zv-card"/>
        <g :transform="`translate(${cx[2]},132)`">
          <rect x="-42" y="-34" width="84" height="68" rx="5" fill="white" stroke="#94a3b8" stroke-width="2"/>
          <rect x="-42" y="-34" width="84" height="16" rx="5" fill="#f1f5f9"/>
          <line x1="-42" y1="-18" x2="42" y2="-18" stroke="#cbd5e1" stroke-width="1.5"/>
          <line x1="-42" y1="0" x2="42" y2="0" stroke="#cbd5e1" stroke-width="1.5"/>
          <line x1="-42" y1="18" x2="42" y2="18" stroke="#cbd5e1" stroke-width="1.5"/>
          <line x1="-14" y1="-34" x2="-14" y2="34" stroke="#cbd5e1" stroke-width="1.5"/>
          <line x1="14" y1="-34" x2="14" y2="34" stroke="#cbd5e1" stroke-width="1.5"/>
        </g>
        <text :x="cx[2]" y="232" text-anchor="middle" class="zv-title">実行トレース</text>
        <text :x="cx[2]" y="258" text-anchor="middle" class="zv-sub">1 命令ずつ記録</text>
      </g>

      <!-- ===== stage 4: Prove ===== -->
      <g class="zv-stage" :class="{ 'is-lit': litArr[3].value, 'is-cur': isCurrent(3) }">
        <rect :x="cx[3]-90" y="68" width="180" height="220" rx="12" class="zv-card"/>
        <g :transform="`translate(${cx[3]},130)`">
          <path d="M 0,-36 L 34,-22 L 34,8 C 34,30 18,40 0,46 C -18,40 -34,30 -34,8 L -34,-22 Z"
                fill="#fffbeb" stroke="#f59e0b" stroke-width="2.5"/>
          <text x="0" y="6" text-anchor="middle" class="zv-pi">π</text>
        </g>
        <text :x="cx[3]" y="232" text-anchor="middle" class="zv-title">STARK/SNARK</text>
        <text :x="cx[3]" y="258" text-anchor="middle" class="zv-sub">算術化して prove</text>
      </g>

      <!-- ===== stage 5: Verify ===== -->
      <g class="zv-stage" :class="{ 'is-lit': litArr[4].value, 'is-cur': isCurrent(4), 'is-final': phase >= 4 }">
        <rect :x="cx[4]-90" y="68" width="180" height="220" rx="12" class="zv-card zv-card-final"/>
        <g :transform="`translate(${cx[4]},130)`">
          <circle cx="0" cy="0" r="34" :fill="phase >= 4 ? '#ecfdf5' : 'white'" :stroke="phase >= 4 ? '#10b981' : '#94a3b8'" stroke-width="2.5"/>
          <path d="M -15,2 L -5,13 L 16,-11" fill="none" :stroke="phase >= 4 ? '#10b981' : '#94a3b8'" stroke-width="4.5" stroke-linecap="round" stroke-linejoin="round"/>
        </g>
        <text :x="cx[4]" y="232" text-anchor="middle" class="zv-title">検証</text>
        <text :x="cx[4]" y="258" text-anchor="middle" class="zv-sub">再実行せず安価に</text>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.zv-root {
  position: relative;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 8px;
  font-family: 'Noto Sans JP', sans-serif;
  color: #111827;
}
.zv-cap {
  padding: 10px 18px;
  background: #fffbeb;
  border: 1px solid #fde68a;
  border-radius: 0.75rem;
  min-height: 56px;
  display: flex;
  align-items: center;
}
.zv-cap-inner { display: flex; flex-direction: column; gap: 3px; width: 100%; }
.zv-code { font-family: 'JetBrains Mono', monospace; font-size: 16px; color: #78350f; font-weight: 800; }
.zv-note { font-size: 14px; color: #b45309; font-weight: 600; }

.zv-svg { width: 100%; height: auto; display: block; }

.zv-stage { opacity: 0.4; transition: opacity 0.5s; }
.zv-stage.is-lit { opacity: 1; }
.zv-card {
  fill: white;
  stroke: #e2e8f0;
  stroke-width: 2;
  transition: stroke 0.4s, filter 0.4s;
}
.zv-stage.is-lit .zv-card { stroke: #cbd5e1; }
.zv-stage.is-cur .zv-card {
  stroke: #f59e0b;
  stroke-width: 3;
  filter: drop-shadow(0 0 10px rgba(245,158,11,0.35));
}
.zv-stage.is-final .zv-card-final { stroke: #10b981; }

.zv-title {
  font-size: 19px;
  font-weight: 800;
  fill: #1f2937;
  font-family: 'BIZ UDPMincho', serif;
}
.zv-isa { font-size: 15px; font-weight: 900; fill: #67e8f9; font-family: 'JetBrains Mono', monospace; }
.zv-pi { font-size: 18px; font-weight: 900; fill: #b45309; font-family: 'JetBrains Mono', monospace; }
.zv-sub { font-size: 14px; fill: #6b7280; font-weight: 600; }

.zv-arrow {
  stroke: #cbd5e1;
  stroke-width: 2.5;
  fill: none;
  transition: stroke 0.4s;
}
.zv-arrow.is-on { stroke: #94a3b8; }
.zv-particle { fill: #f59e0b; filter: drop-shadow(0 0 5px rgba(245,158,11,0.8)); }

.zv-fade-enter-active, .zv-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.zv-fade-enter-from { opacity: 0; transform: translateY(4px); }
.zv-fade-leave-to { opacity: 0; transform: translateY(-4px); }
</style>
