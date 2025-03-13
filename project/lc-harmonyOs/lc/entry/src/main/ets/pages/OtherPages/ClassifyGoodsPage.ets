import { router } from '@kit.ArkUI';
import { getSmallClassifyData } from '../../api/GoodsApi';
import { DetailedClassify, detailedData } from '../../type/allTypes';
import { GoodsListPage } from './basePage/GoodsListPage';

@Entry
@Component
struct ClassifyGoodsPage {
  @State obj: object = router.getParams();
  @State nowTypeName: string = this.obj['typeName'];
  @State nowTypeId: string = this.obj['typeId'];
  @State nowClassifyId: number = this.obj['classifyId'];

  //分类列表
  @State thisData:detailedData[]|undefined=[]

  @State isChoice:number=1



  async aboutToAppear(){
    //获取小分类
    let allData:DetailedClassify[]|undefined = await getSmallClassifyData('/api_classify');
    if (allData) {
      this.thisData = allData.find(item => item.cat_id == this.nowTypeId)?.data
    }

  }

  build() {
    Column(){
      //头部
      Stack({alignContent:Alignment.Start}){
        Column(){
          Text(this.nowTypeName).fontSize(20).fontColor(Color.White)
        }
        .width('100%')

        Image($r('app.media.back'))
          .height('40%').aspectRatio(1)
          .onClick(()=>{
            router.back()
          })
      }
      .backgroundColor($r('app.color.theme_color1'))
      .padding({left:10,right:10,top:5,bottom:5})
      .width('100%')
      .height('8%')

      Scroll(){
        this.TabsTitle(this.nowClassifyId-1)
      }
    }
    .width('100%')
  }

  @Builder TabsTitle(page:number){
    Tabs({index:page}){
      ForEach(this.thisData,(item:detailedData)=>{
        TabContent(){
          GoodsListPage({nowTypeId:this.nowTypeId})
        }.tabBar(this.TabsTitleStyle(item.product_content,item.id))
      })

    }
    .barWidth('95%')
    .barMode(BarMode.Scrollable,{margin:10,nonScrollableLayoutStyle:LayoutStyle.ALWAYS_AVERAGE_SPLIT})
    .onChange((idx: number) => {
      this.isChoice = idx+1;
    })
    .barMode(BarMode.Scrollable)
  }

  @Builder TabsTitleStyle(name:string,index:number){
    Column({space:2}){
      Text(name)
        .fontSize(14)
        .fontColor(index == this.isChoice ? $r('app.color.theme_color1') : '#666')
      Divider().strokeWidth(1).color(index == this.isChoice ? $r('app.color.theme_color1') : $r('app.color.window_background')).width('8%')
    }
    .margin({right: 20})
  }
}