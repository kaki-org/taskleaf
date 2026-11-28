import type { AdminUser } from '@/types/user'

export default function UserDetailTable({ user }: { user: AdminUser }) {
  return (
    <table className="table table-hover">
      <tbody>
        <tr>
          <th>ID</th>
          <td>{user.id}</td>
        </tr>
        <tr>
          <th>名前</th>
          <td>{user.name}</td>
        </tr>
        <tr>
          <th>メールアドレス</th>
          <td>{user.email}</td>
        </tr>
        <tr>
          <th>管理者権限</th>
          <td>{user.admin ? 'あり' : 'なし'}</td>
        </tr>
        <tr>
          <th>登録日時</th>
          <td>{user.created_at}</td>
        </tr>
        <tr>
          <th>更新日時</th>
          <td>{user.updated_at}</td>
        </tr>
      </tbody>
    </table>
  )
}
