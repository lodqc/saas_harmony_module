import TimeUtils from '../../util/TimeUtils';
import { OperationalList } from './OperationalList';

@Preview
@Component
export struct OperationalTab {
  @State selectedDate: Date = new Date()
  @State type: number = 0;
  @State disburseCount: number = 0;
  @State topUpCount: number = 0;
  @State giftCount: number = 0;

  build() {
    Column() {
      Divider().height(1).color($r('app.color.bg4'))
      Row() {
        Text(TimeUtils.toYM(this.selectedDate)).fontSize(14).fontColor($r('app.color.font1')).onClick(() => {
          this.showTimeDialog();
        })
        Image($r('app.media.ic_arrow_down')).width(16).height(16).padding({ left: 4 }).onClick(() => {
          this.showTimeDialog();
        })
        if (this.type == 0) {
          Column() {
            Text(`${this.disburseCount.toFixed(2)}`).fontSize(14).fontColor($r('app.color.font1')).fontWeight(FontWeight.Bold)
            Text("支出总数(豆)").fontSize(14).fontColor($r('app.color.font5')).margin({ top: 4 })
          }.layoutWeight(1).alignItems(HorizontalAlign.End)
        }

        if (this.type == 1) {
          Column() {
            Text(`${this.topUpCount.toFixed(2)}`).fontSize(14).fontColor($r('app.color.font1')).fontWeight(FontWeight.Bold)
            Text("充值总数(豆)").fontSize(14).fontColor($r('app.color.font5')).margin({ top: 4 })
          }.layoutWeight(1).alignItems(HorizontalAlign.End).padding({ right: 14 })

          Text().width(1).height(40).backgroundColor($r('app.color.bg4'))
          Column() {
            Text(`${this.giftCount.toFixed(2)}`).fontSize(14).fontColor($r('app.color.font2')).fontWeight(FontWeight.Bold)
            Text("赠送总数(豆)").fontSize(14).fontColor($r('app.color.font5')).margin({ top: 4 })
          }.layoutWeight(1).alignItems(HorizontalAlign.End)
        }
      }.width('100%').height(56).padding({ left: 16, right: 16 })

      Divider().height(1).color($r('app.color.bg4'))
      OperationalList({
        selectedDate: this.selectedDate,
        type: this.type,
        disburseCount: this.disburseCount,
        topUpCount: this.topUpCount,
        giftCount: this.giftCount
      })
    }
    .borderRadius(4)
  }

  private showTimeDialog() {
    DatePickerDialog.show({
      start: new Date("2000-1"),
      end: new Date(),
      selected: this.selectedDate,
      onAccept: (value: DatePickerResult) => {
        // 通过Date的setFullYear方法设置按下确定按钮时的日期，这样当弹窗再次弹出时显示选中的是上一次确定的日期
        this.selectedDate.setFullYear(value.year, value.month, value.day);
        console.info("DatePickerDialog:onAccept()" + this.selectedDate.toTimeString());
      },
      onCancel: () => {
        console.info("DatePickerDialog:onCancel()");
      },
      onChange: (value: DatePickerResult) => {
        console.info("DatePickerDialog:onChange()" + JSON.stringify(value));
      }
    });
  }
}