import http from '@ohos.net.http'
import Url from '@ohos.url'
import router from '@ohos.router'
import EntryAbility from '../entryability/EntryAbility'
import window from '@ohos.window'
import emitter from '@ohos.events.emitter'

let httpRequest = http.createHttp()

// 定义 Book 类
class imageUrl {
  imageUrl: Url.URLParams
}

class Book {
  id: number
  title: string
  author: string
  description: string
  imageUrl: imageUrl

  // constructor(id: number, title: string, author: string, description: string, imageUrl: imageUrl) {
  //   this.id = id
  //   this.title = title
  //   this.author = author
  //   this.description = description
  //   this.imageUrl = imageUrl
  // }
}

// 定义 Library 类
class Library {
  NAME: string
  TITLE: string
  TELEPHONE: string
}
//确定要接受订阅的事件id
let innerEvent: emitter.InnerEvent = {
  eventId: 1
};
//接收事件后跳转
emitter.on(innerEvent, () => {
  router.pushUrl({ url: 'pages/Test' })
})

@Entry
@Component
struct Index {
  private enrtyAli = new EntryAbility()
  //在页面展示时判断是否生成子窗口
  onPageShow() {
    this.enrtyAli.destroySubWindow()
    let routerState = router.getState()
    console.info('index name', routerState.name)
    if (routerState.name == 'Index') {
      this.enrtyAli.showSubWindow()
    } else {
      this.enrtyAli.destroySubWindow()
    }
  }

  @State res: string = ''
  private testUrl = 'http://03bb4619e4c041a1b67d306114fe8106.apig.cn-south-1.huaweicloudapis.com/vnihugw'
  @State title: string = ''
  @State telephone: string = ''
  // 初始化 Library 对象
  private lib: Library = null

  build() {
    Stack() {
      Column() {
        Row() {
          Button('请求网络')
            .fontSize(20)
            .fontColor(Color.Orange)
            .margin(10)
            .onClick(() => {
              this.onRequestHttpData()
            })
          Button('去phone')
            .onClick(() => {
              router.pushUrl({ url: 'pages/phone' })
            })
        }

        Text(this.res)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
        Text(this.title)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
        Text(this.telephone)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .margin(0)

    }

  }

  onRequestHttpData() {
    let options: http.HttpRequestOptions = {
      extraData: ["data", "data to send"],
      header: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
      usingCache: true,
      connectTimeout: 60000,
      readTimeout: 60000
    }
    // 发起网络请求
    httpRequest.request(this.testUrl, options, (error, data: http.HttpResponse) => {
      if (error) {
        this.res = '请求失败: ' + error.message
        return
      }
      // 确保响应数据有效，并且是 JSON 格式
      if (data && typeof data.result === 'string') {
        let parsedData: Library = JSON.parse(data.result)
        try {
          this.lib = JSON.parse(data.result)
          // 更新状态，显示图书馆名称
          this.res = `图书馆名称: ${this.lib.NAME}`
          this.title = `图书馆简介：${this.lib.TITLE}`
          this.telephone = `图书馆电话：${this.lib.TELEPHONE}`
        } catch (e) {
          this.res = '解析 JSON 失败'
        }
      } else {
        this.res = '无效的响应数据'
      }
    })
  }
}
