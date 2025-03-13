import { preferences } from '@kit.ArkData';
import { getRegionData } from '../../../api/GoodsApi';
import { AddressType, regionDataType } from '../../../type/allTypes';
import { hcHttp } from '../../../utils/HttpRequest';

@Component
export struct baseAddressPage{
  //token
  @State token: preferences.ValueType = '';
  @State AppPreferences: preferences.Preferences | undefined = undefined

  @State AddressData:AddressType[]=[]

  @State isCompile:boolean=false

  //是否为新增
  @State isAddClick:boolean=false


  //修改地址弹窗开关
  @State isAmend:boolean=false
  //修改地址数据
  @State isAmendData:AddressType={}
  //校验详细地区，收货人，手机号
  @State streetname:boolean=false
  @State takename:boolean=false
  @State phoNumber:boolean=false

  //地区弹窗开关
  @State isTextPicker:boolean=false
  //当前选择的省市区
  @State nowAddress:string[]=[]
  //当前选择列表
  @State nowList:string[]=[]
  @State nowClick:number=-1

  //是否来自商品列表的操作
  @State fromDetails:boolean=false
  //设为当前地址下标
  @State isActiveNum:number=-1



  //获取当前列表
  async getAddressList(){
    this.AppPreferences =  AppStorage.get('AppPreferences');
    if(this.AppPreferences){
      this.token = this.AppPreferences.getSync('token', null);
    };

    //请求数据接口
    let httpResponse = await hcHttp.hcPost(hcHttp.BASE_URL + '/api_address', {
      'status': 'getAddress',
      'userId':this.token.toString()
    });

    //数据处理,默认地址在前
    let originData:AddressType[] = await JSON.parse(httpResponse.result.toString()).data;
    this.AddressData = await originData.sort((a, b) => {return (a.isDefault === b.isDefault) ? 0 : a.isDefault ? -1 : 1;});
  }

  //设为默认方法
  async isDefault(addressId:number){
    //设置
    await hcHttp.hcPost(hcHttp.BASE_URL + '/api_address', {
      'status': 'defaultAddress',
      'userId':this.token.toString(),
      'addressId':addressId
    });
    //刷新ui
    this.getAddressList()

  }

  //删除方法
  async isDelete(addressId:number){
    //设置
    await hcHttp.hcPost(hcHttp.BASE_URL + '/api_address', {
      'status': 'deleteAddress',
      'userId':this.token.toString(),
      'addressId':addressId
    });
    //刷新ui
    this.getAddressList()

  }

  //添加方法
  async isAdd(list:AddressType){
    await hcHttp.hcPost(hcHttp.BASE_URL + '/api_address', {
      'status': 'addAddress',
      'userId':this.token.toString(),
      'province':list.province as string,
      'city':list.city as string,
      'district':list.district as string,
      'streetname':list.streetname as string,
      'takename' :list.takename as string,
      'postcode':list.province as string,
      'tel':list.tel as string,
    });
    this.getAddressList()
  }

  //设为当前方法
  async isActive(addressId:number){
    //设置
    await hcHttp.hcPost(hcHttp.BASE_URL + '/api_address', {
      'status': 'activeAddress',
      'userId':this.token.toString(),
      'addressId':addressId
    });
  }

  //请求省
  async getProvince(){
    let AllData:regionDataType[]= await getRegionData('/api_country')
    let data:string[]=[]
    AllData.forEach((item)=>{
      data.push(item.name);
    })
    this.nowList=data
  }
  //请求市
  async getCity(province:string){
    let AllData:regionDataType[]= await getRegionData('/api_country',{'province':province})
    let data:string[]=[]
    AllData.forEach((item)=>{
      data.push(item.name);
    })
    this.nowList=data

    if (data.length !=0) {
      this.nowAddress[1]='请选择'
      this.nowClick=1
    }

  }

  //请求区
  async getDistrict(nowProvince:string,nowCity:string){
    let AllData:regionDataType[]= await getRegionData('/api_country',{'province':nowProvince,'city':nowCity})
    let data:string[]=[]
    AllData.forEach((item)=>{
      data.push(item.name);
    })
    this.nowList=data

    if (data.length != 0) {
      this.nowAddress[2]='请选择'
      this.nowClick=2
    }
  }


  async aboutToAppear(){
    //请求地址列表
    this.getAddressList()
  }
  build() {
    Column(){
      //管理
      Row({space:10}) {
        if (this.isCompile){
          //退出管理
          Row() {
            Image($r('app.media.break')).width('5%').aspectRatio(1)
            Text('退出管理').fontColor($r('app.color.theme_color1'))
          }
          .onClick(()=>{
            this.isCompile=!this.isCompile
          })
        }else {
          //管理
          Row() {
            Image($r('app.media.compile')).width('5%').aspectRatio(1)
            Text('管理').fontColor($r('app.color.theme_color1'))
          }
          .onClick(()=>{
            this.isCompile=!this.isCompile
          })
          //新增
          Row() {
            Image($r('app.media.add')).width('5%').aspectRatio(1)
            Text('新增地址').fontColor($r('app.color.theme_color1'))
          }
          .onClick(()=>{
            //提示为新增地址
            this.isAddClick=true
            //打开弹窗
            this.isAmend = true
            //刷新弹窗里面的数据
            this.isAmendData= {}
            this.nowAddress=['北京市','市辖区','东城区']
          })
          .bindSheet($$this.isAmend, this.AddressAmend(this.isAmendData),{
            height:'70%',
            showClose:false,
          })
        }

      }.backgroundColor(Color.White).width('100%').padding(10)
      //地址列表
      if (this.AddressData.length !=0){
        this.AddressList()
      }
      else {
        Column(){
          Text('暂时还没有地址..')
        }.width('100%').height('100%').justifyContent(FlexAlign.Center)
      }
    }
    .width('100%').padding({bottom:10})
  }


  //地址列表
  @Builder AddressList(){
    List(){
      ForEach(this.AddressData,(item:AddressType,index)=>{
        ListItem(){
          Column(){
            Column({space:15}){
              //上面地址信息
              Row(){
                //地址
                Column({space:5}){
                  Text(`${item.province} ${item.city} ${item.district}`).fontSize(12).fontColor($r('app.color.font_GrayBlack'))
                  Text(item.streetname).fontSize(18).fontWeight(600)
                  Row({space:5}){
                    Text(`${item.takename} ${item.tel}`).fontSize(14).fontColor($r('app.color.font_black'))
                    if (item.isDefault){
                      Text('默认').fontSize(14).padding(3).borderRadius(5).fontColor(Color.White).backgroundColor($r('app.color.theme_color1'))
                    }
                  }
                }
                .alignItems(HorizontalAlign.Start)

                // 编辑按钮
                Image($r('app.media.write')).width('5%').aspectRatio(1)
                  .onClick(()=>{
                    this.isAmend = true
                    this.isAmendData=item

                    this.nowAddress=[item.province as string,item.city as string,item.district as string]
                  })
                  .bindSheet($$this.isAmend, this.AddressAmend(this.isAmendData),{
                    height:'70%',
                    showClose:false,
                  })
              }.width('100%').justifyContent(FlexAlign.SpaceBetween)

              //下面管理选项
              if (this.isCompile){
                Row(){
                  Row({space:5}){
                    Toggle({ type: ToggleType.Checkbox, isOn: item.isDefault })
                      .size({ width: 15, height:15 })
                      .selectedColor($r('app.color.theme_color1'))
                      .onChange(() => {
                        //设置默认
                        if (item.address_id) {
                          this.isDefault(item.address_id)
                        }
                      })
                    Text('默认').fontSize(14).fontColor($r('app.color.font_GrayBlack'))
                  }
                  Row({space:5}){
                    Text('删除').fontSize(14).padding(5).borderRadius(5).fontColor(Color.Black).backgroundColor($r('app.color.window_background'))
                      .onClick(()=>{
                        if (item.address_id) {
                          this.isDelete(item.address_id)
                        }
                      })
                    Text('复制').fontSize(14).padding(5).borderRadius(5).fontColor(Color.Black).backgroundColor($r('app.color.window_background'))
                  }
                }.width('100%').justifyContent(FlexAlign.SpaceBetween)
              }


            }
            .onClick(()=>{
              if (this.fromDetails) {
                //设为当前
                this.isActiveNum=index
                if (item.address_id) {
                  this.isActive(item.address_id)
                  this.AppPreferences?.putSync('ActiveAddressId', item.address_id);
                  this.AppPreferences?.flush();
                }

              }
            })
            .width('100%').backgroundColor(this.isActiveNum == index?'rgba(146, 169, 255,0.3)':Color.White).padding(10)
            Divider().strokeWidth(1)
          }
        }
      })
    }
  }

  //弹窗
  @Builder AddressAmend(item:AddressType){
    Column({space:10}){
      //头部
      Row(){
        Image($r('app.media.back')).width('6%').aspectRatio(1)
          .onClick(()=>{
            this.isAmend=false
            this.isAmendData={}
          })
        Text('编辑地址').fontSize(18).fontWeight(600)
      }.width('100%')

      Column({space:10}){
        //省市区
        Row({space:5}){
          Text('*').fontColor($r('app.color.theme_color1'))
          Text(`${this.nowAddress[0]} ${this.nowAddress[1]} ${this.nowAddress[2]}`)
        }.width('100%').padding({top:10,bottom:10})
        .onClick(()=>{
          //打开弹窗
          this.isTextPicker=true
        })
        .bindSheet($$this.isTextPicker, this.AddressTextPicker(),{
          height:'60%',
          showClose:false,
        })

        //详细地区
        Column(){
          Row({space:5}){
            Text('*').fontColor($r('app.color.theme_color1'))
            Text(`详细地址`)
            if (!this.streetname){
              Text(`请输入详细地址`).fontColor(Color.Red).fontSize(14)
            }
          }
          TextInput({text: this.isAddClick ?'':`${item.streetname}`}).backgroundColor('#f1f3f5')
            .onChange((value)=>{
              this.streetname=false
              if (value != '') {
                item.streetname=value
                this.streetname=true
              }
            })
          Divider().strokeWidth(1)
        }.width('100%').alignItems(HorizontalAlign.Start)

        //姓名
        Column(){
          Row({space:5}){
            Text('*').fontColor($r('app.color.theme_color1'))
            Text(`收货人姓名`)
            if (!this.takename){
              Text(`请输入收货人姓名`).fontColor(Color.Red).fontSize(14)
            }
          }
          TextInput({text: this.isAddClick ?'':`${item.takename}`}).backgroundColor('#f1f3f5')
            .onChange((value)=>{
              this.takename=false
              if (value != '') {
                item.takename=value
                this.takename=true
              }
            })
          Divider().strokeWidth(1)
        }.width('100%').alignItems(HorizontalAlign.Start)

        //手机号
        Column(){
          Row({space:5}){
            Text('*').fontColor($r('app.color.theme_color1'))
            Text(`手机号`)
            if (!this.phoNumber){
              Text(`请输入正确的手机号`).fontColor(Color.Red).fontSize(14)
            }
          }
          TextInput({text:`${item.tel}`}).type(InputType.Number).backgroundColor('#f1f3f5')
            .onChange((value)=>{
              let pattern = /^1[3-9]\d{9}$/;
              this.phoNumber=false
              if (pattern.test(value)){
                item.tel=value
                this.phoNumber=true
              }

            })
          Divider().strokeWidth(1)
        }.width('100%').alignItems(HorizontalAlign.Start)
      }.layoutWeight(1)


      //保存地址
      Button('保存地址').fontColor(Color.White).backgroundColor($r('app.color.theme_color1')).width('80%').margin({bottom:20})
        .onClick(()=>{
          //校验是否都写了
          if (this.streetname && this.takename && this.phoNumber) {
            item.province=this.nowAddress[0]
            item.city=this.nowAddress[1]
            item.district=this.nowAddress[2]
            if (this.isAddClick) {
              this.isAdd(this.isAmendData)
            }else {
              //先删除后新增

              this.isDelete(this.isAmendData.address_id as number)
              this.isAdd(this.isAmendData)
            }
          }
          this.isAddClick=false
          this.streetname=false
          this.takename=false
          this.phoNumber=false
        })


    }
    .width('100%')
    .padding({left:10,right:10,top:30})
  }

  //文字弹窗
  @Builder AddressTextPicker(){
    Column(){
      //头部
      Row(){
        Image($r('app.media.back')).width('6%').aspectRatio(1)
          .onClick(()=>{
            this.isTextPicker=false
          })
        Text('请选择所在地区').fontSize(18).fontWeight(600)
      }.width('100%')

      // 当前选择的省市区
      Column({space:10}){
        ForEach(this.nowAddress,(item:string,index)=>{
          Column(){
            Row(){
              Text(item)
              Image($r('app.media.go')).width('5%').aspectRatio(1)
            }.width('100%').justifyContent(FlexAlign.SpaceBetween).padding({bottom:10})
            Divider().strokeWidth(1)
          }
          .onClick(()=>{
            switch (index){
              case 0:
                //请求省列表
                this.getProvince()
                //清除后面两项
                this.nowAddress.length=1

                this.nowClick=0;
                break;
              case 1:
                // 请求市列表
                this.getCity(this.nowAddress[0])
                //清除后面一项
                this.nowAddress.length=2
                this.nowClick=1;
                break;
              case 2:
                //请求区列表
                this.getDistrict(this.nowAddress[0],this.nowAddress[1])
                this.nowClick=2
                break;
            }
          })
        })

      }.margin({top:10,bottom:10})


      //当前省市区结果列表
      Scroll(){
        List(){
          ForEach(this.nowList,(item:string)=>{
            ListItem(){
              Text(item)
            }
            .padding({top:5,bottom:5})
            .onClick(()=>{
              switch (this.nowClick){
                case 0:
                  this.nowAddress[0]=item
                  this.nowList=[]
                  this.getCity(item)
                  break;
                case 1:
                  this.nowAddress[1]=item
                  this.nowList=[]
                  this.getDistrict(this.nowAddress[0],item)
                  break;
                case 2:
                  this.nowAddress[2]=item
                  this.nowList=[]
                  break;
              }
            })
          })
        }
      }
      .layoutWeight(1)

      Button('确定').width('80%').fontColor(Color.White).backgroundColor($r('app.color.theme_color1')).margin({bottom:20})
        .onClick(()=>{
          console.log('地址',this.nowAddress)
          if (!this.nowAddress.includes("请选择")) {
            this.isAmendData.province=this.nowAddress[0]
            this.isAmendData.city=this.nowAddress[1]
            this.isAmendData.district=this.nowAddress[2]

            this.isTextPicker=false
          }
        })


    }
    .width('100%')
    .padding({left:10,right:10,top:30})

  }
}