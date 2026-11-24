import { render, screen } from '@testing-library/react'
import { describe, expect, it, vi } from 'vitest'

import AppLayout from '@/layouts/AppLayout'
import { setPage } from '@/test/inertiaMock'

vi.mock('@inertiajs/react', () => import('@/test/inertiaMock'))

const renderLayout = () => render(<AppLayout><p>本文</p></AppLayout>)

describe('AppLayout', () => {
  it('ログインしていなければ、ログインへのリンクだけを出す', () => {
    setPage({ props: { current_user: null } })
    renderLayout()
    expect(screen.getByRole('link', { name: 'ログイン' })).toHaveAttribute('href', '/login')
    expect(screen.queryByText('タスク一覧')).not.toBeInTheDocument()
    expect(screen.queryByText('ログアウト')).not.toBeInTheDocument()
    expect(screen.getByText('本文')).toBeInTheDocument()
  })

  it('一般ユーザーには、ユーザー一覧へのリンクを出さない', () => {
    setPage({ props: { current_user: { id: 1, name: '一般', admin: false } } })
    renderLayout()
    expect(screen.getByRole('link', { name: 'タスク一覧' })).toHaveAttribute('href', '/tasks')
    expect(screen.queryByText('ユーザー一覧')).not.toBeInTheDocument()
    expect(screen.queryByText('ログイン')).not.toBeInTheDocument()
  })

  it('管理者には、ユーザー一覧へのリンクを出す', () => {
    setPage({ props: { current_user: { id: 1, name: '管理者', admin: true } } })
    renderLayout()
    expect(screen.getByRole('link', { name: 'ユーザー一覧' })).toHaveAttribute('href', '/admin/users')
  })

  it('ログアウトは DELETE /logout を送るボタンにする', () => {
    setPage({ props: { current_user: { id: 1, name: '一般', admin: false } } })
    renderLayout()
    const logout = screen.getByRole('button', { name: 'ログアウト' })
    expect(logout).toHaveAttribute('data-href', '/logout')
    expect(logout).toHaveAttribute('data-method', 'delete')
  })
})
