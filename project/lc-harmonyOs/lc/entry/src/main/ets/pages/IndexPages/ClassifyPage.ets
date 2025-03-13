import { getSmallClassifyData } from "../../api/GoodsApi"
import { DetailedClassify, detailedData } from "../../type/allTypes"
import { LengthMetrics, router } from "@kit.ArkUI"

@Component

export struct ClassifyPage{
  @State allData:DetailedClassify[]|undefined=[]
  @State isChoice:number=0

  async aboutToAppear(){
    this.allData = await getSmallClassifyData('/api_classify')
  }

  build() {
    Column(){
      Tabs(){
        ForEach(this.allData,(item:DetailedClassify,index:number)=>{
          TabContent(){
            this.Content(item.title_img,item.data,item.title.substring(0, 2),item.cat_id)
          }.tabBar(this.tabTitle(item.title,index))
        })

      }
      .vertical(true).barWidth('25%').divider({strokeWidth:1,color:'#dadada'})
      .barMode(BarMode.Scrollable)
      .onChange((idx: number) => {
        this.isChoice = idx;
      })


    }
  }

  @Builder tabTitle(str:string,index:number){
    Row(){
      Column(){
        Text(str.substring(0, 2)).fontColor(index == this.isChoice ? $r('app.color.theme_color1') : '#666')
      }.border({width:{left:2},color:index == this.isChoice ? $r('app.color.theme_color1') : $r('app.color.window_background')})
      .width('100%')
    }
    .height('10%')
    .width('90%')
  }

  @Builder Content(img:string,data:detailedData[],typeName:string,typeId:string){
    Scroll(){
      Column({space:20}){
        Image(img).width('100%').borderRadius(10)

        Text('分类').fontSize(20).fontWeight(600)

        Flex({wrap:FlexWrap.Wrap, space: {main:LengthMetrics.px(30), cross: LengthMetrics.px(40)}}){
          ForEach(data,(item:detailedData)=>{
            Column(){
              Image(item.product_img).width('100%').aspectRatio(1)
              Text(item.product_content).fontSize(14)
            }
            .padding(5)
            .backgroundColor(Color.White).borderRadius(10)
            .width('30%')
            .height('15%')
            .onClick(()=>{
              router.pushUrl({
                url: 'pages/OtherPages/ClassifyGoodsPage',
                params:{typeName:typeName,typeId:typeId,classifyId:item.id}
              })
            })
          })
        }

      }
      .alignItems(HorizontalAlign.Start)
      .constraintSize({minHeight:'100%'})
      .padding({ left:10,right:10,top:20,bottom:20})
      .width('100%')

    }

    .scrollBar(BarState.Off)


  }
}