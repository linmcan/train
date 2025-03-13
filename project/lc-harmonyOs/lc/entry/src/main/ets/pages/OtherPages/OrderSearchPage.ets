import { router } from '@kit.ArkUI';
import { AllOrderType, GoodsOrderType } from '../../type/allTypes';

@Entry
@Component
struct OrderSearchPage {
  @State message: string = 'Hello World';

  @State obj: object = router.getParams();
  @State AllData: AllOrderType[] = this.obj['AllData'];

  @State SearchData:AllOrderType[]=[]
  @State SearchInput:string=''
  build() {
    Column(){
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

          TextInput({placeholder:'输入订单编号'})
            .width('80%')
            .caretColor($r('app.color.theme_color1'))
            .backgroundColor('#eaeaea')
            .onChange((value:string)=>{
              this.SearchInput=value
            })
            .onSubmit(()=>{
                this.SearchData = this.AllData.filter(item => String(item.trade_no).includes(this.SearchInput));
            })
        }
        .padding({ left:10,right:10 })
        .borderRadius(20)
        .backgroundColor('#eaeaea')
        .width('75%')

        Text('搜索').fontSize(18).fontColor($r('app.color.theme_color1'))
          .onClick(()=>{
            this.SearchData = this.AllData.filter(item => String(item.trade_no).includes(this.SearchInput));
          })
      }
      .backgroundColor(Color.White)
      .padding(10)
      .width('100%')
      .height('8%')
      .justifyContent(FlexAlign.SpaceBetween)

      if (this.SearchData.length == 0){
        Column(){
          Text('什么都没有...').fontSize(20)
        }.padding({top:100})
      }
      List(){
        ForEach(this.SearchData,(item:AllOrderType)=>{
          ListItem(){
            Column({space:10}){
              //订单编号
              Text(`订单编号 ${item.trade_no}`).fontSize(14).fontColor($r('app.color.font_GrayBlack'))
              //商品列表
              ForEach(item.goods,(item:GoodsOrderType)=>{
                Column(){
                  //商品
                  Row(){
                    Row({space:5}){
                      Image(item.goods_thumb).width('30%').aspectRatio(1)
                      Text(item.goods_name).fontSize(12).maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis })
                    }
                    .width('60%').justifyContent(FlexAlign.Start).alignItems(VerticalAlign.Top)

                    Column({space:3}){
                      Text(`￥${item.price}`).fontSize(14)
                      Text(`x${item.goods_number}`).fontSize(12)
                    }
                  }
                  .width('100%').justifyContent(FlexAlign.SpaceBetween).padding({top:10,bottom:10}).alignItems(VerticalAlign.Top)

                }
              })

              Divider().strokeWidth(1)
              //价格
              Row(){
                Text(`总价：￥ ${item.allPrice}`)
              }.width('100%').justifyContent(FlexAlign.End)
            }
            .width('100%').alignItems(HorizontalAlign.Start)
            .onClick(()=>{
              //跳转到订单详细页
              router.pushUrl({
                url:'pages/OtherPages/OrderDetailsPage',
                params:{OrderData:item}
              })
            })
          }.backgroundColor(Color.White).padding(10)
        })

      }
      .scrollBar(BarState.Off).margin({bottom:10}).layoutWeight(1)
    }
  }
}