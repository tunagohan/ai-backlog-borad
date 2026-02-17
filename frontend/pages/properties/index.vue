<script setup lang="ts">
import { createProperty, listProperties } from '~/lib/api/properties'
import { ApiError } from '~/lib/api/client'
import type { Property } from '~/types/api'

const route = useRoute()
const companyId = computed(() => Number(route.query.companyId || 1))

const properties = ref<Property[]>([])
const loading = ref(true)
const submitting = ref(false)
const errorMessage = ref('')
const propertyName = ref('')
const propertyAddress = ref('')

async function load() {
  loading.value = true
  errorMessage.value = ''

  try {
    properties.value = await listProperties(companyId.value)
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

async function submitProperty() {
  submitting.value = true
  errorMessage.value = ''

  try {
    await createProperty(companyId.value, propertyName.value, propertyAddress.value)
    propertyName.value = ''
    propertyAddress.value = ''
    await load()
  } catch (error) {
    if (error instanceof ApiError) {
      errorMessage.value = error.payload?.message || `登録に失敗しました (status: ${error.status})`
    } else {
      errorMessage.value = '登録に失敗しました'
    }
  } finally {
    submitting.value = false
  }
}

await load()
</script>

<template>
  <main class="page">
    <h1>物件一覧</h1>
    <p>Company ID: {{ companyId }}</p>

    <form class="form" @submit.prevent="submitProperty">
      <label>
        物件名
        <input v-model="propertyName" type="text" required />
      </label>
      <label>
        住所
        <input v-model="propertyAddress" type="text" />
      </label>
      <button type="submit" :disabled="submitting">
        {{ submitting ? '登録中...' : '物件を登録' }}
      </button>
    </form>

    <p v-if="loading">読み込み中...</p>
    <p v-else-if="errorMessage" class="error">{{ errorMessage }}</p>
    <ul v-else-if="properties.length">
      <li v-for="property in properties" :key="property.id">
        <NuxtLink :to="`/properties/${property.id}`">
          {{ property.name }} <span v-if="property.address">({{ property.address }})</span>
        </NuxtLink>
      </li>
    </ul>
    <p v-else>登録済み物件はありません。</p>

    <p><NuxtLink to="/companies/new">会社登録へ</NuxtLink></p>
  </main>
</template>
