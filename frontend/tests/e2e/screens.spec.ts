import { expect, test } from '@playwright/test'

const screens = [
  '/',
  '/companies/new',
  '/properties?companyId=1',
  '/properties/1',
  '/stores/1',
  '/spaces/1',
  '/tasks/new',
  '/tasks',
  '/tasks/1/execute',
  '/issues/new?companyId=1&jobId=1',
  '/issues',
  '/dashboard',
  '/notifications'
]

for (const path of screens) {
  test(`screen: ${path}`, async ({ page }) => {
    await page.goto(path)
    await expect(page.locator('main.page h1')).toBeVisible()
  })
}
