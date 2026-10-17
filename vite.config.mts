import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'

export default defineConfig({
  plugins: [react(), RubyPlugin()],
  css: {
    preprocessorOptions: {
      scss: {
        // Bootstrap 5 の SCSS が出す非推奨警告（@import / グローバル関数）を抑止する
        quietDeps: true,
      },
    },
  },
})
