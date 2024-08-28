import { EnterpriseChannelService } from '../../net/EnterpriseChannelService';
import { AddOrderBodyResultBean } from '../../net/model/AddOrderBean';
import { toast } from '../../util/Toast';
import { PaySelectDialog } from '../common/PaySelectDialog';

@Preview
@CustomDialog
export struct TopUpBeanDialog {
  controller?: CustomDialogController
  addOrderBean?: AddOrderBodyResultBean
  confirm?: (addOrderJson: string) => void
  @State searchKey: string = "0";
  @State isError: boolean = false;
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: PaySelectDialog({ confirm: this.confirm, addOrderBean: this.addOrderBean }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    width: '100%',
    cornerRadius: 12,
  })

  aboutToDisappear() {
    this.dialogController = null // 将dialogController置空
  }

  build() {
    Column() {
      Text("金豆充值").fontSize(18).fontWeight(FontWeight.Bold).fontColor($r('app.color.h1')).height(58)
      Text("手动输入")
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.font8'))
        .width("100%")
        .margin({ top: 8 })
      Stack({ alignContent: Alignment.Start }) {
        TextInput({
          placeholder: "输入充值金额", text: this.searchKey
        })
          .fontSize(14)
          .fontColor($r("app.color.font1"))
          .placeholderColor($r("app.color.placeholder1"))
          .backgroundColor($r("app.color.bg1"))
          .caretColor($r("app.color.bg6"))
          .borderRadius(4)
          .type(InputType.NUMBER_DECIMAL)
          .padding({ left: 30 })
          // .inputFilter('/^(0|[1-9]{1}[0-9]{0,2}(,[0-9]{3})*)(.[0-9]{2})$/')
          .onChange((value) => {
            this.searchKey = value
            let number = new Number(value);
            this.isError = !(number > 0 && number < 5000)
          })
        Text("¥")
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.font1')).margin({ left: 12 })
      }
      .height(38)
      .margin({ top: 12 })

      Text("请输入有效值0-50000元")
        .fontSize(12)
        .fontColor(this.isError?$r('app.color.font6'):$r('app.color.font1'))
        .width("100%")
        .margin({ top: 8 })

      Text("快捷输入")
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.font8'))
        .width("100%")
        .margin({ top: 24 })

      Row() {
        Button("1000元", { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(4)
          .backgroundColor($r("app.color.bg3"))
          .fontSize(14)
          .width("30%")
          .fontColor($r('app.color.font1'))
          .height(30)
          .onClick(() => {
            this.searchKey = "1000"
          })

        Button("3000元", { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(4)
          .backgroundColor($r("app.color.bg3"))
          .fontSize(14)
          .margin({ left: 12 })
          .width("30%")
          .fontColor($r('app.color.font1'))
          .height(30)
          .onClick(() => {
            this.searchKey = "3000"
          })

        Button("5000元", { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(4)
          .backgroundColor($r("app.color.bg3"))
          .fontSize(14)
          .width("30%")
          .margin({ left: 12 })
          .fontColor($r('app.color.font1'))
          .height(30)
      }.width("100%").margin({ top: 12 }).onClick(() => {
        this.searchKey = "5000"
      })

      Button("10000元", { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(4)
        .backgroundColor($r("app.color.bg3"))
        .fontSize(14)
        .width("30%")
        .fontColor($r('app.color.font1'))
        .alignSelf(ItemAlign.Start)
        .height(30)
        .margin({ top: 12 })
        .onClick(() => {
          this.searchKey = "10000"
        })

      Row() {
        Button("取消", { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(4)
          .backgroundColor($r("app.color.white"))
          .fontSize(14)
          .borderWidth(1)
          .borderColor($r("app.color.bg5"))
          .layoutWeight(1)
          .onClick(() => {
            this.controller?.close()
          })
          .fontColor($r('app.color.font1'))
          .height(44)

        Button("确定", { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(4)
          .backgroundColor($r("app.color.black"))
          .fontSize(14)
          .layoutWeight(1)
          .margin({ left: 7 })
          .onClick(async () => {
            let number = new Number(this.searchKey);
            if (number > 0 && number < 50000) {
              EnterpriseChannelService.addOrder(number.valueOf()).then(res => {
                this.addOrderBean = res.result
                if (this.dialogController != null) {
                  this.dialogController.open()
                }
              })
            } else {
              this.isError = true
              toast("请输入有效值0-50000元")
            }
            this.controller?.close()
          })
          .fontColor($r('app.color.white'))
          .height(44)
      }.width("100%").margin({ top: 36 })
    }.height(378).width("100%").padding({ left: 16, right: 16 })
  }
}