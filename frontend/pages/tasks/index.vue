<script setup lang="ts">
import { ApiError } from '~/lib/api/client'
import { listInspectionJobs } from '~/lib/api/jobs'
import type { InspectionJob } from '~/types/api'

const companyId = ref(1)
const jobs = ref<InspectionJob[]>([])
const loading = ref(false)
const errorMessage = ref('')

async function loadJobs() {
  loading.value = true
  errorMessage.value = ''

  try {
    jobs.value = await listInspectionJobs(companyId.value)
  } catch (error) {
    if (error instanceof ApiError) {
      errorMessage.value = error.payload?.message || `ジョブ取得に失敗しました (status: ${error.status})`
    } else {
      errorMessage.value = 'ジョブ取得に失敗しました'
    }
  } finally {
    loading.value = false
  }
}

await loadJobs()
</script>

<template>
  <main class="page">
    <h1>点検ジョブ一覧</h1>

    <form class="controls" @submit.prevent="loadJobs">
      <label>
        Company ID
        <input v-model.number="companyId" type="number" min="1" />
      </label>
      <button type="submit">再取得</button>
    </form>

    <p v-if="loading">読み込み中...</p>
    <p v-else-if="errorMessage" class="error">{{ errorMessage }}</p>
    <table v-else-if="jobs.length" class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Template</th>
          <th>Target</th>
          <th>Status</th>
          <th>Scheduled</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="job in jobs" :key="job.id">
          <td>{{ job.id }}</td>
          <td>{{ job.template_name || job.template_id }}</td>
          <td>{{ job.target_type }} #{{ job.target_id }}</td>
          <td>{{ job.status }}</td>
          <td>{{ job.scheduled_for }}</td>
          <td><NuxtLink :to="`/tasks/${job.id}/execute`">実施</NuxtLink></td>
        </tr>
      </tbody>
    </table>
    <p v-else>ジョブはありません。</p>

    <p><NuxtLink to="/tasks/new">ジョブ作成へ</NuxtLink></p>
    <p><NuxtLink to="/issues">不具合一覧へ</NuxtLink></p>
  </main>
</template>

