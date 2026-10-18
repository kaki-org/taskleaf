import { Link, router } from '@inertiajs/react'

import TaskDetailTable from '@/components/tasks/TaskDetailTable'
import type { TaskDetail } from '@/types/task'

export default function ConfirmDestroy({ task }: { task: TaskDetail }) {
  return (
    <>
      <h1>タスクの削除確認</h1>

      <div className="nav justify-content-end">
        <Link href="/tasks" className="nav-link">一覧</Link>
      </div>
      <div className="alert alert-danger">削除します。よろしいですか？</div>
      <TaskDetailTable task={task} />

      <button type="button" className="btn btn-danger" onClick={() => router.delete(`/tasks/${task.id}`)}>
        削除
      </button>
    </>
  )
}
