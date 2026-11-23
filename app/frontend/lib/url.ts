// 現在の URL のクエリを引き継ぎ、指定したパラメータだけ置き換えた URL を返す（null は削除）
export function withParams(url: string, changes: Record<string, string | null>): string {
  const [path, query = ''] = url.split('?')
  const params = new URLSearchParams(query)
  for (const [key, value] of Object.entries(changes)) {
    if (value === null) {
      params.delete(key)
    } else {
      params.set(key, value)
    }
  }
  const nextQuery = params.toString()
  return nextQuery ? `${path}?${nextQuery}` : path
}
