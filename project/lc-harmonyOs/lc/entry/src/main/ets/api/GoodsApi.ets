//商品导航相关的数据
import { hcHttp } from './../utils/HttpRequest';

//引入类型
import {
  ApiClassifyType,
  ApiGoodsDataType,
  ApiGoodsDetails,
  ApiGoodsType, classifyType,
  DetailedClassify,
  detailedData,
  RecommendClassType,
  regionDataType,
  SwiperType } from '../type/allTypes';

//全局的路径
const BASE_URL: string = 'http://110.41.43.118:3008';


//轮播图
export async function getBannerData(url: string, data: Record<string, string|number> = {}){
  let res = await hcHttp.hcGet(BASE_URL + url, data);
  //转对象形式
    let res2: SwiperType[] = JSON.parse(res.result.toString()).data;
    return res2

}
//商品类型
export async function getClassifyData(url: string, data: Record<string, string|number> = {}){
  let res = await hcHttp.hcGet(BASE_URL + url, data);
  //转对象形式
    let res2: classifyType[] = JSON.parse(res.result.toString()).data;
    return res2
}
//商品列表
export async function getGoodsData(url: string, data: Record<string, string|number> = {}){
  let res = await hcHttp.hcGet(BASE_URL + url, data);
  //转对象形式

    let res2: ApiGoodsDataType = JSON.parse(res.result.toString());
    //验证
    if(res2.code != 0){
      console.log('hc', '商品数据请求失败');
      return;
    };
    return res2.data;
}

//商品类型小分类
export async function getSmallClassifyData(url: string, data: Record<string, string|number> = {}){
  let res = await hcHttp.hcGet(BASE_URL + url, data);
  //转对象形式
  let res2: ApiClassifyType = JSON.parse(res.result.toString());
  //验证
  if(res2.code != 0){
    console.log('hc', '商品分类请求失败');
    return;
  };
  return res2.data;
}


//推荐页商品列表
export async function getHotGoodsData(){
  let catList: classifyType[] | undefined = await getClassifyData('/api_cat');

  let hotListData: RecommendClassType[] = [];

  if (catList) {
    for(let i = 0; i < catList?.length; i++){

      let d: ApiGoodsType[] | undefined = await getGoodsData('/api_goods', {
        'page': Math.floor(Math.random()  * 8 + 1),
        'pagesize': 4,
        'catId': (catList[i].cat_id) as string,
      })

      hotListData.push(new RecommendClassType(catList[i].cat_id as string, catList[i].cat_name as string, d));

    }
  }
  return hotListData;

}

//首页商品分类列表
export async function getClassifyGoodsData(catId:string){
  let allData:DetailedClassify[]|undefined = await getSmallClassifyData('/api_classify');

  let thisData:detailedData[]|undefined=[]
  let hotListData: RecommendClassType[] = [];

  if (allData) {
    thisData = allData.find(item =>item.cat_id == catId)?.data
    if (thisData) {
      for (let index = 0; index < thisData.length; index++) {
        let d: ApiGoodsType[] | undefined = await getGoodsData('/api_goods', {
          'page': Math.floor(Math.random() * 30) + 1,
          'pagesize': 4,
          'catId': catId,
        })
        hotListData.push(new RecommendClassType(catId, thisData[index].product_content as string, d));
      }
    }
  }

  return hotListData

}

//商品详细
export async function getGoodsDetails(url: string, data: Record<string, string|number> = {}){
  let res = await hcHttp.hcGet(BASE_URL + url, data);
  //转对象形式
  let res2: ApiGoodsDetails = JSON.parse(res.result.toString());
  //验证
  if(res2.code != 0){
    console.log('hc', '商品请求失败');
    return;
  };

  return res2.data;


}

//请求地址
export async function getRegionData(url: string, data: Record<string, string|number> = {}){
  let res = await hcHttp.hcGet(BASE_URL + url, data);

  let res2:regionDataType[]=[]
  if (JSON.parse(res.result.toString()).data.area) {
    res2= JSON.parse(res.result.toString()).data.area
  }else {
    res2= JSON.parse(res.result.toString()).data
  }

  return res2
}

