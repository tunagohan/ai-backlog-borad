<script setup lang="ts">
import { ApiError } from '~/lib/api/client'
import { createAsset, listAssets } from '~/lib/api/assets'
import type { Asset } from '~/types/api'

const route = useRoute()
const spaceId = computed(() => Number(route.params.spaceId))

const assets = ref<Asset[]>([])
const form = reactive({
  name: '',
  category: '',
  serialNumber: '',
  installedOn: '',
  status: ''
})

const loading = ref(false)
const submitting = ref(false)
const errorMessage = ref('')

async function load() {
  loading.value = true
  errorMessage.value = ''
  try {
    assets.value = await listAssets(spaceId.value)
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

async function submitAsset() {
  submitting.value = true
  errorMessage.value = ''
  try {
    await createAsset(spaceId.value, form)
    form.name = ''
    form.category = ''
    form.serialNumber = ''
    form.installedOn = ''
    form.status = ''
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
    <h1>資産登録</h1>
    <p>Space ID: {{ spaceId }}</p>

    <form class="form" @submit.prevent="submitAsset">
      <label>資産名<input v-model="form.name" type="text" required /></label>
      <label>カテゴリ<input v-model="form.category" type="text" /></label>
      <label>シリアル<input v-model="form.serialNumber" type="text" /></label>
      <label>設置日<input v-model="form.installedOn" type="date" /></label>
      <label>状態<input v-model="form.status" type="text" placeholder="active" /></label>
      <button type="submit" :disabled="submitting">
        {{ submitting ? '登録中...' : '資産を登録' }}
      </button>
    </form>

    <p v-if="loading">読み込み中...</p>
    <p v-else-if="errorMessage" class="error">{{ errorMessage }}</p>
    <ul v-else-if="assets.length">
      <li v-for="asset in assets" :key="asset.id">
        {{ asset.name }}
        <span v-if="asset.category"> / {{ asset.category }}</span>
        <span v-if="asset.status"> / {{ asset.status }}</span>
      </li>
    </ul>
    <p v-else>登録済み資産はありません。</p>

    <p><NuxtLink to="/">トップへ戻る</NuxtLink></p>
  </main>
</template>
