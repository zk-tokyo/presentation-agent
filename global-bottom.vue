<script setup>
import { computed } from 'vue'

const isFirstSlide = computed(() => $nav.currentPage === 1)
</script>

<template>
  <div class="mj-footer">
    <img src="/images/merklejapan_logo.png" alt="Merkle Japan" class="mj-logo" />
    <span v-if="!isFirstSlide" class="page-number">{{ $nav.currentPage }}</span>
  </div>
</template>

<style scoped>
.mj-footer {
  position: fixed;
  bottom: 16px;
  right: 24px;
  z-index: 100;
  display: flex;
  align-items: center;
  gap: 8px;
  pointer-events: none;
}

.mj-logo {
  width: 96px;
  height: auto;
  opacity: 0.9;
}

.page-number {
  font-family: 'BIZ UDPMincho', serif;
  font-size: 14px;
  color: #000000;
  margin-left: 8px;
}
</style>
