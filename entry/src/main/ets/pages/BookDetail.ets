import util from '@ohos.util';
import Url from '@ohos.url'
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
}

@Entry
@Component
struct BookDetail {
  //定义打开文件的地址
  private strJsonUrl = "book.json";

  //异步方式打开JSON,并fanhui数据内容
  async getData(content): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      try {
        let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
        content.resourceManager.getRawFileContent(this.strJsonUrl).then((rawFile: Uint8Array) => {
          let readString = textDecoder.decodeWithStream(rawFile, { stream: false });
          resolve(readString)
        })
      } catch (e) {
        reject(e.message)
      }
    })
  }

  //同步方法根据属性名称获取对应数据
  async asyncGetDataByAttribute(content, id: number) {
    const result = await this.getData(content);
    let arr: Book = JSON.parse(result);
    return arr.id[id]
  }

  @State bid: number = 0
  @State btitle: string = null
  @State bauthor: string = null
  @State bdescription: string = null
  @State bimageUrl: string = null

  build() {
    Row() {
      Column() {
        Text(this.btitle)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
        Text(this.bauthor)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
        Text(this.bdescription)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
        Text(this.bimageUrl)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
      }

      Button('读取book.JSON')
        .onClick(() => {
          this.asyncGetDataByAttribute(this.context,0);
        })
        .width('100%')
    }
    .height('100%')
  }
}