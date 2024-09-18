import call from '@ohos.telephony.call'
import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import router from '@ohos.router';

@Entry
@Component
@Preview
struct phone {
  phone() {
    let okphone = call.hasVoiceCapability()
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