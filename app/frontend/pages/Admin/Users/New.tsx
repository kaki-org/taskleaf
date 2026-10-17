import { Link } from '@inertiajs/react'

import UserForm from '@/components/admin/UserForm'

export default function New() {
  return (
    <>
      <h1>ユーザー登録</h1>

      <div className="nav justify-content-end">
        <Link href="/admin/users" className="nav-link">一覧</Link>
      </div>

      <UserForm initialValues={{ name: '', email: '', admin: false }} method="post" url="/admin/users" />
    </>
  )
}
