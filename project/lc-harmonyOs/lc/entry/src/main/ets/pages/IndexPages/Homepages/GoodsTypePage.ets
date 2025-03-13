
import { LengthMetrics, router, SwipeRefresher } from "@kit.ArkUI";
import { ApiGoodsType, RecommendClassType, RecommendType } from "../../../type/allTypes";
import { OtherData } from "../../../data/allDatas";
import { getClassifyGoodsData } from "../../../api/GoodsApi";
import { recommendDataSource } from "../../../utils/recommendSource";

@Component

export struct GoodsTypePage{
  @State catId:string=''

  @State isRefresh: boolean = false;

  @State SwiperData:string[]|undefined=[]
  @State ztData:string[]=[]

  scrollerTop: Scroller = new Scroller();
  @State scrollTopVal: number = 0;
  scrollerList: Scroller = new Scroller();
  @State scrollListVal: number = 0;

  //创建懒加载数据实例对象
  @State recommendDataSource: recommendDataSource = new recommendDataSource();

  //刷新样式
  @Builder refreshStyle() {
    SwipeRefresher({
      content: '正在加载中',
      isLoading: true
    })
  }

  async aboutToAppear(): Promise<void> {
    //获取轮播图,专题图片
    let OtherImgData = OtherData.find(item => item.cat_id == this.catId)
    this.SwiperData=OtherImgData?.swiperImg
    if (OtherImgData?.ztImg) {
      this.ztData=OtherImgData?.ztImg
    }

    //引入原始数据
    let originHotData = await getClassifyGoodsData(this.catId)
    //热门数据
    originHotData.forEach((item: RecommendClassType) => {
      this.recommendDataSource.pushData(item);
    });
    console.log('cs',JSON.stringify(this.recommendDataSource))
  }

  build() {
    Stack({alignContent:Alignment.BottomEnd}) {
      Refresh({
        refreshing: $$this.isRefresh,
        builder: this.refreshStyle()
      }) {
        Scroll(this.scrollerTop) {
          Column() {
            //轮播图
            this.AllSwiper(this.SwiperData)
            //专题
            if (this.ztData.length != 0) {
              this.allZtImg(this.ztData)
            }


              List({scroller:this.scrollerList}) {
                LazyForEach(this.recommendDataSource, (item: RecommendType,index:number) => {
                  ListItemGroup({ header: this.listGroupTitle(item.cat_name) }) {

                    ListItem() {
                      Flex({
                        wrap: FlexWrap.Wrap,
                        justifyContent: FlexAlign.SpaceBetween,
                        space: { cross: LengthMetrics.px(15) }
                      }) {
                        ForEach(item.cat_goods, (item: ApiGoodsType) => {
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
                          .height('50%')
                          .backgroundColor(Color.White)
                          .borderRadius(10)
                          .onClick(() => {
                            router.pushUrl({
                              url: 'pages/OtherPages/GoodsDetailsPage',
                              params: {goodsId:item.goods_id}
                            })
                          })
                        })

                        //查看更多
                        Column({ space: 5 }) {
                          Text('点击查看更多 >>').fontColor($r('app.color.font_GrayBlack'))
                          Divider().strokeWidth(1)
                        }
                        .width('100%')
                        .justifyContent(FlexAlign.Center)
                        .padding(10)
                        .onClick(()=>{
                          router.pushUrl({
                            url: 'pages/OtherPages/ClassifyGoodsPage',
                            params:{typeName:item.cat_name,typeId:item.cat_id,classifyId:index+1}
                          })
                        })

                      }

                    }.padding({ left: 10, right: 10, bottom: 10 })

                  }
                })
              }
              .width('100%')
              .height('100%')
              .nestedScroll({
                scrollForward: NestedScrollMode.PARENT_FIRST,
                scrollBackward: NestedScrollMode.SELF_FIRST
              })
              .sticky(StickyStyle.Header)
              .scrollBar(BarState.Off)
              .edgeEffect(EdgeEffect.None)
              //监听滚动
              .onWillScroll(() => {
                this.scrollListVal = this.scrollerList.currentOffset().yOffset;
              })

          }
        }
        .layoutWeight(1)
        .edgeEffect(EdgeEffect.Spring)
        .scrollBar(BarState.Off)
        //监听滚动
        .onWillScroll(() => {
          this.scrollTopVal = this.scrollerTop.currentOffset().yOffset;
        })

      }
      //上拉刷新
      .onRefreshing(() => {
        console.log('刷新中...');
        //请求数据
        setTimeout(async () => {
          this.isRefresh = false;
          this.recommendDataSource.deleteAllData()

          let originHotData = await getClassifyGoodsData(this.catId)
          //热门数据
          originHotData.forEach((item: RecommendClassType) => {
            this.recommendDataSource.pushData(item);
          });


        }, 2000)
      })


      //返回顶部
      if(this.scrollTopVal+this.scrollListVal >= 600) {
        Row() {
          Image($r('app.media.backTop'))
            .width(40).opacity(0.7)
        }
        .margin(20)
        .onClick(()=>{
          this.scrollerTop.scrollEdge(Edge.Top);
          this.scrollTopVal = 0;
          this.scrollerList.scrollEdge(Edge.Top);
          this.scrollListVal = 0;
        })
      }
    }
  }

  @Builder AllSwiper(data:string[]|undefined){
    Swiper(){
      ForEach(data,(item:string)=>{
        Image(item)
          .width('100%')
      })
    }
    .autoPlay(true)
    .indicator(Indicator.dot()
      .selectedColor($r('app.color.theme_color1'))
      .color(Color.White))
    .width('95%')
    .borderRadius(10)
  }

  @Builder allZtImg(data:string[]){
    Column({space:10}){
      Text('专题').fontSize(20).fontWeight(600)
      Scroll(){
        Row({space:5}){
          ForEach(data,(item:string)=>{
            Image(item)
              .height('30%').aspectRatio(1).borderRadius(10)
          })
        }
      }.scrollable(ScrollDirection.Horizontal).scrollBar(BarState.Off)
    }
    .margin({top:10})
    .width('95%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder listGroupTitle(str:string){
    Column(){
      Text(str)
        .width('100%')
        .fontSize(24)
        .fontWeight(700)
      Divider().strokeWidth(1)
    }
    .backgroundColor($r('app.color.window_background'))
    .padding(10)

  }
}