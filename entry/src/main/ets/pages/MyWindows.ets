@Entry
@Component
struct MyWindows {
  @State message: string = 'Hello World'
  // pageStack: NavPathStack = new NavPathStack()
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
      })
    }
  }
}