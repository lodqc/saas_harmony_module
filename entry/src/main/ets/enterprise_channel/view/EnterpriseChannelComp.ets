import { OperationalData } from './OperationalData';
import { OtherSettings } from './OtherSettings';
import { RiderManage } from './RiderManage';
import { TitleLayout } from '../widgets/TitleLayout'
import { PaySuccessDialog } from './common/PaySuccessDialog';
import { PreOrderResultBean } from '../net/model/AddOrderBean';
import { EnterpriseChannelService } from '../net/EnterpriseChannelService';

@Component
export struct EnterpriseChannelComp {
  @Link @Watch('onPaySuccess') isPaySuccess:boolean;
  @Consume addOrderJson: string;

  @State currentIndex: number = 0
  private tabsController = new TabsController()

  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: PaySuccessDialog(),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    cornerRadius: 12,
  })

  onPaySuccess(propName: string): void  {
    this.isPaySuccess = false
    let headerBean = JSON.parse(this.addOrderJson) as PreOrderResultBean;
    EnterpriseChannelService.queryPayResult(headerBean.orderId ?? 0, headerBean.paymentType ?? 0).then((result) => {
      if (result.code == 600) {
        this.dialogController?.open();
      }
    });
  }

  build() {
    Column() {
      TitleLayout({ title: "企业渠道" })
      Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
        TabContent() {
          RiderManage()
        }.tabBar(this.tabBuilder("骑手管理", 0, $r("app.media.ic_rider_manage_s"), $r("app.media.ic_rider_manage")))

        TabContent() {
          OperationalData()
        }
        .tabBar(this.tabBuilder("运营数据", 1, $r("app.media.ic_operational_data_s"),
          $r("app.media.ic_operational_data")))

        TabContent() {
          OtherSettings()
        }.tabBar(this.tabBuilder("其他设置", 2, $r("app.media.ic_other_settings_s"), $r("app.media.ic_other_settings")))
      }
      .layoutWeight(1)
      .scrollable(false)
      .onChange((index) => {
        this.currentIndex = index
      })
      .backgroundColor($r("app.color.start_window_background"))
    }
  }

  @Builder
  tabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 24, height: 24 })
      Text(title)
        .fontWeight(this.currentIndex === targetIndex ? FontWeight.Medium : FontWeight.Regular)
        .fontColor(this.currentIndex === targetIndex ? $r("app.color.font1") : $r("app.color.font3"))
        .padding({ top: 3 })
        .fontSize(10)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex
      this.tabsController.changeIndex(targetIndex)
    })
  }
}
