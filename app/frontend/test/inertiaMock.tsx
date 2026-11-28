// @inertiajs/react の代わりに使うテスト用モジュール。各テストで次のように差し替える
//   vi.mock('@inertiajs/react', () => import('@/test/inertiaMock'))
// usePage が返す値は setPage で書き換え、useForm の送信内容は submissions で確かめる
import { type AnchorHTMLAttributes, type ButtonHTMLAttributes, type ReactNode, useRef, useState } from 'react'

import type { FlashData, SharedProps } from '@/types'

type Page = {
  url: string
  props: SharedProps & Record<string, unknown>
  flash: FlashData
}

const defaultPage = (): Page => ({ url: '/', props: { current_user: null }, flash: {} })

let page: Page = defaultPage()

export function setPage(overrides: Partial<Page>) {
  page = { ...defaultPage(), ...overrides }
}

export function usePage() {
  return page
}

type LinkProps = AnchorHTMLAttributes<HTMLAnchorElement> & {
  href: string
  method?: string
  as?: string
  children?: ReactNode
}

// useForm.submit で送られる内容。transform を通したあとの値を記録する
export type Submission = { method: string; url: string; data: unknown }
export const submissions: Submission[] = []

export function useForm<T extends Record<string, unknown>>(initialValues: T) {
  const [data, setDataState] = useState<T>(initialValues)
  const transformRef = useRef<(data: T) => unknown>((d) => d)

  return {
    data,
    errors: {} as Partial<Record<keyof T, string>>,
    processing: false,
    setData: <K extends keyof T>(key: K, value: T[K]) => setDataState((prev) => ({ ...prev, [key]: value })),
    transform: (callback: (data: T) => unknown) => {
      transformRef.current = callback
    },
    submit: (method: string, url: string) => {
      submissions.push({ method, url, data: transformRef.current(data) })
    },
  }
}

// Inertia の Link は <a>（as="button" なら <button>）を描画するので、同じ要素で置き換える
export function Link({ href, method, as, children, ...rest }: LinkProps) {
  if (as === 'button') {
    return (
      <button type="button" data-href={href} data-method={method} {...(rest as ButtonHTMLAttributes<HTMLButtonElement>)}>
        {children}
      </button>
    )
  }
  return (
    <a href={href} data-method={method} {...rest}>
      {children}
    </a>
  )
}
