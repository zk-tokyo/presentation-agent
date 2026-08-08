<script setup>
defineProps({
  class: {
    type: String,
    default: '',
  },
})
</script>

<template>
  <div class="slidev-layout cover" :class="$props.class">
    <div class="cover-kicker">ADVANCED CRYPTOGRAPHY PROGRAM · WEEK 2</div>
    <div class="cover-orbit cover-orbit-a" />
    <div class="cover-orbit cover-orbit-b" />
    <div class="cover-monogram" aria-hidden="true">MPC</div>
    <main class="cover-content">
      <slot />
    </main>
  </div>
</template>

<style scoped>
.cover {
  position: relative;
  width: 100%;
  height: 100%;
  overflow: hidden;
  display: flex;
  align-items: center;
  padding: 5.4rem 5.8rem 4.4rem;
  background:
    radial-gradient(circle at 82% 20%, rgba(46, 211, 183, 0.24), transparent 28%),
    radial-gradient(circle at 8% 92%, rgba(69, 151, 255, 0.18), transparent 26%),
    #07152f;
  color: #f7fbff;
}

.cover::after {
  content: '';
  position: absolute;
  inset: 1.4rem;
  border: 1px solid rgba(211, 232, 249, 0.16);
  border-radius: 26px;
  pointer-events: none;
}

.cover-kicker {
  position: absolute;
  top: 3rem;
  left: 5.8rem;
  z-index: 2;
  font-family: 'Noto Sans JP', sans-serif;
  font-size: 0.78rem;
  font-weight: 700;
  letter-spacing: 0.18em;
  color: #78e4d2;
}

.cover-content {
  position: relative;
  z-index: 2;
  width: 72%;
  text-align: left;
}

.cover-content :deep(h1) {
  max-width: 880px;
  margin: 0 0 1.55rem;
  padding: 0;
  border: 0;
  font-family: 'Noto Sans JP', sans-serif !important;
  font-size: 3.5rem !important;
  font-weight: 800;
  line-height: 1.12;
  letter-spacing: -0.035em;
  color: #f7fbff !important;
}

.cover-content :deep(p) {
  max-width: 820px;
  margin: 0.62rem 0;
  font-family: 'Noto Sans JP', sans-serif !important;
  font-size: 1.14rem;
  line-height: 1.55;
  color: #d8e8f7 !important;
}

.cover-content :deep(p:first-of-type) {
  margin-bottom: 1.8rem;
  padding-left: 1rem;
  border-left: 4px solid #2ed3b7;
  font-size: 1.3rem;
  color: #ffffff !important;
}

.cover-monogram {
  position: absolute;
  right: 4rem;
  bottom: 1.7rem;
  z-index: 1;
  font-family: 'Noto Sans JP', sans-serif;
  font-size: 10.5rem;
  font-weight: 900;
  line-height: 1;
  letter-spacing: -0.09em;
  color: transparent;
  -webkit-text-stroke: 2px rgba(120, 228, 210, 0.16);
  transform: rotate(-5deg);
  user-select: none;
}

.cover-orbit {
  position: absolute;
  z-index: 0;
  border: 1px solid rgba(120, 228, 210, 0.22);
  border-radius: 50%;
}

.cover-orbit-a {
  width: 420px;
  height: 420px;
  right: -130px;
  top: -160px;
}

.cover-orbit-b {
  width: 260px;
  height: 260px;
  right: 78px;
  top: -110px;
}
</style>
