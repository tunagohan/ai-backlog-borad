import type { ApiErrorPayload } from '~/types/api'

export class ApiError extends Error {
  status: number
  payload: ApiErrorPayload | null

  constructor(message: string, status: number, payload: ApiErrorPayload | null) {
    super(message)
    this.name = 'ApiError'
    this.status = status
    this.payload = payload
  }
}

export async function apiFetch<T>(path: string, options: Parameters<typeof $fetch<T>>[1] = {}): Promise<T> {
  const config = useRuntimeConfig()

  try {
    return await $fetch<T>(`${config.public.apiBaseUrl}${path}`, {
      ...options,
      retry: options.method === 'GET' || !options.method ? 1 : 0
    })
  } catch (error: any) {
    const status = error?.response?.status ?? 500
    const payload = (error?.data ?? null) as ApiErrorPayload | null
    throw new ApiError(payload?.message ?? 'API request failed', status, payload)
  }
}
