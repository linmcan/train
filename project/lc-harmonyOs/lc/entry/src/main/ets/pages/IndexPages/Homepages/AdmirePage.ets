

@Component

export struct AdmirePage {
  scrollerList: Scroller = new Scroller();
  build() {
    Scroll(){
      Column({space:10}){

        Swiper(){
          ForEach(['0','1'],(item:string)=>{
            Image($r(`app.media.reward_swiper${item}`))
          })
        }
        .autoPlay(true)
        .indicator(Indicator.dot()
          .selectedColor($r('app.color.theme_color1'))
          .color(Color.White))
        .width('95%')
        .borderRadius(10)

        Image($r('app.media.admire9')).width('95%').borderRadius(10)

        Column(){


          WaterFlow({scroller:this.scrollerList}){
            ForEach(['1','2','3','4','5','6','7','8'],(item:string)=>{
              FlowItem(){
                Image($r(`app.media.admire${item}`)).width('100%').borderRadius(10)
              }

            })
          }
          .nestedScroll({
            scrollForward: NestedScrollMode.PARENT_FIRST,
            scrollBackward: NestedScrollMode.SELF_FIRST
          })
          .columnsTemplate("1fr 1fr")
          .columnsGap(5)
          .rowsGap(5)
          .layoutWeight(1)

        }

        .width('95%')
      }
    }
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }
}