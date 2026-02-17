import { apiFetch } from '~/lib/api/client'
import type { Asset } from '~/types/api'

export type AssetInput = {
  name: string
  category?: string
  serialNumber?: string
  installedOn?: string
  status?: string
}

export function listAssets(spaceId: number) {
  return apiFetch<Asset[]>(`/spaces/${spaceId}/assets`)
}

export function createAsset(spaceId: number, input: AssetInput) {
  return apiFetch<Asset>(`/spaces/${spaceId}/assets`, {
    method: 'POST',
    body: {
      asset: {
        name: input.name,
        category: input.category || null,
        serial_number: input.serialNumber || null,
        installed_on: input.installedOn || null,
        status: input.status || null
      }
    }
  })
}
