import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';

export default class EntryAbility extends UIAbility {
  //首选项实例
  private AppPreferences: preferences.Preferences | null = null;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  //封装首选项项
  AppPreferencesHandler(){
    //创建实例
    this.AppPreferences = preferences.getPreferencesSync(this.context, {name: 'AppPreferences'});
    // 全局共享
    AppStorage.setOrCreate('AppPreferences', this.AppPreferences);

    //默认支付密码
    this.AppPreferences.putSync('payPassword','123456')
    this.AppPreferences?.flush();
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    this.AppPreferencesHandler();

    //关于加载页面路径
    let url = 'pages/StartPage';
    //验证是否第一次启动
    console.log('wj', JSON.stringify(this.AppPreferences?.getSync('firstApp', false)))
    if(this.AppPreferences?.getSync('firstApp', false)){
      url = 'pages/StartPage';
    }else{
      url = 'pages/welcomePage';
    };

    windowStage.loadContent(url, (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}

