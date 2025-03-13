
import { hcHttp } from './../utils/HttpRequest';
import { promptAction, router } from '@kit.ArkUI';
import { PostMessage } from '../type/allTypes';

@Entry
@Component
struct RegisterPage {

  //当前项的值
  @State username:string = '';
  @State password:string = '';
  @State confirmPassword:string = '';
  @State userAgreement:boolean = false;

  //当前提示文本
  @State usernameMsg: string = '';
  @State passwordMsg: string = '';
  @State conPwdMsg: string = '确认密码';
  @State userAgreementMsg: string = '请同意协议';

  //当前气泡的显示状态
  @State usernamePopup: boolean = false;
  @State pwdPopup: boolean = false;
  @State conPwdPopup: boolean = false;
  @State userAgreePopup: boolean = false;


  //当前项是否校验通过
  @State usernameStatus: boolean = false;
  @State pwdStatus: boolean = false;
  @State conPwdStatus: boolean = false;
  @State userAgreeStatus: boolean = false;



  //用户名校验方法
  async checkUsernameHandler(){
    //定义正则
    let re = /[a-z0-9_]{3,12}/g;
    //验证
    if(!re.test(this.username)){
      //设置提示框显示
      this.usernamePopup = true;
      //设置提示文本
      this.usernameMsg = '用户名必须为3-12位字母数字下划线组成';
      //设置当前项的 校验 状态
      this.usernameStatus = false;
      return;
    };

    //通过前端正则. 发起请求，验证用户名是否可用
    let httpResponse = await hcHttp.hcPost(hcHttp.BASE_URL + '/api_user', {
      'username': this.username,
      'status': 'check'
    });
    //转换数据
    let data: PostMessage = JSON.parse(httpResponse.result.toString());
    // 验证
    if(data.code == 1005){
      //用户名不可用
      //设置提示框显示
      this.usernamePopup = true;
      //设置提示文本
      this.usernameMsg = '家人们，这个名字太受欢迎了，请换个吧！';
      //设置当前项的 校验 状态
      this.usernameStatus = false;
      return;
    };
    //OK的用户名
    this.usernameStatus = true;




  }

  //密码校验方法
  async checkPasswordHandler(){
    //密码正则
    let re = /\d{6,12}/g;
    //验证
    if(!re.test(this.password)){
      //设置提示框显示
      this.pwdPopup = true;
      //设置提示文本
      this.passwordMsg = '6-12位的数字';
      //设置当前项的 校验 状态
      this.pwdStatus = false;
      return;
    };

    //通过
    //设置提示框显示
    this.pwdPopup = false;
    //设置提示文本
    this.passwordMsg = '';
    //设置当前项的 校验 状态
    this.pwdStatus = true;
  }

  async checkConPwdHandler(){
    //比对密码
    if(this.password != this.confirmPassword){
      //设置提示框显示
      this.conPwdPopup = true;
      //设置提示文本
      this.conPwdMsg = '两次密码不一致';
      //设置当前项的 校验 状态
      this.conPwdStatus = false;
      return;
    };
    //设置提示框显示
    this.conPwdPopup = false;
    //设置提示文本
    this.conPwdMsg = '';
    //设置当前项的 校验 状态
    this.conPwdStatus = true;
  };


  build() {
    Column({space: 20}) {
      Image($r('app.media.back')).width('5%')
        .onClick(()=>{
          router.back()
        })
      Text('注册').fontSize(30)
        .padding({top:80,bottom:80})

      //账号
      Column({space:10}){
        Row(){
          Text('用户名:').width('20%').fontSize(14)
          TextInput({
            text: $$this.username,
            placeholder: '请输入用户名'
          })
            .layoutWeight(1)
            .onBlur(() => {
              //调用验证用户名的方法
              this.checkUsernameHandler();
            })

        }
        .width('100%')
        .bindPopup(this.usernamePopup, {
          message: this.usernameMsg,
          messageOptions: {textColor: Color.White},
          placement: Placement.Top,
          popupColor: 'rgba(0,0,0,0.8)',
          backgroundBlurStyle: BlurStyle.NONE, // 关闭气泡的模糊背景
        })

        //密码
        Row(){
          Text('密码:').width('20%').fontSize(14)
          TextInput({
            text: $$this.password,
            placeholder: '请输入密码'
          })
            .type(InputType.NUMBER_PASSWORD)
            .layoutWeight(1)
            .onChange(() => {
              this.checkPasswordHandler()
            })
        }
        .width('100%')
        .bindPopup(this.pwdPopup, {
          message: this.passwordMsg,
          messageOptions: {textColor: Color.White},
          placement: Placement.Top,
          popupColor: 'rgba(0,0,0,0.8)',
          backgroundBlurStyle: BlurStyle.NONE, // 关闭气泡的模糊背景
        })

        //确认密码
        Row(){
          Text('确认密码:').width('20%').fontSize(14)
          TextInput({
            text: $$this.confirmPassword,
            placeholder: '确认密码'
          })
            .type(InputType.NUMBER_PASSWORD)
            .layoutWeight(1)
            .onChange(() => {
              this.checkConPwdHandler();
            })
        }
        .width('100%')
        .bindPopup(this.conPwdPopup, {
          message: this.conPwdMsg,
          messageOptions: {textColor: Color.White},
          placement: Placement.Top,
          popupColor: 'rgba(0,0,0,0.8)',
          backgroundBlurStyle: BlurStyle.NONE, // 关闭气泡的模糊背景
        })

        //用户协议
        Row(){
          Toggle({ type: ToggleType.Checkbox, })
            .size({ width: 10, height: 10 })
            .selectedColor($r('app.color.theme_color1'))
            .onChange((isOn: boolean) => {
              this.userAgreement=isOn
            })
          Text('同意《用户协议》和《隐私协议》').fontColor($r('app.color.font_GrayBlack')).fontSize(14)
        }
        .bindPopup(this.userAgreePopup, {
          message: this.userAgreementMsg,
          messageOptions: {textColor: Color.White},
          placement: Placement.Top,
          popupColor: 'rgba(0,0,0,0.8)',
          backgroundBlurStyle: BlurStyle.NONE, // 关闭气泡的模糊背景
        })
      }.width('100%').alignItems(HorizontalAlign.Start)




      //注册按钮
      Button('注册')
        .backgroundColor($r('app.color.theme_color1'))
        .width('100%')
        .onClick(async () => {
          //验证所有项的状态，要都为true
          if(!this.usernameStatus || !this.pwdStatus || !this.conPwdStatus){
            //错误弹框
            promptAction.showToast({message: '注册失败,请检查信息'});
            return;
          };
          if(!this.userAgreement){
            //错误弹框
            promptAction.showToast({message: '请勾选协议'});
            return;
          };

          //调用接口，注册到后台
          let httpResponse = await hcHttp.hcPost(hcHttp.BASE_URL + '/api_user', {
            'username': this.username,
            'password': this.password,
            'status': 'register'
          });
          //转换数据
          let data: PostMessage = JSON.parse(httpResponse.result.toString());
          //验证
          if(data.code == 1004){
            promptAction.showToast({message: '密码必须为6-12位的数字'});
            return;
          };
          //密码： 明码 => 密文  md5
          if(data.code == 1005){
            promptAction.showToast({message: '用户名已存在'});
            return;
          };
          if(data.code == 0){
            promptAction.showToast({message: '注册成功！'});
            router.back()
            return;
          }


        })

      //已有账号
      Row(){
        Text('已有账号，去登录').fontColor($r('app.color.font_GrayBlack')).fontSize(14)
      }.width('100%').justifyContent(FlexAlign.End)

    }
    .alignItems(HorizontalAlign.Start)
    .height('100%')
    .width('100%')
    .padding(20)
  }
}