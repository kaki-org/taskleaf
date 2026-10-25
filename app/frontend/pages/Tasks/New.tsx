import { Link } from '@inertiajs/react'

import TaskForm from '@/components/tasks/TaskForm'

export default function New() {
  return (
    <>
      <h1>タスクの新規登録</h1>

      <div className="nav justify-content-end">
        <Link href="/tasks" className="nav-link">一覧</Link>
      </div>

      <TaskForm initialValues={{ name: '', description: '' }} method="post" url="/tasks" submitLabel="登録する" />
    </>
  )
}
