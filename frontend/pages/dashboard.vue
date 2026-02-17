<script setup lang="ts">
import { ApiError } from '~/lib/api/client'
import { getDashboard } from '~/lib/api/dashboard'
import type { DashboardSummary } from '~/types/api'

const companyId = ref(1)
const loading = ref(false)
const errorMessage = ref('')
const dashboard = ref<DashboardSummary | null>(null)
const config = useRuntimeConfig()

const csvDownloadUrl = computed(
  () => `${config.public.apiBaseUrl}/dashboard.csv?company_id=${companyId.value}`
)

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
      <a :href="csvDownloadUrl">CSVダウンロード</a>
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
        <div class="tile">
          <strong>平均解消時間 (h)</strong>
          <span>{{ dashboard.totals.avg_resolution_hours ?? '-' }}</span>
        </div>
      </section>

      <table class="table">
        <thead>
          <tr>
            <th>Property</th>
            <th>最新点検Job</th>
            <th>最新点検完了時刻</th>
            <th>未解決不具合</th>
            <th>平均解消時間 (h)</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="summary in dashboard.properties" :key="summary.property_id">
            <td>{{ summary.property_name }}</td>
            <td>{{ summary.latest_inspection_job_id ?? '-' }}</td>
            <td>{{ summary.latest_inspection_at ?? '-' }}</td>
            <td>{{ summary.open_issue_count }}</td>
            <td>{{ summary.avg_resolution_hours ?? '-' }}</td>
          </tr>
        </tbody>
      </table>
    </template>

    <p><NuxtLink to="/tasks">ジョブ一覧へ</NuxtLink></p>
  </main>
</template>
