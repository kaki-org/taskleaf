import '@testing-library/jest-dom/vitest'

import { cleanup } from '@testing-library/react'
import { afterEach } from 'vitest'

import { submissions } from '@/test/inertiaMock'

afterEach(() => {
  cleanup()
  submissions.length = 0
})
