import { Link, router } from '@inertiajs/react'

import UserDetailTable from '@/components/admin/UserDetailTable'
import type { AdminUser } from '@/types/user'

export default function ConfirmDestroy({ user }: { user: AdminUser }) {
  return (
    <>
      <h1>ユーザ削除確認</h1>

      <div className="nav justify-content-end">
        <Link href="/admin/users" className="nav-link">一覧</Link>
      </div>
      <div className="alert alert-danger">削除します。よろしいですか？</div>
      <UserDetailTable user={user} />

      <button type="button" className="btn btn-danger" onClick={() => router.delete(`/admin/users/${user.id}`)}>
        削除
      </button>
    </>
  )
}
