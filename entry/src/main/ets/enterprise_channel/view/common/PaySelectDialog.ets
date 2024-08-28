import { EnterpriseChannelService } from '../../net/EnterpriseChannelService'
import { AddOrderBodyResultBean } from '../../net/model/AddOrderBean'

@Preview
@CustomDialog
export struct PaySelectDialog {
  controller?: CustomDialogController
  addOrderBean?: AddOrderBodyResultBean
  confirm?: (addOrderJson: string) => void
  @State paymentType: number = 1

  build() {
    Column() {
      Row() {
        Text("选择支付方式")
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.h1'))
          .height(58)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Image($r("app.media.ic_pay_delete")).width(24).height(24).onClick(() => {
          this.controller?.close()
        })
      }

      Text("充值金额")
        .fontSize(12)
        .fontColor($r('app.color.font4')).margin({ top: 20 })

      Row() {
        Text("¥")
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.font9'))
        Text(`${this.addOrderBean?.payAmount?.toFixed(2)}`)
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.font1')).margin({ left: 4, top: 8 })
      }.alignItems(VerticalAlign.Bottom)

      Row() {
        Image($r("app.media.ic_pay_wx")).width(24).height(24)
        Text("微信支付")
          .fontSize(14)
          .layoutWeight(1)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.font1'))
          .margin({ left: 8 })
        Image(this.paymentType == 1 ? $r("app.media.ic_pay_select") : $r("app.media.ic_pay_unselect"))
          .width(24)
          .height(24)
      }.margin({ top: 36 }).onClick(() => {
        this.paymentType = 1
      })

      Row() {
        Image($r("app.media.ic_pay_ali")).width(24).height(24)
        Text("支付宝")
          .fontSize(14)
          .layoutWeight(1)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.font1'))
          .margin({ left: 8 })
        Image(this.paymentType == 2 ? $r("app.media.ic_pay_select") : $r("app.media.ic_pay_unselect"))
          .width(24)
          .height(24)
      }.margin({ top: 36 }).onClick(() => {
        this.paymentType = 2
      })

      Button("确定支付", { type: ButtonType.Normal, stateEffect: true })
        .width("100%")
        .height(44)
        .backgroundColor($r('app.color.h1'))
        .fontColor($r('app.color.white'))
        .fontSize(14)
        .borderRadius(4)
        .onClick(async () => {
          if (this.confirm) {
            const result = await EnterpriseChannelService.preOrder(this.addOrderBean?.orderId??0,this.paymentType)
            this.confirm(JSON.stringify(result.result))
          }
          this.controller?.close()
        })
        .margin({ top: 38 })
    }.height(342).width("100%").padding({ left: 16, right: 16 })
  }
}