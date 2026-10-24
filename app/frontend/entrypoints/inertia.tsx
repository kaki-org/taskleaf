import { createInertiaApp, type ResolvedComponent } from '@inertiajs/react'

// アイコンは SCSS から読むとフォントの相対パスが解決できないため、配布済みの CSS を読む
import 'bootstrap-icons/font/bootstrap-icons.css'
import '../stylesheets/inertia.scss'

import AppLayout from '@/layouts/AppLayout'

const pages = import.meta.glob<{ default: ResolvedComponent }>('../pages/**/*.tsx')

void createInertiaApp({
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
    visitOptions: () => ({ queryStringArrayFormat: 'brackets' }),
  },
})
