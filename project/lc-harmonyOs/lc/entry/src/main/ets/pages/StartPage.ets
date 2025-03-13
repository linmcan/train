import { router } from '@kit.ArkUI';

@Entry
@Component
struct StartPage {
  @State countdown: number = 3;
  @State timer: number = 0;

  //方法 启动 倒计时
  countdownHandler(){
    //倒计时
    this.timer = setInterval(() => {
      this.countdown--;
      if(this.countdown <= 0){
        clearInterval(this.timer);
        this.countdown = 0;
        //路由跳转
        router.pushUrl({url:'pages/Index',
          params:{pageNum:0}});
      }
    }, 1000)
  };

  //组件加载完成
  aboutToAppear(): void {
    this.countdownHandler();
  };

  //组件销毁完成
  aboutToDisappear(): void {
    clearInterval(this.timer);
  }

  build() {
    Stack({alignContent:Alignment.TopEnd}){
      Column(){
        Column(){}.width('100%').layoutWeight(1).backgroundImage($r('app.media.startImg')).backgroundImageSize(ImageSize.Cover)
        Column(){
          Text('一个购物').fontSize(30)
        }
        .height('20%').width('100%').justifyContent(FlexAlign.Center).border({width:{top:1}})
      }

      Column(){
        Text(`${this.countdown}  跳过`).fontColor(Color.White)
      }.backgroundColor('#66000000').padding({top:10,bottom:10,left:20,right:20}).borderRadius(20).margin(20)
      .onClick(()=>{
        clearInterval(this.timer);
        router.replaceUrl({
          url:'pages/Index',
          params:{pageNum:0}
        })
      })
    }
  }
}