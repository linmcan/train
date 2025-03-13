import { LengthMetrics, promptAction, router } from "@kit.ArkUI"
import { preferences } from "@kit.ArkData";
import { GoodsListPage } from "../OtherPages/basePage/GoodsListPage";
import { hcHttp } from "../../utils/HttpRequest";
import { getClassifyData, getGoodsData } from "../../api/GoodsApi";
import { goodsDataSource } from "../../utils/myDataSource";
import { ApiGoodsType, classifyType } from "../../type/allTypes";

interface orderType{
  img:Resource,
  name:string
}
@Component

export struct UserPage{
  //token
  @State token: preferences.ValueType = '';
  @State userName: preferences.ValueType = '';
  @State AppPreferences: preferences.Preferences | undefined = undefined

  @State order:orderType[]=[
    {img:$r('app.media.allOrder'),name:'全部订单'},{img:$r('app.media.unOrder'),name:'未完成订单'},{img:$r('app.media.sucOrder'),name:'已完成订单'}]

  //总页数和当前页
  @State isType:string=''
  @State allPage:number=0
  @State isPage:number=1

  //创建懒加载
  @State goodsData: goodsDataSource = new goodsDataSource();

  scrollerTop: Scroller = new Scroller();
  scrollerList: Scroller = new Scroller();
  @State scrollTopVal: number = 0;

  //获取当前token
  getTokenHandler(){
    this.AppPreferences= AppStorage.get('AppPreferences');
    if(this.AppPreferences){
      this.token = this.AppPreferences.getSync('token', null);
      this.userName = this.AppPreferences.getSync('username',null)
    };
  }

  //获取商品列表
  async getGoods(){
    let classifyNavData: classifyType[] | undefined = await getClassifyData('/api_cat')
    let num:number=Math.floor(Math.random() * classifyNavData.length)
    this.isType=classifyNavData[num].cat_id

    //获取商品总页数
    let res = await hcHttp.hcGet('http://110.41.43.118:3008/api_goods',{'catId': this.isType,});
    this.allPage= JSON.parse(res.result.toString()).page;

    //随机页数
    this.isPage=Math.floor(Math.random() * this.allPage-1) + 1

    //获取数据
    let originData = await getGoodsData('/api_goods',{'catId': this.isType,'page':this.isPage})
    originData?.forEach((item)=>{
      this.goodsData.pushData(item)
    })
  }

  async aboutToAppear() {
    //获取当前用户的 token
    this.getTokenHandler();
    //获取商品列表
    this.getGoods();

  };


  build() {
    Stack({alignContent:Alignment.Top}){

      Scroll(this.scrollerTop){
        Column({space:10}){
          //头部
          Row(){
            //头像和用户名
            Row({space:10}){
              Image($r('app.media.user')).width('15%').aspectRatio(1)
              Text(this.userName == null ? '未登录，点击去登录':this.userName.toString())
            }

            if (this.token){
              Row({space:5}){
                Image($r('app.media.setting')).width('5%').aspectRatio(1)
                Text('设置').fontSize(12)
              }.border({width:1,color:'#8a8a8a'}).borderRadius(20).padding(5)
              //登录时显示设置按钮
              .onClick(()=>{
                router.pushUrl({
                  url:'pages/OtherPages/settingPage',
                })
              })
            }else {
              Image($r('app.media.go')).width('5%')
            }
          }.width('100%').justifyContent(FlexAlign.SpaceBetween).backgroundColor(Color.White).padding(10)
          //没登录的时候点击跳转登录
          .onClick(()=>{
            if (!this.token) {
              router.pushUrl({
                url:'pages/loginPage',
                params:{goodsId:''}
              })
            }
          })

          //地址管理
          Row(){
            Row({space:5}){
              Image($r('app.media.address')).width('5%').aspectRatio(1)
              Text('地址管理')
            }
            Image($r('app.media.go')).width('5%')
          }.width('100%').justifyContent(FlexAlign.SpaceBetween).backgroundColor(Color.White).padding(10)
          .onClick(()=>{
            //验证已登录
            if (!this.token) {
              promptAction.showToast({
                message: '还没登录，请先登录'
              })
              return;
            }
            router.pushUrl({url:'pages/OtherPages/addressPage'})
          })

          //订单
          Column({space:10}){
            Row(){
              Text('我的订单').fontSize(18)
              Image($r('app.media.go')).width('5%')
            }.width('100%').justifyContent(FlexAlign.SpaceBetween)
            .onClick(()=>{
              //验证已登录
              if (!this.token) {
                promptAction.showToast({
                  message: '还没登录，请先登录'
                })
                return;
              }
              router.pushUrl({
                url:'pages/OtherPages/orderPage',
                params: {isChoice:0}
              })
            })
            Row(){
              ForEach(this.order,(item:orderType,index)=>{
                Column({space:5}){
                  Image(item.img).width('8%')
                  Text(item.name).fontSize(12).fontColor('#515151')
                }
                .onClick(()=>{
                  //验证已登录
                  if (!this.token) {
                    promptAction.showToast({
                      message: '还没登录，请先登录'
                    })
                    return;
                  }
                  router.pushUrl({
                    url:'pages/OtherPages/orderPage',
                    params: {isChoice:index}
                  })
                })
              })

            }.width('100%').justifyContent(FlexAlign.SpaceAround)
          }.width('100%').backgroundColor(Color.White).padding(10)

          // 猜你喜欢
          Column(){
            WaterFlow({scroller:this.scrollerList}){
              LazyForEach(this.goodsData,(item:ApiGoodsType)=>{
                FlowItem(){
                  Column() {
                    Image(item.goods_thumb)
                      .width('100%')
                      .borderRadius({ topLeft: 10, topRight: 10 })
                    Column({ space: 5 }) {
                      Text(item.goods_name)
                        .fontSize(16)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .maxLines(2)
                      Text(item.goods_desc)
                        .fontSize(12)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .maxLines(2)
                        .fontColor($r('app.color.font_GrayBlack'))
                      Text(`￥${item.price}`).fontColor($r('app.color.theme_color1')).fontWeight(600)
                    }.padding(5)
                    .alignItems(HorizontalAlign.Start)

                  }
                  .width('49%')
                  .height('41%')
                  .backgroundColor(Color.White)
                  .borderRadius(10)
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/OtherPages/GoodsDetailsPage',
                      params: {goodsId:item.goods_id}
                    })
                  })
                }
              })
            }
            .padding(10)
            .width('100%')
            .columnsTemplate('1fr 1fr')
            .columnsGap(10)
            .rowsGap(10)
            .nestedScroll({
              scrollForward: NestedScrollMode.PARENT_FIRST,
              scrollBackward: NestedScrollMode.SELF_FIRST
            })
            //下拉加载
            .onReachEnd(async ()=>{
              console.log('触发了')
              this.isPage += 1;
              //添加数据
                this.isPage = (this.isPage <= this.allPage) ? this.isPage : 1;
                let originData = await getGoodsData('/api_goods',{'catId': this.isType,'page':this.isPage})
                originData?.forEach((item)=>{
                  this.goodsData.pushData(item)
                })
            })
          }
          .width('100%')
          .height('100%')
        }
        .width('100%')
      }
      .layoutWeight(1)
      .edgeEffect(EdgeEffect.Spring)
      .scrollBar(BarState.Off)
      //滚动监听
      .onDidScroll(() => {
        this.scrollTopVal = this.scrollerTop.currentOffset().yOffset;
        console.log('scroll'+ this.scrollTopVal.toString())
      })

      if (this.scrollTopVal>=200){
        Row(){
          Text(this.userName == null ? '未登录，点击去登录':this.userName.toString()).fontSize(20)
          .onClick(()=>{
            if (!this.token) {
              router.pushUrl({url:'pages/loginPage'})
            }
          })

          if (this.token){
            Text('设置').fontSize(20)
              .onClick(()=>{
                router.pushUrl({url:'pages/OtherPages/settingPage'})
              })
          }
        }
        .width('100%').padding(10).backgroundColor(Color.White)
        .justifyContent(FlexAlign.SpaceBetween)

        //双击回到顶部
        .gesture(TapGesture({ count: 2 }).onAction((event: GestureEvent) => {
              if (event) {
                this.scrollerTop.scrollEdge(Edge.Top);
                this.scrollerList.scrollEdge(Edge.Top)
                this.scrollTopVal = 0;
              }
            }))
      }
    }

  }
}