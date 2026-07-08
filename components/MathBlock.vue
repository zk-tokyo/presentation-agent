<script setup>
import { computed } from 'vue'
import katex from 'katex'

const props = defineProps({
  expr: {
    type: String,
    required: true,
  },
})

const html = computed(() =>
  katex.renderToString(props.expr, {
    displayMode: true,
    throwOnError: false,
    strict: 'ignore',
  }),
)
</script>

<template>
  <div class="week5-html-math week5-html-math-block" v-html="html" />
</template>
