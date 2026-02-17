<script setup lang="ts">
import { ApiError } from '~/lib/api/client'
import { listNotifications, markNotificationRead } from '~/lib/api/notifications'
import type { Notification } from '~/types/api'

const companyId = ref(1)
const unreadOnly = ref(true)
const loading = ref(false)
const errorMessage = ref('')
const notifications = ref<Notification[]>([])

async function load() {
  loading.value = true
  errorMessage.value = ''

  try {
    notifications.value = await listNotifications(companyId.value, unreadOnly.value)
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

async function markRead(id: number) {
  try {
    await markNotificationRead(id)
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
    <h1>通知一覧</h1>

    <form class="controls" @submit.prevent="load">
      <label>Company ID<input v-model.number="companyId" type="number" min="1" /></label>
      <label><input v-model="unreadOnly" type="checkbox" /> 未読のみ</label>
      <button type="submit">再取得</button>
    </form>

    <p v-if="loading">読み込み中...</p>
    <p v-else-if="errorMessage" class="error">{{ errorMessage }}</p>
    <table v-else-if="notifications.length" class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Level</th>
          <th>Title</th>
          <th>Message</th>
          <th>Read</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="notification in notifications" :key="notification.id">
          <td>{{ notification.id }}</td>
          <td>{{ notification.level }}</td>
          <td>{{ notification.title }}</td>
          <td>{{ notification.message }}</td>
          <td>
            <button v-if="!notification.read_at" @click="markRead(notification.id)">既読</button>
            <span v-else>済</span>
          </td>
        </tr>
      </tbody>
    </table>
    <p v-else>通知はありません。</p>
  </main>
</template>

<style scoped>
.page { max-width: 900px; margin: 32px auto; padding: 0 16px; font-family: sans-serif; }
.controls { display: flex; gap: 12px; align-items: center; margin-bottom: 12px; }
.table { width: 100%; border-collapse: collapse; }
th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
.error { color: #b3261e; }
</style>
