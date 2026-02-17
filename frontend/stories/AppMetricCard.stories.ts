import type { Meta, StoryObj } from '@storybook/vue3-vite'
import { expect, within } from '@storybook/test'
import AppMetricCard from '../components/ui/AppMetricCard.vue'

const meta = {
  title: 'Metrics/AppMetricCard',
  component: AppMetricCard,
  args: {
    label: '未解決不具合',
    value: 12,
    hint: '前週比 +2'
  },
  tags: ['autodocs']
} satisfies Meta<typeof AppMetricCard>

export default meta
type Story = StoryObj<typeof meta>

export const Default: Story = {
  play: async ({ canvasElement }) => {
    const canvas = within(canvasElement)
    await expect(canvas.getByText('未解決不具合')).toBeVisible()
    await expect(canvas.getByText('12')).toBeVisible()
    await expect(canvas.getByText('前週比 +2')).toBeVisible()
  }
}
