<script setup lang="ts">
const companyIdInput = ref('1')
const router = useRouter()

function goToProperties() {
  router.push(`/properties?companyId=${companyIdInput.value}`)
}
</script>

<template>
  <main class="page">
    <h1>点検業務管理ダッシュボード</h1>
    <p>現場入力からオーナー可視化までの運用導線を、単一画面で管理します。</p>

    <section class="card">
      <h2>主要導線</h2>
      <div class="actions">
        <NuxtLink to="/companies/new">会社登録へ</NuxtLink>
        <NuxtLink to="/tasks/new">業務設定（テンプレート/ジョブ）へ</NuxtLink>
        <NuxtLink to="/tasks">点検ジョブ一覧へ</NuxtLink>
        <NuxtLink to="/issues">不具合一覧へ</NuxtLink>
        <NuxtLink to="/dashboard">オーナーダッシュボードへ</NuxtLink>
        <NuxtLink to="/notifications">通知一覧へ</NuxtLink>
      </div>
    </section>

    <section class="card">
      <h2>会社別物件のクイック移動</h2>
      <form class="form" @submit.prevent="goToProperties">
        <label>
          Company ID
          <input v-model="companyIdInput" type="number" min="1" />
        </label>
        <button type="submit">物件一覧を表示</button>
      </form>
    </section>
  </main>
</template>
