export type Company = {
  id: number
  name: string
  created_at: string
  updated_at: string
}

export type Property = {
  id: number
  company_id: number
  name: string
  address: string | null
  created_at: string
  updated_at: string
}

export type Store = {
  id: number
  property_id: number
  name: string
  created_at: string
  updated_at: string
}

export type Space = {
  id: number
  store_id: number
  name: string
  floor_label: string | null
  created_at: string
  updated_at: string
}

export type Asset = {
  id: number
  space_id: number
  name: string
  category: string | null
  serial_number: string | null
  installed_on: string | null
  status: string | null
  created_at: string
  updated_at: string
}

export type ApiErrorPayload = {
  error: string
  message?: string
  details?: Record<string, string[]>
}
