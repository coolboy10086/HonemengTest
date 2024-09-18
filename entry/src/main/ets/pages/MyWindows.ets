// import has from '@atomicservice/asweb-sdk';
import webview from '@ohos.web.webview';
import abilityFeatureAbility from '@ohos.ability.featureAbility';
import router from '@ohos.router';

function openWebUrl(url) {
  try {
    const want = {
      action: 'action.view',
      uri: url,
      type: 'text/html',
    };
    abilityFeatureAbility.startAbility(want);
  } catch (err) {
    console.error('Failed to open web URL:', err);
  }
}

// 使用函数打开一个Web页面

@Entry
@Component
struct MyWindows {
  @State message: string = '点他'
  // pageStack: NavPathStack = new NavPathStack()
  // controller: webview.WebviewController = new webview.WebviewController();

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
        // try {
        //   this.controller.loadUrl('www.baidu.com')
        // } catch (e) {
        //   console.error(`message:${e.message},errcode:${e.code}`)
        // }
        openWebUrl('https://www.example.com');
      })

      // Web({ src: 'www.bing.com', controller: this.controller })
    }
  }
}