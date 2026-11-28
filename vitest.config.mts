import { fileURLToPath } from 'node:url'

import react from '@vitejs/plugin-react'
import { defineConfig } from 'vitest/config'

// vite.config.mts の RubyPlugin は Rails の dev server 前提の設定を足すため、テストでは読み込まない
export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./app/frontend', import.meta.url)),
    },
  },
  test: {
    environment: 'jsdom',
    include: ['app/frontend/**/*.test.{ts,tsx}'],
    setupFiles: ['./app/frontend/test/setup.ts'],
    restoreMocks: true,
  },
})
