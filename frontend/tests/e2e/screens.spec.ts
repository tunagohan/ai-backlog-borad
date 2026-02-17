import { expect, test } from '@playwright/test'

const screens = [
  { path: '/', title: '点検業務管理ダッシュボード' },
  { path: '/companies/new', title: '会社登録' },
  { path: '/properties?companyId=1', title: '物件一覧' },
  { path: '/properties/1', title: '店舗登録' },
  { path: '/stores/1', title: 'スペース登録' },
  { path: '/spaces/1', title: '資産登録' },
  { path: '/tasks/new', title: '業務設定（M2）' },
  { path: '/tasks', title: '点検ジョブ一覧' },
  { path: '/tasks/1/execute', title: '点検実施' },
  { path: '/issues/new?companyId=1&jobId=1', title: '不具合報告' },
  { path: '/issues', title: '不具合一覧' },
  { path: '/dashboard', title: 'オーナーダッシュボード' },
  { path: '/notifications', title: '通知一覧' }
]

for (const screen of screens) {
  test(`screen: ${screen.path}`, async ({ page }) => {
    await page.goto(screen.path)
    await expect(page.locator('main.page h1')).toContainText(screen.title)
  })
}
