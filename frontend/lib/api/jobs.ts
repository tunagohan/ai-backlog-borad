import { apiFetch } from '~/lib/api/client'
import type { InspectionJob } from '~/types/api'

export function listInspectionJobs(companyId: number) {
  return apiFetch<InspectionJob[]>(`/inspection_jobs?company_id=${companyId}`)
}

export function createInspectionJob(input: {
  company_id: number
  template_id: number
  target_type: 'property' | 'store' | 'space'
  target_id: number
  scheduled_for: string
}) {
  return apiFetch<InspectionJob>('/inspection_jobs', {
    method: 'POST',
    body: {
      inspection_job: {
        company_id: input.company_id,
        template_id: input.template_id,
        target_type: input.target_type,
        target_id: input.target_id,
        scheduled_for: input.scheduled_for
      }
    }
  })
}
