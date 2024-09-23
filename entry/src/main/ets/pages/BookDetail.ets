import router from '@ohos.router'

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

@Entry
@Component
struct BookDetail {
  @State message: string = 'Hello World'
  @State Book: Book = null;

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('getParams')
          .onClick(() => {
            const params = router.getParams(); // 获取传递过来的参数对象
            const id = params['id'];
            const title = params['title'];
            const author = params['author'];
            const description = params['description'];
            const imageUrl = params['imageUrl'];

            console.log('id111', '33333', id)
            console.log('title', '33333', title)
            console.log('author', '33333', author)
            console.log('description', '33333', description)
            console.log('imageUrl', '33333', imageUrl)
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}