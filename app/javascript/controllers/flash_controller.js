import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { timeout: Number, direction: String }

  connect() {
    // デフォルトのタイムアウト値（ミリ秒）
    const timeout = this.hasTimeoutValue ? this.timeoutValue : 3000
    const direction = this.hasDirectionValue ? this.directionValue : 'right'
    // 指定された時間後にフラッシュメッセージを非表示にする
    this.timeoutId = setTimeout(() => {
      this.element.classList.add('transition-all', 'duration-500', 'ease-in-out', 'opacity-0')

      if (direction === 'right') {
        this.element.classList.add('translate-x-full')
      } else {
        this.element.classList.add('-translate-x-full')
      }

      setTimeout(() => {
        this.element.remove()
      }, 500)
    }, timeout)
  }

  disconnect() {
    // コントローラーが切断されたときにタイマーをクリア
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }
}
