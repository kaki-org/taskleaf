import { Link, usePage } from '@inertiajs/react'

import { withParams } from '@/lib/url'

// kaminari の既定値（config.window = 4, outer_window = 0）と同じ範囲のページ番号を出す
const WINDOW = 4

export type PaginationMeta = {
  current_page: number
  total_pages: number
}

type Item = { type: 'page'; page: number } | { type: 'gap'; key: string }

function pageItems(current: number, total: number): Item[] {
  const items: Item[] = []
  for (let page = 1; page <= total; page++) {
    if (Math.abs(page - current) <= WINDOW) {
      items.push({ type: 'page', page })
    } else if (items[items.length - 1]?.type !== 'gap') {
      items.push({ type: 'gap', key: `gap-${page}` })
    }
  }
  return items
}

// 移行前の kaminari の Bootstrap 用テンプレート（app/views/kaminari）と同じマークアップで描画する
export default function Pagination({ current_page: current, total_pages: total }: PaginationMeta) {
  const { url } = usePage()
  if (total <= 1) return null

  const pageUrl = (page: number) => withParams(url, { page: page === 1 ? null : String(page) })

  return (
    <nav>
      <ul className="pagination">
        {current > 1 && (
          <>
            <li className="page-item">
              <Link href={pageUrl(1)} className="page-link">« 最初</Link>
            </li>
            <li className="page-item">
              <Link href={pageUrl(current - 1)} rel="prev" className="page-link">‹ 前</Link>
            </li>
          </>
        )}
        {pageItems(current, total).map((item) =>
          item.type === 'gap' ? (
            <li key={item.key} className="page-item disabled">
              <span className="page-link">…</span>
            </li>
          ) : (
            <li key={item.page} className={item.page === current ? 'page-item active' : 'page-item'}>
              {item.page === current ? (
                <span className="page-link">{item.page}</span>
              ) : (
                <Link href={pageUrl(item.page)} className="page-link">{item.page}</Link>
              )}
            </li>
          ),
        )}
        {current < total && (
          <>
            <li className="page-item">
              <Link href={pageUrl(current + 1)} rel="next" className="page-link">次 ›</Link>
            </li>
            <li className="page-item">
              <Link href={pageUrl(total)} className="page-link">最後 »</Link>
            </li>
          </>
        )}
      </ul>
    </nav>
  )
}
