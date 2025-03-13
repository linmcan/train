import { preferences } from '@kit.ArkData';
import { promptAction, router } from '@kit.ArkUI';
import { PostMessage } from '../type/allTypes';
import { hcHttp } from '../utils/HttpRequest';

@Entry
@Component
struct LoginPage {
  @State username: string = '';
  @State password: string = '';
  @State xy:boolean=false
  //传递过来的商品ID
  @State obj: object = router.getParams();
  @State goodsId: string =this.obj['goodsId']
  //获取首选项的实例
  @State AppPreferences: preferences.Preferences | undefined = undefined;


  aboutToAppear(): void {
    //通过APPstorage 获取 首选项
    this.AppPreferences = AppStorage.get('AppPreferences');
  }


  build() {
    Column({space:20}){
      Image($r('app.media.back')).width('5%')
        .onClick(()=>{
          router.back()
        })
      Text('用户登录').fontSize(30)
        .padding({top:80,bottom:80})

      Column({space:10}){
        Row({space:10}){
          Text('用户名:').width('20%').fontSize(14)
          TextInput({
            text: $$this.username,
            placeholder: '请输入用户名'
          }).layoutWeight(1)
        }

        Row({space:10}){
          Text('密码:').width('20%').fontSize(14)
          TextInput({
            text: $$this.password,
            placeholder: '请输入密码'
          }).layoutWeight(1)
            .type(InputType.NUMBER_PASSWORD)
        }

        Row({space:5}){
          Toggle({ type: ToggleType.Checkbox, })
            .size({ width: 10, height: 10 })
            .selectedColor($r('app.color.theme_color1'))
            .onChange((isOn: boolean) => {
              this.xy=isOn
            })
          Text('同意《用户协议》和《隐私协议》').fontColor($r('app.color.font_GrayBlack')).fontSize(14)
        }
      }.width('100%').alignItems(HorizontalAlign.Start)


      //按钮
      Button('登录').width('100%').backgroundColor($r('app.color.theme_color1')).onClick(async () => {
        //验证不为空
        if(this.username == '' || this.password == ''){
          promptAction.showToast({
            message: '用户名或密码不能为空'
          })
          return;
        };
        if(!this.xy){
          promptAction.showToast({
            message: '请勾选协议'
          })
          return;
        };

        //请求登录接口
        let httpResponse = await hcHttp.hcPost(hcHttp.BASE_URL + '/api_user', {
          'username': this.username,
          'password': this.password,
          'status': 'login'
        });

        //转换数据  所有跟校验相关的接口数据类型，自己重新定义一个
        let data: PostMessage = JSON.parse(httpResponse.result.toString());

        //验证
        if(data.code != 0){
          promptAction.showToast({
            message: '用户名或密码错误'
          });
          return;
        };
        //才是登录成功
        //登录状态持久化
        this.AppPreferences?.putSync('username', data.username);
        this.AppPreferences?.putSync('token', data.user_id);
        this.AppPreferences?.flush();
        console.log('用户111'+this.AppPreferences?.getSync('username', null))

        //跳转：参数验证
        if(this.goodsId){
          router.replaceUrl({
            url: 'pages/OtherPages/GoodsDetailsPage',
            params: {
              goodsId: this.goodsId
            }
          })
        }else{
          router.pushUrl({
            url: 'pages/Index',
            params:{pageNum:0}
          })
        }


      })

      Column(){
        Text('没有账号？去注册').fontSize(14).fontColor($r('app.color.theme_color1'))
          .onClick(()=>{
            router.pushUrl({
              url:'pages/registPage'
            })
          })
      }.width('100%').alignItems(HorizontalAlign.Center)

    }.alignItems(HorizontalAlign.Start)
    .width('100%').height('100%').padding(20)
  }
}