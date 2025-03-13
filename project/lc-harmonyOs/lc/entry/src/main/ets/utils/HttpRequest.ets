//引入模块
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

async function hcRequest(url: string, method: http.RequestMethod = http.RequestMethod.GET, data : Record<string,string|number> = {}){

  //创建http实例对象
  let httpRequest: http.HttpRequest = http.createHttp();

  //返回一个成功的promise对象
  let result = await httpRequest.request(url, {
    method: method,
    extraData: Object.keys(data).map((item: string, index: number) => {
      return item + '=' + encodeURIComponent(data[item]);
    }).join('&')
  });

  httpRequest.destroy();
  return result;

};

export class hcHttp{
  static BASE_URL: string = 'http://110.41.43.118:3008';

  static hcGet(url: string, data : Record<string,string|number> = {}): Promise<http.HttpResponse>{
    return hcRequest(url, http.RequestMethod.GET, data);
  };

  static hcPost(url: string, data : Record<string,string|number> = {}): Promise<http.HttpResponse>{
    return hcRequest(url, http.RequestMethod.POST, data);
  };

  static hcPut(url: string, data : Record<string,string|number> = {}): Promise<http.HttpResponse>{
    return hcRequest(url, http.RequestMethod.PUT, data);
  };

  static hcDelete(url: string, data : Record<string,string|number> = {}): Promise<http.HttpResponse>{
    return hcRequest(url, http.RequestMethod.DELETE, data);
  };

};


