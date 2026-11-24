import { describe, expect, it } from 'vitest'

import { withParams } from '@/lib/url'

describe('withParams', () => {
  it('クエリのない URL にパラメータを足す', () => {
    expect(withParams('/tasks', { page: '2' })).toBe('/tasks?page=2')
  })

  it('既存のクエリを残したまま、指定したパラメータだけ置き換える', () => {
    expect(withParams('/tasks?q%5Bname_cont%5D=foo&page=2', { page: '3' })).toBe('/tasks?q%5Bname_cont%5D=foo&page=3')
  })

  it('null を渡したパラメータは削除する', () => {
    expect(withParams('/tasks?q%5Bs%5D=name+desc&page=2', { page: null })).toBe('/tasks?q%5Bs%5D=name+desc')
  })

  it('パラメータがすべてなくなったら ? を付けない', () => {
    expect(withParams('/tasks?page=2', { page: null })).toBe('/tasks')
  })
})
