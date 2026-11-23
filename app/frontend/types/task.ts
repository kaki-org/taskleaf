// TasksController#task_detail_props
export type TaskDetail = {
  id: number
  name: string
  // サーバー側で HTML エスケープ済みの説明に改行とリンクを付けたもの
  description_html: string
  image_url: string | null
  created_at: string
  updated_at: string
}
