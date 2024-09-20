import EntryAbility from '../entryability/EntryAbility'
import router from '@ohos.router'

@Entry
@Component
struct Test {
  @State message: string = 'Hello World'
  private entryAbi = new EntryAbility()

  onPageShow() {
    const routerState = router.getState()
    this.message = routerState.name
    // const entryAbility = router.getAbilityInstance();
    if (routerState.name != 'Index') {
      console.info('okokok', routerState.name);
      this.entryAbi.destroySubWindow()
    }
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}