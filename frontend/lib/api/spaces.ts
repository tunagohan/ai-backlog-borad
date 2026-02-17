import { apiFetch } from '~/lib/api/client'
import type { Space } from '~/types/api'

export function listSpaces(storeId: number) {
  return apiFetch<Space[]>(`/stores/${storeId}/spaces`)
}

export function createSpace(storeId: number, name: string, floorLabel: string) {
  return apiFetch<Space>(`/stores/${storeId}/spaces`, {
    method: 'POST',
    body: { space: { name, floor_label: floorLabel || null } }
  })
}
