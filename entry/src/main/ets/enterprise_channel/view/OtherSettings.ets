import { AccountCenterBean } from '../net/model/AccountCenterBean';
@Component
export struct OtherSettings {
  @LocalStorageLink("AccountCenterBean") accountBean:AccountCenterBean = new AccountCenterBean();

  build() {
    Column() {
      Row() {
        Text('渠道名称').fontSize(14).fontColor($r('app.color.font1')).layoutWeight(1)
        Text(this.accountBean.channelName).fontSize(14).fontColor($r('app.color.font1'))
      }.height(54).backgroundColor($r('app.color.white')).margin({ top: 10 }).padding(16)
    }.backgroundColor($r('app.color.bg1')).width("100%").height("100%")
  }
}