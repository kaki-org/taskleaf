import { createInertiaApp, type ResolvedComponent } from '@inertiajs/react'

// アイコンは SCSS から読むとフォントの相対パスが解決できないため、配布済みの CSS を読む
import 'bootstrap-icons/font/bootstrap-icons.css'
import '../stylesheets/inertia.scss'

import AppLayout from '@/layouts/AppLayout'

const pages = import.meta.glob<{ default: ResolvedComponent }>('../pages/**/*.tsx')

// Inertia が注入する <style>（プログレスバーなど）を CSP の style-src nonce で許可する
const nonce = document.querySelector<HTMLMetaElement>('meta[name="csp-nonce"]')?.content

void createInertiaApp({
  nonce,
  resolve: async (name) => {
    const page = pages[`../pages/${name}.tsx`]
    if (!page) throw new Error(`Inertia のページが見つかりません: ${name}`)
    return page().then((module) => module.default)
  },
  // ページを切り替えてもヘッダと flash を保持する persistent layout
  layout: () => AppLayout,
  strictMode: true,
  defaults: {
    form: {
      forceIndicesArrayFormatInFormData: false,
    },
  },
})
