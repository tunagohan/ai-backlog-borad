<script setup lang="ts">
import { ApiError } from '~/lib/api/client'
import { createStore, listStores } from '~/lib/api/stores'
import type { Store } from '~/types/api'

const route = useRoute()
const propertyId = computed(() => Number(route.params.propertyId))

const stores = ref<Store[]>([])
const storeName = ref('')
const loading = ref(false)
const submitting = ref(false)
const errorMessage = ref('')

async function load() {
  loading.value = true
  errorMessage.value = ''
  try {
    stores.value = await listStores(propertyId.value)
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

async function submitStore() {
  submitting.value = true
  errorMessage.value = ''
  try {
    await createStore(propertyId.value, storeName.value)
    storeName.value = ''
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
    <h1>店舗登録</h1>
    <p>Property ID: {{ propertyId }}</p>

    <form class="form" @submit.prevent="submitStore">
      <label>
        店舗名
        <input v-model="storeName" type="text" required />
      </label>
      <button type="submit" :disabled="submitting">{{ submitting ? '登録中...' : '店舗を登録' }}</button>
    </form>

    <p v-if="loading">読み込み中...</p>
    <p v-else-if="errorMessage" class="error">{{ errorMessage }}</p>
    <ul v-else-if="stores.length">
      <li v-for="store in stores" :key="store.id">
        <NuxtLink :to="`/stores/${store.id}`">{{ store.name }}</NuxtLink>
      </li>
    </ul>
    <p v-else>登録済み店舗はありません。</p>

    <p><NuxtLink to="/">トップへ戻る</NuxtLink></p>
  </main>
</template>

<style scoped>
.page { max-width: 760px; margin: 40px auto; font-family: sans-serif; padding: 0 16px; }
.form { display: grid; gap: 12px; max-width: 320px; margin-bottom: 16px; }
.error { color: #b3261e; }
</style>
