import { GetChannelPackageBean } from '../../net/model/getChannelPackageBean'

@Preview
@Component
export struct PlanItem {
  isSelect: boolean = false
  item: GetChannelPackageBean = new GetChannelPackageBean()

  build() {
    Column(){
      if (this.isSelect){
        Divider().color($r("app.color.bg4")).height(1)
      }
      Row() {
        Image($r("app.media.ic_bean")).width(14).height(14)
        Text(`${this.item.packageAmount}豆`)
          .fontSize(16)
          .fontColor(this.isSelect?$r('app.color.font1'):$r('app.color.font5')).margin({left:4})
        Text(this.item.packageName)
          .fontSize(16)
          .fontColor(this.isSelect?$r('app.color.font1'):$r('app.color.font5'))
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text(`${this.item.duration}天`)
          .fontSize(16)
          .fontColor(this.isSelect?$r('app.color.font1'):$r('app.color.font5'))
      }.height(40).width("100%").padding({ left: 30, right: 30 })
      if (this.isSelect){
        Divider().color($r("app.color.bg4")).height(1)
      }
    }
  }
}