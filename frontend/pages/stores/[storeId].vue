<script setup lang="ts">
import { ApiError } from '~/lib/api/client'
import { createSpace, listSpaces } from '~/lib/api/spaces'
import type { Space } from '~/types/api'

const route = useRoute()
const storeId = computed(() => Number(route.params.storeId))

const spaces = ref<Space[]>([])
const spaceName = ref('')
const floorLabel = ref('')
const loading = ref(false)
const submitting = ref(false)
const errorMessage = ref('')

async function load() {
  loading.value = true
  errorMessage.value = ''
  try {
    spaces.value = await listSpaces(storeId.value)
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

async function submitSpace() {
  submitting.value = true
  errorMessage.value = ''
  try {
    await createSpace(storeId.value, spaceName.value, floorLabel.value)
    spaceName.value = ''
    floorLabel.value = ''
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
    <h1>スペース登録</h1>
    <p>Store ID: {{ storeId }}</p>

    <form class="form" @submit.prevent="submitSpace">
      <label>
        スペース名
        <input v-model="spaceName" type="text" required />
      </label>
      <label>
        フロア
        <input v-model="floorLabel" type="text" placeholder="例: 1F" />
      </label>
      <button type="submit" :disabled="submitting">{{ submitting ? '登録中...' : 'スペースを登録' }}</button>
    </form>

    <p v-if="loading">読み込み中...</p>
    <p v-else-if="errorMessage" class="error">{{ errorMessage }}</p>
    <ul v-else-if="spaces.length">
      <li v-for="space in spaces" :key="space.id">
        <NuxtLink :to="`/spaces/${space.id}`">{{ space.name }} <span v-if="space.floor_label">({{ space.floor_label }})</span></NuxtLink>
      </li>
    </ul>
    <p v-else>登録済みスペースはありません。</p>

    <p><NuxtLink to="/">トップへ戻る</NuxtLink></p>
  </main>
</template>

