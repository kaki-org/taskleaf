import { useForm } from '@inertiajs/react'
import type { FormEvent } from 'react'

import ErrorMessages from '@/components/ErrorMessages'

type Props = {
  initialValues: { name: string; description: string }
  method: 'post' | 'patch'
  url: string
  submitLabel: string
}

export default function TaskForm({ initialValues, method, url, submitLabel }: Props) {
  const form = useForm<{ name: string; description: string; image: File | null }>({ ...initialValues, image: null })

  const submit = (event: FormEvent) => {
    event.preventDefault()
    // image に null を送ると添付済みの画像が外れるため、選択したときだけ送る
    form.transform(({ image, ...rest }) => ({ task: image ? { ...rest, image } : rest }))
    form.submit(method, url)
  }

  return (
    <>
      <ErrorMessages errors={form.errors} />
      <form onSubmit={submit}>
        <div className="form-group">
          <label htmlFor="task_name">名称</label>
          <input
            type="text"
            id="task_name"
            className="form-control"
            value={form.data.name}
            onChange={(e) => form.setData('name', e.target.value)}
          />
        </div>
        <div className="form-group">
          <label htmlFor="task_description">詳しい説明</label>
          <textarea
            id="task_description"
            rows={5}
            className="form-control"
            value={form.data.description}
            onChange={(e) => form.setData('description', e.target.value)}
          />
        </div>
        <div className="form-group">
          <label htmlFor="task_image">画像</label>
          <input
            type="file"
            id="task_image"
            className="form-control"
            onChange={(e) => form.setData('image', e.target.files?.[0] ?? null)}
          />
        </div>
        <input type="submit" value={submitLabel} className="btn btn-primary" disabled={form.processing} />
      </form>
    </>
  )
}
