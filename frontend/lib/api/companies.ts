import { apiFetch } from '~/lib/api/client'
import type { Company } from '~/types/api'

export function createCompany(name: string) {
  return apiFetch<Company>('/companies', {
    method: 'POST',
    body: {
      company: { name }
    }
  })
}

export function getCompany(companyId: number) {
  return apiFetch<Company>(`/companies/${companyId}`)
}
