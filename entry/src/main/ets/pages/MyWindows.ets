import webview from '@ohos.web.webview';
import abilityFeatureAbility from '@ohos.ability.featureAbility';
import router from '@ohos.router';

@Entry
@Component
struct MyWindows {
  @State message: string = '点他'
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Text(this.message)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      Web({ src: 'www.bing.com', controller: this.controller }).layoutWeight(1)
    }
    .backgroundColor(Color.Red)
    .width('100%')
    .onClick(() => {
      console.info('test1111', '点了')
      try {
        this.controller.loadUrl('www.baidu.com')
      } catch (e) {
        console.error(`message:${e.message},errcode:${e.code}`)
      }
      router.pushUrl({ url: 'pages/Test' })
    })
  }
}