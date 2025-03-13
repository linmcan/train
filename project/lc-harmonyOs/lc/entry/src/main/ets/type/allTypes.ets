//index页面总用
//总导航栏标题类型
export interface tabsTitle{
  id:number;
  acImg?:Resource;
  Img?:Resource;
  name:string;
}

//总导航栏类型
export interface tabs{
  id:number;
  pageName:string;
  title:tabsTitle;
}


//商品导航分类
export interface classifyType{
  _id?:string,
  cat_img:string
  cat_id: string,
  cat_name:string
}

//轮播图类型
export interface SwiperType{
  _id?:string,
  cat_id:string,
  goods_desc:string,
  goods_id:string,
  goods_name:string,
  goods_thumb:string,
  price:number,
  star_number:string
}


//商品类型总数据
export interface ApiGoodsDataType{
  code: number;
  data?: ApiGoodsType[];
  message?: string;
  page?: number;
  nowpage?: number;
  count?: number;
}
//首页推荐预览类型
export interface RecommendType{
  cat_id:string;
  cat_name:string;
  cat_goods:ApiGoodsType[]| undefined
}
//商品数据类型
export interface ApiGoodsType{
  _id?: string;
  goods_id: string;
  cat_id: string;
  goods_name: string;
  goods_desc: string;
  goods_thumb: string;
  brand_name: string;
  brand_thumb: string;
  goods_number: string;
  star_number: string;
  price: number;
}


//商品详细分类类型
export interface ApiClassifyType{
  code: number;
  message?: string;
  data?: DetailedClassify[];
}
//商品详细分类
export interface DetailedClassify{
  data:detailedData[];
  _id: string;
  cat_id: string;
  title: string;
  title_img: string
}
//详细分类类型
export interface detailedData{
  id: number,
  product_content: string;
  product_img:string
}

//商品详细页类型
export interface ApiGoodsDetails{
  code: number,
  message:string,
  data?: GoodsDetailsData[],
  page?: number,
  nowpage?: number,
  count?: number
}
//商品详细页数据类型
export interface GoodsDetailsData{
  goods_number?:string,
  banner?: string[],
  product_banner?:string[],
  lc_recommend?:string[],
  _id?:string,
  brand_name?: string,
  goods_id?: string,
  cat_id?: string,
  goods_name?: string,
  price?: number,
  star_number?:string
}


//post返回数据类型
export interface PostMessage{
  code:number;
  message?: string;
  user_id?: number,
  username?:string
}

//地址列表类型
export interface AddressType{
  isDefault?: boolean,
  _id?: string,
  address_id?: number,
  user_id?:string,
  takename?: string,
  province?:string,
  city?:string,
  district?: string,
  streetname?: string,
  postcode?: string,
  tel?: string
}


//省市区返回类型
export interface regionDataType{
  code:string,
  name: string
}

//订单大类型
export interface AllOrderType{
  goods:GoodsOrderType[]
  _id?:string
  order_address?:AddressType
  status?:string
  trade_no?:string
  allPrice?:number
}

//单个商品订单类型
export interface GoodsOrderType{
  _id?:string
  goods_id?:string
  cat_id?: string
  goods_name?: string
  goods_desc?: string
  goods_thumb?:string
  goods_number?:string
  star_number?: string
  price: number
  status?: string
}

//购物车
export interface GoodsShopType{
  _id:string,
  goods_id:string,
  cat_id:string,
  goods_name:string,
  goods_desc:string,
  goods_thumb:string,
  brand_name:string,
  brand_thumb:string,
  goods_number:string
  star_number:string
  price:number
}






export class RecommendClassType{
  cat_id:string;
  cat_name:string;
  cat_goods:ApiGoodsType[]| undefined

  constructor(catId: string,catName:string,catGoods:ApiGoodsType[]| undefined) {
    this.cat_id=catId;
    this.cat_name=catName
    this.cat_goods=catGoods
  }
}

//商品类型  类
export class GoodsType{
  _id?: string;
  goods_id: string;
  cat_id: string;
  goods_name: string;
  goods_desc: string;
  goods_thumb: string;
  brand_name: string;
  brand_thumb: string;
  goods_number: string;
  star_number: string;
  price: number;

  constructor(goodsId: string, goodsName: string, goodsDesc: string, catId: string, goodsThumb: string, brandName: string, brandThumb: string, goodsNumber: string, starNumber: string, price: number) {
    this.goods_id = goodsId;
    this.goods_name = goodsName;
    this.cat_id = catId;
    this.goods_desc = goodsDesc;
    this.goods_thumb = goodsThumb;
    this.brand_name = brandName;
    this.brand_thumb = brandThumb;
    this.goods_number = goodsNumber;
    this.star_number = starNumber;
    this.price = price;
  }
}


