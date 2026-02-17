<script setup lang="ts">
const route = useRoute()

const navItems = [
  { to: '/', label: 'ホーム' },
  { to: '/companies/new', label: '会社' },
  { to: '/tasks/new', label: '業務設定' },
  { to: '/tasks', label: 'ジョブ' },
  { to: '/issues', label: '不具合' },
  { to: '/dashboard', label: '分析' },
  { to: '/notifications', label: '通知' }
]

function isActive(path: string) {
  if (path === '/') return route.path === '/'
  return route.path.startsWith(path)
}
</script>

<template>
  <div class="app-shell">
    <div class="app-shell__bg" />
    <header class="app-header">
      <div class="app-header__brand">
        <p class="app-header__eyebrow">Facility Ops Suite</p>
        <h1>Inspection Control Board</h1>
      </div>
      <nav class="app-nav">
        <NuxtLink
          v-for="item in navItems"
          :key="item.to"
          :to="item.to"
          class="app-nav__item"
          :class="{ 'is-active': isActive(item.to) }"
        >
          {{ item.label }}
        </NuxtLink>
      </nav>
    </header>

    <main class="app-content">
      <NuxtPage />
    </main>
  </div>
</template>
