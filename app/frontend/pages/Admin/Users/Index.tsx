import { Link } from '@inertiajs/react'

import type { AdminUser } from '@/types/user'

export default function Index({ users }: { users: AdminUser[] }) {
  return (
    <>
      <h1>ユーザー一覧</h1>

      <Link href="/admin/users/new" className="btn btn-primary">新規登録</Link>

      <div className="mb-3">
        <table className="table table-hover">
          <thead className="thead-default">
            <tr>
              <th>名前</th>
              <th>メールアドレス</th>
              <th>管理者権限</th>
              <th>登録日時</th>
              <th>更新日時</th>
              <th></th>
            </tr>
          </thead>
          <tbody id="users-list">
            {users.map((user) => (
              <tr key={user.id} id={`user_${user.id}`}>
                <td><Link href={`/admin/users/${user.id}`}>{user.name}</Link></td>
                <td>{user.email}</td>
                <td>{user.admin ? 'あり' : 'なし'}</td>
                <td>{user.created_at}</td>
                <td>{user.updated_at}</td>
                <td>
                  <Link href={`/admin/users/${user.id}/edit`} className="btn btn-primary">編集</Link>{' '}
                  <Link href={`/admin/users/${user.id}/confirm_destroy`} className="btn btn-danger">削除</Link>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  )
}
