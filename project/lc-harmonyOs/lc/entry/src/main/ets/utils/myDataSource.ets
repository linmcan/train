import {ApiGoodsType} from './../type/allTypes';

//这里是商品类型的懒加载
class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  // 数据类型要修改成自己的类型
  private originDataArray: ApiGoodsType[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): ApiGoodsType {
    return this.originDataArray[index];
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('123add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }

  notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    })
  }
}

// 商品懒加载
export class goodsDataSource extends BasicDataSource{

  //数据源
  private dataArray: ApiGoodsType[] = [];

  //获取数据数量
  public totalCount(): number {
    return this.dataArray.length;
  };

  //获取下标位置的数据
  public getData(index: number): ApiGoodsType {
    return this.dataArray[index];
  };

  //获取整个数据
  public getDataAll(): ApiGoodsType[] {
    return this.dataArray;
  };

  //添加数据
  public pushData(data: ApiGoodsType): void {
    //添加数据源中去
    this.dataArray.push(data);
    //通知添加，才会UI重新渲染
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  //删除全部
  public deleteAllData():void {
    this.dataArray = [];
  }

  //删除一条数据
  public deleteData(index: number): void{
    //操作数据源
    this.dataArray.splice(index, 1);
    //通知 lazyForEach 删除数据
    this.notifyDataDelete(index);
  };

  //替换一条数据
  public changeData(index: number, data: ApiGoodsType): void {
    this.dataArray.splice(index, 1, data);
    //通知更新
    this.notifyDataChange(index);
  }

  //交换数据位置
  public moveData(from: number, to: number): void {
    //跳转存储
    let temp: ApiGoodsType = this.dataArray[from];
    //设置起始下标值
    this.dataArray[from] = this.dataArray[to];
    //设置目标下标值
    this.dataArray[to] = temp;
    //通知更新
    this.notifyDataMove(from, to);
  }

  //重载数据
  public ReloadData(): void{
    //调用框架侧方法
    this.notifyDataReload();
  }

  //拖动
  public moveDataWithoutNotify(from: number, to: number): void {
    let tmp = this.dataArray.splice(from, 1);
    this.dataArray.splice(to, 0, tmp[0])
  }


}



