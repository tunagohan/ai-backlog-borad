import { apiFetch } from '~/lib/api/client'
import type { InspectionTemplate } from '~/types/api'

export type TemplateItemInput = {
  name: string
  result_type: 'pass_fail' | 'numeric'
  unit?: string
  required?: boolean
}

export type TemplateSectionInput = {
  name: string
  items: TemplateItemInput[]
}

export function listInspectionTemplates(companyId: number) {
  return apiFetch<InspectionTemplate[]>(`/inspection_templates?company_id=${companyId}`)
}

export function createInspectionTemplate(input: {
  company_id: number
  name: string
  version?: number
  is_active?: boolean
  sections: TemplateSectionInput[]
}) {
  return apiFetch<InspectionTemplate>('/inspection_templates', {
    method: 'POST',
    body: {
      inspection_template: {
        company_id: input.company_id,
        name: input.name,
        version: input.version ?? 1,
        is_active: input.is_active ?? true,
        sections: input.sections
      }
    }
  })
}
