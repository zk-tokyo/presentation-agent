<script setup>
defineProps({
  term: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  label: {
    type: String,
    default: 'TERM',
  },
})
</script>

<template>
  <aside class="term-note">
    <span class="term-note-label">{{ label }}</span>
    <strong class="term-note-term">{{ term }}</strong>
    <p>{{ description }}</p>
  </aside>
</template>

<style scoped>
.term-note {
  position: relative;
  padding: 1rem 1rem 0.95rem 1.15rem;
  border: 1px solid #cfe3e5;
  border-left: 5px solid #0ea5a4;
  border-radius: 0 12px 12px 0;
  background: linear-gradient(120deg, rgba(230, 248, 245, 0.92), rgba(248, 251, 253, 0.96));
  box-shadow: 0 8px 22px rgba(11, 31, 58, 0.06);
}

.term-note-label {
  display: block;
  margin-bottom: 0.2rem;
  font-size: 0.66rem;
  font-weight: 800;
  letter-spacing: 0.15em;
  color: #0b8782;
}

.term-note-term {
  display: block;
  margin-bottom: 0.36rem;
  font-family: 'Cascadia Mono', 'Noto Sans Mono', monospace !important;
  font-size: 1rem;
  color: #0b1f3a;
}

.term-note p {
  margin: 0 !important;
  font-size: 0.78rem;
  line-height: 1.48;
  color: #475569 !important;
}
</style>
