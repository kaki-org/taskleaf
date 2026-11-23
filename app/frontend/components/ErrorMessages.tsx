type Props = {
  // redirect_to ..., inertia: { errors: model.errors.to_hash(true) } で受け取るエラー
  errors: Partial<Record<string, string[] | string>>
}

export default function ErrorMessages({ errors }: Props) {
  const messages = Object.values(errors).flatMap((value) => value ?? [])
  if (messages.length === 0) return null

  return (
    <ul id="error_explanation" className="list-unstyled">
      {/* 同じ文言のエラーが複数あっても key が重複しないよう位置を使う */}
      {messages.map((message, index) => (
        <li key={index} className="alert alert-danger">
          {message}
        </li>
      ))}
    </ul>
  )
}
