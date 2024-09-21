import http from '@ohos.net.http'
import Url from '@ohos.url'
import router from '@ohos.router'
import EntryAbility from '../entryability/EntryAbility'
import window from '@ohos.window'
import emitter from '@ohos.events.emitter'
import fileIo from '@ohos.file.fs'
import util from '@ohos.util'

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

  constructor(id: number, title: string, author: string, description: string, imageUrl: imageUrl) {
    this.id = id
    this.title = title
    this.author = author
    this.description = description
    this.imageUrl = imageUrl
  }
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
  @State value: string = '66666';
  @State BookData: Book[] = []

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
          Button('book').onClick(() => {
            try {
              let context = getContext(this); // 获取当前 context 对象
              let resourceManager = context.resourceManager;
              resourceManager.getRawFileContent("book.json", (error, value) => {
                if (error != null) {
                  console.error("error is " + error);
                  this.value = JSON.stringify(error);
                } else {
                  let rawFile = value;
                  let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
                  let retStr = textDecoder.decodeWithStream(rawFile);
                  try {
                    let booksJson = JSON.parse(retStr);
                    if (Array.isArray(booksJson)) {
                      this.BookData = booksJson.map((bookJson) => new Book(
                        bookJson.id,
                        bookJson.title,
                        bookJson.author,
                        bookJson.description,
                        bookJson.imageUrl.imageUrl // 假设您的 JSON 格式中 imageUrl 字段是一个对象，且包含一个 imageUrl 属性
                      ));
                    } else {
                      console.error('Parsed JSON is not an array');
                    }
                  } catch (parseError) {
                    console.error("Failed to parse JSON: " + parseError);
                  }
                }
              });
            } catch (error) {
              this.value = JSON.stringify(error)
              console.error(`callback getRawFileContent failed, error code: ${error.code}, message: ${error.message}.`);
            }
          })
        }

        Text(this.value)
        Text(JSON.stringify(this.BookData))
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
