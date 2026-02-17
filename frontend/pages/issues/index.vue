<script setup lang="ts">
import { ApiError } from '~/lib/api/client'
import { listIssues, updateIssue } from '~/lib/api/issues'
import type { Issue } from '~/types/api'

const companyId = ref(1)
const statusFilter = ref('')
const issues = ref<Issue[]>([])
const loading = ref(false)
const errorMessage = ref('')

async function load() {
  loading.value = true
  errorMessage.value = ''

  try {
    issues.value = await listIssues(companyId.value, statusFilter.value || undefined)
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

async function closeIssue(issueId: number) {
  try {
    await updateIssue(issueId, { status: 'closed' })
    await load()
  } catch (error) {
    if (error instanceof ApiError) {
      errorMessage.value = error.payload?.message || `更新に失敗しました (status: ${error.status})`
    } else {
      errorMessage.value = '更新に失敗しました'
    }
  }
}

await load()
</script>

<template>
  <main class="page">
    <h1>不具合一覧</h1>

    <form class="controls" @submit.prevent="load">
      <label>Company ID<input v-model.number="companyId" type="number" min="1" /></label>
      <label>
        Status
        <select v-model="statusFilter">
          <option value="">all</option>
          <option value="open">open</option>
          <option value="in_progress">in_progress</option>
          <option value="closed">closed</option>
        </select>
      </label>
      <button type="submit">再取得</button>
    </form>

    <p v-if="loading">読み込み中...</p>
    <p v-else-if="errorMessage" class="error">{{ errorMessage }}</p>
    <table v-else-if="issues.length" class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Job</th>
          <th>Title</th>
          <th>Severity</th>
          <th>Status</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="issue in issues" :key="issue.id">
          <td>{{ issue.id }}</td>
          <td>{{ issue.job_id }}</td>
          <td>{{ issue.title }}</td>
          <td>{{ issue.severity }}</td>
          <td>{{ issue.status }}</td>
          <td>
            <button v-if="issue.status !== 'closed'" @click="closeIssue(issue.id)">close</button>
          </td>
        </tr>
      </tbody>
    </table>
    <p v-else>不具合はありません。</p>

    <p><NuxtLink to="/issues/new">不具合報告へ</NuxtLink></p>
  </main>
</template>

<style scoped>
.page { max-width: 900px; margin: 32px auto; padding: 0 16px; font-family: sans-serif; }
.controls { display: flex; gap: 12px; align-items: end; margin-bottom: 12px; }
.table { width: 100%; border-collapse: collapse; }
th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
.error { color: #b3261e; }
</style>
