import { apiFetch } from '~/lib/api/client'
import type { InspectionJobDetail, InspectionResultInput } from '~/types/api'

export function getInspectionJob(jobId: number) {
  return apiFetch<InspectionJobDetail>(`/inspection_jobs/${jobId}`)
}

export function startInspectionJob(jobId: number) {
  return apiFetch(`/inspection_jobs/${jobId}/start`, { method: 'POST' })
}

export function saveInspectionResults(jobId: number, results: InspectionResultInput[]) {
  return apiFetch<{ job_id: number; results_count: number }>(`/inspection_jobs/${jobId}/results`, {
    method: 'POST',
    body: { results }
  })
}

export function completeInspectionJob(jobId: number) {
  return apiFetch(`/inspection_jobs/${jobId}/complete`, { method: 'POST' })
}
