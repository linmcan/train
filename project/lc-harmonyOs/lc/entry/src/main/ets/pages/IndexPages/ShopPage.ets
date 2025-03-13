import { preferences } from "@kit.ArkData";
import { GoodsOrderType, GoodsShopType } from "../../type/allTypes";
import { hcHttp } from "../../utils/HttpRequest";
import { router } from "@kit.ArkUI";

@Component

export struct ShopPage{
  //token
  @State token: preferences.ValueType = '';

  @Prop @Watch('changePageNum') pageNum:number;
  changePageNum(){
    if(this.pageNum == 2){
      this.getShop()
    }
  }

  //购物车数据
  @State ShopData: GoodsShopType[]=[]

  //管理状态
  @State isGl:boolean=false

  //商品选择状态
  @State goodsIsOn:boolean[]=[]
  @State AllGoodsIsOn:boolean=false

  //总价
  @State Price:number=0

  //数量改变
  @State isNum:boolean[]=[]
  @State temporaryNum:number=-1

  //滚动监听
  scroll : Scroller = new Scroller()

  //获取用户购物车
  async getShop(ison?:boolean,ischange?:boolean){
    let httpResponse = await hcHttp.hcPost(hcHttp.BASE_URL + '/api_cart', {
      'userId': this.token.toString(),
      'status': 'viewcart'
    });
    this.ShopData=JSON.parse(httpResponse.result.toString()).data

    //首次加载才刷新
    if (ison) {
      for (let index = 0; index < this.ShopData.length; index++) {
        this.goodsIsOn.push(false)
        this.isNum.push(false)
      }
    }

    if (ischange) {
      this.allPrice()
    }
  }

  //获取token
  async getTokenHandler(){
    let AppPreferences: preferences.Preferences | undefined = AppStorage.get('AppPreferences');
    if(AppPreferences){
      this.token = AppPreferences.getSync('token', null);
    };
  }

  //计算总价方法
  async allPrice(){
    let num=0
    //所有被选中的下标
    let trueIndicesViaMap = this.goodsIsOn.map((value, index) => value ? index : -1).filter(index => index !== -1);
    await trueIndicesViaMap.forEach((item)=>{
      num += this.ShopData[item].price*Number(this.ShopData[item].goods_number)
    })

    this.Price=num
    console.log('价格：',this.Price)
  }

  //更新购物车方法
  async shopNumber(goodsId:string,goodsNumber:number){
    await hcHttp.hcPost(hcHttp.BASE_URL + '/api_cart', {
      'userId': this.token.toString(),
      'status': 'addcart',
      'goodsId':goodsId,
      'goodsNumber':goodsNumber
    });

    this.getShop(false,true)
  }

  //删除购物车方法
  async dltShop(goodsId:string,index:number){
    //删除数据
    await hcHttp.hcPost(hcHttp.BASE_URL + '/api_cart', {
      'userId': this.token.toString(),
      'status': 'delcart',
      'goodsId':goodsId,
    });

    //删除
    await this.goodsIsOn.splice(index, 1);
    await this.isNum.splice(index, 1)

    this.getShop(false,true)
  }

  //结算方法
  async PayGoods(){
    let arr:number[] = this.goodsIsOn.map((value, index) => value ? index : -1).filter(index => index !== -1);
    let result:GoodsOrderType[] = arr.map(index => {
      let obj = this.ShopData[index];
      let payData:GoodsOrderType = {
        _id:obj._id,
        goods_id:obj.goods_id,
        cat_id:obj.cat_id,
        goods_name:obj.goods_name,
        goods_desc:obj.goods_desc,
        goods_thumb:obj.goods_thumb,
        goods_number:obj.goods_number,
        star_number: obj.star_number,
        price: obj.price,
      }
      return payData;
    });

    if (result.length>0) {
      //删除选中的商品
      arr.forEach((item)=>{
        this.dltShop(this.ShopData[item].goods_id,item)
      })
      //跳转
      router.pushUrl({
        url:'pages/OtherPages/payPage',
        params:{payGoodsData:result}
      })
    }

  }

  async aboutToAppear(): Promise<void> {
      this.getTokenHandler()
      this.getShop(true)
  }

  build() {
    Column(){
      //头部
      Row(){
        Text(`购物车（${this.ShopData.length}）`).fontSize(18).fontColor(Color.White)

        Text(this.isGl?'退出管理':'管理').fontSize(18).fontColor(Color.White)
          .onClick(()=>{
            this.isGl=!this.isGl
          })
      }
      .width('100%').padding(10).backgroundColor($r('app.color.theme_color1')).justifyContent(FlexAlign.SpaceBetween)

      //滚动

      Scroll(this.scroll){
        Column(){
          if (this.ShopData.length==0){
            Column(){
              Text('暂时还没有商品..')
            }.width('100%').height('100%').justifyContent(FlexAlign.Center)
          }
          List(){
            ForEach(this.ShopData,(item:GoodsShopType,index)=>{
              ListItem(){
                Row(){
                  //选择框
                  Toggle({ type: ToggleType.Checkbox, isOn: this.goodsIsOn[index] })
                    .size({ width: 20, height: 20 })
                    .selectedColor($r('app.color.theme_color1'))
                    .onChange((isOn: boolean) => {
                      this.goodsIsOn[index]=isOn
                      this.AllGoodsIsOn = !this.goodsIsOn.some(value => value === false)

                      this.allPrice()
                    })
                    .width('10%')

                  //商品部分
                  Row({space:5}){
                    //图片
                    Image(item.goods_thumb).width('30%').aspectRatio(1).borderRadius(10)

                    //商品描述
                    Column(){
                      Row(){
                        Text(item.goods_name).fontSize(14)
                          .width('70%')
                        //商品数量
                        if (this.isNum[index]){
                          Row({space:10}){
                            Text('-').fontSize(14)
                              .onClick(()=>{
                                this.temporaryNum--
                                //刷新购物车
                                this.shopNumber(item.goods_id,this.temporaryNum)
                              })
                            Text(this.temporaryNum.toString()).fontSize(14)
                            Text('+').fontSize(14)
                              .onClick(()=>{
                                this.temporaryNum++
                                this.shopNumber(item.goods_id,this.temporaryNum)
                              })
                          }
                        }else {
                          Text(`x ${item.goods_number}`).fontSize(12).fontColor($r('app.color.font_GrayBlack'))
                            .onClick(()=>{
                              if(!this.isGl){
                                if (index >= 0 && index < this.isNum.length) {
                                  // 将选中的下标设置为 true，其他设置为 false
                                  this.isNum = this.isNum.map((_, i) => i === index);
                                }
                                this.temporaryNum=Number(item.goods_number)
                              }
                            })
                        }

                      }.width('100%').justifyContent(FlexAlign.SpaceBetween)

                      Row(){
                        Text(`￥ ${item.price}`).fontColor($r('app.color.theme_color1')).fontWeight(600)
                        if(this.isGl){
                          Image($r('app.media.dlt')).width('8%').aspectRatio(1)
                            .onClick(()=>{
                              this.dltShop(item.goods_id,index)
                            })
                        }
                      }.width('100%').justifyContent(FlexAlign.SpaceBetween)

                    }.height('90%').width('65%').alignItems(HorizontalAlign.Start).justifyContent(FlexAlign.SpaceBetween)
                  }.width('85%')
                  .onClick(()=>{
                    router.pushUrl({
                      url: 'pages/OtherPages/GoodsDetailsPage',
                      params: {goodsId:item.goods_id}
                    })
                  })
                }
                .width('100%').height('20%').padding(10)
              }
            })
          }
        }
      }.scrollBar(BarState.Off)
      .layoutWeight(1)
      //滚动监听
      .onDidScroll(() => {
        if (this.scroll.currentOffset().yOffset >= 30){
          this.isNum = this.isNum.map(() => false);
        }
      })

      //结算清单
      Row(){
        Row(){
          Toggle({ type: ToggleType.Checkbox,isOn:this.AllGoodsIsOn })
            .size({ width: 20, height: 20 })
            .selectedColor($r('app.color.theme_color1'))
            .onClick(()=>{
              this.AllGoodsIsOn = !this.AllGoodsIsOn
              for (let i = 0; i < this.goodsIsOn.length; i++) {
                this.goodsIsOn[i] = this.AllGoodsIsOn
              }
            })

          Text('全择')
        }
        if (this.isGl){
          Button('删除').backgroundColor('#d81e06')
            .onClick(()=>{
              let arr:number[] = this.goodsIsOn.map((value, index) => value ? index : -1).filter(index => index !== -1);
              AlertDialog.show({
                message:'是否删除这些商品？',
                primaryButton:{
                  value: '取消',
                  action: () => {
                  }
                },
                secondaryButton:{
                  value: '确定',
                  action: () => {
                    if(arr.length >0){
                      //删除选中的商品
                      arr.forEach((item)=>{
                        this.dltShop(this.ShopData[item].goods_id,item)
                      })
                    }
                  }
                }
              })
            })
        }else {
          Row({space:5}){
            Text('合计：')
            Text(`￥ ${this.Price}`)
            Button('结算').backgroundColor($r('app.color.theme_color1'))
              .onClick(()=>{
                this.PayGoods()
              })
          }
        }

      }
      .width('100%').padding(10).justifyContent(FlexAlign.SpaceBetween).backgroundColor(Color.White)
    }
  }
}