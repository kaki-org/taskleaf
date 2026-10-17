import { usePage } from '@inertiajs/react'
import { useEffect, useState } from 'react'

const HIDE_AFTER_MS = 5000

// ERB の flash_controller.js と同じく、表示から一定時間後に flash を消す
export default function FlashMessages() {
  const { flash } = usePage()
  const [shownFlash, setShownFlash] = useState(flash)
  const [hidden, setHidden] = useState(false)

  // 同じ文言が続けて返っても再表示できるよう、画面遷移ごとの flash オブジェクトで判定する
  if (flash !== shownFlash) {
    setShownFlash(flash)
    setHidden(false)
  }

  useEffect(() => {
    if (hidden) return
    const timer = setTimeout(() => setHidden(true), HIDE_AFTER_MS)
    return () => clearTimeout(timer)
  }, [flash, hidden])

  return (
    <div id="flash">
      {!hidden && flash?.notice && <div className="alert alert-success">{flash.notice}</div>}
      {!hidden && flash?.alert && <div className="alert alert-danger">{flash.alert}</div>}
    </div>
  )
}
