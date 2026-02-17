import { apiFetch } from '~/lib/api/client'
import type { DashboardSummary } from '~/types/api'

export function getDashboard(companyId: number) {
  return apiFetch<DashboardSummary>(`/dashboard?company_id=${companyId}`)
}
