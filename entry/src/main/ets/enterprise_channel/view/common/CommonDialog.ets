@Preview
@CustomDialog
export struct CommonDialog {
  title: string = ""
  content: string = ""
  confirm?: () => void
  controller?: CustomDialogController

  build() {
    Column() {
      Text(this.title).fontSize(18).fontWeight(FontWeight.Bold).fontColor($r('app.color.h1')).height(58)
      Text(this.content)
        .fontSize(14)
        .fontColor($r('app.color.h1'))
        .layoutWeight(1)
        .padding({ left: 20, right: 20,top:16,bottom:16 })
      Divider().color($r('app.color.bg4')).height(1).width("100%")
      Row() {
        Text("取消")
          .layoutWeight(1)
          .fontColor($r('app.color.font1'))
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .height(56)
          .onClick(() => {
            this.controller?.close()
          })
        Divider().color($r('app.color.bg4')).width(1).height(56)
        Text("确定")
          .layoutWeight(1)
          .height(56)
          .fontColor($r('app.color.font2'))
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            if (this.confirm) {
              this.confirm()
            }
            this.controller?.close()
          })
      }
    }.height(184).width(311)
  }
}