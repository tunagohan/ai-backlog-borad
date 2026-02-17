<script setup lang="ts">
import { ApiError } from '~/lib/api/client'
import {
  completeInspectionJob,
  getInspectionJob,
  saveInspectionResults,
  startInspectionJob
} from '~/lib/api/execution'
import type { InspectionJobDetail, InspectionResultInput } from '~/types/api'

const route = useRoute()
const taskId = computed(() => Number(route.params.taskId))

const job = ref<InspectionJobDetail | null>(null)
const loading = ref(false)
const saving = ref(false)
const errorMessage = ref('')
const message = ref('')

const passFailValues = reactive<Record<number, string>>({})
const numericValues = reactive<Record<number, string>>({})
const comments = reactive<Record<number, string>>({})

async function loadJob() {
  loading.value = true
  errorMessage.value = ''
  try {
    job.value = await getInspectionJob(taskId.value)

    job.value.template.sections.forEach((section) => {
      section.items.forEach((item) => {
        const existing = job.value?.results.find((result) => result.template_item_id === item.id)
        if (item.result_type === 'pass_fail') {
          passFailValues[item.id] = existing?.result_value || 'pass'
        } else {
          numericValues[item.id] =
            existing?.numeric_value != null ? String(existing.numeric_value) : ''
        }
        comments[item.id] = existing?.comment || ''
      })
    })
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

function buildResultInputs(): InspectionResultInput[] {
  if (!job.value) return []

  const results: InspectionResultInput[] = []

  job.value.template.sections.forEach((section) => {
    section.items.forEach((item) => {
      const base = {
        template_item_id: item.id,
        result_type: item.result_type,
        comment: comments[item.id] || undefined
      } as InspectionResultInput

      if (item.result_type === 'pass_fail') {
        base.result_value = passFailValues[item.id] || 'pass'
      } else {
        const numeric = Number(numericValues[item.id])
        if (!Number.isNaN(numeric)) {
          base.numeric_value = numeric
        }
      }

      results.push(base)
    })
  })

  return results
}

async function startJob() {
  if (!job.value) return

  try {
    await startInspectionJob(job.value.id)
    message.value = '業務を開始しました'
    await loadJob()
  } catch (error) {
    if (error instanceof ApiError) {
      errorMessage.value = error.payload?.message || `開始に失敗しました (status: ${error.status})`
    } else {
      errorMessage.value = '開始に失敗しました'
    }
  }
}

async function saveResultsOnly() {
  if (!job.value) return

  saving.value = true
  errorMessage.value = ''
  try {
    await saveInspectionResults(job.value.id, buildResultInputs())
    message.value = '点検結果を保存しました'
    await loadJob()
  } catch (error) {
    if (error instanceof ApiError) {
      errorMessage.value = error.payload?.message || `保存に失敗しました (status: ${error.status})`
    } else {
      errorMessage.value = '保存に失敗しました'
    }
  } finally {
    saving.value = false
  }
}

async function completeJob() {
  if (!job.value) return

  saving.value = true
  errorMessage.value = ''
  try {
    await saveInspectionResults(job.value.id, buildResultInputs())
    await completeInspectionJob(job.value.id)
    message.value = '業務を完了しました'
    await loadJob()
  } catch (error) {
    if (error instanceof ApiError) {
      errorMessage.value = error.payload?.message || `完了に失敗しました (status: ${error.status})`
    } else {
      errorMessage.value = '完了に失敗しました'
    }
  } finally {
    saving.value = false
  }
}

await loadJob()
</script>

<template>
  <main class="page">
    <h1>点検実施</h1>
    <p>Task ID: {{ taskId }}</p>

    <p v-if="loading">読み込み中...</p>
    <template v-else-if="job">
      <p>テンプレート: {{ job.template.name }} / ステータス: {{ job.status }}</p>

      <button v-if="job.status === 'scheduled'" @click="startJob">業務を開始</button>

      <section v-for="section in job.template.sections" :key="section.id" class="card">
        <h2>{{ section.name }}</h2>
        <div v-for="item in section.items" :key="item.id" class="item">
          <p>{{ item.name }}</p>
          <template v-if="item.result_type === 'pass_fail'">
            <label><input v-model="passFailValues[item.id]" type="radio" value="pass" /> 良</label>
            <label><input v-model="passFailValues[item.id]" type="radio" value="fail" /> 否</label>
          </template>
          <template v-else>
            <input v-model="numericValues[item.id]" type="number" step="0.01" placeholder="数値" />
          </template>
          <input v-model="comments[item.id]" type="text" placeholder="コメント" />
        </div>
      </section>

      <div class="actions">
        <button :disabled="saving" @click="saveResultsOnly">保存</button>
        <button :disabled="saving" @click="completeJob">完了</button>
        <NuxtLink :to="`/issues/new?jobId=${job.id}&companyId=${job.company_id}`"
          >不具合を報告</NuxtLink
        >
      </div>
    </template>

    <p v-if="message" class="success">{{ message }}</p>
    <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
    <p><NuxtLink to="/tasks">ジョブ一覧へ戻る</NuxtLink></p>
  </main>
</template>
