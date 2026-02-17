<script setup lang="ts">
import { ApiError } from '~/lib/api/client'
import { getDashboard } from '~/lib/api/dashboard'
import type { DashboardSummary } from '~/types/api'

const companyId = ref(1)
const loading = ref(false)
const errorMessage = ref('')
const dashboard = ref<DashboardSummary | null>(null)

async function loadDashboard() {
  loading.value = true
  errorMessage.value = ''

  try {
    dashboard.value = await getDashboard(companyId.value)
  } catch (error) {
    if (error instanceof ApiError) {
      errorMessage.value = error.payload?.message || `取得に失敗しました (status: ${error.status})`
    } else {
      errorMessage.value = '取得に失敗しました'
    }
  } finally {
    loading.value = false
  }
}

await loadDashboard()
</script>

<template>
  <main class="page">
    <h1>オーナーダッシュボード</h1>

    <form class="controls" @submit.prevent="loadDashboard">
      <label>
        Company ID
        <input v-model.number="companyId" type="number" min="1" />
      </label>
      <button type="submit">再取得</button>
    </form>

    <p v-if="loading">読み込み中...</p>
    <p v-else-if="errorMessage" class="error">{{ errorMessage }}</p>

    <template v-else-if="dashboard">
      <section class="totals">
        <div class="tile">
          <strong>物件数</strong>
          <span>{{ dashboard.totals.property_count }}</span>
        </div>
        <div class="tile">
          <strong>未解決不具合</strong>
          <span>{{ dashboard.totals.open_issue_count }}</span>
        </div>
        <div class="tile">
          <strong>完了ジョブ</strong>
          <span>{{ dashboard.totals.completed_job_count }}</span>
        </div>
      </section>

      <table class="table">
        <thead>
          <tr>
            <th>Property</th>
            <th>最新点検Job</th>
            <th>最新点検完了時刻</th>
            <th>未解決不具合</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="summary in dashboard.properties" :key="summary.property_id">
            <td>{{ summary.property_name }}</td>
            <td>{{ summary.latest_inspection_job_id ?? '-' }}</td>
            <td>{{ summary.latest_inspection_at ?? '-' }}</td>
            <td>{{ summary.open_issue_count }}</td>
          </tr>
        </tbody>
      </table>
    </template>

    <p><NuxtLink to="/tasks">ジョブ一覧へ</NuxtLink></p>
  </main>
</template>

<style scoped>
.page { max-width: 980px; margin: 32px auto; padding: 0 16px; font-family: sans-serif; }
.controls { display: flex; gap: 12px; align-items: end; margin-bottom: 16px; }
.totals { display: grid; grid-template-columns: repeat(3, minmax(120px, 1fr)); gap: 12px; margin-bottom: 16px; }
.tile { border: 1px solid #ddd; border-radius: 8px; padding: 10px; display: grid; gap: 4px; }
.table { width: 100%; border-collapse: collapse; }
th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
.error { color: #b3261e; }
</style>
