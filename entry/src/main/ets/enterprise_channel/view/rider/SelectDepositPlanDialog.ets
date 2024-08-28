import { EnterpriseChannelService } from '../../net/EnterpriseChannelService';
import { GetChannelDepositBean } from '../../net/model/GetChannelDepositBean';
import { GetChannelPackageBean } from '../../net/model/getChannelPackageBean';
import { GetChannelUser } from '../../net/model/GetChannelUserBean';
import { toast } from '../../util/Toast';
import { CommonDialog } from '../common/CommonDialog';
import { DepositItem } from './DepositItem';
import { PlanItem } from './PlanItem';

@Preview
@CustomDialog
export struct SelectDepositPlanDialog {
  searchType: number = 0
  depositId: number = 0
  packageId: number = 0
  bean: GetChannelUser = new GetChannelUser();
  controller?: CustomDialogController
  private scroller: Scroller = new Scroller();
  @State depositData: GetChannelDepositBean[] = [];
  @State packageData: GetChannelPackageBean[] = [];
  @State index: number = 0;
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CommonDialog({
      title: "支付提示",
      content: `您确定为 [${this.bean.nickName}] 用户，${this.searchType == 0 ? "代支付 [电池押金]" : "续套餐"} ？`,
      confirm: async () => {
        if (this.searchType == 0) {
          EnterpriseChannelService.goldBeanBuyDeposit(this.depositId, this.bean.userId ?? 0).then(res => {
            if (res.code == 600) {
              toast("支付成功")
            }
          })
        } else {
          await EnterpriseChannelService.goldBeanBuyPackage(this.packageId, this.bean.userId ?? 0).then(res => {
            if (res.code == 600) {
              toast("支付成功")
            }
          })
        }
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    cornerRadius: 12,
  })
  confirm = (index: number) => {
    this.index = index
  }

  // 在自定义组件即将析构销毁时将dialogController置空
  aboutToDisappear() {
    this.dialogController = null
  }

  async aboutToAppear() {
    if (this.searchType == 0) {
      const res = await EnterpriseChannelService.getChannelDepositList()
      this.depositData = res.result!!;
    } else {
      const res = await EnterpriseChannelService.getChannelPackageList()
      this.packageData = res.result!!;
    }
  }

  build() {
    Column() {
      Row() {
        Text("取消").fontSize(16).fontWeight(FontWeight.Medium).fontColor($r('app.color.font1')).onClick(() => {
          this.controller?.close()
        })
        Text("代付套餐")
          .fontSize(18)
          .fontColor($r('app.color.h1'))
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text("确定").fontSize(16).fontWeight(FontWeight.Medium).fontColor($r('app.color.font2')).onClick(async () => {
          if (this.dialogController != null) {
            if (this.searchType == 0) {
              this.depositId = this.depositData[this.index].depositId ?? 0
            } else {
              this.packageId = this.packageData[this.index].packageId ?? 0
            }
            this.dialogController.open()
          }
          this.controller?.close()
        })
      }.height(58).width("100%").padding({ left: 16, right: 16 })

      List({ scroller: this.scroller }) {
        if (this.searchType == 0) {
          ForEach(this.depositData, (item: GetChannelDepositBean, index) => {
            ListItem() {
              if (this.index == index) {
                DepositItem({ item: item, isSelect: true }).onClick(() => {
                  this.index = index
                })
              } else {
                DepositItem({ item: item, isSelect: false }).onClick(() => {
                  this.index = index
                })
              }
            }
          })
        } else {
          ForEach(this.packageData, (item: GetChannelPackageBean, index) => {
            ListItem() {
              if (this.index == index) {
                PlanItem({ item: item, isSelect: true }).onClick(() => {
                  this.index = index
                })
              } else {
                PlanItem({ item: item, isSelect: false }).onClick(() => {
                  this.index = index
                })
              }
            }
          })
        }
      }
      .width('100%')
      .height('100%')
      .alignListItem(ListItemAlign.Center)
      .listDirection(Axis.Vertical)
    }.height(308).width("100%")
  }
}