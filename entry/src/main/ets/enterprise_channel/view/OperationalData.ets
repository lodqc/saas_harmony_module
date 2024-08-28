import { EnterpriseChannelService } from '../net/EnterpriseChannelService';
import { AccountCenterBean } from '../net/model/AccountCenterBean';
import { toast } from '../util/Toast';
import { OperationalTab } from './opertional/OperationalTab';
import { TopUpBeanDialog } from './opertional/TopUpBeanDialog';

@Component
export struct OperationalData {
  @Consume addOrderJson: string;
  @LocalStorageLink("AccountCenterBean") accountBean: AccountCenterBean = new AccountCenterBean();
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: TopUpBeanDialog({
      confirm: (addOrderJson) => {
        this.addOrderJson = addOrderJson
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    width: '100%',
    cornerRadius: 12,
  })

  async aboutToAppear(): Promise<void> {
    await this.loadData();
  }

  private  loadData(onSuccess?: () => void) {
    EnterpriseChannelService.accountCenter().then(res => {
      this.accountBean = res.result!!;
      if (onSuccess&&res.code == 600) {
        onSuccess()
      }
    });
  }

  // 在自定义组件即将析构销毁时将dialogController置空
  aboutToDisappear() {
    this.dialogController = null // 将dialogController置空
  }

  build() {
    Column() {
      Stack() {
        Image($r('app.media.ic_bean_bg')).width("100%").height(104).objectFit(ImageFit.Fill)
        Column() {
          Row() {
            Text("金豆数量").fontSize(14).fontColor($r('app.color.white'))
            Image($r('app.media.ic_bean')).width(14).height(14).margin({ left: 4 })
            Shape().layoutWeight(1)
            Image($r('app.media.ic_refresh')).width(14).height(14)
            Text("刷新").fontSize(13).fontColor($r('app.color.white')).margin({ left: 4 }).onClick(() => {
              this.loadData(() => {
                toast("刷新成功")
              })
            })
          }.width("100%")

          Row() {
            Text(`${this.accountBean.residueNum ?? 0}`)
              .fontSize(32)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.white'))
              .layoutWeight(1)
            Button("充值", { type: ButtonType.Normal })
              .borderRadius(4)
              .backgroundColor($r("app.color.white"))
              .width(72)
              .fontSize(14)
              .onClick(() => {
                if (this.dialogController != null) {
                  this.dialogController.open()
                }
              })
              .fontColor($r('app.color.font1'))
              .height(30)
              .alignSelf(ItemAlign.End)
          }.width("100%").margin({ top: 8 })
        }.padding(20)
      }.padding({ left: 16, right: 16, top: 8 })


      Tabs({ barPosition: BarPosition.Start, controller: this.tabsController }) {
        TabContent() {
          OperationalTab({
            type: 0
          })
        }.tabBar(this.tabBuilder("金豆明细", 0))

        TabContent() {
          OperationalTab({
            type: 1
          })
        }.tabBar(this.tabBuilder("充值记录", 1))
      }
      .barMode(BarMode.Scrollable)
      .height("78%")
      .barHeight(44)
      .borderRadius(4)
      .backgroundColor($r('app.color.white'))
      .margin({ top: 18, left: 16, right: 16 })
      .onChange((index) => {
        this.currentIndex = index
      })
      .scrollable(true)
    }
    .width('100%').height('100%').backgroundColor($r('app.color.bg7'))
  }

  @State currentIndex: number = 0
  private tabsController = new TabsController()

  @Builder
  tabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontWeight(this.currentIndex === targetIndex ? FontWeight.Medium : FontWeight.Regular)
        .fontColor(this.currentIndex === targetIndex ? $r("app.color.font1") : $r("app.color.font4"))
        .padding({ top: 3 })
        .fontSize(14)
      Text()
        .backgroundColor(this.currentIndex === targetIndex ? $r("app.color.bg6") : $r("app.color.white"))
        .width(40)
        .height(3)
        .margin({ top: 8 })
        .borderRadius(2)
    }
    .justifyContent(FlexAlign.Center)
    .padding({ left: 50, right: 50 })
    .onClick(() => {
      this.currentIndex = targetIndex
      this.tabsController.changeIndex(targetIndex)
    })
  }
}
