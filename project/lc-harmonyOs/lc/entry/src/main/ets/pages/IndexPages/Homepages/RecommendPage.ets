import {RecommendClassType, RecommendType, SwiperType } from "../../../type/allTypes"

//引入数据方法
import { getBannerData, getHotGoodsData} from './../../../api/GoodsApi'
//引入类型
import type { ApiGoodsType } from '../../../type/allTypes'
import { LengthMetrics, router, SwipeRefresher } from "@kit.ArkUI";
import { recommendDataSource } from "../../../utils/recommendSource";

@Component

export struct RecommendPage{
  //轮播图数据
  @State banner: SwiperType[] = [];

  //刷新控制器
  @State isRefresh: boolean = false;

  //滚动组件
  scrollerTop: Scroller = new Scroller();
  @State scrollTopVal: number = 0;
  scrollerList: Scroller = new Scroller();
  @State scrollListVal: number = 0;

  //懒加载数据
  @State recommendDataSource: recommendDataSource = new recommendDataSource();

  //获取数据
  async aboutToAppear(){
    //轮播图广告请求
    this.banner = await getBannerData('/api_banner', {'bannerId': 1});

    // 推荐数据请求
    let originHotData = await getHotGoodsData();
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
            Swiper() {
              ForEach(this.banner, (item: SwiperType) => {
                Image(item.goods_thumb)
                  .width('100%')
              })
            }
            .autoPlay(true)
            .indicator(Indicator.dot()
              .selectedColor($r('app.color.theme_color1'))
              .color(Color.White))
            .width('95%')
            .borderRadius(10)

            //小图广告


            //分类预览

            List({scroller:this.scrollerList}) {
              LazyForEach(this.recommendDataSource, (item: RecommendType) => {
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
                          params:{typeName:item.cat_name,typeId:item.cat_id,classifyId:1}
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
            //监听滚动
            .onWillScroll(() => {
              this.scrollListVal = this.scrollerList.currentOffset().yOffset;
            })
          }

        }
        .width('100%')
        .scrollBar(BarState.Off)
        //监听滚动
        .onWillScroll(() => {
          this.scrollTopVal = this.scrollerTop.currentOffset().yOffset;
        })
      }
      //上拉刷新
      .onRefreshing(() => {
        //请求数据
        setTimeout(async () => {
          this.isRefresh = false;
          //删除数据
          this.recommendDataSource.deleteAllData()
          //重新请求
          let originHotData = await getHotGoodsData();
          originHotData.forEach((item: RecommendClassType) => {
            this.recommendDataSource.pushData(item);
          });

        }, 3000)
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


  //刷新样式
  @Builder refreshStyle() {
    SwipeRefresher({
      content: '正在加载中',
      isLoading: true
    })
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