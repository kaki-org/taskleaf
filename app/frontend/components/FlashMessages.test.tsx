import { act, render, screen } from '@testing-library/react'
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'

import FlashMessages from '@/components/FlashMessages'
import { setPage } from '@/test/inertiaMock'

vi.mock('@inertiajs/react', () => import('@/test/inertiaMock'))

describe('FlashMessages', () => {
  beforeEach(() => {
    vi.useFakeTimers()
  })

  afterEach(() => {
    vi.useRealTimers()
  })

  it('notice と alert をそれぞれの色で表示する', () => {
    setPage({ flash: { notice: '登録しました', alert: '失敗しました' } })
    render(<FlashMessages />)
    expect(screen.getByText('登録しました')).toHaveClass('alert-success')
    expect(screen.getByText('失敗しました')).toHaveClass('alert-danger')
  })

  it('5 秒たつと消える', () => {
    setPage({ flash: { notice: '登録しました' } })
    render(<FlashMessages />)

    act(() => vi.advanceTimersByTime(4999))
    expect(screen.getByText('登録しました')).toBeInTheDocument()

    act(() => vi.advanceTimersByTime(1))
    expect(screen.queryByText('登録しました')).not.toBeInTheDocument()
  })

  it('消えたあと、次の画面遷移で同じ文言が返ってきたら再表示する', () => {
    setPage({ flash: { notice: '更新しました' } })
    const { rerender } = render(<FlashMessages />)
    act(() => vi.advanceTimersByTime(5000))
    expect(screen.queryByText('更新しました')).not.toBeInTheDocument()

    // 画面遷移ごとに flash は別オブジェクトになる
    setPage({ flash: { notice: '更新しました' } })
    rerender(<FlashMessages />)
    expect(screen.getByText('更新しました')).toBeInTheDocument()

    act(() => vi.advanceTimersByTime(5000))
    expect(screen.queryByText('更新しました')).not.toBeInTheDocument()
  })
})
