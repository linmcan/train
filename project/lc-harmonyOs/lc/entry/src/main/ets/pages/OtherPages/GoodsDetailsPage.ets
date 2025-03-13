import { promptAction, router } from '@kit.ArkUI';
import { getGoodsDetails } from '../../api/GoodsApi';
import { AddressType, AllOrderType, GoodsDetailsData, GoodsOrderType, GoodsShopType } from '../../type/allTypes';
import { preferences } from '@kit.ArkData';
import { hcHttp } from '../../utils/HttpRequest';
import { baseAddressPage } from './basePage/baseAddressPage';

@Entry
@Component
struct GoodsDetailsPage {
  //token
  @State token: preferences.ValueType = '';
  //获取首选项的实例
  @State AppPreferences: preferences.Preferences | undefined = undefined;

  //传过来的商品
  @State obj: object = router.getParams();
  @State nowGoodsId: string = this.obj['goodsId'];

  //商品信息
  @State goodsData:GoodsDetailsData={}

  //购物车数量
  @State shopNum:number=1
  //用户当前地址
  @State AddressData:AddressType|undefined={}

  //弹窗控制
  @State isAmend:boolean=false
  //加车/购买
  @State isAdd:string=''
  //地址弹窗控制
  @State isAddress:boolean=false

  //支付弹窗控制
  @State isPay:boolean=false
  @State allPrice:number=0
  //密码
  @State isPassword:boolean[]=[false,false,false,false,false,false]
  @State inputPassword:string=''
  @State userPassword:preferences.ValueType=''

  //输入键盘
  @State isNum:string[]=[
    '1','2','3',
    '4','5','6',
    '7','8','9',
    '','0',
  ]

  //支付中遮罩
  @State isPaying:boolean=false

  //加入商品数量
  @State addGoodsNum:number=1

  //滚动监听
  scroll : Scroller = new Scroller()
  @State scrollTopVal: number = 0;

  //获取用户
  async getTokenHandler(){
    this.AppPreferences = AppStorage.get('AppPreferences');
    if(this.AppPreferences){
      this.token = this.AppPreferences.getSync('token', null);
      this.userPassword = this.AppPreferences.getSync('payPassword',null)
    };
  }
  //获取购物车数量
  async getShop(){
    let httpResponse = await hcHttp.hcPost(hcHttp.BASE_URL + '/api_cart', {
      'userId': this.token.toString(),
      'status': 'viewcart'
    });
    let ShopData: GoodsShopType[]=JSON.parse(httpResponse.result.toString()).data

    this.AppPreferences?.putSync('ShopLength', ShopData.length);
    this.AppPreferences?.flush();

    this.shopNum = ShopData.length
  }

  //获取当前选择的地址
  async getAddressList(isChangeAddress?:boolean){
    //请求数据接口
    let httpResponse = await hcHttp.hcPost(hcHttp.BASE_URL + '/api_address', {
      'status': 'getAddress',
      'userId':this.token.toString()
    });

    //获取总地址
    let originData:AddressType[] = await JSON.parse(httpResponse.result.toString()).data;

    //第一次调用当前地址为默认地址,没有默认地址就用第一个
    if (!isChangeAddress) {
      this.AddressData=originData.find(obj => obj.isDefault === true);
      if (this.AddressData == undefined) {
        this.AddressData=originData[0]
      }
    }

    //获取首选项的当前地址ID
    if(this.AppPreferences && isChangeAddress){
      let AddressID : preferences.ValueType=this.AppPreferences.getSync('ActiveAddressId', null);
      //筛选指定id的data内容
      this.AddressData=originData.find(obj => obj.address_id === AddressID);
    }
  }

  //加入购物车方法
  async AddShop(){
    if (this.goodsData.goods_id) {
      await hcHttp.hcPost(hcHttp.BASE_URL + '/api_cart', {
        'userId': this.token.toString(),
        'status': 'addcart',
        'goodsId':this.goodsData.goods_id,
        'goodsNumber': this.addGoodsNum
      });
    }
  }

  //支付订单
  getOrder(isPay:boolean){
    let dateTime = new Date()
    this.allPrice = Number(this.goodsData.price)*this.addGoodsNum
    let goods:GoodsOrderType[]=[]
    if (this.goodsData.banner) {
      goods =[
        {  _id:this.goodsData._id,
          goods_id:this.goodsData.goods_id,
          cat_id: this.goodsData.cat_id,
          goods_name: this.goodsData.goods_name,
          goods_thumb:String(this.goodsData.banner[0]),
          goods_number:this.goodsData.goods_number,
          star_number: this.goodsData.star_number,
          price: Number(this.goodsData.price), }
      ]
    }
    let Order:AllOrderType={
      _id:'12345678999',
      order_address:this.AddressData,
      status:isPay ? '支付成功':'未支付',
      trade_no:dateTime.getTime().toString(),
      allPrice:this.allPrice,
      goods:goods,
    }
    return Order;
  }



  //获取商品详细数据
   async aboutToAppear(){
    let origin =  await getGoodsDetails('/api_goods',{'goodsId':this.nowGoodsId})
     if (origin){
       this.goodsData=origin[0]
     }

     //获取首选项
     this.getTokenHandler()
     //显示购物车数量
     if (this.token) {
       this.getShop()
     }

     this.getAddressList()

  }

  build() {

    Stack(){
      //页面主体
      Column() {
        //滚动后的搜索框
        if (this.scrollTopVal >= 300){
          Stack({ alignContent: Alignment.Start }) {
            Row() {
              Text('商品详细')
            }.width('100%').justifyContent(FlexAlign.Center)

            Image($r('app.media.back')).width('5%').aspectRatio(1)
              .onClick(() => {
                router.back()
              })
          }.width('100%').padding(10).backgroundColor(Color.White)
        }

        //商品详细
        this.scrollDetailBuilder()

        //底部购买按钮
        Row(){

          Row({space:15}){
            //客服 店铺 收藏
            Column({space:3}){
              Image($r('app.media.kf')).width('5%').aspectRatio(1)
              Text('客服').fontSize(12)
            }
            Column({space:3}){
              Image($r('app.media.dp')).width('5%').aspectRatio(1)
              Text('店铺').fontSize(12)
            }
            Column({space:3}){
              Image($r('app.media.sc')).width('5%').aspectRatio(1)
              Text('收藏').fontSize(12)
            }
          }

          Row(){
            Text('加入购物车')
              .padding(10).backgroundColor($r('app.color.theme_color1')).fontColor(Color.White)
              .fontSize(14).borderRadius({topLeft:10,bottomLeft:10})
              .onClick(()=>{
                if (this.token) {
                  this.isAmend=true
                  this.isAdd='加入购物车'
                }else {
                  router.replaceUrl({
                    url:'pages/loginPage',
                    params:{goodsId:this.goodsData.goods_id}
                  })
                }
              })
              .bindSheet($$this.isAmend, this.isBuy(),{
                height:'80%',
                showClose:false,
              })
            Text('立即购买')
              .padding(10).backgroundColor($r('app.color.theme_color2'))
              .fontColor(Color.White).fontSize(14).borderRadius({topRight:10,bottomRight:10})
              .onClick(()=>{
                if (this.token) {
                  this.isAmend=true
                  this.isAdd='立即购买'
                }else {
                  router.replaceUrl({
                    url:'pages/loginPage',
                    params:{goodsId:this.goodsData.goods_id}
                  })
                }
              })
              .bindSheet($$this.isAmend, this.isBuy(),{
                height:'80%',
                showClose:false,
              })
          }
        }
        .width('100%').padding(10).backgroundColor(Color.White).justifyContent(FlexAlign.SpaceBetween)
      }
      .backgroundColor($r('app.color.window_background'))
      .height('100%')
      .width('100%')

      if (this.isPaying){
        Column(){
          Column(){
            Text('支付中..').fontColor(Color.White)
          }.width('30%').aspectRatio(1).borderRadius(10).backgroundColor('#ff7a7a7a').justifyContent(FlexAlign.Center)
        }.width('100%').height('100%').backgroundColor('#57000000').justifyContent(FlexAlign.Center)
      }
    }


  }
  //详情的滚动容器
  @Builder scrollDetailBuilder(){
    Scroll(this.scroll){
      Column(){
        //轮播图
        Stack({alignContent:Alignment.Top}){
          Swiper(){
            ForEach(this.goodsData.banner,(item:string)=>{
              Image(item).width('100%').aspectRatio(1).objectFit(ImageFit.Cover)
            })
          }
          .width('100%').aspectRatio(1)
          .autoPlay(true)
          .indicator(Indicator.dot()
            .selectedColor($r('app.color.theme_color1'))
            .color(Color.White))

          Row(){
            Image($r('app.media.back_fff')).ImgStyles()
              .onClick(()=>{
                router.back()
              })

              Badge({
                count: this.shopNum,
                position: BadgePosition.RightTop,
                style: { badgeSize: 14, badgeColor: '#FA2A2D' }
              }){
                Image($r('app.media.cart_fff')).ImgStyles()
                  .onClick(()=>{
                    router.pushUrl({
                      url:'pages/Index',
                      params:{pageNum:2}
                    })
                  })
              }
          }.width('100%').padding(10).justifyContent(FlexAlign.SpaceBetween)
        }


        //商品信息
        Column({space:10}){
          //价格、收藏
          Row(){
            Text(`￥${this.goodsData.price?.toString()}`).fontSize(20).fontColor($r('app.color.theme_color1'))
            Text(`收藏数${this.goodsData.star_number}`).fontSize(14).fontColor($r('app.color.font_GrayBlack'))
          }.width('100%').justifyContent(FlexAlign.SpaceBetween)

          //商品名
          Text(this.goodsData.goods_name).fontSize(22).width('100%')

          //服务保障
          Row(){
            Row({space:5}){
              Image($r('app.media.like')).width('5%').aspectRatio(1)
              Text('七天无理由退换货').fontSize(14).fontColor($r('app.color.font_GrayBlack'))
              Text('运费险保障').fontSize(14).fontColor($r('app.color.font_GrayBlack'))
            }
            Image($r('app.media.go')).width('5%').aspectRatio(1)
          }.width('100%').justifyContent(FlexAlign.SpaceBetween)

          //款式
          Row(){
            Row({space:5}){
              ForEach(this.goodsData.banner,(item:string,index:number)=>{
                if (index<=6) {
                  Image(item).width('10%').aspectRatio(1)
                }
              })
            }
            Image($r('app.media.go')).width('5%').aspectRatio(1)
          }.width('100%').justifyContent(FlexAlign.SpaceBetween)

        }.width('100%').padding(10).backgroundColor(Color.White)

        //店铺
        Row(){
          Row({space:10}){
            if (this.goodsData.banner){
              Image(this.goodsData.banner[0]).width('15%').aspectRatio(1).borderRadius(10)
            }
            Column({space:5}){
              Text(this.goodsData.brand_name)
              Text(`商品好评率${Math.floor(Math.random() * 10) + 90}%`).fontSize(14).fontColor($r('app.color.font_GrayBlack'))
            }.alignItems(HorizontalAlign.Start)

          }

          Text('+ 关注')
            .padding(5).backgroundColor($r('app.color.theme_color1')).fontSize(14)
            .fontColor(Color.White).borderRadius(5)
        }.width('100%').padding(10).backgroundColor(Color.White).justifyContent(FlexAlign.SpaceBetween).margin({top:10})

        //商品详细
        Column({space:10}){
          Text('商品详细').fontSize(24).width('100%')
          Divider().strokeWidth(1)
          Column({space:5}){
            ForEach(this.goodsData.lc_recommend,(item:string,index:number)=>{
              if (index+1 == this.goodsData.lc_recommend?.length) {
                Text(item).fontSize(14).lineHeight(20)
              }

            })
          }
          ForEach(this.goodsData.product_banner,(item:string)=>{
            Image(item).width('100%')
          })
        }.width('100%').padding(10).backgroundColor(Color.White).margin({top:10})

        //猜你喜欢推荐
      }
    }.layoutWeight(1).scrollBar(BarState.Off)
    //滚动监听
    .onDidScroll(() => {
      this.scrollTopVal = this.scroll.currentOffset().yOffset;
    })
  }

  //弹窗
  @Builder isBuy(){
    Column(){
      //关闭按钮
      Row(){Text('X').onClick(()=>{this.isAmend=false})}.width('100%').justifyContent(FlexAlign.End)
      //地址列表
      Row(){
        Row({space:10}){
          Image($r('app.media.address')).width('5%').aspectRatio(1)
          Text(`${this.AddressData?.takename} ${this.AddressData?.streetname}`).fontSize(18)
        }
        Image($r('app.media.go')).width('5%').aspectRatio(1)
      }.width('100%').padding(10).justifyContent(FlexAlign.SpaceBetween)
      .onClick(()=>{
          this.isAddress=true
      })
      .bindSheet($$this.isAddress, this.address(),{
        height:'70%',
        showClose:false,
      })

      Divider().strokeWidth(1)

      //商品信息
      Column(){
        Row({space:10}){
          if (this.goodsData.banner){
            Image(this.goodsData.banner[0]).width('35%').aspectRatio(1).borderRadius(20)
          }
          Column({space:5}){
            Text(`￥ ${this.goodsData.price}`).fontSize(20).fontWeight(600).fontColor($r('app.color.theme_color1'))
            Counter() {
              Text(this.addGoodsNum.toString())
            }
            .onInc(() => {
              this.addGoodsNum++
            })
            .onDec(() => {
              this.addGoodsNum = this.addGoodsNum > 1 ? this.addGoodsNum - 1 : 1;
            })
          }.alignItems(HorizontalAlign.Start)
        }.width('100%')
      }.padding(10).layoutWeight(1)

      Button(this.isAdd).width('80%').padding(10).backgroundColor($r('app.color.theme_color1'))
        .onClick(()=>{
          if (this.isAdd=='加入购物车') {
            //加入购物车
            this.AddShop()
            //更新购物车数量
            this.getShop()
            promptAction.showToast({
              message: '加入购物车成功'
            })
            this.isAmend=false
          }
          else {
            this.isPay=true
          }
        })
        .bindSheet($$this.isPay, this.zf(),{
          height:'70%',
          showClose:false,
        })
    }
    .width('100%').padding(20)
  }

  //地址弹窗
  @Builder address(){
    Column(){
      //头部
      Stack({alignContent:Alignment.End}){
        Row(){
          Text('选择地址')
        }.width('100%').justifyContent(FlexAlign.Center)
        Text('X').onClick(()=>{this.isAddress=false})
      }.width('100%').padding(10)
      Scroll(){
        baseAddressPage({fromDetails:true})
      }.scrollBar(BarState.Off).layoutWeight(1)
     Button('确定').width('80%').backgroundColor($r('app.color.theme_color1')).padding(5)
       .onClick(()=>{
       //调用方法
       this.getAddressList(true)
       //关闭地址页
       this.isAddress=false
     })
    }
    .width('100%').padding(20).backgroundColor(Color.White)
  }

  //立即购买弹窗
  //支付弹窗
  @Builder zf(){
    Column({space:10}){
      //头部
      Row(){
        Text('X').fontSize(18).onClick(()=>{this.isPay=false})
        Text('使用指纹').fontColor("#ff475296")
      }.width('100%').justifyContent(FlexAlign.SpaceBetween)
      //支付信息
      Column(){
        Column({space:10}){
          Text('商家收款').fontSize(18)
          Text(`￥${Number(this.goodsData.price) * this.addGoodsNum}.00`).fontWeight(700).fontSize(30)
          Divider().strokeWidth(1).color('#eaeaea')
        }.width('100%')
      }
      //付款方式
      Column({space:5}){
        Text('付款方式').fontSize(14).fontColor($r('app.color.font_GrayBlack'))
        Row(){
          Row({space:10}){
            Image($r('app.media.lqian')).width('7%')
            Text('零钱').fontColor($r('app.color.font_GrayBlack'))
          }
          Text('√').fontSize(20).fontColor(Color.Green)
        }.width('100%').justifyContent(FlexAlign.SpaceBetween).backgroundColor('#c6ffe58b').padding(10).borderRadius(10)
      }.alignItems(HorizontalAlign.Start)

      //密码
      Column({space:20}){
        //密码框
        Row({space:10}){
          ForEach([0,1,2,3,4,5],(item:number)=>{
            Column(){
              if (this.isPassword[item]) {
                Image($r('app.media.dot')).width(10).aspectRatio(1)
              }
            }.width(40).aspectRatio(1).backgroundColor('#ffd7d7d7').borderRadius(10).justifyContent(FlexAlign.Center)
          })
        }

        //输入框
        Flex({wrap:FlexWrap.Wrap,justifyContent:FlexAlign.SpaceBetween}){
          ForEach(this.isNum,(item:string)=>{
            Column(){
              Text(item).fontSize(26)
            }.width('30%').height('25%').justifyContent(FlexAlign.Center)
            .onClick(()=>{
              if (item != '') {
                this.inputPassword += item
                this.isPassword[this.inputPassword.length-1] = true
                console.log('点击密码',this.inputPassword,this.isPassword)
                if (this.inputPassword.length == 6) {
                  if (this.inputPassword == this.userPassword) {
                    console.log('密码正确')

                    //订单数据
                    let formerData: AllOrderType[] = this.AppPreferences?.getSync(`payData${this.token}`,null) as AllOrderType[]
                    if (formerData == null) {
                      formerData=[]
                    }
                    let payData:AllOrderType=this.getOrder(true)
                    formerData.push(payData)

                    this.AppPreferences?.putSync(`payData${this.token}`,formerData)
                    this.AppPreferences?.flush()

                    //关闭弹窗，显示支付中，延时跳转（销毁）到支付成功页面
                    this.isPay=false
                    this.isAmend=false
                    this.isPaying=true

                    setTimeout(()=>{
                      this.isPaying=false
                      router.replaceUrl({
                        url:'pages/OtherPages/PaySucessPage',
                        params:{payNum:this.allPrice}
                      })
                    },2000)

                  }else {
                    AlertDialog.show({
                      message:'密码错误',
                      primaryButton: {
                        value: '忘记密码',
                        action: () => {
                          router.pushUrl({
                            url:'pages/OtherPages/PayPasswordPage'
                          })
                        }
                      },
                      secondaryButton:{
                        value:'重新输入',
                        action:()=>{
                          this.inputPassword=''
                          this.isPassword=[false,false,false,false,false,false]
                        }
                      }

                    })
                  }
                }
              }
            })
          })
          Column(){
            Image($r('app.media.dltNum')).width('25%')
          }.width('30%').height('25%').justifyContent(FlexAlign.Center)
          .onClick(()=>{
            this.inputPassword = this.inputPassword.slice(0,this.inputPassword.length-1)
            this.isPassword[this.inputPassword.length] = false
          })
        }.height('80%')

      }.layoutWeight(1)
    }.width('100%').padding(20).backgroundColor(Color.White)
  }

  @Styles ImgStyles(){
    .width('8%').aspectRatio(1).backgroundColor(Color.Gray).padding(5).borderRadius(8).opacity(0.7)
  }


}