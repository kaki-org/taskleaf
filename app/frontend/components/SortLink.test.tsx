import { render, screen } from '@testing-library/react'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import SortLink from '@/components/SortLink'
import { setPage } from '@/test/inertiaMock'

vi.mock('@inertiajs/react', () => import('@/test/inertiaMock'))

const link = () => screen.getByRole('link')
const nextSort = () => new URLSearchParams(link().getAttribute('href')!.split('?')[1]).get('q[s]')

describe('SortLink', () => {
  beforeEach(() => {
    setPage({ url: '/tasks?page=2' })
  })

  it('並び替えていなければ、矢印なしで降順へのリンクにする', () => {
    render(<SortLink field="name" label="名称" />)
    expect(link()).toHaveTextContent(/^名称$/)
    expect(link()).toHaveClass('sort_link', { exact: true })
    expect(nextSort()).toBe('name desc')
  })

  it('この列で降順なら ▼ を付け、昇順へのリンクにする', () => {
    render(<SortLink field="name" label="名称" sort="name desc" />)
    expect(link()).toHaveTextContent('名称 ▼')
    expect(link()).toHaveClass('sort_link desc')
    expect(nextSort()).toBe('name asc')
  })

  it('この列で昇順なら ▲ を付け、降順へのリンクにする', () => {
    render(<SortLink field="name" label="名称" sort="name asc" />)
    expect(link()).toHaveTextContent('名称 ▲')
    expect(link()).toHaveClass('sort_link asc')
    expect(nextSort()).toBe('name desc')
  })

  it('別の列で並び替え中なら、この列は未選択として扱う', () => {
    render(<SortLink field="name" label="名称" sort="created_at asc" />)
    expect(link()).toHaveTextContent(/^名称$/)
    expect(nextSort()).toBe('name desc')
  })

  it('ほかのクエリは残す', () => {
    render(<SortLink field="name" label="名称" />)
    expect(link().getAttribute('href')).toContain('page=2')
  })
})
