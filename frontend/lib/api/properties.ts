import { apiFetch } from '~/lib/api/client'
import type { Property } from '~/types/api'

export function listProperties(companyId: number) {
  return apiFetch<Property[]>(`/companies/${companyId}/properties`)
}

export function createProperty(companyId: number, name: string, address: string) {
  return apiFetch<Property>(`/companies/${companyId}/properties`, {
    method: 'POST',
    body: {
      property: {
        name,
        address: address || null
      }
    }
  })
}
