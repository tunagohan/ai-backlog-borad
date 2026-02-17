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

export type InspectionTemplateItem = {
  id: number
  name: string
  result_type: 'pass_fail' | 'numeric'
  unit: string | null
  required: boolean
  sort_order: number
}

export type InspectionTemplateSection = {
  id: number
  name: string
  sort_order: number
  items: InspectionTemplateItem[]
}

export type InspectionTemplate = {
  id: number
  company_id: number
  name: string
  version: number
  is_active: boolean
  sections: InspectionTemplateSection[]
  created_at: string
  updated_at: string
}

export type InspectionJob = {
  id: number
  company_id: number
  template_id: number
  template_name: string | null
  target_type: 'property' | 'store' | 'space'
  target_id: number
  status: 'scheduled' | 'in_progress' | 'completed'
  scheduled_for: string
  started_at: string | null
  completed_at: string | null
  created_at: string
  updated_at: string
}

export type InspectionResult = {
  id: number
  template_item_id: number
  template_item_name: string | null
  result_type: 'pass_fail' | 'numeric'
  result_value: string | null
  numeric_value: number | null
  comment: string | null
}

export type InspectionResultInput = {
  template_item_id: number
  result_type: 'pass_fail' | 'numeric'
  result_value?: string
  numeric_value?: number
  comment?: string
}

export type InspectionJobDetail = InspectionJob & {
  template: InspectionTemplate
  results: InspectionResult[]
}

export type Issue = {
  id: number
  company_id: number
  job_id: number
  title: string
  description: string | null
  severity: 'low' | 'medium' | 'high'
  status: 'open' | 'in_progress' | 'closed'
  reported_at: string
  resolved_at: string | null
  created_at: string
  updated_at: string
}
