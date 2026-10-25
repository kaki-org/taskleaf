import { Link } from '@inertiajs/react'

import TaskDetailTable from '@/components/tasks/TaskDetailTable'
import type { TaskDetail } from '@/types/task'

export default function Show({ task }: { task: TaskDetail }) {
  return (
    <>
      <h1>タスクの詳細</h1>

      <div className="nav justify-content-end">
        <Link href="/tasks" className="nav-link">一覧</Link>
      </div>
      <TaskDetailTable task={task} />

      <Link href={`/tasks/${task.id}/edit`} className="btn btn-primary mr-3">編集</Link>{' '}
      <Link href={`/tasks/${task.id}/confirm_destroy`} className="btn btn-danger">削除</Link>
    </>
  )
}
