<script setup>
import { computed } from 'vue'

const isFirstSlide = computed(() => $nav.currentPage === 1)
const isDarkSlide = computed(() => [4, 7, 14, 24, 33, 42, 48].includes($nav.currentPage))
</script>

<template>
  <div v-if="!isFirstSlide" class="deck-footer" :class="{ 'is-dark': isDarkSlide }">
    <span class="deck-label">WEEK 2 · MULTI-PARTY COMPUTATION</span>
    <span class="deck-rule" />
    <img src="/images/merklejapan_logo.png" alt="Merkle Japan" class="mj-logo" />
    <span class="page-number">{{ String($nav.currentPage).padStart(2, '0') }}</span>
  </div>
</template>

<style scoped>
.deck-footer {
  position: fixed;
  right: 30px;
  bottom: 20px;
  left: 48px;
  z-index: 100;
  display: flex;
  align-items: center;
  gap: 12px;
  pointer-events: none;
}

.deck-label {
  font-family: 'Noto Sans JP', sans-serif;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.14em;
  color: #64748b;
}

.deck-rule {
  height: 1px;
  flex: 1;
  background: linear-gradient(90deg, rgba(14, 165, 164, 0.42), rgba(148, 163, 184, 0.14));
}

.mj-logo {
  width: 74px;
  height: auto;
  border-radius: 7px;
  opacity: 0.82;
}

.deck-footer.is-dark .deck-label {
  color: rgba(255, 255, 255, 0.62);
}

.deck-footer.is-dark .deck-rule {
  background: linear-gradient(90deg, rgba(46, 211, 183, 0.68), rgba(255, 255, 255, 0.12));
}

.deck-footer.is-dark .mj-logo {
  padding: 5px 6px;
  background: rgba(255, 255, 255, 0.94);
  opacity: 1;
}

.deck-footer.is-dark .page-number {
  background: #2ed3b7;
  color: #07152f;
}

.page-number {
  display: grid;
  width: 30px;
  height: 30px;
  place-items: center;
  border-radius: 50%;
  background: #0b1f3a;
  font-family: 'Noto Sans JP', sans-serif;
  font-size: 11px;
  font-weight: 800;
  color: #ffffff;
}
</style>
