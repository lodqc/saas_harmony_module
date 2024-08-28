import { QueryTradeLogListBean } from '../../net/model/QueryTradeLogListBean'
import TimeUtils from '../../util/TimeUtils'

@Preview
@Component
export struct QueryTradeLogItem {
  item: QueryTradeLogListBean = new QueryTradeLogListBean()

  build() {
    Column() {
      Row() {
        Image(this.getIcon()).width(22).height(22)
        Text(this.item.tradeContent)
          .fontSize(16)
          .fontColor($r('app.color.font1'))
          .margin({ left: 5 })
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
        Text(`${this.item.tradeGoldBean}`)
          .fontSize(16)
          .fontColor(this.item.actionType == 1?$r('app.color.font1'):$r('app.color.font2'))
          .fontWeight(FontWeight.Bold)
      }.width("100%")

      Row() {
        Text("订单号")
          .fontSize(14)
          .fontColor($r('app.color.font5'))

        Text(this.item.orderNo)
          .fontSize(14)
          .fontColor($r('app.color.font5')).margin({ left: 30 })
      }.width("100%").margin({ top: 13 })

      Row() {
        Text("手机号")
          .fontSize(14)
          .fontColor($r('app.color.font5'))
        Text(this.item.userPhone)
          .fontSize(14)
          .fontColor($r('app.color.font5')).margin({ left: 30 })
      }.width("100%").layoutWeight(1)


      Row() {
        Text("支付时间")
          .fontSize(14)
          .fontColor($r('app.color.font5'))
        Text(TimeUtils.toFull(this.item.createTime??0))
          .fontSize(14)
          .fontColor($r('app.color.font5')).margin({ left: 16 })
      }.width("100%")
    }
    .padding(16)
    .backgroundColor($r('app.color.white'))
    .width("100%")
    .height(142)
  }

  private getIcon() {
    if (this.item.actionType == 1) {
      if (this.item.businessType == 1) {
        return $r('app.media.ic_deosit')
      } else {
        return $r('app.media.ic_money')
      }
    } else {
      return $r('app.media.ic_yelow_back')
    }
  }
}