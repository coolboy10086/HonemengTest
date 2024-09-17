// // import UIAbility from '@ohos.app.ability.UIAbility';
// // import window from '@ohos.window';
// //
// // export default class myAbility extends UIAbility {
// //   onWindowStageCreate(windowStage) {
// //     // 1.创建悬浮窗。
// //     let windowClass = null;
// //     let config = {
// //       name: "floatWindow", windowType: window.WindowType.TYPE_FLOAT, ctx: this.context
// //     };
// //     window.createWindow(config, (err, data) => {
// //       if (err.code) {
// //         console.error('Failed to create the floatWindow. Cause: ' + JSON.stringify(err));
// //         return;
// //       }
// //       console.info('Succeeded in creating the floatWindow. Data: ' + JSON.stringify(data));
// //       windowClass = data;
// //       // 2.悬浮窗窗口创建成功后，设置悬浮窗的位置、大小及相关属性等。
// //       windowClass.moveWindowTo(300, 300, (err) => {
// //         if (err.code) {
// //           console.error('Failed to move the window. Cause:' + JSON.stringify(err));
// //           return;
// //         }
// //         console.info('Succeeded in moving the window.');
// //       });
// //       windowClass.resize(500, 500, (err) => {
// //         if (err.code) {
// //           console.error('Failed to change the window size. Cause:' + JSON.stringify(err));
// //           return;
// //         }
// //         console.info('Succeeded in changing the window size.');
// //       });
// //       // 3.为悬浮窗加载对应的目标页面。
// //       windowClass.setUIContent("pages/Index", (err) => {
// //         if (err.code) {
// //           console.error('Failed to load the content. Cause:' + JSON.stringify(err));
// //           return;
// //         }
// //         console.info('Succeeded in loading the content.');
// //         // 3.显示悬浮窗。
// //         windowClass.showWindow((err) => {
// //           if (err.code) {
// //             console.error('Failed to show the window. Cause: ' + JSON.stringify(err));
// //             return;
// //           }
// //           console.info('Succeeded in showing the window.');
// //         });
// //       });
// //       // 4.销毁悬浮窗。当不再需要悬浮窗时，可根据具体实现逻辑，使用destroy对其进行销毁。
// //       windowClass.destroyWindow((err) => {
// //         if (err.code) {
// //           console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
// //           return;
// //         }
// //         console.info('Succeeded in destroying the window.');
// //       });
// //     });
// //   }
// // };
//
//
// import window from '@ohos.window'
//
// let windowsClass: window.Window | undefined = undefined
// let config: window.Configuration = {
//   name: 'test',
//   windowType: window.WindowType.TYPE_FLOAT,
//   ctx:this.context
// }
// window.createWindow()
// // createWindow(config: Configuration, callback: AsyncCallback<Window>): void
// class MyWindow {
// }