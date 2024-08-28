import bridge from '@arkui-x.bridge'
import deviceInfo from '@ohos.deviceInfo'
import { EnterpriseChannelComp } from '../enterprise_channel/view/EnterpriseChannelComp'

const osFullNameInfo: string = deviceInfo.osFullName
const platform = osFullNameInfo.split(' ')[0]

@Entry
@Component
struct Index {
  // @StorageLink("HeaderBean") headerBean: string = "{\"authorization\":\"" +
  //   "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50VGltZSI6MTcyNDc1MTczODMyNiwicGxhdElkIjoiMSIsInBob25lIjoiMTcxOTg2MzQxMTUiLCJsZXZlbCI6IjIiLCJpc3MiOiJhdXRoMCIsInRlbmFudElkIjoiNjRGODQ5RjI1MzQzQUIzRTBBODhEQjhCIiwibUlkIjoiOTE3M2RjNTRhM2ZiNDFmMmJjYzZmYmU1YzQxMWM2YTQiLCJ1c2VyVHlwZSI6IjUiLCJ1c2VyTmFtZSI6IjE3MTk4NjM0MTE1IiwiZGF0YUNvZGUiOiJERlNXQVAiLCJleHAiOjE3MjQ3OTQ5MzgsInN1cGVyQWRtaW4iOiIwIn0.nRFA85B5ndmhPPbef-HLWbmxS6pg7EPN8ELK0tGqwT8" +
  //   "\",\"acceptEncoding\":\"identity\",\"acceptLanguage\":\"zh\",\"baseUrl\":\"https://t-cloud-manage-api.ehuandian.net\",\"cacheControl\":\"no-cache\",\"cityCode\":\"440306\",\"userAgent\":\"ANDROID_3.0.1,14,HONOR_ALP-AN00\"}"

  @StorageLink("HeaderBean") headerBean: string = ""
  @StorageLink("NetInfo") @Watch('onNetInfo') netInfo: string = ""
  @State isPaySuccess: boolean = false
  @Provide @Watch('onAddOrderJson') addOrderJson: string = "";
  bridgeImpl: undefined | bridge.BridgeObject = undefined;

  onPageShow(): void {
    if (platform == "Android" || platform == "iOS") {
      this.bridgeImpl = bridge.createBridge('Bridge');
      if (this.bridgeImpl != undefined) {
        this.bridgeImpl.setMessageListener((data) => {
          if (data?.toString() == "支付成功") {
            this.isPaySuccess = true
          } else {
            this.headerBean = data?.toString() ?? ""
          }
          return data;
        });
      }
    }
  }

  onAddOrderJson(propName: string): void {
    this.bridgeImpl?.callMethod('preOrder', this.addOrderJson).then((res) => {
      console.log('result: ' + res);
    });
  }

  onNetInfo(propName: string): void {
    let content = this.netInfo.split('_')
    this.bridgeImpl?.callMethod('netInfo', content[0], content[1]).then((res) => {
      console.log('result: ' + res);
    });
  }

  build() {
    if (this.headerBean){
      EnterpriseChannelComp({ isPaySuccess: this.isPaySuccess })
    }
  }
}