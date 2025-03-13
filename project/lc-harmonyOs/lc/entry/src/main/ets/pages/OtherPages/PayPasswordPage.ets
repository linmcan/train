import { router } from '@kit.ArkUI';
import { faceDetector } from '@kit.CoreVisionKit';
import { preferences } from '@kit.ArkData';

@Entry
@Component
struct PayPasswordPage {
  //token
  // @State token: preferences.ValueType = '';
  //获取首选项的实例
  @State AppPreferences: preferences.Preferences | undefined = undefined;
  @State changePassword:boolean=false

  // //获取用户
  // async getTokenHandler(){
  //   this.AppPreferences = AppStorage.get('AppPreferences');
  //   // if(this.AppPreferences){
  //   //   this.token = this.AppPreferences.getSync('token', null);
  //   // };
  // }
  aboutToAppear(): void {
    this.AppPreferences = AppStorage.get('AppPreferences');
  }


  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExample({
      AppPreferences:this.AppPreferences
    }),
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
    cornerRadius: 10,
  })

  build() {
    Column() {
      //头部
      Stack({ alignContent: Alignment.Start }) {
        Row() {
          Text('支付设置')
        }.width('100%').justifyContent(FlexAlign.Center)

        Image($r('app.media.back')).width('5%').aspectRatio(1)
          .onClick(() => {
            router.back()
          })
      }.width('100%').padding(10).backgroundColor(Color.White)

      Row() {
        Text('修改密码').fontSize(14)
        Image($r('app.media.go')).width('3%').aspectRatio(1)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(10)
      .backgroundColor(Color.White)
      .margin({ top: 10 })
      .onClick(()=>{
        this.dialogController?.open()
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.window_background'))
  }

}

@CustomDialog
@Component
struct CustomDialogExample{
  @State newPassword:string=''

  @State AppPreferences: preferences.Preferences | undefined = undefined;
  controller: CustomDialogController
  build() {
    Column({space:30}){
      Text('修改支付密码').fontSize(18)
      TextInput({placeholder:'请输入新的六位数密码'}).type(InputType.Password)
        .onChange((value)=>{
          this.newPassword=value
        })
      Row(){
        Text('取消').fontColor(Color.Red).fontSize(20)
          .onClick(()=>{
            this.controller.close()
          })
        Divider().strokeWidth(1).height(20).vertical(true)
        Text('确定').fontColor($r('app.color.theme_color1')).fontSize(20)
          .onClick(()=>{
            let regex = /^[0-9]{6}$/;
            let isOn =  regex.test(this.newPassword);
            if(isOn){
              this.AppPreferences?.putSync('payPassword',this.newPassword)
              this.AppPreferences?.flush();

              this.controller.close()
            }else {
              AlertDialog.show({
                message:'请输入正确的支付密码格式'
              })
            }
          })
      }.width('100%').justifyContent(FlexAlign.SpaceEvenly)
    }
    .padding(10)
  }
}