import { apiFetch } from '~/lib/api/client'
import type { Issue } from '~/types/api'

export function listIssues(companyId: number, status?: string) {
  const query = new URLSearchParams({ company_id: String(companyId) })
  if (status) query.set('status', status)
  return apiFetch<Issue[]>(`/issues?${query.toString()}`)
}

export function createIssue(input: {
  company_id: number
  job_id: number
  title: string
  description?: string
  image_urls?: string[]
  severity?: 'low' | 'medium' | 'high'
}) {
  return apiFetch<Issue>('/issues', {
    method: 'POST',
    body: {
      issue: {
        company_id: input.company_id,
        job_id: input.job_id,
        title: input.title,
        description: input.description || null,
        image_urls: input.image_urls || [],
        severity: input.severity || 'medium'
      }
    }
  })
}

export function updateIssue(issueId: number, input: Partial<Pick<Issue, 'status' | 'severity' | 'title' | 'description' | 'image_urls'>>) {
  return apiFetch<Issue>(`/issues/${issueId}`, {
    method: 'PATCH',
    body: { issue: input }
  })
}
