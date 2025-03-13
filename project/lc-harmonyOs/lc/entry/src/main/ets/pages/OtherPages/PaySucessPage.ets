import { router } from '@kit.ArkUI';

@Entry
@Component
struct PaySucessPage {
  @State obj: object = router.getParams();
  @State payNum:number=this.obj['payNum']

  build() {
    Column({space:400}){
      Column({space:60}){
        Text('支付成功').fontColor('#20b36b')

        Column({space:5}){
          Text('商家收款')
          Text(`￥${this.payNum}.00`).fontSize(30)
        }
      }

      Text('完成').padding({top:10,bottom:10,left:50,right:50}).backgroundColor('#f2f2f2').borderRadius(5)
        .onClick(()=>{
          router.back()
        })
    }.width('100%').height('100%').backgroundColor(Color.White)
  }
}