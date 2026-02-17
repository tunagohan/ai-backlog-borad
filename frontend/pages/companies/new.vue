<script setup lang="ts">
import { createCompany } from '~/lib/api/companies'
import { ApiError } from '~/lib/api/client'

const companyName = ref('')
const createdCompanyId = ref<number | null>(null)
const loading = ref(false)
const errorMessage = ref('')

async function submit() {
  loading.value = true
  errorMessage.value = ''

  try {
    const company = await createCompany(companyName.value)
    createdCompanyId.value = company.id
    companyName.value = ''
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
    <h1>会社登録</h1>

    <form class="form" @submit.prevent="submit">
      <label>
        会社名
        <input v-model="companyName" type="text" required />
      </label>
      <button :disabled="loading" type="submit">{{ loading ? '登録中...' : '登録する' }}</button>
    </form>

    <p v-if="errorMessage" class="error">{{ errorMessage }}</p>

    <p v-if="createdCompanyId" class="success">
      登録完了: Company ID {{ createdCompanyId }}
      <NuxtLink :to="`/properties?companyId=${createdCompanyId}`">物件登録/一覧へ</NuxtLink>
    </p>

    <p><NuxtLink to="/">トップへ戻る</NuxtLink></p>
  </main>
</template>

<style scoped>
.page { max-width: 760px; margin: 40px auto; font-family: sans-serif; padding: 0 16px; }
.form { display: grid; gap: 12px; max-width: 320px; }
.error { color: #b3261e; }
.success { color: #1f7a39; }
</style>
