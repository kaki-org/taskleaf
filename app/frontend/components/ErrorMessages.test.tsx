import { render, screen } from '@testing-library/react'
import { describe, expect, it } from 'vitest'

import ErrorMessages from '@/components/ErrorMessages'

describe('ErrorMessages', () => {
  it('エラーがなければ何も描画しない', () => {
    const { container } = render(<ErrorMessages errors={{}} />)
    expect(container).toBeEmptyDOMElement()
  })

  it('配列と文字列のどちらで届いたエラーも 1 件ずつ並べる', () => {
    render(<ErrorMessages errors={{ name: ['名称を入力してください', '名称は30文字以内で入力してください'], email: 'メールアドレスは不正な値です' }} />)
    expect(screen.getAllByRole('listitem').map((li) => li.textContent)).toEqual([
      '名称を入力してください',
      '名称は30文字以内で入力してください',
      'メールアドレスは不正な値です',
    ])
  })

  it('同じ文言のエラーが複数あってもすべて表示する', () => {
    render(<ErrorMessages errors={{ name: ['不正な値です'], email: ['不正な値です'] }} />)
    expect(screen.getAllByText('不正な値です')).toHaveLength(2)
  })
})
