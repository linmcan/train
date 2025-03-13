import { router } from '@kit.ArkUI';
import { GoodsListPage } from './basePage/GoodsListPage';

@Entry
@Component
struct SearchResultPage {
  @State obj: object = router.getParams();
  @State nowKeywords: string = this.obj['keywords'];

  build() {
      Column(){

        //头部
        Row(){
          //返回按钮
          Image($r('app.media.back')).height('60%').aspectRatio(1)
            .onClick(()=>{
              router.back()
            })

          //搜索框
          Column(){
            Row({space:10}){
              Image($r('app.media.ic_search'))
                .width('6%')
                .aspectRatio(1)

              Text(this.nowKeywords)
                .fontSize(14)
                .fontColor($r('app.color.font_GrayBlack'))
            }
            .padding(10)
            .borderRadius(20)
            .backgroundColor(Color.White)
            .width('95%')
          }
          .width('90%')
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
          .onClick(()=>{
            router.pushUrl({url: 'pages/OtherPages/SearchPage'})
          })

        }
        .backgroundColor($r('app.color.theme_color1'))
        .padding(10)
        .width('100%')
        .height('8%')
        .justifyContent(FlexAlign.SpaceBetween)

        //调用公共商品列表页面
        GoodsListPage({isSearch:true,keywords:this.nowKeywords})
      }
      .width('100%')
    .height('100%')


  }
}