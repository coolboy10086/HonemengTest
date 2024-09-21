import EntryAbility from '../entryability/EntryAbility'
import router from '@ohos.router'
import webview from '@ohos.web.webview'

@Entry
@Component
struct Test {
  @State message: string = 'Hello World'
  controller: webview.WebviewController = new webview.WebviewController()
  private entryAbi = new EntryAbility()
  //在页面展示时判断是否生成子窗口
  onPageShow() {
    const routerState = router.getState()
    this.message = routerState.name
    // const entryAbility = router.getAbilityInstance();
    if (routerState.name != 'Index') {
      console.info('okokok', routerState.name);
      this.entryAbi.destroySubWindow()
    }
  }

  build() {
    Stack() {
      Row() {
        Column() {
          Web({ src: 'www.bing.com', controller: this.controller }).layoutWeight(1).height('100%')
        }
        .width('100%')
      }
      .height('100%')

      Button('back')
        .onClick(() => {
          router.pushUrl({ url: 'pages/Index' })
        })
    }
  }
}