import { Link } from '@inertiajs/react'

import TaskForm from '@/components/tasks/TaskForm'

type Props = {
  task: { id: number; name: string; description: string | null }
}

export default function Edit({ task }: Props) {
  return (
    <>
      <h1>タスクの編集</h1>

      <div className="nav justify-content-end">
        <Link href="/tasks" className="nav-link">一覧</Link>
      </div>

      <TaskForm
        initialValues={{ name: task.name, description: task.description ?? '' }}
        method="patch"
        url={`/tasks/${task.id}`}
        submitLabel="更新する"
      />
    </>
  )
}
