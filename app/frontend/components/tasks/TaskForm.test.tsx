import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, expect, it, vi } from 'vitest'

import TaskForm from '@/components/tasks/TaskForm'
import { submissions } from '@/test/inertiaMock'

vi.mock('@inertiajs/react', () => import('@/test/inertiaMock'))

const renderEditForm = () =>
  render(
    <TaskForm
      initialValues={{ name: '買い物', description: '牛乳' }}
      method="patch"
      url="/tasks/1"
      submitLabel="更新する"
    />,
  )

describe('TaskForm', () => {
  it('初期値を入力欄に入れる', () => {
    renderEditForm()
    expect(screen.getByLabelText('名称')).toHaveValue('買い物')
    expect(screen.getByLabelText('詳しい説明')).toHaveValue('牛乳')
  })

  it('画像を選ばずに送信したら image を送らない（添付済みの画像を外さない）', async () => {
    const user = userEvent.setup()
    renderEditForm()
    await user.clear(screen.getByLabelText('名称'))
    await user.type(screen.getByLabelText('名称'), '掃除')
    await user.click(screen.getByRole('button', { name: '更新する' }))

    expect(submissions).toEqual([
      { method: 'patch', url: '/tasks/1', data: { task: { name: '掃除', description: '牛乳' } } },
    ])
  })

  it('画像を選んで送信したら task.image に入れて送る', async () => {
    const user = userEvent.setup()
    renderEditForm()
    const file = new File(['png'], 'photo.png', { type: 'image/png' })
    await user.upload(screen.getByLabelText('画像'), file)
    await user.click(screen.getByRole('button', { name: '更新する' }))

    expect(submissions).toEqual([
      { method: 'patch', url: '/tasks/1', data: { task: { name: '買い物', description: '牛乳', image: file } } },
    ])
  })
})
