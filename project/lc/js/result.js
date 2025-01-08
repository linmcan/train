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

//地址
(function () {
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

        },
    })


    // 地址添加
    addAddresss()

    //地址列表渲染方法
    function renderAddressList(data) {
        let str = '';
        data.forEach(item => {
            str += `
                <li address-id="${item.address_id}" class="list ${item.isActive ? 'isActive' : ''}">
                    <div class="tle">
                        <span class="name">hc</span>
                        <span class="pho">18074336440</span>
                    </div>
                    <div class="con">
                        <p class="location">湖南 长沙</p>
                        <p class="locationDtl">11111111111111111111111111111111111</p>
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
        userAddressUl.innerHTML = str;
    }
})();

// 地址添加方法
function addAddresss() {
    //新增
    let isadd = document.querySelector('.isadd input');
    let addTable = document.querySelector('.addTable');
    //点击新增
    isadd.onchange = function () {
        console.log(isadd.checked);
        addTable.style.display = isadd.checked ? 'block' : 'none';
    }

    //新增输入
    let province = addTable.querySelector('.province');
    let city = addTable.querySelector('.city');
    let area = addTable.querySelector('.area');
    // 获取省市区

    // 默认调用省
    getProvince();

    // 请求省
    function getProvince() {
        hc_ajax.ajax({
            method:'get',
            url: BASE_URL + '/api_country',
            data: {},
            success(res) {
                console.log(res);
                if (res.code != 0) {
                    console.log(res);
                    return;
                };
                city.style.display='none';
                area.style.display='none';

                //dom
                let str = '<option value="">--请选择省--</option>';
                res.data.forEach(item => {
                    str += `<option value="${item.name}">${item.name}</option>`;
                });
                // 添加到页面
                province.innerHTML = str;

                province.onchange = function () {
                    nowProvince = this.value;
                    city.style.display='none';
                    area.style.display='none';
                    // 调用城市数据
                    getCity(this.value, city);
                }
            }
        });
    };
    // 请求城市
    function getCity(province, dom) {
        hc_ajax.ajax({
            method:'get',
            url: BASE_URL + '/api_country',
            data: { province },
            success(res) {
                // console.log(res);
                if (res.code != 0) {
                    console.log(res);
                    return;
                };
                city.style.display='inline';

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
                    // 调用区方法
                    getTown(nowProvince, nowCity, area);
                }
            }
        });
    };
    // 请求区
    function getTown(province, city, dom) {
        hc_ajax.ajax({
            method:'get',
            url: BASE_URL + '/api_country',
            data: { province, city },
            success(res) {
                console.log(res);
                if (res.code != 0) {
                    console.log(res);
                    area.style.display='none';
                    return;
                };
                area.style.display='inline';

                //dom
                let str = '<option value="">--请选择区--</option>';
                let dataTown = res.data.area || res.data;
                dataTown.forEach(item => {
                    str += `<option value="${item.name}">${item.name}</option>`;
                });
                // 添加到页面
                dom.innerHTML = str;
                dom.onchange = function () {
                    nowTown = this.value;
                }
            }
        });
    };


}




