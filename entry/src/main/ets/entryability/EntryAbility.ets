import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import Url from '@ohos.url'
import router from '@ohos.router';
import relationalStore from '@ohos.data.relationalStore';
import contextConstant from '@ohos.app.ability.contextConstant';

let windowStage_: window.WindowStage | null = null;
let sub_windowClass: window.Window | null = null;
let context_create: Context

export default class EntryAbility extends UIAbility {
  // 1.创建应用子窗口。
  public showSubWindow() {
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
  // 4.销毁子窗口。当不再需要子窗口时，可根据具体实现逻辑，使用destroy对其进行销毁。
  public destroySubWindow() {
    (sub_windowClass as window.Window).destroyWindow((err) => {
      let errCode: number = err.code;
      if (errCode) {
        console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in destroying the window.');
    });
  }
  // 插入图书馆数据
  public insertLibrary(NAME: string, LOCATION: string, TELEPHONENUMBER: string, DESCRIPTION: string) {
    let STORE_CONFIG = {
      name: 'Library.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1 // 数据库安全级别
    };
    relationalStore.getRdbStore(context_create, STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info(`Succeeded in getting RdbStore.`);
      //谓语
      // let predicates = new relationalStore.RdbPredicates('LIBRARY');
      //初始化数据
      const valuelibrary = {
        "NAME": NAME,
        "LOCATION": LOCATION,
        "TELEPHONENUMBER": TELEPHONENUMBER,
        "DESCRIPTION": DESCRIPTION
      };
      store.insert('lIBRARY', valuelibrary, (err, rowId) => {
        if (err) {
          console.error(`Failed to insert Library. Code:${err.code}, message:${err.message}`);
          return;
        }
        console.info(`Succeeded in inserting Library. rowId:${rowId}`);
      });
    });
  }
  //取出图书馆数据
  public getLibrary(NAME: string) {
    let STORE_CONFIG = {
      name: 'Library.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1 // 数据库安全级别
    };
    relationalStore.getRdbStore(context_create, STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info(`Succeeded in getting RdbStore.`);

      let predicates = new relationalStore.RdbPredicates('LIBRARY');

      predicates.equalTo('NAME', NAME);
      store.query(predicates, ['ID', 'NAME', 'LOCATION', 'TELEPHONENUMBER', 'DESCRIPTION'], (err, resultSet) => {
        if (err) {
          console.error(`Failed to query data. Code:${err.code}, message:${err.message}`);
          return;
        }

        // 遍历 ResultSet 的行数据
        while (resultSet.goToNextRow()) {
          const id = resultSet.getLong(0); // 第一列：ID
          const name = resultSet.getString(1); // 第二列：NAME
          const location = resultSet.getString(2); // 第三列：AGE
          const telephoneNumber = resultSet.getString(3); // 第四列：SALARY
          const description = resultSet.getString(4); // 第五列：CODES

          // 打印出结果
          console.info(`Row22: ID=${id}, NAME=${name}, LOCATION=${location}, TELEPHONENUMBWE=${telephoneNumber}, DESCRIPTION=${description}`);
        }

        // 关闭 ResultSet
        resultSet.close();
      });
    });
  }
  //存储书籍数据
  public insertBook(NAME: string, AUTHOR: string, DESCRIPTION: string, IMAGEURL: string) {
    let STORE_CONFIG = {
      name: 'Library.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1 // 数据库安全级别
    };
    relationalStore.getRdbStore(context_create, STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info(`Succeeded in getting RdbStore.`);
      //谓语
      // let predicates = new relationalStore.RdbPredicates('LIBRARY');
      //初始化数据
      const valuebook = {
        "NAME": NAME,
        "AUTHOR": AUTHOR,
        "DESCRIPTION": DESCRIPTION,
        "IMAGEURL": IMAGEURL
      };
      store.insert('BOOKS', valuebook, (err, rowId) => {
        if (err) {
          console.error(`Failed to insert book. Code:${err.code}, message:${err.message}`);
          return;
        }
        console.info(`Succeeded in inserting book. rowId:${rowId}`);
      });
    });
  }

  onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    // 初始化 context
    console.log('Context111:', this.context); // 打印 context 确保其初始化
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    //本地数据库SQLlite
    //数据库配置
    const STORE_CONFIG = {
      name: 'Library.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1 // 数据库安全级别
    };
    // 建表BOOKS的Sql语句
    const SQL_CREATE_TABLE_BOOKS = 'CREATE TABLE IF NOT EXISTS BOOKS (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITTLE TEXT NOT NULL, AUTHOR TEXT NOT NULL, DESCRIPTION TEXT NOT NULL, IMAGEURL TEXT NOT NULL)';
    const SQL_CREATE_TABLE_LIBRARY = 'CREATE TABLE IF NOT EXISTS LIBRARY (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, LOCATION TEXT NOT NULL, TELEPHONENUMBER TEXT NOT NULL, DESCRIPTION TEXT NOT NULL)';

    // 作关系型数据库，用户可以根据自己的需求配置RdbStore的参数，然后通过RdbStore调用相关接口可以执行相关的数据操作，使用callback异步回调。this.context应用的上下文
    context_create = this.context;
    //创建数据库并获取RdbStore
    relationalStore.getRdbStore(this.context, STORE_CONFIG, (err, store) => {
      if (err) {
        // console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      // console.info(`Succeeded in getting RdbStore.`);

      // 创建数据表
      // executeSql()执行包含指定参数但不返回值的SQL语句。
      store.executeSql(SQL_CREATE_TABLE_BOOKS);
      store.executeSql(SQL_CREATE_TABLE_LIBRARY);

      // // 创建表'BOOKS'的 predicates  谓语
      // let predicates = new relationalStore.RdbPredicates('BOOKS');
      // /*
      //  * 增 2、获取到RdbStore后，调用insert()接口插入数据。示例代码如下所示：
      //  * todo
      //  */
      // //要写入的数据
      // const valuebook = {
      //   "ID": 1,
      //   "TITTLE": "解忧杂货店",
      //   "AUTHOR": "东野圭吾",
      //   "DESCRIPTION": "这是一部温暖人心的小说，通过回答过去与现在之间的信件，讲述了人与人之间的联系和理解。",
      //   "IMAGEURL": "https://cdn.wtzw.com/bookimg/public/images/cover/a3c6/7bf53134b81136c75759be088e39e579_360x480.jpg"
      // };
      // store.insert('BOOKS', valuebook, (err, rowId) => {
      //   if (err) {
      //     console.error(`Failed to insert data. Code:${err.code}, message:${err.message}`);
      //     return;
      //   }
      //   console.info(`Succeeded in inserting data. rowId:${rowId}`);
      // });
      //
      // /*
      // * 查根据谓词指定的查询条件查找数据。调用query()方法查找数据，返回一个ResultSet结果集。示例代码如下所示：
      // * todo
      //  */
      // // predicates.equalTo('NAME', 'Linda');
      // store.query(predicates, ['ID', 'TITTLE', 'AUTHOR', 'DESCRIPTION', 'IMAGEURL'], (err, resultSet) => {
      //   if (err) {
      //     console.error(`Failed to query data. Code:${err.code}, message:${err.message}`);
      //     return;
      //   }
      //
      //   // 遍历 ResultSet 的行数据
      //   while (resultSet.goToNextRow()) {
      //     const id = resultSet.getLong(0); // 第一列：ID
      //     const tittle = resultSet.getString(1); // 第二列：NAME
      //     const author = resultSet.getString(2); // 第三列：AGE
      //     const description = resultSet.getString(3); // 第四列：SALARY
      //     const imageUrl = resultSet.getString(4); // 第五列：CODES
      //
      //     // 打印出结果
      //     console.info(`Row22: ID=${id}, TITTLE=${tittle}, AUTHOR=${author}, DESCRIPTION=${description}, IMAGEURL=${imageUrl}`);
      //   }
      //
      //   // 关闭 ResultSet
      //   resultSet.close();
      // });

      // // 创建表'lIBRARY'的 predicates  谓语
      // let predicates = new relationalStore.RdbPredicates('LIBRARY');
      // /*
      //  * 增 2、获取到RdbStore后，调用insert()接口插入数据。示例代码如下所示：
      //  * todo
      //  */
      // //要写入的数据
      // const valuelibrary = {
      //   "NAME": "市中心图书馆",
      //   "LOCATION": "市中心大街123号",
      //   "TELEPHONENUMBER": "0769-83398746",
      //   "DESCRIPTION": "市中心图书馆，城市的文化地标，藏书丰富，环境优雅。这里不仅是知识的海洋，更是市民学习的乐园。现代科技与传统阅读完美融合，提供电子阅读、自助借还等便捷服务。无论老少，皆能在此找到心灵的栖息地，享受阅读的乐趣，启迪智慧，丰富生活。"
      // };
      // store.insert('lIBRARY', valuelibrary, (err, rowId) => {
      //   if (err) {
      //     console.error(`Failed to insert data. Code:${err.code}, message:${err.message}`);
      //     return;
      //   }
      //   console.info(`Succeeded in inserting data. rowId:${rowId}`);
      // });
      //
      // /*
      // * 查根据谓词指定的查询条件查找数据。调用query()方法查找数据，返回一个ResultSet结果集。示例代码如下所示：
      // * todo
      //  */
      // // predicates.equalTo('NAME', 'Linda');
      // store.query(predicates, ['ID', 'NAME', 'LOCATION', 'TELEPHONENUMBER', 'DESCRIPTION'], (err, resultSet) => {
      //   if (err) {
      //     console.error(`Failed to query data. Code:${err.code}, message:${err.message}`);
      //     return;
      //   }
      //
      //   // 遍历 ResultSet 的行数据
      //   while (resultSet.goToNextRow()) {
      //     const id = resultSet.getLong(0); // 第一列：ID
      //     const name = resultSet.getString(1); // 第二列：NAME
      //     const location = resultSet.getString(2); // 第三列：AGE
      //     const telephoneNumber = resultSet.getString(3); // 第四列：SALARY
      //     const description = resultSet.getString(4); // 第五列：CODES
      //
      //     // 打印出结果
      //     console.info(`Row22: ID=${id}, NAME=${name}, LOCATION=${location}, TELEPHONENUMBWE=${telephoneNumber}, DESCRIPTION=${description}`);
      //   }
      //
      //   // 关闭 ResultSet
      //   resultSet.close();
      // });

    });

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
