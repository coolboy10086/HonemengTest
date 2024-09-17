import http from '@ohos.net.http'
import Url from '@ohos.url'
import router from '@ohos.router'

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
  name: string
  location: string
  telephoneNumber: string
  description: string
  books: Book[]

  // constructor(name: string, location: string, telephoneNumber: string, description: string, books: Book[]) {
  //   this.name = name
  //   this.location = location
  //   this.telephoneNumber = telephoneNumber
  //   this.description = description
  //   this.books = books
  // }
}

@Entry
@Component
struct Index {
  @State res: string = ''
  private testUrl = 'http://03bb4619e4c041a1b67d306114fe8106.apig.cn-south-1.huaweicloudapis.com/vnihugw'
  @State url: string = ''
  // 初始化 Library 对象
  private lib: Library = null

  build() {
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
      Text(this.url)
      Image(this.url)
        .width('100%')
        .height(200)

    }
    .width('100%')
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
          // 解析 JSON 数据并赋值给 lib
          // this.lib = new Library(
          //   parsedData.name,
          //   parsedData.location,
          //   parsedData.telephoneNumber,
          //   parsedData.description,
          //   parsedData.books.map((item: Book) =>
          //   new Book(item.id, item.title, item.author, item.description, item.imageUrl))
          // )
          this.lib = JSON.parse(data.result)
          // 更新状态，显示图书馆名称
          this.res = `图书馆名称: ${this.lib.name}`
          this.url = '' + this.lib.books[0].imageUrl
        } catch (e) {
          this.res = '解析 JSON 失败'
        }
      } else {
        this.res = '无效的响应数据'
      }
    })
  }
}
