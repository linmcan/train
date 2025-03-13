import { router } from '@kit.ArkUI';

@Entry
@Component
 struct SearchPage {
  @State text: string = '';
  @State placeholderText:string='甜品'

  @State searchArr:string[]=['球','水杯','被子','枕头','玩具','玩偶','音箱','酒']

  build() {
    Column(){
      //head
      Row(){
        //返回按钮
        Image($r('app.media.back')).height('60%').aspectRatio(1)
          .onClick(()=>{
            router.back()
          })

        //搜索框
        Row(){
          Image($r('app.media.ic_search'))
            .height('50%')
            .aspectRatio(1)

          TextInput({text: this.text,placeholder:this.placeholderText})
            .width('80%')
            .caretColor($r('app.color.theme_color1'))
            .backgroundColor('#eaeaea')
            .onChange((value:string)=>{
              this.text=value
            })
            .onSubmit(()=>{
              router.pushUrl({
                url: 'pages/OtherPages/SearchResultPage',
                params:{keywords:this.text == '' ? this.placeholderText : this.text}
              })
            })
        }
        .padding({ left:10,right:10 })
        .borderRadius(20)
        .backgroundColor('#eaeaea')
        .width('75%')

        Text('搜索').fontSize(18).fontColor($r('app.color.theme_color1'))
          .onClick(()=>{
            router.pushUrl({
              url: 'pages/OtherPages/SearchResultPage',
              params:{keywords : this.text == '' ? this.placeholderText : this.text}
            })
          })
      }
      .backgroundColor(Color.White)
      .padding(10)
      .width('100%')
      .height('8%')
      .justifyContent(FlexAlign.SpaceBetween)


      //热门搜索
      Column(){
        Row({space:5}){
          Image($r('app.media.hot')).width('5%')
          Text('热门搜索')
        }.width('100%')

        Flex({wrap:FlexWrap.Wrap}){
          ForEach(this.searchArr,(item:string)=>{
            Column(){
              Text(item)
            }
            .margin({top:5,right:10 })
            .borderRadius(20)
            .backgroundColor('#eaeaea')
            .padding({ top:10,bottom:10,left:15,right:15 })
            .onClick(()=>{
              router.pushUrl({
                url: 'pages/OtherPages/SearchResultPage',
                params:{keywords:item}
              })
            })
          })
        }

      }
      .padding(10)
    }
    .backgroundColor($r('app.color.window_background'))
    .height('100%')
    .width('100%')
  }
}