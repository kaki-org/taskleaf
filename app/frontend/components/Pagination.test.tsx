import { render, screen } from '@testing-library/react'
import { describe, expect, it, vi } from 'vitest'

import Pagination from '@/components/Pagination'
import { setPage } from '@/test/inertiaMock'

vi.mock('@inertiajs/react', () => import('@/test/inertiaMock'))

const pageLabels = () =>
  Array.from(document.querySelectorAll('.pagination li')).map((li) => li.textContent)

describe('Pagination', () => {
  it('1 ページしかなければ何も描画しない', () => {
    setPage({ url: '/tasks' })
    const { container } = render(<Pagination current_page={1} total_pages={1} />)
    expect(container).toBeEmptyDOMElement()
  })

  it('最初のページでは「最初」「前」を出さず、「次」「最後」を出す', () => {
    setPage({ url: '/tasks' })
    render(<Pagination current_page={1} total_pages={3} />)
    expect(pageLabels()).toEqual(['1', '2', '3', '次 ›', '最後 »'])
    expect(screen.getByText('次 ›')).toHaveAttribute('href', '/tasks?page=2')
    expect(screen.getByText('最後 »')).toHaveAttribute('href', '/tasks?page=3')
  })

  it('最後のページでは「次」「最後」を出さない', () => {
    setPage({ url: '/tasks?page=3' })
    render(<Pagination current_page={3} total_pages={3} />)
    expect(pageLabels()).toEqual(['« 最初', '‹ 前', '1', '2', '3'])
  })

  it('現在のページはリンクにせず active にする', () => {
    setPage({ url: '/tasks?page=2' })
    render(<Pagination current_page={2} total_pages={3} />)
    const current = screen.getByText('2')
    expect(current.tagName).toBe('SPAN')
    expect(current.closest('li')).toHaveClass('active')
  })

  it('1 ページ目へのリンクからは page パラメータを外し、ほかのクエリは残す', () => {
    setPage({ url: '/tasks?q%5Bname_cont%5D=foo&page=3' })
    render(<Pagination current_page={3} total_pages={5} />)
    expect(screen.getByText('« 最初')).toHaveAttribute('href', '/tasks?q%5Bname_cont%5D=foo')
    expect(screen.getByText('‹ 前')).toHaveAttribute('href', '/tasks?q%5Bname_cont%5D=foo&page=2')
  })

  it('現在のページから 4 ページより離れた範囲は 1 つの省略記号にまとめる', () => {
    setPage({ url: '/tasks?page=10' })
    render(<Pagination current_page={10} total_pages={20} />)
    expect(pageLabels()).toEqual([
      '« 最初', '‹ 前',
      '…', '6', '7', '8', '9', '10', '11', '12', '13', '14', '…',
      '次 ›', '最後 »',
    ])
  })
})
