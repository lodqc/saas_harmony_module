import { RiderTab } from './rider/RiderTab';

@Component
export struct RiderManage {
  @State searchKey: string = "";
  @State currentIndex: number = 1
  private tabsController = new TabsController()

  build() {
    Column() {
      Row() {
        Stack({ alignContent: Alignment.Start }) {
          TextInput({
            placeholder: "请输入完整手机号/选择标签"
          })
            .showPasswordIcon(true)
            .fontSize(14)
            .fontColor($r("app.color.font1"))
            .caretColor($r("app.color.bg6"))
            .placeholderColor($r("app.color.placeholder1"))
            .backgroundColor($r("app.color.bg1"))
            .borderRadius(4)
            .maxLength(11)
            .cancelButton({ style: CancelButtonStyle.INPUT })
            .type(InputType.Normal)
            .padding({ left: 30 })
            .onChange((value) => {
              this.searchKey = value
            })
          Image($r('app.media.ic_search'))
            .width(16).margin({ left: 10 })
        }.layoutWeight(1)
        .height(36)
        .margin({ left: 20, right: 20 })

        Text('搜索')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor($r("app.color.font2"))
          .margin({ right: 20 })
      }.height(52)

      if (this.searchKey) {
        RiderTab({
          searchType: 0, searchKey: this.searchKey
        })
      } else {
        Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.tabsController }) {
          TabContent() {
            RiderTab({
              searchType: 1
            })
          }.tabBar(this.tabBuilder("已代付", 0))

          TabContent() {
            RiderTab({
              searchType: 2
            })
          }.tabBar(this.tabBuilder("代付到期", 1))

          TabContent() {
            RiderTab({
              searchType: 3
            })
          }.tabBar(this.tabBuilder("可回收", 2))
        }
        .barMode(BarMode.Scrollable)
        .onChange((index) => {
          this.currentIndex = index
        })
        .scrollable(true)
      }
    }
  }

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
        .width(16)
        .height(3)
        .margin({ top: 8 })
        .borderRadius(2)
    }
    .width(82)
    .height(44)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex
      this.tabsController.changeIndex(targetIndex)
    })
  }
}
