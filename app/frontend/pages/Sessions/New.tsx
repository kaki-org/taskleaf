import { useForm } from '@inertiajs/react'
import type { FormEvent } from 'react'

type Props = {
  greeting: string
}

export default function New({ greeting }: Props) {
  const form = useForm({ email: '', password: '' })

  const submit = (event: FormEvent) => {
    event.preventDefault()
    form.transform((data) => ({ session: data }))
    // 失敗時はログイン画面へリダイレクトされ、入力値が残るためパスワードだけ消す
    form.post('/login', { onFinish: () => form.reset('password') })
  }

  return (
    <>
      <h1>ログイン</h1>
      {greeting}

      <form onSubmit={submit}>
        <div className="form-group">
          <label htmlFor="session_email">メールアドレス</label>
          <input
            type="text"
            id="session_email"
            className="form-control"
            value={form.data.email}
            onChange={(e) => form.setData('email', e.target.value)}
          />
        </div>
        <div className="form-group">
          <label htmlFor="session_password">パスワード</label>
          <input
            type="password"
            id="session_password"
            className="form-control"
            value={form.data.password}
            onChange={(e) => form.setData('password', e.target.value)}
          />
        </div>
        <input type="submit" value="ログインする" className="btn btn-primary" disabled={form.processing} />
      </form>
    </>
  )
}
