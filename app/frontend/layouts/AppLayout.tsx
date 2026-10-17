import { Link, usePage } from '@inertiajs/react'
import type { ReactNode } from 'react'

import FlashMessages from '@/components/FlashMessages'

export default function AppLayout({ children }: { children: ReactNode }) {
  const { current_user: currentUser } = usePage().props

  return (
    <>
      <div className="app-title navbar navbar-expand-md navbar-light bg-light">
        <div className="navbar-brand">Taskleaf</div>

        <ul className="navbar-nav ml-auto">
          {currentUser ? (
            <>
              {/* 遷移先が ERB の間は Inertia の Link ではなく通常のリンクにする */}
              <li className="nav-item">
                <a href="/tasks" className="nav-link">タスク一覧</a>
              </li>
              {currentUser.admin && (
                <li className="nav-item">
                  <a href="/admin/users" className="nav-link">ユーザー一覧</a>
                </li>
              )}
              <li className="nav-item">
                <Link href="/logout" method="delete" as="button" className="nav-link">ログアウト</Link>
              </li>
            </>
          ) : (
            <li className="nav-item">
              <Link href="/login" className="nav-link">ログイン</Link>
            </li>
          )}
        </ul>
      </div>
      <div className="container">
        <FlashMessages />
        {children}
      </div>
    </>
  )
}
