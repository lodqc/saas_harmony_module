import { webview } from '@kit.ArkWeb'
import { logger } from '../utils/logger'

@Component
export struct HdWeb {
  src: ResourceStr = $rawfile('detail.html')
  onLoad: () => void = () => {
  }
  controller: webview.WebviewController = new webview.WebviewController()

  build() {
    Web({ src: this.src, controller: this.controller })
      .javaScriptAccess(true)
      .onPageEnd(() => {
        this.onLoad()
      })
      .onErrorReceive(event => {
        logger.error(event!.error.getErrorInfo())
      })
      .layoutWeight(1)
  }
}