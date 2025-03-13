import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct WelcomePage {
  //获取首选项的实例
  @State AppPreferences: preferences.Preferences | undefined = undefined;

  //启动图标
  @State firstApp:boolean=true
  //用户须知
  @State scdApp:boolean=true

  //设置首选项方法
  async setFirstAppHandler(){
    //设置已启动过
    this.AppPreferences?.putSync('firstApp', true);
    this.AppPreferences?.flush().catch((err: BusinessError) => {
      console.log('pfs', '设置持久化-firstApp-失败：' + JSON.stringify(err));
    })
  };

  async aboutToAppear(): Promise<void> {
    this.AppPreferences = AppStorage.get('AppPreferences');

    let timer=setTimeout(()=>{
      this.firstApp=false
      clearInterval(timer)
    },3000)
  }

  build() {
    Stack() {
      //登录选择
      Column({space:40}){
        Text(`为了您更好的体验
建议您先登录`).fontSize(30)

        Row(){
          Button('暂不去').backgroundColor(Color.White).fontColor($r('app.color.theme_color1')).border({width:1,color:$r('app.color.theme_color1')}).width('30%')
            .onClick(()=>{
                //设置已启动过
                this.setFirstAppHandler();
                //路由跳转
                router.replaceUrl({
                  url:'pages/StartPage'
                });
            })
          Button('去登录').backgroundColor($r('app.color.theme_color1')).width('30%')
            .onClick(()=>{
                //设置已启动过
                this.setFirstAppHandler();
                //路由跳转
                router.replaceUrl({
                  url:'pages/loginPage',
                  params:{goodsId:''}
                });
            })
        }.width('100%').justifyContent(FlexAlign.SpaceEvenly)

      }
      .width('100%').height('100%').expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
      .padding(10).justifyContent(FlexAlign.SpaceAround)
      .backgroundImage($r('app.media.wlcBg'))
      .backgroundImageSize(ImageSize.Cover).backgroundBlurStyle(BlurStyle.Thin, { colorMode: ThemeColorMode.LIGHT, adaptiveColor: AdaptiveColor.DEFAULT, scale: 1.0 })

      //用户须知
      if (this.scdApp){
        Column(){
          Column({space:10}){
            Text('用户须知').fontSize(20).fontWeight(700)
            Scroll(){
              Text(`欢迎使用本购物软件！为了保障您的权益，请在使用前仔细阅读以下用户须知。一旦您注册、登录或使用本软件，即表示您已充分理解并同意遵守以下条款和规则。

1. 用户注册与账户安全
1.1 您需要注册账户并使用有效的个人信息（如手机号、邮箱等）完成实名认证。
1.2 请妥善保管您的账户信息（如用户名、密码等），切勿将账户信息透露给他人。
1.3 因您个人原因导致账户信息泄露或被盗用，本平台不承担相关责任。

2. 商品购买与支付
2.1 本平台展示的商品信息（如价格、规格、库存等）仅供参考，请以实际下单页面为准。
2.2 您可以通过本平台支持的支付方式（如微信支付、支付宝、银行卡等）完成订单支付。
2.3 请确保支付账户余额充足，若因余额不足导致支付失败，订单可能会被取消。

3. 订单与配送
3.1 订单提交后，您可以在“我的订单”页面查看订单状态。
3.2 本平台将根据您填写的收货地址安排配送，请确保地址信息准确无误。
3.3 配送时间可能因天气、交通等因素有所延迟，请您耐心等待。

4. 退换货与售后服务
4.1 若收到的商品存在质量问题或与描述不符，您可以在签收后7天内申请退换货。
4.2 退换货时，请确保商品完好无损、包装完整，并附上相关凭证（如发票、订单号等）。
4.3 本平台将在收到退货商品并确认无误后，为您办理退款或换货。

5. 用户行为规范
5.1 您不得利用本平台从事任何违法、违规活动（如虚假交易、恶意刷单等）。
5.2 请勿发布虚假评价、恶意诋毁商家或其他用户。
5.3 若发现任何违规行为，本平台有权采取限制账户功能、封禁账户等措施。

6. 隐私保护
6.1 本平台将严格保护您的个人信息，未经您的同意，不会向第三方泄露。
6.2 本平台可能会收集您的浏览记录、订单信息等数据，以优化服务和提升用户体验。
6.3 您可以通过“隐私设置”管理您的个人信息授权范围。

7. 免责声明
7.1 因不可抗力（如自然灾害、网络故障等）导致的服务中断，本平台不承担相关责任。
7.2 本平台不对第三方链接或广告内容负责，请您谨慎判断。
7.3 您在使用本平台过程中产生的任何风险，需自行承担。

8. 其他
8.1 本平台有权根据法律法规或业务需求对用户须知进行修改，修改后的内容将通过公告或站内信通知您。
8.2 若您对本用户须知有任何疑问，请联系客服咨询。

感谢您选择本购物软件！我们将竭诚为您提供优质的商品和服务，祝您购物愉快！`).fontSize(12)
            }.layoutWeight(1).scrollBar(BarState.Off)

            Row(){
              Button('不同意').backgroundColor(Color.White).fontColor($r('app.color.theme_color1')).border({width:1,color:$r('app.color.theme_color1')}).width('30%')
                .onClick(()=>{
                  router.back()
                })
              Button('同意').backgroundColor($r('app.color.theme_color1')).width('30%')
                .onClick(()=>{
                  this.scdApp=false
                })
            }.width('100%').justifyContent(FlexAlign.SpaceEvenly)
          }
          .width('70%').height('50%').padding(10).borderRadius(20).border({width:1,color:$r('app.color.window_background')}).backgroundColor(Color.White)
        }
        .width('100%').height('100%').expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
        .justifyContent(FlexAlign.Center).backgroundImage($r('app.media.wlcBg'))
        .backgroundImageSize(ImageSize.Cover).backgroundBlurStyle(BlurStyle.Thin, { colorMode: ThemeColorMode.LIGHT, adaptiveColor: AdaptiveColor.DEFAULT, scale: 1.0 })
      }


      // 启动页图标
      if (this.firstApp){
        Column(){
          Text('假装图标').fontSize(50).width(100)
        }
        .width('100%').height('100%').justifyContent(FlexAlign.Center).backgroundColor(Color.White)
      }


    }
    .height('100%')
    .width('100%')

  }
}