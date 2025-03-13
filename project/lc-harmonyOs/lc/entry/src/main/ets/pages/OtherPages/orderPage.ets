import { preferences } from '@kit.ArkData';
import { AllOrderType, GoodsOrderType } from '../../type/allTypes';
import { hcHttp } from '../../utils/HttpRequest';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct OrderPage {
  //token
  @State token: preferences.ValueType = '';
  @State AppPreferences: preferences.Preferences | undefined = undefined

  @State obj: object = router.getParams();
  @State isChoice: number = this.obj['isChoice'];

  @State tabTitle:string[]=['全部订单','未完成订单','已完成订单']

  //数据库订单
  @State AllOrderData:AllOrderType[]=[]
  @State isOrderData:AllOrderType[]=[]

  //首选项订单
  @State PFCAllOrderData:AllOrderType[]=[]
  @State PFCisOrderData:AllOrderType[]=[]

  getTokenHandler(){
    this.AppPreferences = AppStorage.get('AppPreferences');
    if(this.AppPreferences){
      this.token = this.AppPreferences.getSync('token', null);
      //获取首选项订单数据
      this.PFCAllOrderData = this.AppPreferences.getSync(`payData${this.token}`,null) as AllOrderType[]
    };
  }

  //获取用户订单
  async getOrder(){
      let httpResponse = await hcHttp.hcPost(hcHttp.BASE_URL + '/api_order', {
        'userId': this.token.toString(),
        'status': 'vieworder'
      });

      //处理数据库订单数据
    this.AllOrderData=JSON.parse(httpResponse.result.toString()).data
    for (let i = 0; i < this.AllOrderData.length; i++) {
      if (this.AllOrderData[i].goods) {
        for (let j = 0; j < this.AllOrderData[i].goods.length; j++) {
          let add = 0
          add += Number(this.AllOrderData[i].goods[j].price) * Number(this.AllOrderData[i].goods[j].goods_number)
          this.AllOrderData[i].allPrice = add
        }
      }
    }


    this.OrderStatus(this.isChoice)
  }
  //订单状态
  async OrderStatus(Type:number){
    switch (Type){
      case 0:
        this.isOrderData=this.AllOrderData
        this.PFCisOrderData = this.PFCAllOrderData
        break;
      case 1:
        this.isOrderData=this.AllOrderData.filter(item => item.status === '未支付');
        this.PFCisOrderData = this.PFCAllOrderData.filter(item => item.status === '未支付');
        break;
      case 2:
        this.isOrderData=this.AllOrderData.filter(item => item.status === '支付成功');
        this.PFCisOrderData = this.PFCAllOrderData.filter(item => item.status === '支付成功');
        break;
    }
    return this.isOrderData
  }

  //删除数据库的订单方法
  async DltOrder(tradeNo:string){
    await hcHttp.hcPost(hcHttp.BASE_URL + '/api_order', {
      'userId': this.token.toString(),
      'status': 'delorder',
      'tradeNo':tradeNo
    });

    this.getOrder()
  }

  //删除首选项订单方法
  DltPFCOrder(OrderIdx:number){
    //处理数据
    if (this.isChoice == 0) {
      this.PFCAllOrderData.splice(OrderIdx,1)
      this.AppPreferences?.putSync(`payData${this.token}`,this.PFCAllOrderData)
      this.AppPreferences?.flush()
    }else {
      let isDlt = this.PFCisOrderData.splice(OrderIdx,1)

      let filteredItems = this.PFCAllOrderData.filter(item => item.trade_no !== isDlt[0].trade_no);

      this.AppPreferences?.putSync(`payData${this.token}`,filteredItems)
      this.AppPreferences?.flush()
    }
  }

  async aboutToAppear() {
    //获取当前用户的 token
    this.getTokenHandler();
    //获取总数据
    this.getOrder()
  };

  build() {
    Column(){
      //头部
      Stack({alignContent:Alignment.Start}){
        Text('我的订单').textAlign(TextAlign.Center).width('100%')

        Image($r('app.media.back')).width('5%').aspectRatio(1)
          .onClick(()=>{
            router.back()
          })
      }
      .width('100%').padding(10).backgroundColor(Color.White)

      //tab
      this.OrderTab()
    }
  }

  @Builder OrderTab(){
    Tabs({index:this.isChoice}){
      ForEach(this.tabTitle,(item:string,index)=>{
        TabContent(){
          this.DataList()
        }
        .tabBar(this.TabsTitle(item,index))
      })
    }
    .width('100%')
    .onChange((idx: number) => {
      this.isChoice = idx;
      this.OrderStatus(idx)
    })
    .barHeight(40)
  }

  @Builder TabsTitle(name:string,index:number){
    Column({space:2}){
      Text(name)
        .fontSize(14)
        .fontColor(index == this.isChoice ? $r('app.color.theme_color1') : '#666')
      Divider().strokeWidth(1).color(index == this.isChoice ? $r('app.color.theme_color1') : $r('app.color.window_background')).width('8%')
    }
    .margin({right: 20})
  }

  @Builder DataList(){
    Column(){
      Column(){
        Row({space:10}){
          Image($r('app.media.ic_search'))
            .width('6%')
            .aspectRatio(1)

          Text('搜索订单')
            .fontSize(14)
            .fontColor($r('app.color.font_GrayBlack'))
        }
        .padding(10)
        .borderRadius(20)
        .backgroundColor($r('app.color.window_background'))
        .width('95%')
      }
      .padding({ top:10,bottom:10 })
      .backgroundColor(Color.White)
      .width('100%')
      .onClick(()=>{
        let searchData:AllOrderType[]=[]
        if (this.isChoice == 0) {
          searchData=this.AllOrderData.concat(this.PFCAllOrderData)
        }else {
          searchData=this.isOrderData.concat(this.PFCisOrderData)
        }
        router.pushUrl({
          url: 'pages/OtherPages/OrderSearchPage',
          params:{AllData:searchData}
        })
      })

      if (this.isOrderData.length == 0 || this.PFCisOrderData.length==0){
        Column(){
          Text('暂时还没有订单..')
        }.width('100%').height('100%').justifyContent(FlexAlign.Center)
      }


      List({space:10}){
        ForEach(this.isOrderData,(item:AllOrderType)=>{
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
                  Text('删除订单').fontSize(14).fontColor($r('app.color.font_GrayBlack'))
                    .onClick(()=>{
                      AlertDialog.show({
                        message:'是否删除订单',
                        primaryButton:{
                          value: '取消',
                          action: () => {
                          }
                        },
                        secondaryButton:{
                          value: '确定',
                          action: () => {
                            this.DltOrder(item.trade_no)
                          }
                        }
                      })
                    })
                  Text(`总价：￥ ${item.allPrice}`)
              }.width('100%').justifyContent(FlexAlign.SpaceBetween)


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
        ForEach(this.PFCisOrderData,(item:AllOrderType,index)=>{
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
                Text('删除订单').fontSize(14).fontColor($r('app.color.font_GrayBlack'))
                  .onClick(()=>{
                    AlertDialog.show({
                      message:'是否删除订单',
                      primaryButton:{
                        value: '取消',
                        action: () => {
                        }
                      },
                      secondaryButton:{
                        value: '确定',
                        action: () => {
                          this.DltPFCOrder(index)
                        }
                      }
                    })
                  })
                Text(`总价：￥ ${item.allPrice}`)
              }.width('100%').justifyContent(FlexAlign.SpaceBetween)


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
      }.scrollBar(BarState.Off).margin({bottom:10})
      .layoutWeight(1)
    }
    .backgroundColor($r('app.color.window_background'))

  }
}