//用户地址列表
let userAddress = document.querySelector('.myaddress');
let userAddressUl = document.querySelector('.myaddress ul');

//结算清单
let resultUl = document.querySelector('.resultList ul');
let allPrice = document.querySelector('.allPrice');

let nowProvince = '';
let nowCity = '';
let nowTown = '';

//请求结算清单
(function () {
    hc_ajax.ajax({
        method: 'post',
        url: BASE_URL + '/api_settlement',
        data: { status: 'getsettlement', userId: TOKEN },
        ContentType: 'url',
        success(res) {
            console.log(res);
            if (res.code != 0) {
                console.log(res);
                return;
            };

            let str = '';
            //渲染结算清单
            res.data.forEach(item => {
                str += `
                    <li class="resultGoods">
                        <div class="imgCon">
                            <a href="detail.html?goodsId=${item.goods_id}&catId=${item.cat_id}"><img src="${item.goods_thumb}" alt=""></a>
                        </div>
                        <div class="infoCon">
                            <div class="l">
                                <p class="name">${item.goods_name}</p>
                                <p class="price">单价：${parseInt(item.price * 0.9)}</p>
                            </div>
                            <div class="r">
                                <span class="number">数量：${item.goods_number}</span>
                                <span class="sumPrice">¥${parseInt(item.price * 0.9) * item.goods_number}.00</span>
                            </div>
                        </div>
                    </li>
                `
            });
            resultUl.innerHTML = str;

            //计算总价
            let sumPrice = document.querySelectorAll('.sumPrice');
            let sumNum = 0;
            for (let i = 0; i < sumPrice.length; i++) {
                sumNum += parseInt(sumPrice[i].innerHTML.replace(/¥/g, ''));
            }
            allPrice.innerHTML = sumNum + '.00';

        },
    })
})();

//默认初始化一次
getAddressList();

// 地址添加
(function () {
    //新增
    let isadd = document.querySelector('.isadd input');
    let addTable = document.querySelector('.addTable');
    //点击新增
    isadd.onchange = function () {
        console.log(isadd.checked);
        addTable.style.display = isadd.checked ? 'block' : 'none';
    }

    //新增输入
    let username = addTable.querySelector('.username');
    let province = addTable.querySelector('.province');
    let city = addTable.querySelector('.city');
    let area = addTable.querySelector('.area');
    let useraddress = addTable.querySelector('.useraddress');
    let userphone = addTable.querySelector('.userphone');

    let save = addTable.querySelector('.save')

    //判断是否输入
    let isusername = false;
    let isprovince = false;
    let isuseraddress = false;
    let isuserphone = false;

    //用户名判断
    username.onblur = function () {
        username.style.border = username.value.length == 0 ? 'red 2px solid' : ' #dedede  2px solid';
        isusername = username.value.length == 0 ? false : true;
    }
    // 获取省市区
    getProvince();
    // 请求省
    function getProvince() {
        hc_ajax.ajax({
            method: 'get',
            url: BASE_URL + '/api_country',
            data: {},
            success(res) {
                console.log(res);
                if (res.code != 0) {
                    console.log(res);
                    return;
                };

                city.style.display = 'none';
                area.style.display = 'none';
                //dom
                let str = '<option value="">--请选择省--</option>';
                res.data.forEach(item => {
                    str += `<option value="${item.name}">${item.name}</option>`;
                });
                // 添加到页面
                province.innerHTML = str;




                province.onchange = function () {
                    nowProvince = this.value;
                    city.style.display = 'none';
                    area.style.display = 'none';
                    this.style.outline = this.value == '' ? 'red 1px solid' : 'none';
                    isprovince = this.value == '' ? false : true;
                    // 调用城市数据
                    getCity(this.value, city);
                }
            }
        });
    };
    // 请求城市
    function getCity(province, dom) {
        hc_ajax.ajax({
            method: 'get',
            url: BASE_URL + '/api_country',
            data: { province },
            success(res) {
                // console.log(res);
                if (res.code != 0) {
                    console.log(res);
                    return;
                };
                city.style.display = 'inline';

                let datas = res.data.area || res.data;
                //dom
                let str = '<option value="">--请选择市--</option>';
                datas.forEach(item => {
                    str += `<option value="${item.name}">${item.name}</option>`;
                });
                // 添加到页面
                dom.innerHTML = str;

                dom.onchange = function () {
                    nowCity = this.value;
                    this.style.outline = this.value == '' ? 'red 1px solid' : 'none';
                    // 调用区方法
                    getTown(nowProvince, nowCity, area);
                }
            }
        });
    };
    // 请求区
    function getTown(province, city, dom) {
        hc_ajax.ajax({
            method: 'get',
            url: BASE_URL + '/api_country',
            data: { province, city },
            success(res) {
                console.log(res);
                if (res.code != 0) {
                    console.log(res);
                    area.style.display = 'none';
                    return;
                };
                area.style.display = 'inline';

                //dom
                let str = '<option value="">--请选择区--</option>';
                let dataTown = res.data.area || res.data;
                dataTown.forEach(item => {
                    str += `<option value="${item.name}">${item.name}</option>`;
                });
                // 添加到页面
                dom.innerHTML = str;
                dom.onchange = function () {
                    this.style.outline = this.value == '' ? 'red 1px solid' : 'none';
                    nowTown = this.value;
                }
            }
        });
    };
    //详细地址判断
    useraddress.onblur = function () {
        useraddress.style.border = useraddress.value.length == 0 ? 'red 2px solid' : ' #dedede  2px solid';
        isuseraddress = useraddress.value.length == 0 ? false : true;
    }
    //电话号码判断
    userphone.onblur = function () {
        let res = /^1[3-9]\d{9}$/;
        userphone.style.border = (userphone.value.length == 0 || !res.test(userphone.value)) ? 'red 2px solid' : ' #dedede  2px solid';
        isuserphone = (userphone.value.length == 0 || !res.test(userphone.value)) ? false : true;
    }

    //保存地址
    save.onclick = function () {
        if (isusername && isprovince && isuseraddress && isuserphone) {
            //保存
            // console.log(username.value, province.value, city.value, area.value, useraddress.value, userphone.value);
            hc_ajax.ajax({
                method: 'post',
                url: BASE_URL + '/api_address',
                data: {
                    status: 'addAddress',
                    userId: localStorage.getItem('token'),
                    province: province.value,
                    city: city.value,
                    district: area.value,
                    streetname: useraddress.value,
                    takename: username.value,
                    tel: userphone.value,
                },
                ContentType: 'url',
                success(res) {
                    console.log(res);
                    if (res.code != 0) {
                        console.log(res);
                        return;
                    };
                    getAddressList();
                }
            });

            addTable.style.display = 'none';
            isadd.checked = false;
            username.value = '';
            province.value = '';
            city.style.display = 'none';
            area.style.display = 'none';
            city.value = '';
            area.value = '';
            useraddress.value = '';
            userphone.value = '';
        }
    }


})();

//获取地址
function getAddressList() {
    //请求用户地址
    hc_ajax.ajax({
        method: 'post',
        url: BASE_URL + '/api_address',
        data: { status: 'getAddress', userId: localStorage.getItem('token') },
        ContentType: 'url',
        success(res) {
            console.log(res);
            if (res.code != 0) {
                console.log(res);
                return;
            };


            if (res.data.length == 0) {
                userAddress.innerHTML = `<p>暂无地址，快去添加收货地址吧</p>`;
                return;
            };

            //调用渲染方法
            renderAddressList(res.data);

            //地址操作，监听父组件操作
            userAddressUl.addEventListener('click', function (event) {
                //删除
                if (event.target.classList.contains('dlt')) {
                    let row = event.target.closest('li');
                    console.log(row.getAttribute('address-id'));

                    //更新后台
                    hc_ajax.ajax({
                        method: 'post',
                        url: BASE_URL + '/api_address',
                        data: {
                            status: 'deleteAddress',
                            userId: localStorage.getItem('token'),
                            addressId: row.getAttribute('address-id')
                        },
                        ContentType: 'url',
                        success(dltres) {
                            console.log(dltres);
                            if (dltres.code != 0) {
                                console.log(dltres);
                                return;
                            };
                            //移除dom节点
                            row.remove()
                            //判断是否为空
                            if (res.data.length == 0) {
                                userAddress.innerHTML = `<p>暂无地址，快去添加收货地址吧</p>`;
                                return;
                            };

                        }
                    })
                }
            });
            //删除


            //编辑

            //设为默认
        },
    })




}
//地址列表渲染方法
function renderAddressList(data) {
    let str = '';
    data.forEach(item => {
        str += `
            <li address-id="${item.address_id}" class="list ${item.isActive ? 'isActive' : ''}">
                <div class="tle">
                    <span class="name">${item.takename}</span>
                    <span class="pho">${item.tel}</span>
                </div>
                <div class="con">
                    <p class="location">${item.province} ${item.city} ${item.district}</p>
                    <p class="locationDtl">${item.streetname}</p>
                </div>
                <div class="opt">
                    <div class="isdefault">默认地址</div>
                    <div>
                        <span class="redact">编辑</span>
                        <span class="dlt">删除</span>
                    </div>
                </div>
            </li>
        `
    })
    userAddressUl.style.width = data.length * 250 + 'px';
    userAddressUl.innerHTML = str;

    //地址列表移动
    let prev = document.querySelector('.prev');
    let next = document.querySelector('.next');
    //移动下标
    let num = 0;
    //上一个
    prev.onclick = function () {
        num--;
        num = num <= 0 ? 0 : num;
        userAddressUl.style.transition = '.5s';
        userAddressUl.style.left = (-250 * num) + 'px'
    };
    //下一个
    next.onclick = function () {
        num++;
        num = num >= data.length - 4 ? data.length - 4 : num;
        userAddressUl.style.transition = '.5s';
        userAddressUl.style.left = (-250 * num) + 'px'
    };




}


