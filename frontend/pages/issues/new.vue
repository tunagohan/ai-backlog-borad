<script setup lang="ts">
import { ApiError } from '~/lib/api/client'
import { createIssue } from '~/lib/api/issues'

const route = useRoute()

const form = reactive({
  companyId: Number(route.query.companyId || 1),
  jobId: Number(route.query.jobId || 1),
  title: '',
  description: '',
  imageUrlsText: '',
  severity: 'medium' as 'low' | 'medium' | 'high'
})

const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

async function submit() {
  loading.value = true
  errorMessage.value = ''

  try {
    const issue = await createIssue({
      company_id: form.companyId,
      job_id: form.jobId,
      title: form.title,
      description: form.description,
      image_urls: form.imageUrlsText
        .split('\n')
        .map((url) => url.trim())
        .filter(Boolean),
      severity: form.severity
    })

    successMessage.value = `不具合を登録しました: ID ${issue.id}`
    form.title = ''
    form.description = ''
    form.imageUrlsText = ''
  } catch (error) {
    if (error instanceof ApiError) {
      errorMessage.value = error.payload?.message || `登録に失敗しました (status: ${error.status})`
    } else {
      errorMessage.value = '登録に失敗しました'
    }
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <main class="page">
    <h1>不具合報告</h1>

    <form class="form" @submit.prevent="submit">
      <label>Company ID<input v-model.number="form.companyId" type="number" min="1" required /></label>
      <label>Job ID<input v-model.number="form.jobId" type="number" min="1" required /></label>
      <label>タイトル<input v-model="form.title" type="text" required /></label>
      <label>詳細<textarea v-model="form.description" rows="4" /></label>
      <label>画像URL（改行区切り）<textarea v-model="form.imageUrlsText" rows="3" placeholder="https://example.com/image1.jpg" /></label>
      <label>
        緊急度
        <select v-model="form.severity">
          <option value="low">low</option>
          <option value="medium">medium</option>
          <option value="high">high</option>
        </select>
      </label>
      <button type="submit" :disabled="loading">{{ loading ? '送信中...' : '登録する' }}</button>
    </form>

    <p v-if="successMessage" class="success">{{ successMessage }}</p>
    <p v-if="errorMessage" class="error">{{ errorMessage }}</p>

    <p><NuxtLink to="/issues">不具合一覧へ</NuxtLink></p>
  </main>
</template>

