import { router } from '@kit.ArkUI'
import { baseAddressPage } from './basePage/baseAddressPage'


@Entry
@Component
struct AddressPage {


  build() {
    Column(){
      //头部
      Stack({alignContent:Alignment.Start}){
        Row(){
          Text('地址管理')
        }.width('100%').justifyContent(FlexAlign.Center)

        Image($r('app.media.back')).width('5%').aspectRatio(1)
          .onClick(()=>{
            router.back()
          })
      }.width('100%').padding(10).backgroundColor(Color.White)

      baseAddressPage({fromDetails:false})

    }.backgroundColor($r('app.color.window_background'))
  }

}