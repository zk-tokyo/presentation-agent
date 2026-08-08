<script setup>
defineProps({
  current: {
    type: Number,
    required: true,
  },
});

const chapters = [
  { number: 1, label: "MPCは何をしたい技術か" },
  { number: 2, label: "問題設定" },
  { number: 3, label: "秘密分散" },
  { number: 4, label: "MPCでの演算" },
  { number: 5, label: "モデルとプロトコル" },
  { number: 6, label: "応用例" },
  { number: 7, label: "比較とまとめ" },
];
</script>

<template>
  <nav class="chapter-map" aria-label="講義全体の構成">
    <div
      v-for="chapter in chapters"
      :key="chapter.number"
      class="chapter-map-item"
      :class="{ active: chapter.number === current }"
    >
      <span class="chapter-map-number">{{
        String(chapter.number).padStart(2, "0")
      }}</span>
      <span class="chapter-map-label">{{ chapter.label }}</span>
    </div>
  </nav>
</template>

<style scoped>
.chapter-map {
  position: relative;
  z-index: 3;
  display: grid;
  width: 100%;
  grid-template-columns: repeat(7, minmax(0, 1fr));
  gap: 9px;
  margin-top: 3rem;
}

.chapter-map-item {
  min-width: 0;
  padding: 0.75rem 0.65rem 0.7rem;
  border-top: 3px solid rgba(255, 255, 255, 0.24);
  color: rgba(255, 255, 255, 0.42);
}

.chapter-map-item.active {
  border-top-color: #2ed3b7;
  border-radius: 0 0 10px 10px;
  background: rgba(46, 211, 183, 0.12);
  color: #ffffff;
}

.chapter-map-number,
.chapter-map-label {
  display: block;
}

.chapter-map-number {
  margin-bottom: 0.24rem;
  font-size: 0.72rem;
  font-weight: 800;
  letter-spacing: 0.12em;
  color: inherit;
}

.chapter-map-item.active .chapter-map-number {
  color: #78e4d2;
}

.chapter-map-label {
  overflow: hidden;
  font-size: 0.72rem;
  font-weight: 700;
  line-height: 1.3;
  text-overflow: ellipsis;
}
</style>
