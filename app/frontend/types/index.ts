export type FlashData = {
  notice?: string
  alert?: string
}

export type CurrentUser = {
  id: number
  name: string
  admin: boolean
}

// ApplicationController の inertia_share で全ページに渡す props
export type SharedProps = {
  current_user: CurrentUser | null
}
