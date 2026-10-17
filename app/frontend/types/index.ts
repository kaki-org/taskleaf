export type FlashData = {
  notice?: string
  alert?: string
}

// inertia_share で全ページに渡す props。ページを移行するステップで項目を足す
export type SharedProps = Record<string, never>
