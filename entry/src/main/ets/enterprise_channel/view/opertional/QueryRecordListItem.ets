import { QueryRecordListBean } from '../../net/model/QueryRecordListBean'
import TimeUtils from '../../util/TimeUtils'

@Preview
@Component
export struct QueryRecordListItem {
  item: QueryRecordListBean = new QueryRecordListBean()

  build() {
    Row() {
      Column() {
        Row() {
          Image(this.getIcon()).width(22).height(22)
          Text(this.getTitle())
            .fontSize(16)
            .fontColor($r('app.color.font1'))
            .fontWeight(FontWeight.Bold).margin({ left: 8 })
        }.width("100%")

        Text(TimeUtils.toFull(this.item.createTime ?? 0))
          .fontSize(13)
          .fontColor($r('app.color.font5')).margin({ top: 4 })
      }.layoutWeight(1).alignItems(HorizontalAlign.Start)

      Text(`+${this.item.goldBeanNum}豆`)
        .fontSize(16)
        .fontColor(this.item.tradeType == 4 ? $r('app.color.font2') : $r('app.color.font1'))
        .fontWeight(FontWeight.Bold)
    }
    .padding(16)
    .width("100%")
    .height(82)
  }

  private getIcon() {
    if (this.item.tradeType == 1 || this.item.tradeType == 3) {
      return $r('app.media.ic_wx')
    } else if (this.item.tradeType == 2) {
      return $r('app.media.ic_ali')
    } else {
      return $r('app.media.ic_gift')
    }
  }

  private getTitle() {
    if (this.item.tradeType == 1 || this.item.tradeType == 3) {
      return "微信充值"
    } else if (this.item.tradeType == 2) {
      return "支付宝充值"
    } else {
      return "平台赠送"
    }
  }
}