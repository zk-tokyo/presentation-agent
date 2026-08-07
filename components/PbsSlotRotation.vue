<template>
  <div v-click class="pbs-slot-rotation">
    <div class="pbs-slot-rotation-track">
      <div class="pbs-slot"><MathInline expr="m_0" /></div>
      <div class="pbs-slot is-ellipsis">…</div>
      <div class="pbs-slot"><MathInline expr="m_0" /></div>
      <div class="pbs-slot is-ellipsis">…</div>
      <div class="pbs-slot is-target"><MathInline expr="m_i" /></div>
      <div class="pbs-slot is-ellipsis">…</div>
      <div class="pbs-slot is-target"><MathInline expr="m_i" /></div>
      <div class="pbs-slot is-ellipsis">…</div>
      <div class="pbs-slot"><MathInline expr="m_{p-1}" /></div>
      <div class="pbs-slot is-ellipsis">…</div>
      <div class="pbs-slot"><MathInline expr="m_{p-1}" /></div>

      <div aria-hidden="true" class="pbs-slot"><MathInline expr="m_0" /></div>
      <div aria-hidden="true" class="pbs-slot is-ellipsis">…</div>
      <div aria-hidden="true" class="pbs-slot"><MathInline expr="m_0" /></div>
      <div aria-hidden="true" class="pbs-slot is-ellipsis">…</div>
    </div>
  </div>
</template>

<style scoped>
.pbs-slot-rotation {
  height: 34px;
  overflow: hidden;
  border: 1px solid #17324d;
  border-right: 0;
}

.pbs-slot-rotation.slidev-vclick-hidden {
  opacity: 1 !important;
  pointer-events: auto !important;
  user-select: auto !important;
}

.pbs-slot-rotation-track {
  display: grid;
  grid-template-columns: 1fr 0.55fr 1fr 0.55fr 1fr 0.55fr 1fr 0.55fr 1.25fr 0.55fr 1.25fr 1fr 0.55fr 1fr 0.55fr;
  width: 133.513514%;
  height: 100%;
  transform: translateX(0);
  transition: transform 900ms cubic-bezier(0.45, 0, 0.2, 1);
  will-change: transform;
}

.pbs-slot-rotation:not(.slidev-vclick-hidden) .pbs-slot-rotation-track {
  transform: translateX(-25.101215%);
}

.pbs-slot {
  display: grid;
  place-items: center;
  border-right: 1px solid #17324d;
  font-size: 0.8rem;
}

.pbs-slot.is-target {
  background: #f2f7fc;
}

@media (prefers-reduced-motion: reduce) {
  .pbs-slot-rotation-track {
    transition: none;
  }
}
</style>
