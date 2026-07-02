<script setup lang="ts"></script>

<template>
  <div class="df-root">
    <svg class="df-svg" viewBox="0 0 1180 480" preserveAspectRatio="xMidYMid meet">
      <defs>
        <marker id="df-arrow" viewBox="0 0 8 8" refX="7" refY="4" markerWidth="7" markerHeight="7" orient="auto-start-reverse">
          <path d="M0,0 L8,4 L0,8 Z" class="df-arrow-head" />
        </marker>
      </defs>

      <!-- ===== Edges ===== -->
      <g class="df-edges">
        <path d="M160,229 C200,229 220,130 260,130" class="df-edge" marker-end="url(#df-arrow)" />
        <path d="M160,229 C200,229 220,328 260,328" class="df-edge" marker-end="url(#df-arrow)" />

        <path d="M440,130 C480,130 520,71 560,71" class="df-edge" marker-end="url(#df-arrow)" />
        <path d="M440,130 C480,130 520,189 560,189" class="df-edge" marker-end="url(#df-arrow)" />

        <path d="M750,71 C790,71 820,35 860,35" class="df-edge" marker-end="url(#df-arrow)" />
        <path d="M750,71 C790,71 820,107 860,107" class="df-edge" marker-end="url(#df-arrow)" />

        <path d="M440,328 C480,328 520,276 560,276" class="df-edge" marker-end="url(#df-arrow)" />
        <path d="M440,328 C480,328 520,380 560,380" class="df-edge" marker-end="url(#df-arrow)" />

        <path d="M750,380 C790,380 820,343 860,343" class="df-edge" marker-end="url(#df-arrow)" />
        <path d="M750,380 C790,380 820,417 860,417" class="df-edge" marker-end="url(#df-arrow)" />
      </g>

      <!-- ===== Edge labels ===== -->
      <g class="df-edge-labels">
        <text x="210" y="182" text-anchor="middle" class="df-elabel">証明</text>
        <text x="210" y="280" text-anchor="middle" class="df-elabel">計算結果</text>

        <text x="500" y="103" text-anchor="middle" class="df-elabel">単独</text>
        <text x="500" y="162" text-anchor="middle" class="df-elabel">複数者(分散)</text>

        <text x="805" y="46" text-anchor="middle" class="df-elabel">回路</text>
        <text x="805" y="92" text-anchor="middle" class="df-elabel">任意プログラム</text>

        <text x="500" y="301" text-anchor="middle" class="df-elabel">複数者(共同計算)</text>
        <text x="500" y="360" text-anchor="middle" class="df-elabel">第三者に委託</text>

        <text x="805" y="355" text-anchor="middle" class="df-elabel">いいえ</text>
        <text x="805" y="401" text-anchor="middle" class="df-elabel">はい</text>
      </g>

      <!-- ===== Question nodes ===== -->
      <g class="df-node df-node-q">
        <rect x="20" y="198" width="140" height="62" rx="10" class="df-q-bg" />
        <text x="90" y="222" text-anchor="middle" class="df-q-text">欲しい</text>
        <text x="90" y="244" text-anchor="middle" class="df-q-text">成果物は?</text>
      </g>

      <g class="df-node df-node-q">
        <rect x="260" y="99" width="180" height="62" rx="10" class="df-q-bg" />
        <text x="350" y="123" text-anchor="middle" class="df-q-text">witness (秘密情報) は</text>
        <text x="350" y="145" text-anchor="middle" class="df-q-text">誰が持つ?</text>
      </g>

      <g class="df-node df-node-q">
        <rect x="260" y="299" width="180" height="58" rx="10" class="df-q-bg" />
        <text x="350" y="333" text-anchor="middle" class="df-q-text">誰が計算する?</text>
      </g>

      <g class="df-node df-node-q">
        <rect x="560" y="40" width="190" height="62" rx="10" class="df-q-bg" />
        <text x="655" y="64" text-anchor="middle" class="df-q-text">証明対象は</text>
        <text x="655" y="86" text-anchor="middle" class="df-q-text">回路 or 任意プログラム?</text>
      </g>

      <g class="df-node df-node-q">
        <rect x="560" y="349" width="190" height="62" rx="10" class="df-q-bg" />
        <text x="655" y="373" text-anchor="middle" class="df-q-text">その計算の正しさも</text>
        <text x="655" y="395" text-anchor="middle" class="df-q-text">証明したい?</text>
      </g>

      <!-- ===== Leaf / outcome nodes ===== -->
      <g class="df-node df-node-leaf">
        <rect x="860" y="10" width="120" height="50" rx="10" class="df-leaf-bg" />
        <text x="920" y="41" text-anchor="middle" class="df-leaf-title">ZK</text>
      </g>

      <g class="df-node df-node-leaf">
        <rect x="860" y="81" width="180" height="52" rx="10" class="df-leaf-bg" />
        <text x="950" y="113" text-anchor="middle" class="df-leaf-title">zkVM</text>
      </g>

      <g class="df-node df-node-leaf">
        <rect x="560" y="163" width="240" height="52" rx="10" class="df-leaf-bg" />
        <text x="680" y="195" text-anchor="middle" class="df-leaf-title">co-SNARK</text>
      </g>

      <g class="df-node df-node-leaf">
        <rect x="560" y="250" width="140" height="52" rx="10" class="df-leaf-bg" />
        <text x="630" y="282" text-anchor="middle" class="df-leaf-title">MPC</text>
      </g>

      <g class="df-node df-node-leaf">
        <rect x="860" y="318" width="120" height="50" rx="10" class="df-leaf-bg" />
        <text x="920" y="349" text-anchor="middle" class="df-leaf-title">FHE</text>
      </g>

      <g class="df-node df-node-leaf">
        <rect x="860" y="391" width="240" height="52" rx="10" class="df-leaf-bg" />
        <text x="980" y="423" text-anchor="middle" class="df-leaf-title">Verifiable FHE</text>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.df-root {
  width: 100%;
  display: flex;
  justify-content: center;
}
.df-svg {
  width: 100%;
  max-width: 1080px;
  height: auto;
  display: block;
  font-family: 'Noto Sans JP', sans-serif;
}

.df-edge {
  fill: none;
  stroke: #9ca3af;
  stroke-width: 1.75;
}
.df-arrow-head {
  fill: #9ca3af;
}

.df-elabel {
  font-size: 12.5px;
  font-weight: 600;
  fill: #6b7280;
  paint-order: stroke;
  stroke: #ffffff;
  stroke-width: 5px;
  stroke-linejoin: round;
}

.df-q-bg {
  fill: #ffffff;
  stroke: #d1d5db;
  stroke-width: 1.5;
}
.df-q-text {
  font-size: 14.5px;
  font-weight: 700;
  fill: #111827;
}

.df-leaf-bg {
  fill: #fffbeb;
  stroke: #f59e0b;
  stroke-width: 2;
}
.df-leaf-title {
  font-size: 18px;
  font-weight: 900;
  fill: #b45309;
}
</style>
