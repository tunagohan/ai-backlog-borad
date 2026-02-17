<script setup lang="ts">
defineProps<{
  label: string
  value: string | number
  hint?: string
}>()
</script>

<template>
  <article class="tile app-metric-card">
    <strong>{{ label }}</strong>
    <span>{{ value }}</span>
    <small v-if="hint" class="app-metric-card__hint">{{ hint }}</small>
  </article>
</template>

<style scoped>
.app-metric-card__hint {
  color: var(--muted);
  font-size: 0.8rem;
}
</style>
