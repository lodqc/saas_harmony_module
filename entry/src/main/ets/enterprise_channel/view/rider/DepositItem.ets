import { GetChannelDepositBean } from '../../net/model/GetChannelDepositBean'

@Preview
@Component
export struct DepositItem {
  isSelect: boolean = false
  item: GetChannelDepositBean = new GetChannelDepositBean()

  build() {
    Column(){
      if (this.isSelect){
        Divider().color($r("app.color.bg4")).height(1)
      }
      Row() {
        Image($r("app.media.ic_bean")).width(14).height(14)
        Text(`${this.item.batteryAmount}豆`)
          .fontSize(16)
          .fontColor(this.isSelect?$r('app.color.font1'):$r('app.color.font5')).margin({left:4})
        Text(this.item.depositName)
          .fontSize(16)
          .fontColor(this.isSelect?$r('app.color.font1'):$r('app.color.font5')).margin({left:24})
      }.height(40).width("100%").padding({ left: 30, right: 30 }).justifyContent(FlexAlign.Center)
      if (this.isSelect){
        Divider().color($r("app.color.bg4")).height(1)
      }
    }
  }
}