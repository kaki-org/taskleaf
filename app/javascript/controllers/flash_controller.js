import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
// フラッシュメッセージを一定時間後に自動的に非表示にする
export default class extends Controller {
  static values = {
    delay: { type: Number, default: 5000 }
  }

  connect() {
    this.timeout = setTimeout(() => {
      this.dismiss()
    }, this.delayValue)
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  dismiss() {
    this.element.classList.add("fade")
    this.element.addEventListener("transitionend", () => {
      this.element.remove()
    })
    this.element.style.opacity = "0"
  }
}
