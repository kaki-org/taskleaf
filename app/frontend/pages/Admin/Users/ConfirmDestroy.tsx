import { Link, router } from '@inertiajs/react'
import { useState } from 'react'

import UserDetailTable from '@/components/admin/UserDetailTable'
import type { AdminUser } from '@/types/user'

export default function ConfirmDestroy({ user }: { user: AdminUser }) {
  // ダブルクリックで DELETE が 2 回送られないよう、送信中はボタンを無効にする
  const [processing, setProcessing] = useState(false)

  const destroy = () =>
    router.delete(`/admin/users/${user.id}`, {
      onStart: () => setProcessing(true),
      onFinish: () => setProcessing(false),
    })

  return (
    <>
      <h1>ユーザ削除確認</h1>

      <div className="nav justify-content-end">
        <Link href="/admin/users" className="nav-link">一覧</Link>
      </div>
      <div className="alert alert-danger">削除します。よろしいですか？</div>
      <UserDetailTable user={user} />

      <button type="button" className="btn btn-danger" onClick={destroy} disabled={processing}>
        削除
      </button>
    </>
  )
}
