import { Link } from '@inertiajs/react'

import UserDetailTable from '@/components/admin/UserDetailTable'
import type { AdminUser } from '@/types/user'

export default function Show({ user }: { user: AdminUser }) {
  return (
    <>
      <h1>ユーザ詳細</h1>

      <div className="nav justify-content-end">
        <Link href="/admin/users" className="nav-link">一覧</Link>
      </div>
      <UserDetailTable user={user} />

      <Link href={`/admin/users/${user.id}/edit`} className="btn btn-primary">編集</Link>{' '}
      <Link href={`/admin/users/${user.id}/confirm_destroy`} className="btn btn-danger">削除</Link>
    </>
  )
}
