import { useForm } from '@inertiajs/react'
import type { FormEvent } from 'react'

import ErrorMessages from '@/components/ErrorMessages'

type Props = {
  initialValues: { name: string; email: string; admin: boolean }
  method: 'post' | 'patch'
  url: string
}

export default function UserForm({ initialValues, method, url }: Props) {
  const form = useForm({ ...initialValues, password: '', password_confirmation: '' })

  const submit = (event: FormEvent) => {
    event.preventDefault()
    form.transform((data) => ({ user: data }))
    form.submit(method, url, { onFinish: () => form.reset('password', 'password_confirmation') })
  }

  return (
    <>
      <ErrorMessages errors={form.errors} />
      <form onSubmit={submit}>
        <div className="form-group">
          <label htmlFor="user_name">名前</label>
          <input
            type="text"
            id="user_name"
            className="form-control"
            value={form.data.name}
            onChange={(e) => form.setData('name', e.target.value)}
          />
        </div>
        <div className="form-group">
          <label htmlFor="user_email">メールアドレス</label>
          <input
            type="text"
            id="user_email"
            className="form-control"
            value={form.data.email}
            onChange={(e) => form.setData('email', e.target.value)}
          />
        </div>
        <div className="form-check">
          <label htmlFor="user_admin" className="form-check-label">
            <input
              type="checkbox"
              id="user_admin"
              className="form-check-input"
              checked={form.data.admin}
              onChange={(e) => form.setData('admin', e.target.checked)}
            />
            管理者権限
          </label>
        </div>
        <div className="form-group">
          <label htmlFor="user_password">パスワード</label>
          <input
            type="password"
            id="user_password"
            className="form-control"
            value={form.data.password}
            onChange={(e) => form.setData('password', e.target.value)}
          />
        </div>
        <div className="form-group">
          <label htmlFor="user_password_confirmation">パスワード(確認)</label>
          <input
            type="password"
            id="user_password_confirmation"
            className="form-control"
            value={form.data.password_confirmation}
            onChange={(e) => form.setData('password_confirmation', e.target.value)}
          />
        </div>
        <input type="submit" value="登録する" className="btn btn-primary" disabled={form.processing} />
      </form>
    </>
  )
}
