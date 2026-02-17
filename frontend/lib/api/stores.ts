import { apiFetch } from '~/lib/api/client'
import type { Store } from '~/types/api'

export function listStores(propertyId: number) {
  return apiFetch<Store[]>(`/properties/${propertyId}/stores`)
}

export function createStore(propertyId: number, name: string) {
  return apiFetch<Store>(`/properties/${propertyId}/stores`, {
    method: 'POST',
    body: { store: { name } }
  })
}
