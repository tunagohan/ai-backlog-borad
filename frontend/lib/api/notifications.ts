import { apiFetch } from '~/lib/api/client'
import type { Notification } from '~/types/api'

export function listNotifications(companyId: number, unreadOnly = false) {
  const query = new URLSearchParams({ company_id: String(companyId) })
  if (unreadOnly) query.set('unread', 'true')
  return apiFetch<Notification[]>(`/notifications?${query.toString()}`)
}

export function markNotificationRead(notificationId: number) {
  return apiFetch<Notification>(`/notifications/${notificationId}`, { method: 'PATCH' })
}
