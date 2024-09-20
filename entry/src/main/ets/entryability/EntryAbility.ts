import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import router from '@ohos.router';

let windowStage_: window.WindowStage | null = null;
let sub_windowClass: window.Window | null = null;

export default class EntryAbility extends UIAbility {
  public showSubWindow() {
    // 1.创建应用子窗口。
    if (windowStage_ == null) {
      console.error('Failed to create the subwindow. Cause: windowStage_ is null');
    }
    else {
      windowStage_.createSubWindow("mySubWindow", (err, data) => {
        let errCode: number = err.code;
        if (errCode) {
          console.error('Failed to create the subwindow. Cause: ' + JSON.stringify(err));
          return;
        }
        sub_windowClass = data;
        console.info('Succeeded in creating the subwindow. Data: ' + JSON.stringify(data));
        // 2.子窗口创建成功后，设置子窗口的位置、大小及相关属性等。
        //窗口位置
        sub_windowClass.moveWindowTo(0, 900, (err) => {
          let errCode: number = err.code;
          if (errCode) {
            console.error('Failed to move the window. Cause:' + JSON.stringify(err));
            return;
          }
          console.info('Succeeded in moving the window.');
        });
        //定义窗口大小
        sub_windowClass.resize(300, 300, (err) => {
          let errCode: number = err.code;
          if (errCode) {
            console.error('Failed to change the window size. Cause:' + JSON.stringify(err));
            return;
          }
          console.info('Succeeded in changing the window size.');
        })

        // 3.为子窗口加载对应的目标页面。

        sub_windowClass.setUIContent("pages/MyWindows", (err) => {
          let errCode: number = err.code;
          if (errCode) {
            console.error('Failed to load the content. Cause:' + JSON.stringify(err));
            return;
          }
          console.info('Succeeded in loading the content.');
          // 3.显示子窗口。
          (sub_windowClass as window.Window).showWindow((err) => {
            let errCode: number = err.code;
            if (errCode) {
              console.error('Failed to show the window. Cause: ' + JSON.stringify(err));
              return;
            }
            console.info('Succeeded in showing the window.');
          });
        });
      })
    }
    let windowsClass = null
    let promise = windowStage_.getMainWindow()
    promise.then((data) => {
      windowsClass = data
      console.log('zhu', JSON.stringify(data))
    })
  }

  public destroySubWindow() {
    // 4.销毁子窗口。当不再需要子窗口时，可根据具体实现逻辑，使用destroy对其进行销毁。
    (sub_windowClass as window.Window).destroyWindow((err) => {
      let errCode: number = err.code;
      if (errCode) {
        console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in destroying the window.');
    });
  }

  onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // 1.获取应用主窗口。
    let windowClass = null;
    windowStage.getMainWindow((err, data) => {
      if (err.code) {
        console.error('Failed to obtain the main window. Cause: ' + JSON.stringify(err));
        return;
      }
      windowClass = data;
      console.info('Succeeded in obtaining the main window. Data: ' + JSON.stringify(data));
      // 2.设置主窗口属性。以设置"是否可触"属性为例。
      let isTouchable = true;
      windowClass.setWindowTouchable(isTouchable, (err) => {
        if (err.code) {
          console.error('Failed to set the window to be touchable. Cause:' + JSON.stringify(err));
          return;
        }
        console.info('Succeeded in setting the window to be touchable.');
      })
    })


    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage_ = windowStage
    this.showSubWindow()
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });

  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    this.destroySubWindow()
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
