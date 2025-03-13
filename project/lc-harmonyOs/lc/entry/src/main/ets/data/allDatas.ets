import type{ tabs } from "../type/allTypes";

//下导航栏数据
export const tabsBottomData: tabs[]=[
  {
    id:0,
    pageName:'HomePage',
    title:{
      id:0,
      name:'商店',
      acImg: $r('app.media.ic_home_selected'),
      Img: $r('app.media.ic_home')
    }
  },
  {
    id:1,
    pageName:'ClassifyPage',
    title:{
      id:1,
      name:'分类',
      acImg: $r('app.media.ic_classify_selected'),
      Img: $r('app.media.ic_classify')
    }
  },
  {
    id:2,
    pageName:'ShopPage',
    title:{
      id:2,
      name:'购物车',
      acImg: $r('app.media.ic_shop_selected'),
      Img: $r('app.media.ic_shop')
    }
  },
  {
    id:3,
    pageName:'UserPage',
    title:{
      id:3,
      name:'我的',
      acImg: $r('app.media.ic_my_selected'),
      Img: $r('app.media.ic_my')
    }
  },
];


//首页其他页面轮播图和专题
export interface otherSwiper{
  cat_id?: string;
  swiperImg?:string[];
  ztImg?:string[];
}

export const OtherData:otherSwiper[]=[
  {
    cat_id: '0045',
    swiperImg: ['/data/imgData/0045_swiper1.jpg', '/data/imgData/0045_swiper2.jpg'],
    ztImg: ['/data/imgData/0045_zt1.png', '/data/imgData/0045_zt2.jpg', '/data/imgData/0045_zt3.jpg']
  },
  {
    cat_id: '0077',
    swiperImg: ['/data/imgData/0077_swiper1.jpg', '/data/imgData/0077_swiper2.png'],
    ztImg: ['/data/imgData/0077_zt1.jpg', '/data/imgData/0077_zt2.jpg', '/data/imgData/0077_zt3.jpg']
  },
  {
    cat_id: '0082',
    swiperImg: ['/data/imgData/0082_swiper1.jpg'],
    ztImg: ['/data/imgData/0082_zt1.jpg', '/data/imgData/0082_zt2.jpg', '/data/imgData/0082_zt3.jpg']
  },
  {
    cat_id: '0092',
    swiperImg: ['/data/imgData/0092_swiper1.jpg', '/data/imgData/0092_swiper2.png'],
    ztImg: ['/data/imgData/0092_zt1.jpg', '/data/imgData/0092_zt2.jpg', '/data/imgData/0092_zt3.jpg']
  },
  {
    cat_id: '0062',
    swiperImg: ['/data/imgData/0062_swiper1.jpg', '/data/imgData/0062_swiper2.jpg'],
    ztImg: ['/data/imgData/0062_zt1.jpg']
  },
  {
    cat_id: '0069',
    swiperImg: ['/data/imgData/0069_swiper1.png', '/data/imgData/0069_swiper2.jpg'],
    ztImg: ['/data/imgData/0069_zt1.jpg', '/data/imgData/0069_zt2.jpg', '/data/imgData/0069_zt3.jpg']
  },
  {
    cat_id: '0141',
    swiperImg: ['/data/imgData/0141_swiper1.jpg', '/data/imgData/0141_swiper2.png'],
  },
  {
    cat_id: '0154',
    swiperImg: ['/data/imgData/0154_swiper1.jpg', '/data/imgData/0154_swiper2.png'],
    ztImg: ['/data/imgData/0154_zt1.jpg', '/data/imgData/0154_zt2.jpg', '/data/imgData/0154_zt3.png']
  },
  {
    cat_id: '0166',
    swiperImg: ['/data/imgData/0166_swiper1.png', '/data/imgData/0166_swiper2.png'],
    ztImg: ['/data/imgData/0166_zt1.jpg', '/data/imgData/0166_zt2.jpg', '/data/imgData/0166_zt3.jpg']
  },
  {
    cat_id: '0182',
    swiperImg: ['/data/imgData/0182_swiper1.jpg']
  },
  {
    cat_id: '0214',
    swiperImg: ['/data/imgData/0214_swiper1.png'],
    ztImg: ['/data/imgData/0214_zt1.jpg', '/data/imgData/0214_zt2.jpg']
  },
  {
    cat_id: '0279',
    swiperImg: ['/data/imgData/0279_swiper1.jpg', '/data/imgData/0279_swiper2.jpg'],
    ztImg: ['/data/imgData/0279_zt1.jpg', '/data/imgData/0279_zt2.png', '/data/imgData/0279_zt3.jpg']
  },
  {
    cat_id: '0358',
    swiperImg: ['/data/imgData/0358_swiper1.png'],
    ztImg: ['/data/imgData/0358_zt1.jpg', '/data/imgData/0358_zt2.png', '/data/imgData/0358_zt3.png']
  },
  {
    cat_id: '0112',
    swiperImg: ['/data/imgData/0112_swiper1.jpg', '/data/imgData/0112_swiper2.png'],
  },
  {
    cat_id: '0129',
    swiperImg: ['/data/imgData/0129_swiper1.jpg', '/data/imgData/0129_swiper2.png'],
    ztImg: ['/data/imgData/0129_zt1.jpg', '/data/imgData/0129_zt2.jpg', '/data/imgData/0129_zt3.jpg']
  }
]




