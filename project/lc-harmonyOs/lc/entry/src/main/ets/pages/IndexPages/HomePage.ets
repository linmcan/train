
import { classifyType } from "../../type/allTypes"
import {GoodsTypePage} from "./Homepages/GoodsTypePage"
import { RecommendPage } from "./Homepages/RecommendPage"
import { getClassifyData } from "../../api/GoodsApi"
import { AdmirePage } from "./Homepages/AdmirePage"
import { router } from "@kit.ArkUI"

@Component

export struct HomePage{
  @State isChoice:number=0

  //分类导航栏数据
  @State classifyNavData:classifyType[] | undefined = []

  //获取数据
  async aboutToAppear(){
    this.classifyNavData = await getClassifyData('/api_cat');
}

  build() {
    Column(){
      //搜索框
      this.searchBuilder()

      Scroll(){
          //Tab主体
          this.HomeTabs()
      }
      .width('100%')
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .layoutWeight(1)

    }
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }



  @Builder searchBuilder(){
    Column(){
      Row({space:10}){
        Image($r('app.media.ic_search'))
          .width('6%')
          .aspectRatio(1)

        Text('儿童餐椅')
          .fontSize(14)
          .fontColor($r('app.color.font_GrayBlack'))
      }
      .padding(10)
      .borderRadius(20)
      .backgroundColor(Color.White)
      .width('95%')
    }
    .padding({ top:10,bottom:10 })
    .backgroundColor($r('app.color.theme_color1'))
    .width('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .onClick(()=>{
      router.pushUrl({url: 'pages/OtherPages/SearchPage'})
    })
  }

  @Builder HomeTabs(){
    Tabs(){
      //单独的页面-推荐
      TabContent(){
        RecommendPage()
      }.tabBar(this.HomeTabsTitle('推荐',0))
      //大赏
      TabContent(){
        AdmirePage()
      }.tabBar(this.HomeTabsTitle('大赏',1))

      ForEach(this.classifyNavData,(item:classifyType,index)=>{
        TabContent(){
           GoodsTypePage({ catId: item.cat_id });
        }.tabBar(this.HomeTabsTitle(item.cat_name,index+2))
      })
    }
    .width('100%')
    .onChange((idx: number) => {
      this.isChoice = idx;
    })
    .barMode(BarMode.Scrollable,{margin:10})
    .barHeight(40)
  }

  @Builder HomeTabsTitle(name:string,index:number){
    Column({space:2}){
      Text(name)
        .fontSize(14)
        .fontColor(index == this.isChoice ? $r('app.color.theme_color1') : '#666')
      Divider().strokeWidth(1).color(index == this.isChoice ? $r('app.color.theme_color1') : $r('app.color.window_background')).width('8%')
    }
    .margin({right: 20})
  }
}