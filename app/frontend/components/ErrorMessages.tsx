type Props = {
  // redirect_to ..., inertia: { errors: model.errors.to_hash(true) } で受け取るエラー
  errors: Partial<Record<string, string[] | string>>
}

export default function ErrorMessages({ errors }: Props) {
  const messages = Object.values(errors).flatMap((value) => value ?? [])
  if (messages.length === 0) return null

  return (
    <ul id="error_explanation" className="list-unstyled">
      {messages.map((message) => (
        <li key={message} className="alert alert-danger">
          {message}
        </li>
      ))}
    </ul>
  )
}
