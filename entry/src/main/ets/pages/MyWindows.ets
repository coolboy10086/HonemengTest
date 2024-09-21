
import emitter from '@ohos.events.emitter';
//确定订阅事件id
let innerEvent: emitter.InnerEvent = {
  eventId: 1
};


@Entry
@Component
struct MyWindows {

  @State message: string = '点他'
  @State test: string = ''
  @State windowPosition: Position = null

  build() {
    Column() {
      Text(this.test)
      Text(this.message)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
    }
    .backgroundColor(Color.Red)
    .layoutWeight(1)
    .onClick(() => {
      //点击后发布事件
      emitter.emit(innerEvent)
    });

  }
}