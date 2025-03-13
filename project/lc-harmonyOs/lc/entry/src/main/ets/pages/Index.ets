import { tabsBottomData } from '../data/allDatas';
import { tabs, tabsTitle } from '../type/allTypes';
import { ClassifyPage } from './IndexPages/ClassifyPage';
import { HomePage } from './IndexPages/HomePage';
import { ShopPage } from './IndexPages/ShopPage';
import { UserPage } from './IndexPages/UserPage';
import { router } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';


@Entry
@Component
struct Index {
  //总导航选择项
  @State obj: object = router.getParams();
  @State pageNum:number=this.obj['pageNum']

  //token
  @State token: preferences.ValueType = '';

  //自定义导航栏
  @Builder tabStyle(type:tabsTitle){
    Column({space:4}){
      Image(type.id == this.pageNum ? type.acImg : type.Img)
        .width(30)
      Text(type.name).fontSize(14).fontColor(type.id == this.pageNum ? $r('app.color.theme_color1') : $r('app.color.font_black'))

    }
    .padding({top:4})
  }


  //获取token
  async getTokenHandler(){
    let AppPreferences: preferences.Preferences | undefined = AppStorage.get('AppPreferences');
    if(AppPreferences){
      this.token = AppPreferences.getSync('token', null);
    };
  }
  aboutToAppear(): void {
    this.getTokenHandler()
  }

  build() {
    Tabs({barPosition:BarPosition.End,index:this.pageNum}){
      ForEach(tabsBottomData,(item:tabs,index:number)=>{
        TabContent(){
          if(item.pageName == 'HomePage'){
            //首页
            HomePage()
          }else if(item.pageName == 'ClassifyPage'){
            //分类
            ClassifyPage()
          }else if(item.pageName == 'ShopPage'){
            //购物车
            ShopPage({pageNum: this.pageNum})
          }else if(item.pageName == 'UserPage'){
            //用户
            UserPage()
          }
        }.tabBar(this.tabStyle(item.title)).backgroundColor($r('app.color.window_background'))
        .onWillShow(()=>{
          if (index == 2) {
            //检测登录状态
            console.log('跳转到购物页了')
            if (this.token == null) {
              router.pushUrl({
                url:'pages/loginPage',
                params:{goodsId:''}
              })
            }
          }
        })
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
      })

    }
    .width('100%')
    .height('100%')
    .divider({strokeWidth: 1, color: '#eee'})
    .onChange((index: number) => {
      this.pageNum = index;
    })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }


}