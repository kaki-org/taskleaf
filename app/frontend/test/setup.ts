import '@testing-library/jest-dom/vitest'

import { cleanup } from '@testing-library/react'
import { afterEach } from 'vitest'

import { setPage, submissions } from '@/test/inertiaMock'

// usePage の値と送信内容はモジュール変数なので、テストごとに初期状態へ戻す
afterEach(() => {
  cleanup()
  setPage({})
  submissions.length = 0
})
