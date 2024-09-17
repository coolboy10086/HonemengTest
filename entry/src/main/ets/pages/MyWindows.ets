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
      }.backgroundColor(Color.Red)
      .width('100%')
    }
    .height('100%')
  }
}