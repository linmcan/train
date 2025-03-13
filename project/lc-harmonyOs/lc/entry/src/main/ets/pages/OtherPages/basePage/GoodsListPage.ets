import { router, SwipeRefresher } from "@kit.ArkUI";
import { getGoodsData } from "../../../api/GoodsApi";
import { ApiGoodsType } from "../../../type/allTypes";
import { hcHttp } from '../../../utils/HttpRequest';
import { goodsDataSource } from "../../../utils/myDataSource";

@Component

export struct GoodsListPage{
  //判断是否为搜索页调用
  @State isSearch:boolean=false

  //传过来的搜索关键字和类型id
  @State keywords:string=''
  @State nowTypeId:string=''

  //总页数和当前页
  @State allPage:number=0
  @State isPage:number=1


  //创建懒加载
  @State goodsData: goodsDataSource = new goodsDataSource();

  //刷新样式和刷新状态开关
  @Builder refreshStyle() {
    SwipeRefresher({
      content: '正在加载中',
      isLoading: true
    })
  }
  @State isRefresh: boolean = false;

  //获取数据
  async aboutToAppear(){
    //判断是否是搜索页调用
    if (this.isSearch) {
      //获取搜索商品总页数
      let res = await hcHttp.hcGet('http://110.41.43.118:3008/api_search',{'keywords': this.keywords});
      this.allPage= JSON.parse(res.result.toString()).count / 9;

      //获取数据
      let originData = await getGoodsData('/api_search',{'keywords': this.keywords,'page':this.isPage})
      originData?.forEach((item)=>{
        this.goodsData.pushData(item)
      })
    }else {
      //获取商品总页数
      let res = await hcHttp.hcGet('http://110.41.43.118:3008/api_goods',{'catId': this.nowTypeId,});
      this.allPage= JSON.parse(res.result.toString()).page;

      //随机页数
      this.isPage=Math.floor(Math.random() * this.allPage-1) + 1

      //获取数据
      let originData = await getGoodsData('/api_goods',{'catId': this.nowTypeId,'page':this.isPage})
      originData?.forEach((item)=>{
        this.goodsData.pushData(item)
      })
    }
  }

  build() {
    Refresh({
      refreshing: $$this.isRefresh,
      builder: this.refreshStyle()
    }){
      WaterFlow(){
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
            .height('42%')
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
        if (this.isSearch) {
          if (this.isPage<=this.allPage) {
            let originData = await getGoodsData('/api_search',{'keywords': this.keywords,'page':this.isPage})
            originData?.forEach((item)=>{
              this.goodsData.pushData(item)
            })
          }
        }else {
          this.isPage = (this.isPage <= this.allPage) ? this.isPage : 1;
          let originData = await getGoodsData('/api_goods',{'catId': this.nowTypeId,'page':this.isPage})
          originData?.forEach((item)=>{
            this.goodsData.pushData(item)
          })
        }
      })

    }
    .backgroundColor($r('app.color.window_background'))
    .padding({ left: 10, right: 10})
    //上拉刷新
    .onRefreshing(() => {
      if (!this.isSearch) {
        //请求数据
        setTimeout(async () => {
          this.isRefresh = false;
          this.goodsData.deleteAllData()

          //随机页数
          this.isPage=Math.floor(Math.random() * this.allPage-1) + 1
          //获取数据
          let originData = await getGoodsData('/api_goods',{'catId': this.nowTypeId,'page':this.isPage})
          originData?.forEach((item)=>{
            this.goodsData.pushData(item)
          })
        }, 2000)
      }
      else {
        this.isRefresh = false;
      }

    })
  }
}