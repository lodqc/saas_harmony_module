import router from '@ohos.router';
import WindowUtils from '../util/WindowUtils';

@Component
export struct TitleLayout {
  @Prop
  title: string;
  isJustShowStatusBar: boolean = false;
  showBack: boolean = true;
  onBack: () => void = () => {
    router.back();
  }
  menuIcon?: Resource;
  onMenuClick?: () => void;

  build() {
    Column() {
      Row()
        .width('100%')
        .height(WindowUtils.statusBarHeight + 'px')
      if (this.isJustShowStatusBar === false) {
        Row() {
          if (this.showBack) {
            Image($r("app.media.ic_back"))
              .width(24)
              .height(24)
              .padding(3)
              .margin({left:16})
              .fillColor($r("app.color.h1"))
              .objectFit(ImageFit.Contain)
              .onClick((event) => {
                if (this.onBack !== undefined) {
                  this.onBack();
                }
              })
          }
          Text(this.title)
            .fontWeight(FontWeight.Medium)
            .fontSize(16)
            .fontColor($r("app.color.h1"))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .padding({ left: 8, right: 8 })
          if (this.menuIcon !== undefined) {
            Image(this.menuIcon)
              .width(48)
              .height(48)
              .padding(14)
              .fillColor($r("app.color.h1"))
              .objectFit(ImageFit.Contain)
              .onClick((event) => {
                if (this.onMenuClick !== undefined) {
                  this.onMenuClick();
                }
              })
          }
        }
        .width('100%')
        .height(44)
        .alignItems(VerticalAlign.Center)
      }
    }
    .width('100%')
    .backgroundColor($r("app.color.white"))
  }
}