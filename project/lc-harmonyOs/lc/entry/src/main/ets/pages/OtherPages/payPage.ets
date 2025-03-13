import { router } from '@kit.ArkUI';
import { AddressType, AllOrderType, GoodsOrderType} from '../../type/allTypes';
import { hcHttp } from '../../utils/HttpRequest';
import { preferences } from '@kit.ArkData';
import { baseAddressPage } from './basePage/baseAddressPage';

@Entry
@Component
struct PayPage {
  //token
  @State token: preferences.ValueType = '';
  //获取首选项的实例
  @State AppPreferences: preferences.Preferences | undefined = undefined;

  //用户当前地址
  @State AddressData:AddressType|undefined={}
  //地址弹窗控制
  @State isAddress:boolean=false
  //支付弹窗控制
  @State isPay:boolean=false

  //订单
  @State obj: object = router.getParams();
  @State payGoodsData:GoodsOrderType[]=this.obj['payGoodsData']
  @State payGoodsDataNum:number[]=[]

  //总价
  @State allPrice:number=0

  //支付方式
  @State isPayWx:boolean=true
  @State isPayZfb:boolean=false

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

  //获取用户
  async getTokenHandler(){
    this.AppPreferences = AppStorage.get('AppPreferences');
    if(this.AppPreferences){
      this.token = this.AppPreferences.getSync('token', null);
      //获取支付密码
      this.userPassword=this.AppPreferences?.getSync('payPassword',null)
    };
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

    //第一次调用当前地址为默认地址
    if (!isChangeAddress) {
      this.AddressData = originData.find(obj => obj.isDefault === true);
    }


    //获取首选项的当前地址ID
    if(this.AppPreferences && isChangeAddress){
      let AddressID : preferences.ValueType=this.AppPreferences.getSync('ActiveAddressId', null);
      //筛选指定id的data内容
      this.AddressData=originData.find(obj => obj.address_id === AddressID);

      console.log('调用了2')
    }
  }
  //总价方法
  async getAllPrice(){
    let num:number = 0
    for (let i = 0; i < this.payGoodsData.length; i++) {
        num += this.payGoodsData[i].price * this.payGoodsDataNum[i]
    }
    this.allPrice=num
  }

  //生成订单
  getOrder(isPay:boolean){
    let dateTime = new Date()
    let Order:AllOrderType={
      _id:'12345678999',
      order_address:this.AddressData,
      status:isPay ? '支付成功':'未支付',
      trade_no:dateTime.getTime().toString(),
      allPrice:this.allPrice,
      goods:this.payGoodsData,
    }
    return Order;
  }


  async aboutToAppear(){
    this.getTokenHandler()
    this.getAddressList(false)
    for (let index = 0; index < this.payGoodsData.length; index++) {
      this.payGoodsDataNum.push(Number(this.payGoodsData[index].goods_number))
    }
    this.getAllPrice()


  }

  build() {
    Stack(){
      Column(){
        //头部
        Stack({alignContent:Alignment.Start}){
          Row(){
            Text('支付页面')
          }.width('100%').justifyContent(FlexAlign.Center)

          Image($r('app.media.back')).width('5%').aspectRatio(1)
            .onClick(()=>{
              let formerData: AllOrderType[] = this.AppPreferences?.getSync(`payData${this.token}`,null) as AllOrderType[]

              if (formerData == null) {
                formerData=[]
              }
              let payData:AllOrderType=this.getOrder(false)

              formerData.push(payData)
              console.log('支付数据',JSON.stringify(formerData))

              this.AppPreferences?.putSync(`payData${this.token}`,formerData)
              this.AppPreferences?.flush()
              router.back()
            })
        }.width('100%').padding(10).backgroundColor(Color.White)
        //地址和商品
        Scroll(){
          Column({space:10}){
            //地址列表
            Row(){
              Row({space:10}){
                Image($r('app.media.address')).width('10%').aspectRatio(1)

                Column(){
                  Row({space:10}){
                    Text(this.AddressData?.takename).fontSize(20).fontWeight(600)
                    Text(this.AddressData?.tel?.slice(0,3)+'****'+this.AddressData?.tel?.slice(7))
                  }
                  Text(`${this.AddressData?.province} ${this.AddressData?.city} ${this.AddressData?.district} ${this.AddressData?.streetname}`)
                }.alignItems(HorizontalAlign.Start)
              }
              .width('75%')
              Image($r('app.media.go')).width('5%').aspectRatio(1)
            }.width('100%').padding(10).justifyContent(FlexAlign.SpaceBetween).backgroundColor(Color.White)
            .onClick(()=>{
              this.isAddress=true
            })
            .bindSheet($$this.isAddress, this.address(),{
              height:'70%',
              showClose:false,
            })

            //订单列表
            Column({space:10}){
              ForEach(this.payGoodsData,(item:GoodsOrderType,index)=>{
                Column({space:10}){
                  Row({space:10}){
                    Image(item.goods_thumb).height('80%')

                    Column(){
                      Text(item.goods_name)
                      Text(`￥ ${item.price}`).fontColor($r('app.color.theme_color1'))
                      Counter(){
                        Text(this.payGoodsDataNum[index].toString())
                      }
                      .onInc(() => {
                        this.payGoodsDataNum[index]++
                        item.goods_number=this.payGoodsDataNum[index].toString()
                        this.getAllPrice()
                      })
                      .onDec(() => {
                        this.payGoodsDataNum[index] = this.payGoodsDataNum[index] > 1 ? this.payGoodsDataNum[index] - 1 : 1;
                        item.goods_number=this.payGoodsDataNum[index].toString()
                        this.getAllPrice()
                      })
                    }.width('60%').height('80%').justifyContent(FlexAlign.SpaceBetween).alignItems(HorizontalAlign.Start)

                  }.width('100%').height('15%')

                  Divider().strokeWidth(1)
                }

              })

              //总价
              Column(){
                Text(`总价：￥${this.allPrice}`)
              }.width('100%').alignItems(HorizontalAlign.End)
            }.width('100%').padding(10).backgroundColor(Color.White)

            //支付方式
            Column({space:10}){

              Column({space:10}){
                Row({space:5}){
                  Toggle({ type: ToggleType.Checkbox,isOn:this.isPayWx})
                    .size({ width: 20, height: 20 })
                    .selectedColor($r('app.color.theme_color1'))
                    .onClick(() => {
                      this.isPayWx=!this.isPayWx
                      this.isPayZfb=!this.isPayZfb
                    })
                  Image($r('app.media.weichatpay')).width('8%')
                  Text('微信支付')
                }.width('100%').justifyContent(FlexAlign.Start)
                Divider().strokeWidth(1).color('#eaeaea')
              }

              Column({space:10}){
                Row({space:5}){
                  Toggle({ type: ToggleType.Checkbox,isOn:this.isPayZfb})
                    .size({ width: 20, height: 20 })
                    .selectedColor($r('app.color.theme_color1'))
                    .onClick(() => {
                      this.isPayWx=!this.isPayWx
                      this.isPayZfb=!this.isPayZfb
                    })
                  Image($r('app.media.zfb')).width('8%')
                  Text('支付宝支付')
                }.width('100%').justifyContent(FlexAlign.Start)
                Divider().strokeWidth(1).color('#eaeaea')
              }

              Column(){
                Text('更多支付方式..').fontSize(14).fontColor($r('app.color.font_GrayBlack'))
              }

            }.width('100%').padding(10).backgroundColor(Color.White)
          }
        }.layoutWeight(1).align(Alignment.Top).scrollBar(BarState.Off)
        //支付按钮
        Row({space:5}){
          Text('实付款:')
          Text(`￥ ${this.allPrice}`).fontColor($r('app.color.theme_color1')).fontSize(18)
          Button('支付').backgroundColor($r('app.color.theme_color1'))
            .onClick(()=>{
              this.isPay=true
            })
            .bindSheet($$this.isPay, this.zf(),{
              height:'70%',
              showClose:false,
            })
        }.width('100%').padding(10).justifyContent(FlexAlign.End).backgroundColor(Color.White)

      }.width('100%').backgroundColor($r('app.color.window_background'))
      if (this.isPaying){
        Column(){
          Column(){
            Text('支付中..').fontColor(Color.White)
          }.width('30%').aspectRatio(1).borderRadius(10).backgroundColor('#ff7a7a7a').justifyContent(FlexAlign.Center)
        }.width('100%').height('100%').backgroundColor('#57000000').justifyContent(FlexAlign.Center)
      }
    }
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
          Text(`￥${this.allPrice}.00`).fontWeight(700).fontSize(30)
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
                    console.log('支付数据',JSON.stringify(formerData))

                    this.AppPreferences?.putSync(`payData${this.token}`,formerData)
                    this.AppPreferences?.flush()

                    //关闭弹窗，显示支付中，延时跳转（销毁）到支付成功页面
                    this.isPay=false

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
}