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
    displayMode: false,
    throwOnError: false,
    strict: 'ignore',
  }),
)
</script>

<template>
  <span class="week5-html-math week5-html-math-inline" v-html="html" />
</template>
