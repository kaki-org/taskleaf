import { Link, router, useForm } from '@inertiajs/react'
import { useRef, useState, type FormEvent } from 'react'

import Pagination, { type PaginationMeta } from '@/components/Pagination'
import SortLink from '@/components/SortLink'

type TaskRow = {
  id: number
  name: string
  created_at: string
}

type Query = {
  name_cont?: string
  created_at_gteq?: string
  s?: string
}

type Props = {
  tasks: TaskRow[]
  pagination: PaginationMeta
  entries_info: string
  query: Query
  special_time: boolean
}

export default function Index({ tasks, pagination, entries_info: entriesInfo, query, special_time: specialTime }: Props) {
  const [search, setSearch] = useState({ name_cont: query.name_cont ?? '', created_at_gteq: query.created_at_gteq ?? '' })
  const importForm = useForm<{ file: File | null }>({ file: null })
  const fileInput = useRef<HTMLInputElement>(null)

  const submitSearch = (event: FormEvent) => {
    event.preventDefault()
    router.get('/tasks', { q: search }, { preserveState: true })
  }

  const submitImport = (event: FormEvent) => {
    event.preventDefault()
    importForm.post('/tasks/import', {
      onSuccess: () => {
        importForm.reset()
        if (fileInput.current) fileInput.current.value = ''
      },
    })
  }

  return (
    <>
      <h1>タスク一覧</h1>

      <form className="mb-5" onSubmit={submitSearch}>
        <div className="form-group row">
          <label htmlFor="q_name_cont" className="col-sm-2 col-form-label">名称</label>
          <div className="col-sm-10">
            <input
              type="search"
              id="q_name_cont"
              className="form-control"
              value={search.name_cont}
              onChange={(e) => setSearch({ ...search, name_cont: e.target.value })}
            />
          </div>
        </div>
        <div className="form-group row">
          <label htmlFor="q_created_at_gteq" className="col-sm-2 col-form-label">登録日時</label>
          <div className="col-sm-10">
            <input
              type="search"
              id="q_created_at_gteq"
              className="form-control"
              value={search.created_at_gteq}
              onChange={(e) => setSearch({ ...search, created_at_gteq: e.target.value })}
            />
          </div>
        </div>
        <div className="form-group">
          <input type="submit" value="検索" className="btn btn-outline-primary" />
        </div>
      </form>

      <Link href="/tasks/new" className="btn btn-primary">新規登録</Link>

      <div className="mb-3">
        <Pagination {...pagination} />
        {entriesInfo}

        <table className="table table-hover">
          <thead className="thead-default">
            <tr>
              <th><SortLink field="name" label="名称" sort={query.s} /></th>
              <th><SortLink field="created_at" label="登録日時" sort={query.s} /></th>
              <th></th>
            </tr>
          </thead>
          <tbody id="tasks-list">
            {tasks.map((task) => (
              <tr key={task.id} id={`task_${task.id}`}>
                <td><Link href={`/tasks/${task.id}`}>{task.name}</Link></td>
                <td>{task.created_at}</td>
                <td>
                  <Link href={`/tasks/${task.id}/edit`} className="btn btn-primary">編集</Link>{' '}
                  <Link href={`/tasks/${task.id}/confirm_destroy`} className="btn btn-danger delete">削除</Link>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* CSV のダウンロードは Inertia の画面遷移にしない */}
      <a href="/tasks.csv" className="btn btn-primary mb-3">エクスポート</a>

      <form className="mb-3" onSubmit={submitImport}>
        <input
          type="file"
          name="file"
          ref={fileInput}
          onChange={(e) => importForm.setData('file', e.target.files?.[0] ?? null)}
        />
        <input type="submit" value="インポート" className="btn btn-primary" disabled={importForm.processing} />
      </form>

      {specialTime && <div className="alert alert-success">お誕生日おめでとうございます</div>}
    </>
  )
}
