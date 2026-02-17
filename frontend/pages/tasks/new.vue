<script setup lang="ts">
import { ApiError } from '~/lib/api/client'
import { createInspectionJob } from '~/lib/api/jobs'
import { createInspectionTemplate, listInspectionTemplates } from '~/lib/api/templates'
import type { InspectionTemplate } from '~/types/api'

const companyId = ref(1)
const loadingTemplates = ref(false)
const templates = ref<InspectionTemplate[]>([])

const templateForm = reactive({
  name: '',
  sectionName: '基本点検',
  itemName: '動作確認',
  resultType: 'pass_fail' as 'pass_fail' | 'numeric'
})

const jobForm = reactive({
  templateId: '',
  targetType: 'property' as 'property' | 'store' | 'space',
  targetId: '',
  scheduledFor: ''
})

const templateMessage = ref('')
const jobMessage = ref('')
const errorMessage = ref('')
const templateSubmitting = ref(false)
const jobSubmitting = ref(false)

async function loadTemplates() {
  loadingTemplates.value = true
  errorMessage.value = ''
  try {
    templates.value = await listInspectionTemplates(companyId.value)
  } catch (error) {
    if (error instanceof ApiError) {
      errorMessage.value =
        error.payload?.message || `テンプレート取得に失敗しました (status: ${error.status})`
    } else {
      errorMessage.value = 'テンプレート取得に失敗しました'
    }
  } finally {
    loadingTemplates.value = false
  }
}

async function submitTemplate() {
  templateSubmitting.value = true
  templateMessage.value = ''
  errorMessage.value = ''

  try {
    const created = await createInspectionTemplate({
      company_id: companyId.value,
      name: templateForm.name,
      sections: [
        {
          name: templateForm.sectionName,
          items: [
            {
              name: templateForm.itemName,
              result_type: templateForm.resultType,
              required: true
            }
          ]
        }
      ]
    })

    templateMessage.value = `テンプレート作成完了: ID ${created.id}`
    templateForm.name = ''
    await loadTemplates()
  } catch (error) {
    if (error instanceof ApiError) {
      errorMessage.value =
        error.payload?.message || `テンプレート作成に失敗しました (status: ${error.status})`
    } else {
      errorMessage.value = 'テンプレート作成に失敗しました'
    }
  } finally {
    templateSubmitting.value = false
  }
}

async function submitJob() {
  jobSubmitting.value = true
  jobMessage.value = ''
  errorMessage.value = ''

  try {
    const created = await createInspectionJob({
      company_id: companyId.value,
      template_id: Number(jobForm.templateId),
      target_type: jobForm.targetType,
      target_id: Number(jobForm.targetId),
      scheduled_for: jobForm.scheduledFor
    })

    jobMessage.value = `ジョブ作成完了: ID ${created.id}`
    jobForm.templateId = ''
    jobForm.targetId = ''
    jobForm.scheduledFor = ''
  } catch (error) {
    if (error instanceof ApiError) {
      errorMessage.value =
        error.payload?.message || `ジョブ作成に失敗しました (status: ${error.status})`
    } else {
      errorMessage.value = 'ジョブ作成に失敗しました'
    }
  } finally {
    jobSubmitting.value = false
  }
}

await loadTemplates()
</script>

<template>
  <main class="page">
    <h1>業務設定（M2）</h1>

    <section class="card">
      <h2>テンプレート作成</h2>
      <form class="form" @submit.prevent="submitTemplate">
        <label>Company ID<input v-model.number="companyId" type="number" min="1" required /></label>
        <label>テンプレート名<input v-model="templateForm.name" type="text" required /></label>
        <label>セクション名<input v-model="templateForm.sectionName" type="text" required /></label>
        <label>項目名<input v-model="templateForm.itemName" type="text" required /></label>
        <label>
          入力型
          <select v-model="templateForm.resultType">
            <option value="pass_fail">良否</option>
            <option value="numeric">数値</option>
          </select>
        </label>
        <button type="submit" :disabled="templateSubmitting">
          {{ templateSubmitting ? '作成中...' : 'テンプレートを作成' }}
        </button>
      </form>
      <p v-if="templateMessage" class="success">{{ templateMessage }}</p>
    </section>

    <section class="card">
      <h2>点検ジョブ作成</h2>
      <p v-if="loadingTemplates">テンプレート読込中...</p>
      <form class="form" @submit.prevent="submitJob">
        <label>
          テンプレート
          <select v-model="jobForm.templateId" required>
            <option value="" disabled>選択してください</option>
            <option v-for="template in templates" :key="template.id" :value="String(template.id)">
              {{ template.name }} (v{{ template.version }})
            </option>
          </select>
        </label>
        <label>
          対象種別
          <select v-model="jobForm.targetType">
            <option value="property">Property</option>
            <option value="store">Store</option>
            <option value="space">Space</option>
          </select>
        </label>
        <label>対象ID<input v-model="jobForm.targetId" type="number" min="1" required /></label>
        <label
          >実施予定日<input v-model="jobForm.scheduledFor" type="datetime-local" required
        /></label>
        <button type="submit" :disabled="jobSubmitting">
          {{ jobSubmitting ? '作成中...' : 'ジョブを作成' }}
        </button>
      </form>
      <p v-if="jobMessage" class="success">{{ jobMessage }}</p>
      <p><NuxtLink to="/tasks">ジョブ一覧へ</NuxtLink></p>
    </section>

    <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
    <p><NuxtLink to="/">トップへ戻る</NuxtLink></p>
  </main>
</template>
