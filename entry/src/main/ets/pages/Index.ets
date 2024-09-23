import http from '@ohos.net.http'
import Url from '@ohos.url'
import router from '@ohos.router'
import EntryAbility from '../entryability/EntryAbility'
import util from '@ohos.util'
import url from '@ohos.url'

let httpRequest = http.createHttp()

// 定义 Book 类
// class imageUrl {
//   imageUrl: Url.URLParams
// }

class Book {
  id: number
  title: string
  author: string
  description: string
  imageUrl: string

  constructor(id: number, title: string, author: string, description: string, imageUrl: string) {
    this.id = id
    this.title = title
    this.author = author
    this.description = description
    this.imageUrl = imageUrl
  }
}

// 定义 Library 类
class Library {
  name: string
  location: string
  telephoneNumber: string
  description: string
}


@Entry
@Component
struct Index {
  private enrtyAli = new EntryAbility()

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

  @State libname: string = ''
  @State liblocation: string = ''
  @State libtelephoneNumber: string = ''
  @State libdescription: string = ''
  private testUrl = 'https://1ffc8088cc224333a4ea2cf62fb31bcd.apig.cn-east-3.huaweicloudapis.com/API_test1'
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
        }

        Row() {
          Button('去BookDetail')
            .onClick(() => {
              router.pushUrl({ url: 'pages/BookDetail' })
            })
          Button('获取数据库图书馆')
            .onClick(() => {
              this.getlib()
            })

        }

        Row() {
          Button('book').onClick(() => {
            this.getbook()
          })
          Button('storebook').onClick(() => {
            this.storebook()
          })
          Button('getBook').onClick(() => {
            this.enrtyAli.getBook('混沌塔')
          })
        }

        Row() {
          Button('带params跳')
            .onClick(() => {
              console.log('params', this.BookData[0].title)
              let params: Book = {
                id: this.BookData[0].id,
                title: this.BookData[0].title,
                author: this.BookData[0].author,
                description: this.BookData[0].description,
                imageUrl: this.BookData[0].imageUrl
              }

              router.pushUrl({
                url: "pages/BookDetail",
                params: params })
            })

        }

        Text(this.value)
        Text(JSON.stringify(this.BookData))
        Text(this.libname)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
        Text(this.liblocation)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
        Text(this.libtelephoneNumber)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
        Text(this.libdescription)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
        Button('测试')
          .position({ x: 0, y: 300 })
          .zIndex(999)
          .width(100)
          .height(100)
          .onClick(() => {
            router.pushUrl({ url: "pages/Test" })
          })
      }
      .width('100%')
      .margin(0)

    }

  }

  getlib() {
    this.enrtyAli.getLibrary(this.libname)
  }

  storebook() {
    this.BookData.forEach((book) => {
      let URL = JSON.stringify(book.imageUrl)
      URL = URL.replace('"', '')
      console.log("book111", book.title)
      console.log("book111", book.author)
      console.log("book111", book.description)
      console.log("book111", URL)
      try {
        this.enrtyAli.insertBook(
          book.title, // NAME
          book.author, // AUTHOR
          book.description, // DESCRIPTION
          URL // IMAGEURL
        )
        console.info(`Inserted book: ${book.title}`);
      } catch (error) {
        console.error(`Failed to insert book: ${book.title}, error: ${error}`);
      }
    });
  }

  getbook() {
    console.log("getbook", "getbook")
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
                bookJson.imageUrl // 假设您的 JSON 格式中 imageUrl 字段是一个对象，且包含一个 imageUrl 属性
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
        // this.libname = '请求失败: ' + error.message
        return
      }
      // 确保响应数据有效，并且是 JSON 格式
      if (data && typeof data.result === 'string') {
        try {
          this.lib = JSON.parse(data.result)
          // 更新状态，显示图书馆名称
          this.libname = this.lib.name
          this.liblocation = this.lib.location
          this.libtelephoneNumber = this.lib.telephoneNumber
          this.libdescription = this.lib.description
        } catch (e) {
          this.libname = '解析 JSON 失败'
        }
      } else {
        this.libname = '无效的响应数据'
      }
      // 调用入口文件中的方法在向数据库中存入数据
      try {
        this.enrtyAli.insertLibrary(this.libname, this.liblocation, this.libtelephoneNumber, this.libdescription)
      } catch (e) {
        console.log('storeLib', e)
        console.log('storeLib', '存入失败')
      }
    })
  }
}
