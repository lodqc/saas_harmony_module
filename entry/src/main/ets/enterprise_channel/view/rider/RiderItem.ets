import { EnterpriseChannelService } from '../../net/EnterpriseChannelService';
import { GetChannelUser } from '../../net/model/GetChannelUserBean';
import TimeUtils from '../../util/TimeUtils';
import { toast } from '../../util/Toast';
import { SelectDepositPlanDialog } from './SelectDepositPlanDialog';

@Preview
@Component
export struct RiderItem {
  searchType: number = 3;
  @State isUnAuth: boolean = true;
  onReload?: () => void;
  bean: GetChannelUser = new GetChannelUser();
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: SelectDepositPlanDialog({ searchType: this.searchType, bean: this.bean }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    width: '100%',
    cornerRadius: 12,
  })

  aboutToAppear(): void {
    this.isUnAuth = this.searchType == 0 && this.bean?.realNameStatus != 1
  }

  // 在自定义组件即将析构销毁时将dialogController置空
  aboutToDisappear() {
    this.dialogController = null // 将dialogController置空
  }

  build() {
    Column() {
      if (this.isUnAuth) { //未实名认证
        Row() {
          Image($r('app.media.ic_info')).width(16).height(16).margin({ right: 4 })
          Text("用户需完成 [实名认证]").fontSize(14).fontColor($r('app.color.font10'))
        }.width("100%").height(40).padding({ left: 16 }).backgroundColor($r('app.color.bg8'))
      }

      RelativeContainer() {
        Row() {
          Text(this.bean.nickName)
            .fontSize(14)
            .fontColor($r("app.color.font1"))
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
          Text(getTypeStatus(this.searchType)).fontSize(14).fontColor(getTypeStatusColor(this.searchType))
        }.id("Row1")

        Row() {
          Text("押金状态：").fontSize(14).fontColor($r("app.color.font5"))
          Text(getDepositStatus(this.bean.depositFlag))
            .fontSize(14)
            .fontColor(this.searchType == 0 ? $r("app.color.font6") : $r("app.color.font1"))
        }.id("Row2").alignRules({
          top: { 'anchor': 'Row1', align: VerticalAlign.Bottom },
          left: { 'anchor': 'Row1', align: HorizontalAlign.Start }
        }).margin({ top: 13 })

        Row() {
          Text("电池型号：").fontSize(14).fontColor($r("app.color.font5"))
          Text(this.bean.batteryTypeName ?? "--").fontSize(14).fontColor($r("app.color.font1"))
        }.id("Row3").alignRules({
          top: { 'anchor': 'Row2', align: VerticalAlign.Bottom },
          left: { 'anchor': 'Row2', align: HorizontalAlign.Start }
        }).margin({ top: 4 })

        Row() {
          Text("绑定电池：").fontSize(14).fontColor($r("app.color.font5"))
          Text(this.bean.bindBatterySn ?? "--").fontSize(14).fontColor($r("app.color.font1"))
        }.id("Row4").alignRules({
          top: { 'anchor': 'Row3', align: VerticalAlign.Bottom },
          left: { 'anchor': 'Row3', align: HorizontalAlign.Start }
        }).margin({ top: 4 })

        Row() {
          Text("用户备注：").fontSize(14).fontColor($r("app.color.font5"))
          Text(this.bean.userRemark ?? "--").fontSize(14).fontColor($r("app.color.font1"))
        }.id("Row6").alignRules({
          top: { 'anchor': 'Row4', align: VerticalAlign.Bottom },
          left: { 'anchor': 'Row4', align: HorizontalAlign.Start }
        }).margin({ top: 4 })

        if (this.bean.canRecycleGoldBeanNum && this.bean.canRecycleGoldBeanNum != 0) {
          Row() {
            Text("当前可回收").fontSize(14).fontColor($r("app.color.font5"))
            Image($r("app.media.ic_bean")).width(14).height(14).margin({ left: 4, right: 4 })
            Text(`${this.bean.canRecycleGoldBeanNum}豆`)
              .fontSize(14)
              .fontColor($r("app.color.font2"))
              .fontWeight(FontWeight.Bold)
              .layoutWeight(1)
            Text("点击全部回收").fontSize(14).fontColor($r("app.color.font1"))
          }
          .id("Row5")
          .alignRules({
            top: { 'anchor': 'Row6', align: VerticalAlign.Bottom },
            left: { 'anchor': 'Row6', align: HorizontalAlign.Start }
          })
          .margin({ top: 16 })
          .padding({ left: 12, right: 12 })
          .borderRadius(2)
          .backgroundColor($r("app.color.bg3"))
          .width('100%')
          .height(38)
          .onClick(async () => {
            await EnterpriseChannelService
              .goldBeanRecycle(this.bean.depositOrderId ?? 0, this.bean.packageOrderId ?? 0, this.bean.userId ?? 0)
            if (this.onReload) {
              this.onReload()
            }
          })
        }

        if (this.searchType != 0) {
          Divider()
            .color($r("app.color.bg4"))
            .width('100%')
            .height(0.5)
            .alignRules({
              bottom: { 'anchor': 'Button', align: VerticalAlign.Top },
              left: { 'anchor': 'Row4', align: HorizontalAlign.Start }
            })
            .margin({ bottom: 8 })

          if (this.searchType != 2) {
            Text((this.bean.packageFinishTime && this.bean.packageFinishTime != "") ?
              `${TimeUtils.toYMD(this.bean.packageFinishTime)} 到期（余${this.bean.remainDays ?? ""}天）` : '--')
              .fontSize(14)
              .fontColor($r("app.color.font5"))
              .alignRules({
                top: { 'anchor': 'Button', align: VerticalAlign.Top },
              })
              .margin({ top: 8 })
          }
        }

        Button(this.searchType == 0 ? "代付押金" : "续套餐", { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(4)
          .backgroundColor($r("app.color.main"))
          .width(100)
          .height(30)
          .id("Button")
          .onClick(() => {
            if (this.isUnAuth) {
              toast('未实名认证用户，不能代付')
            } else {
              if (this.dialogController != null) {
                this.dialogController.open()
              }
            }
          })
          .alignRules({
            bottom: { 'anchor': '__container__', align: VerticalAlign.Bottom },
            right: { 'anchor': '__container__', align: HorizontalAlign.End }
          })
      }
      .height(getTypeHeight(this.bean))
      .margin({ left: 10, right: 10, top: 10 })
      .padding({
        left: 16,
        right: 16,
        top: 12,
        bottom: 8
      })
      .backgroundColor($r('app.color.white'))
      .borderRadius(4)
    }
  }
}

function getDepositStatus(depositFlag?: number): string {
  switch (depositFlag) {
    case 1:
      return "支付押金"
    case 2:
      return "微信支付分免押"
    case 3:
      return "支付宝信用免押"
    case 4:
      return "白名单免押"
    case 5:
      return "人工免押"
    case 6:
      return "代付免押"
    default:
      return "未缴纳押金"
  }
}

function getTypeHeight(bean: GetChannelUser): Length {
  if (bean.canRecycleGoldBeanNum && bean.canRecycleGoldBeanNum != 0) {
    return 238
  } else {
    return 184
  }
}

function getTypeStatus(searchType: number): string {
  switch (searchType) {
    case 1:
      return "已代付"
    case 2:
      return "已到期"
    case 3:
      return "可回收"
    default:
      return "未代付"
  }
}

function getTypeStatusColor(searchType: number) {
  switch (searchType) {
    case 1:
      return $r("app.color.font7")
    case 2:
      return $r("app.color.font4")
    case 3:
      return $r("app.color.font1")
    default:
      return $r("app.color.font2")
  }
}
