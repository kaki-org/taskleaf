import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
// フォーム送信時のローディング状態を管理
export default class extends Controller {
  static targets = ["submit"]

  connect() {
    this.originalText = this.submitTarget.value || this.submitTarget.textContent
  }

  submit() {
    this.submitTarget.disabled = true
    if (this.submitTarget.tagName === "INPUT") {
      this.submitTarget.value = "送信中..."
    } else {
      this.submitTarget.textContent = "送信中..."
    }
  }

  reset() {
    this.submitTarget.disabled = false
    if (this.submitTarget.tagName === "INPUT") {
      this.submitTarget.value = this.originalText
    } else {
      this.submitTarget.textContent = this.originalText
    }
  }
}
