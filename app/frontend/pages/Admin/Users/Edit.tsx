import { Link } from '@inertiajs/react'

import UserForm from '@/components/admin/UserForm'

type Props = {
  user: { id: number; name: string; email: string; admin: boolean }
}

export default function Edit({ user }: Props) {
  return (
    <>
      <h1>ユーザー編集</h1>

      <div className="nav justify-content-end">
        <Link href="/admin/users" className="nav-link">一覧</Link>
      </div>

      <UserForm
        initialValues={{ name: user.name, email: user.email, admin: user.admin }}
        method="patch"
        url={`/admin/users/${user.id}`}
      />
    </>
  )
}
