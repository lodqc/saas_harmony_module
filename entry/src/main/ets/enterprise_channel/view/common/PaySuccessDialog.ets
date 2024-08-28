@Preview
@CustomDialog
export struct PaySuccessDialog {
  controller?: CustomDialogController

  build() {
    Column() {
      Image($r("app.media.ic_pay_success")).width(284).height(167)
      Text("支付成功")
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.h1'))
        .margin({ top: 6 })
        .height(58)
      Button("确定", { type: ButtonType.Normal, stateEffect: true })
        .width("100%")
        .height(44)
        .backgroundColor($r('app.color.h1'))
        .fontColor($r('app.color.white'))
        .fontSize(14)
        .borderRadius(4)
        .onClick(() => {
          this.controller?.close()
        })
        .margin({ bottom: 24 })
    }.height(293).width(284)
  }
}