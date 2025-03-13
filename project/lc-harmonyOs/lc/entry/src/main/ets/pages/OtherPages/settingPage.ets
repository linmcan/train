import { router } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';

interface settingType{
  name:string,
  type:string[]
}

@Entry
@Component
struct SettingPage {
  @State settingData: settingType[] = [
    {name:'账号与安全',type:['收货地址','账号与安全','支付设置','位置服务']},
    {name:'功能',type:['通用设置','消息通知','隐私管理','模式切换']},
    {name:'关于',type:['商家入驻','帮助与反馈','关于']},
    {name:'账号管理',type:['切换账号','退出登录']},
  ];

  //清除当前token
  dltToken(){
    let AppPreferences: preferences.Preferences | undefined = AppStorage.get('AppPreferences');
    AppPreferences?.deleteSync('token')
    AppPreferences?.deleteSync('username')
    AppPreferences?.flush()
  }

  build() {
    Column(){
      //头部
      Stack({alignContent:Alignment.Start}){
        Text('设置').textAlign(TextAlign.Center).width('100%')

        Image($r('app.media.back')).width('5%').aspectRatio(1)
          .onClick(()=>{
            router.back()
          })
      }
      .width('100%').padding(10).backgroundColor(Color.White)

        List(){
          ForEach(this.settingData,(item:settingType)=>{
            ListItemGroup({header: this.listGroupTitle(item.name)}){
              ForEach(item.type,(item:string)=>{
                ListItem(){
                  Row(){
                    Text(item).fontSize(14)
                    Image($r('app.media.go')).width('3%').aspectRatio(1)
                  }.width('100%').justifyContent(FlexAlign.SpaceBetween).padding({top:10,bottom:10})
                }.onClick(()=>{
                  switch (item){
                    case '退出登录':
                      this.dltToken()
                      router.pushUrl({
                        url:'pages/Index',
                        params:{pageNum:0}
                      })
                      break;
                    case '收货地址':
                      router.pushUrl({url:'pages/OtherPages/addressPage'})
                      break;
                    case '支付设置':
                      router.pushUrl({url:'pages/OtherPages/PayPasswordPage'})
                      break;
                    case '位置服务':
                      router.pushUrl({url:'pages/OtherPages/testPage/MapPage'})
                      break;
                    case '切换账号':
                      this.dltToken()
                      router.pushUrl({ url:'pages/loginPage', params:{goodsId:''}})
                      break;
                  }
                })

              })
            }.width('100%').padding(10).backgroundColor(Color.White).margin({top:10})
          })
        }
      .layoutWeight(1)
    }
    .width('100%').height('100%')
    .backgroundColor($r('app.color.window_background'))
  }
  @Builder listGroupTitle(str:string){
    Column(){
      Text(str)
        .width('100%')
        .fontSize(20)
        .fontWeight(700)
      Divider().strokeWidth(1)
    }
  }
}