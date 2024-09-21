import call from '@ohos.telephony.call'

import router from '@ohos.router';
import EntryAbility from '../entryability/EntryAbility';

@Entry
@Component
@Preview
struct phone {
  //拨号时间
  phone() {
    //看一下机体是否支持通话
    let okphone = call.hasVoiceCapability()
    //ok 的话，拉起应用，打电话
    if (okphone) {
      call.makeCall('15976786774', (err) => {
        if (!err) {
          console.log('okk,phone is no problem')
        } else {
          console.log("nonono", JSON.stringify(err))
        }
      })
    }
  }

  private entryAbi = new EntryAbility()
  //在页面展示时判断是否生成子窗口
  onPageShow() {
    const routerState = router.getState()
    // const entryAbility = router.getAbilityInstance();
    if (routerState.name != 'Index') {
      console.info('okokok', routerState.name);
      this.entryAbi.destroySubWindow()
    }
  }

  @State message: string = ''

  build() {

    Column() {
      Button('去index')
        .onClick(() => {
          router.pushUrl({ url: 'pages/Index' })
        })
      Image($r('app.media.phone'))
        .width(50)
        .height(50)
        .margin(50)
        .onClick(() => this.phone())
    }.width('100%')
  }
}