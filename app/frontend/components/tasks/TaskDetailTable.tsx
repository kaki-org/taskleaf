import type { TaskDetail } from '@/types/task'

export default function TaskDetailTable({ task }: { task: TaskDetail }) {
  return (
    <table className="table table-hover">
      <tbody>
        <tr>
          <th>ID</th>
          <td>{task.id}</td>
        </tr>
        <tr>
          <th>名称</th>
          <td>{task.name}</td>
        </tr>
        <tr>
          <th>詳しい説明</th>
          <td dangerouslySetInnerHTML={{ __html: task.description_html }} />
        </tr>
        <tr>
          <th>画像</th>
          <td>{task.image_url && <img src={task.image_url} alt={task.name} />}</td>
        </tr>
        <tr>
          <th>登録日時</th>
          <td>{task.created_at}</td>
        </tr>
        <tr>
          <th>更新日時</th>
          <td>{task.updated_at}</td>
        </tr>
      </tbody>
    </table>
  )
}
