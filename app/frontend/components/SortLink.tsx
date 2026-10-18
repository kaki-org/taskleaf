import { Link, usePage } from '@inertiajs/react'

import { withParams } from '@/lib/url'

type Props = {
  field: string
  label: string
  // ransack の q[s]（例: "name desc"）
  sort?: string
}

// ransack の sort_link(@q, field, default_order: :desc) と同じく、未選択なら降順、選択中なら昇降を切り替える
export default function SortLink({ field, label, sort }: Props) {
  const { url } = usePage()
  const [sortedField, sortedDirection] = (sort ?? '').split(' ')
  const direction = sortedField === field ? sortedDirection : null
  const nextDirection = direction === 'desc' ? 'asc' : 'desc'
  const arrow = direction === 'asc' ? ' ▲' : direction === 'desc' ? ' ▼' : ''

  return (
    <Link
      href={withParams(url, { 'q[s]': `${field} ${nextDirection}` })}
      className={direction ? `sort_link ${direction}` : 'sort_link'}
    >
      {label}
      {arrow}
    </Link>
  )
}
