// import has from '@atomicservice/asweb-sdk';
import webview from '@ohos.web.webview';

@Entry
@Component
struct MyWindows {
  @State message: string = '点他'
  // pageStack: NavPathStack = new NavPathStack()
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    NavDestination() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
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
      })

      Web({ src: 'www.baidu.com', controller: this.controller })
    }
  }
}