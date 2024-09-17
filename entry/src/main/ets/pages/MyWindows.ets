@Entry
@Component
struct MyWindows {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .backgroundColor(Color.Red)
      .width('100%')
      .onClick(() => {
        console.info('test1111', '点了')
      })
    }

    .height('100%')
  }
}