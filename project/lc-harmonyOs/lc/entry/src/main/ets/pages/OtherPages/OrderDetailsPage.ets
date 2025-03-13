import { router } from '@kit.ArkUI';
import { AllOrderType, GoodsOrderType } from '../../type/allTypes';

@Entry
@Component
struct OrderDetailsPage {
  @State obj: object = router.getParams();
  @State OrderData:AllOrderType=this.obj['OrderData']

  @State isMore:boolean=false


  build() {
    Column(){
      //头部
      Stack({alignContent:Alignment.Start}){
        Text('交易完成').textAlign(TextAlign.Center).width('100%')

        Image($r('app.media.back')).width('5%').aspectRatio(1)
          .onClick(()=>{
            router.back()
          })
      }
      .width('100%').padding(10).backgroundColor(Color.White)

      Scroll(){
        Column(){
          Column({space:10}){
            // 商品信息
            Column({space:10}){
              //商品列表
              ForEach(this.OrderData.goods,(item:GoodsOrderType)=>{
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
                  .onClick(()=>{
                    router.pushUrl({
                      url:'pages/OtherPages/GoodsDetailsPage',
                      params: {goodsId:item.goods_id}
                    })
                  })

                }
              })

              Divider().strokeWidth(1)
              //价格
              Column(){
                Text(`总价：￥ ${this.OrderData.allPrice}`)
              }.width('100%').alignItems(HorizontalAlign.End)

            }
            .width('100%').alignItems(HorizontalAlign.Start)

            //订单信息
            Column({space:5}){
              Row(){
                Text('订单编号').fontSize(14)

                Row({space:5}){
                  Text(this.OrderData.trade_no).fontSize(14).fontColor($r('app.color.theme_color1'))
                  Divider().strokeWidth(1).vertical(true).height(10)
                  Text('复制').fontSize(14)
                }
              }.justifyContent(FlexAlign.SpaceBetween).width('100%')

              if (!this.isMore){
                Text('查看更多订单信息..').fontSize(14).fontColor($r('app.color.theme_color1'))
                  .onClick(()=>{
                    this.isMore=true
                  })
              }else {
                //收货信息
                Row(){
                  Text('收货信息').fontSize(14)

                  Column({space:5}){
                    Text(`${this.OrderData.order_address?.takename} ${this.OrderData.order_address?.tel}`).fontSize(14).fontColor($r('app.color.theme_color1'))
                    Text(`${this.OrderData.order_address?.province} ${this.OrderData.order_address?.city} ${this.OrderData.order_address?.district}`)
                      .fontSize(14).fontColor($r('app.color.theme_color1'))
                    Text(`${this.OrderData.order_address?.streetname}`).fontSize(14).fontColor($r('app.color.theme_color1'))
                  }.width('60%').alignItems(HorizontalAlign.End)
                }.justifyContent(FlexAlign.SpaceBetween).width('100%')
              }
            }.alignItems(HorizontalAlign.Start)
          }
          .width('100%').padding(10)
        }

      }

    }
  }
}