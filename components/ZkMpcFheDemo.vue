<script setup lang="ts">
// 3 paradigms shown SIMULTANEOUSLY in 3 columns.
// All actor boxes are uniform 130×96 with icon-above-text centered alignment.
// Topology (1→1 / mesh / 1↔server) is the only difference between scenes.
</script>

<template>
  <div class="zm-root">
    <!-- Top header strip -->

    <!-- 3-column grid -->
    <div class="zm-grid">

      <!-- ============================ ZK ============================ -->
      <div class="zm-col zm-col-zk">
        <div class="zm-col-head">
          <div class="zm-col-name">ZK</div>
          <div class="zm-col-purpose"><strong>事実を証明する</strong> (秘密は出さず)</div>
        </div>

        <svg class="zm-scene" viewBox="0 0 380 200" preserveAspectRatio="xMidYMid meet">
          <defs>
            <marker id="zm-zk-ar" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
              <path d="M 0,0 L 10,5 L 0,10 z" fill="#b45309"/>
            </marker>
          </defs>

          <!-- top formula label -->
          <text x="190" y="22" text-anchor="middle" class="zm-scene-formula">π : ∃w. C(x, w) = 1</text>

          <!-- Prover (left) -->
          <g>
            <rect x="15" y="50" width="130" height="100" rx="9" fill="#fffbeb" stroke="#fcd34d" stroke-width="2"/>
            <g transform="translate(80, 80)">
              <circle cx="0" cy="-7" r="7" fill="#b45309"/>
              <path d="M -10,4 Q 0,1 10,4 L 9,17 L -9,17 Z" fill="#b45309"/>
            </g>
            <text x="80" y="120" text-anchor="middle" class="zm-actor-title">Prover</text>
            <text x="80" y="140" text-anchor="middle" class="zm-actor-sub">witness w 🔒</text>
          </g>

          <!-- wire + π particle -->
          <line x1="145" y1="100" x2="235" y2="100" class="zm-zk-wire" marker-end="url(#zm-zk-ar)"/>
          <g class="zm-zk-particle">
            <circle cx="160" cy="100" r="8" fill="#b45309" filter="drop-shadow(0 0 6px rgba(180,83,9,0.7))"/>
            <text x="160" y="105" text-anchor="middle" class="zm-zk-tag">π</text>
          </g>

          <!-- Verifier (right) -->
          <g>
            <rect x="235" y="50" width="130" height="100" rx="9" fill="#f0fdf4" stroke="#86efac" stroke-width="2"/>
            <g transform="translate(300, 82)">
              <path d="M 0,-15 L 13,-9 L 13,4 Q 13,15 0,18 Q -13,15 -13,4 L -13,-9 Z" fill="#059669"/>
              <path d="M -5,2 L 0,7 L 7,-3" stroke="white" stroke-width="2.4" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
            </g>
            <text x="300" y="120" text-anchor="middle" class="zm-actor-title">Verifier</text>
            <text x="300" y="140" text-anchor="middle" class="zm-actor-sub">✓ accept</text>
          </g>
        </svg>

        <ul class="zm-attrs">
          <li><span class="zm-attr-key">隠す対象</span><span class="zm-attr-val">prover の witness w</span></li>
          <li><span class="zm-attr-key">信頼前提</span><span class="zm-attr-val">Prover を信頼しなくてよい (math が保証)</span></li>
          <li><span class="zm-attr-key">敵対モデル</span><span class="zm-attr-val"><strong>Prover</strong> (偽証) ／ <strong>Verifier</strong> (witness 窃取)</span></li>
          <li class="zm-attr-emph"><span class="zm-attr-key">主な用途</span><span class="zm-attr-val">年齢証明 — 生年月日を出さず「18 以上」を証明</span></li>
        </ul>
      </div>

      <!-- ============================ MPC ============================ -->
      <div class="zm-col zm-col-mpc">
        <div class="zm-col-head">
          <div class="zm-col-name">MPC</div>
          <div class="zm-col-purpose"><strong>複数の秘密を持ち寄って</strong>計算</div>
        </div>

        <svg class="zm-scene" viewBox="0 0 380 200" preserveAspectRatio="xMidYMid meet">
          <!-- P1 (top) -->
          <g>
            <rect x="125" y="20" width="130" height="60" rx="8" fill="#ecfeff" stroke="#67e8f9" stroke-width="2"/>
            <g transform="translate(160, 50)">
              <circle cx="0" cy="-7" r="6" fill="#0e7490"/>
              <path d="M -9,3 Q 0,0 9,3 L 8,15 L -8,15 Z" fill="#0e7490"/>
            </g>
            <text x="200" y="45" text-anchor="middle" class="zm-actor-title">P1</text>
            <text x="200" y="65" text-anchor="middle" class="zm-actor-sub">x₁ 🔒</text>
          </g>

          <!-- P2 (bottom-left) -->
          <g>
            <rect x="20" y="140" width="130" height="60" rx="8" fill="#ecfeff" stroke="#67e8f9" stroke-width="2"/>
            <g transform="translate(55, 170)">
              <circle cx="0" cy="-7" r="6" fill="#0e7490"/>
              <path d="M -9,3 Q 0,0 9,3 L 8,15 L -8,15 Z" fill="#0e7490"/>
            </g>
            <text x="95" y="165" text-anchor="middle" class="zm-actor-title">P2</text>
            <text x="95" y="185" text-anchor="middle" class="zm-actor-sub">x₂ 🔒</text>
          </g>

          <!-- P3 (bottom-right) -->
          <g>
            <rect x="230" y="140" width="130" height="60" rx="8" fill="#ecfeff" stroke="#67e8f9" stroke-width="2"/>
            <g transform="translate(265, 170)">
              <circle cx="0" cy="-7" r="6" fill="#0e7490"/>
              <path d="M -9,3 Q 0,0 9,3 L 8,15 L -8,15 Z" fill="#0e7490"/>
            </g>
            <text x="305" y="165" text-anchor="middle" class="zm-actor-title">P3</text>
            <text x="305" y="185" text-anchor="middle" class="zm-actor-sub">x₃ 🔒</text>
          </g>

          <!-- mesh edges between parties -->
          <line x1="190" y1="80" x2="85" y2="140" class="zm-mpc-edge"/>
          <line x1="190" y1="80" x2="295" y2="140" class="zm-mpc-edge"/>
          <line x1="150" y1="170" x2="230" y2="170" class="zm-mpc-edge"/>

          <!-- traveling shares -->
          <circle r="4.5" class="zm-mpc-share">
            <animateMotion dur="2.4s" repeatCount="indefinite"
              path="M 190,80 L 85,140 L 295,140 Z"/>
          </circle>
          <circle r="4.5" class="zm-mpc-share-b">
            <animateMotion dur="2.4s" begin="-0.8s" repeatCount="indefinite"
              path="M 190,80 L 85,140 L 295,140 Z"/>
          </circle>
          <circle r="4.5" class="zm-mpc-share-c">
            <animateMotion dur="2.4s" begin="-1.6s" repeatCount="indefinite"
              path="M 190,80 L 85,140 L 295,140 Z"/>
          </circle>

          <!-- Center: joint result -->
          <g>
            <rect x="138" y="95" width="104" height="32" rx="5" fill="white" stroke="#0891b2" stroke-width="2"/>
            <text x="190" y="116" text-anchor="middle" class="zm-mpc-result">f(x₁,x₂,x₃)</text>
          </g>
        </svg>

        <ul class="zm-attrs">
          <li><span class="zm-attr-key">隠す対象</span><span class="zm-attr-val">各参加者の入力</span></li>
          <li><span class="zm-attr-key">信頼前提</span><span class="zm-attr-val">k-of-n の party を信頼 (t 未満が corrupt)</span></li>
          <li><span class="zm-attr-key">敵対モデル</span><span class="zm-attr-val"><strong>Party</strong> (最大 t 名が逸脱: semi-honest / malicious)</span></li>
          <li class="zm-attr-emph"><span class="zm-attr-key">主な用途</span><span class="zm-attr-val">秘密入札 — 入札額を漏らさず最高値を決定</span></li>
        </ul>
      </div>

      <!-- ============================ FHE ============================ -->
      <div class="zm-col zm-col-fhe">
        <div class="zm-col-head">
          <div class="zm-col-name">FHE</div>
          <div class="zm-col-purpose"><strong>自分のデータを見せずに</strong>計算させる</div>
        </div>

        <svg class="zm-scene" viewBox="0 0 380 200" preserveAspectRatio="xMidYMid meet">
          <defs>
            <marker id="zm-fhe-ar" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto">
              <path d="M 0,0 L 10,5 L 0,10 z" fill="#7c3aed"/>
            </marker>
          </defs>

          <!-- top formula label -->
          <text x="190" y="22" text-anchor="middle" class="zm-scene-formula">サーバはデータを見ない</text>

          <!-- User (left) -->
          <g>
            <rect x="15" y="50" width="130" height="100" rx="9" fill="#f5f3ff" stroke="#c4b5fd" stroke-width="2"/>
            <g transform="translate(80, 80)">
              <circle cx="0" cy="-7" r="7" fill="#6d28d9"/>
              <path d="M -10,4 Q 0,1 10,4 L 9,17 L -9,17 Z" fill="#6d28d9"/>
            </g>
            <text x="80" y="120" text-anchor="middle" class="zm-actor-title">User</text>
            <text x="80" y="140" text-anchor="middle" class="zm-actor-sub">x 🔒</text>
          </g>

          <!-- E(x) wire out (top) -->
          <line x1="145" y1="85" x2="235" y2="85" class="zm-fhe-wire" marker-end="url(#zm-fhe-ar)"/>
          <g>
            <rect x="160" y="73" width="60" height="20" rx="3" fill="white" stroke="#7c3aed" stroke-width="1.2"/>
            <text x="190" y="88" text-anchor="middle" class="zm-fhe-tag">E(x)</text>
          </g>

          <!-- Server (right) -->
          <g>
            <rect x="235" y="50" width="130" height="100" rx="9" fill="#f5f3ff" stroke="#c4b5fd" stroke-width="2"/>
            <g transform="translate(300, 82)" class="zm-fhe-gear">
              <circle cx="0" cy="0" r="14" fill="none" stroke="#6d28d9" stroke-width="2.2"/>
              <circle cx="0" cy="0" r="4.5" fill="#6d28d9"/>
              <g v-for="i in 8" :key="i">
                <rect :x="-1.6" :y="-19" width="3.2" height="7" rx="0.7"
                      :transform="`rotate(${i * 45})`" fill="#6d28d9"/>
              </g>
            </g>
            <text x="300" y="120" text-anchor="middle" class="zm-actor-title">Server</text>
            <text x="300" y="140" text-anchor="middle" class="zm-actor-sub">blind eval</text>
          </g>

          <!-- E(f(x)) wire back (bottom) -->
          <line x1="235" y1="115" x2="145" y2="115" class="zm-fhe-wire" marker-end="url(#zm-fhe-ar)"/>
          <g>
            <rect x="156" y="103" width="76" height="20" rx="3" fill="white" stroke="#7c3aed" stroke-width="1.2"/>
            <text x="194" y="118" text-anchor="middle" class="zm-fhe-tag">E(f(x))</text>
          </g>
        </svg>

        <ul class="zm-attrs">
          <li><span class="zm-attr-key">隠す対象</span><span class="zm-attr-val">計算データと中間状態</span></li>
          <li><span class="zm-attr-key">信頼前提</span><span class="zm-attr-val">Server を信頼 (正しく計算するか)</span></li>
          <li><span class="zm-attr-key">敵対モデル</span><span class="zm-attr-val"><strong>盗聴者</strong> (復号・改ざん) ／ <strong>Server</strong> (復号試行)</span></li>
          <li class="zm-attr-emph"><span class="zm-attr-key">主な用途</span><span class="zm-attr-val">暗号文 AI 診断 — 医療データを暗号化のまま分析</span></li>
        </ul>
      </div>

    </div>
  </div>
</template>

<style scoped>
.zm-root {
  position: relative;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 10px;
  font-family: 'Noto Sans JP', sans-serif;
  color: #111827;
}

/* Header strip */
.zm-header {
  padding: 9px 18px;
  background: #eef2ff;
  border: 1px solid #c7d2fe;
  border-radius: 0.5rem;
  font-size: 15px;
  color: #1e1b4b;
  font-weight: 700;
  text-align: center;
  letter-spacing: 0.01em;
}
.zm-header strong { color: #4338ca; }

/* 3-column grid */
.zm-grid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 14px;
}

.zm-col {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 16px;
  border-radius: 14px;
  border: 2px solid;
  background: white;
}
.zm-col-zk  { border-color: #fcd34d; background: linear-gradient(180deg, #fffbeb 0%, white 35%); }
.zm-col-mpc { border-color: #67e8f9; background: linear-gradient(180deg, #ecfeff 0%, white 35%); }
.zm-col-fhe { border-color: #c4b5fd; background: linear-gradient(180deg, #f5f3ff 0%, white 35%); }

/* Column head — consistent 3-line structure */
.zm-col-head {
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.zm-col-name {
  font-size: 34px;
  font-weight: 900;
  font-family: 'JetBrains Mono', monospace;
  line-height: 1;
  letter-spacing: 0.04em;
  margin-bottom: 2px;
}
.zm-col-zk  .zm-col-name { color: #b45309; }
.zm-col-mpc .zm-col-name { color: #0e7490; }
.zm-col-fhe .zm-col-name { color: #6d28d9; }

.zm-col-purpose {
  font-size: 15px;
  color: #1f2937;
  font-family: 'BIZ UDPMincho', serif;
  line-height: 1.4;
}
.zm-col-purpose strong { font-weight: 800; }
.zm-col-zk  .zm-col-purpose strong { color: #92400e; }
.zm-col-mpc .zm-col-purpose strong { color: #155e75; }
.zm-col-fhe .zm-col-purpose strong { color: #5b21b6; }


/* Scene */
.zm-scene {
  width: 100%;
  height: auto;
  display: block;
}

.zm-actor-title {
  font-size: 17px;
  font-weight: 800;
  fill: #1f2937;
  font-family: 'BIZ UDPMincho', serif;
}
.zm-actor-sub {
  font-size: 13px;
  fill: #475569;
  font-family: 'JetBrains Mono', monospace;
  font-weight: 700;
}
.zm-scene-formula {
  font-size: 14px;
  fill: #6b7280;
  font-family: 'JetBrains Mono', monospace;
  font-weight: 700;
}

/* ZK */
.zm-zk-wire {
  stroke: #b45309;
  stroke-width: 2.5;
  stroke-dasharray: 5 3;
  animation: zm-flow 1s linear infinite;
  fill: none;
}
@keyframes zm-flow { to { stroke-dashoffset: -16; } }
.zm-zk-particle {
  animation: zm-zk-fly 2s ease-in-out infinite;
}
@keyframes zm-zk-fly {
  0%   { transform: translateX(0);    opacity: 0; }
  10%  { opacity: 1; }
  90%  { opacity: 1; }
  100% { transform: translateX(75px); opacity: 0; }
}
.zm-zk-tag {
  font-size: 12px;
  font-weight: 900;
  fill: white;
  font-family: 'JetBrains Mono', monospace;
}

/* MPC */
.zm-mpc-edge {
  stroke: #0891b2;
  stroke-width: 1.8;
  stroke-dasharray: 4 3;
  opacity: 0.55;
  animation: zm-flow 1.4s linear infinite;
}
.zm-mpc-share   { fill: #0891b2; filter: drop-shadow(0 0 4px rgba(8,145,178,0.7)); }
.zm-mpc-share-b { fill: #06b6d4; filter: drop-shadow(0 0 4px rgba(6,182,212,0.7)); }
.zm-mpc-share-c { fill: #14b8a6; filter: drop-shadow(0 0 4px rgba(20,184,166,0.7)); }
.zm-mpc-result {
  font-size: 14px;
  font-weight: 800;
  fill: #0e4d57;
  font-family: 'JetBrains Mono', monospace;
}

/* FHE */
.zm-fhe-wire {
  stroke: #7c3aed;
  stroke-width: 2.5;
  stroke-dasharray: 5 3;
  animation: zm-flow 1s linear infinite;
  fill: none;
}
/* gear is static — no spin animation */
.zm-fhe-tag {
  font-size: 13px;
  font-weight: 800;
  fill: #4c1d95;
  font-family: 'JetBrains Mono', monospace;
}

/* Attribute table — generous padding, aligned rows */
.zm-attrs {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.zm-attrs li {
  display: grid;
  grid-template-columns: 78px 1fr;
  gap: 10px;
  padding: 8px 12px;
  background: rgba(255,255,255,0.75);
  border-radius: 6px;
  border-left: 3px solid;
  font-size: 12.5px;
  line-height: 1.45;
  min-height: 44px;
  align-items: center;
}
.zm-col-zk  .zm-attrs li { border-left-color: #fcd34d; }
.zm-col-mpc .zm-attrs li { border-left-color: #67e8f9; }
.zm-col-fhe .zm-attrs li { border-left-color: #c4b5fd; }

.zm-attr-key {
  font-weight: 800;
  font-size: 11px;
  color: #6b7280;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.05em;
}
.zm-attr-val {
  color: #1f2937;
  font-family: 'BIZ UDPMincho', serif;
  font-weight: 600;
}
.zm-attr-val strong {
  font-weight: 800;
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.95em;
}
.zm-col-zk  .zm-attr-val strong { color: #92400e; }
.zm-col-mpc .zm-attr-val strong { color: #155e75; }
.zm-col-fhe .zm-attr-val strong { color: #5b21b6; }

/* Emphasized "主な用途" row at bottom of each column */
.zm-attr-emph {
  font-size: 14px !important;
  font-weight: 800;
  border-left-width: 6px !important;
  padding: 10px 12px !important;
}
.zm-col-zk  .zm-attr-emph { background: #fef3c7; }
.zm-col-mpc .zm-attr-emph { background: #cffafe; }
.zm-col-fhe .zm-attr-emph { background: #ede9fe; }

.zm-attr-emph .zm-attr-key { font-size: 12px; }
.zm-attr-emph .zm-attr-val { font-size: 15px; font-weight: 800; }
.zm-col-zk  .zm-attr-emph .zm-attr-key { color: #92400e; }
.zm-col-mpc .zm-attr-emph .zm-attr-key { color: #155e75; }
.zm-col-fhe .zm-attr-emph .zm-attr-key { color: #5b21b6; }
.zm-col-zk  .zm-attr-emph .zm-attr-val { color: #78350f; }
.zm-col-mpc .zm-attr-emph .zm-attr-val { color: #0e4d57; }
.zm-col-fhe .zm-attr-emph .zm-attr-val { color: #4c1d95; }
</style>
