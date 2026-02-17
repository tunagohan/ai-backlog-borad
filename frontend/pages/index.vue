<script setup lang="ts">
const companyIdInput = ref('1')
const router = useRouter()

function goToProperties() {
  router.push(`/properties?companyId=${companyIdInput.value}`)
}
</script>

<template>
  <main class="page">
    <h1>点検業務管理</h1>
    <p>M1 Setup Foundation の最小UIです。</p>
    <div class="actions">
      <NuxtLink to="/companies/new">会社登録へ</NuxtLink>
      <form @submit.prevent="goToProperties">
        <label>
          Company ID
          <input v-model="companyIdInput" type="number" min="1" />
        </label>
        <button type="submit">物件一覧を表示</button>
      </form>
    </div>
  </main>
</template>

<style scoped>
.page { max-width: 760px; margin: 40px auto; font-family: sans-serif; padding: 0 16px; }
.actions { display: grid; gap: 16px; }
form { display: grid; gap: 8px; max-width: 260px; }
</style>
