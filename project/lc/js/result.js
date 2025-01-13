//用户地址列表
let userAddress = document.querySelector('.myaddress');
let userAddressUl = document.querySelector('.myaddress ul');

//结算清单
let resultUl = document.querySelector('.resultList ul');
let allPrice = document.querySelector('.allPrice');

//结算按钮
let buy = document.querySelector('.buy');

let nowProvince = '';
let nowCity = '';
let nowTown = '';

//监听是否登录
(function () {
    let modal = document.querySelector('.modal');
    modal.style.display = localStorage.getItem('token') ? 'none' : 'block';
    let log = document.querySelector('.log');
    let ret = document.querySelector('.ret');
    log.onclick = function () {
        location.href = `login.html`;
    }
    ret.onclick = function () {
        location.href = `index.html`;
    }
})();

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

            //点击支付
            buy.onclick = function () {
                console.log('支付');
                // 请求支付地址
                hc_ajax.ajax({
                    method: 'post',
                    url: BASE_URL + '/api_payment',
                    data: {
                        userId: localStorage.getItem('token'),
                        orderId: new Date().getTime(),
                        returnUrl: 'http://127.0.0.1:5500/order.html',
                        totalAmount: sumNum+'',
                        subject: `${res.data[0].goods_name}`,
                        body: `${res.data[0].goods_desc}`
                    },
                    ContentType: 'url',
                    success(res){
                        console.log(res);
                        if(res.code != 0){
                            console.log(res);
                            return;
                        };
                        // 获取支付地址成功
                        location.href = res.data;
                    }
                })
            }
            
        },
    })
})();

//默认初始化一次
getAddressList();
addModify();

// 地址添加
function addModify(modifyId, mdfName, mdfProvince, mdfCity, mdfArea, mdfAddrss, mdfPho) {
    //新增
    let isadd = document.querySelector('.isadd');
    let isaddIpt = document.querySelector('.isadd input');
    let addTable = document.querySelector('.addTable');
    //点击新增
    isaddIpt.onchange = function () {
        console.log(isaddIpt.checked);
        addTable.style.display = isaddIpt.checked ? 'block' : 'none';
    }

    //修改ID
    let modify = modifyId;

    //输入框
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


    if (modify != undefined) {
        username.value = mdfName;
        useraddress.value = mdfAddrss;
        userphone.value = mdfPho;

        isusername = true;
        isprovince = true;
        isuseraddress = true;
        isuserphone = true;
    }

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

                //验证是否是修改
                if (modify != undefined) {
                    nowProvince  = mdfProvince;
                    province.value = mdfProvince;
                    // 调用城市数据
                    getCity(mdfProvince, city);
                }

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
                    city.value = '';
                    area.value = '';
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

                ////验证是否是修改
                if (modify != undefined) {
                    city.value = mdfCity + '';
                    // 调用城市数据
                    getTown(mdfProvince, mdfCity, area);
                }

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
                    area.value = '';
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

                //验证是否是修改
                if (modify != undefined) {
                    area.value = mdfArea + '';
                }

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

    //保存/编辑地址
    save.onclick = function () {
        if (isusername && isprovince && isuseraddress && isuserphone) {
            //保存
            if (modify == undefined) {
                saveAddress()
            } else {
                //编辑（先删除后保存）
                //删除指定modifyId地址
                hc_ajax.ajax({
                    method: 'post',
                    url: BASE_URL + '/api_address',
                    data: {
                        status: 'deleteAddress',
                        userId: localStorage.getItem('token'),
                        addressId: modify,
                    },
                    ContentType: 'url',
                    success(dltres) {
                        console.log(dltres);
                        if (dltres.code != 0) {
                            console.log(dltres);
                            return;
                        };
                    }
                });
                //保存为新地址
                saveAddress();
                //出现
                isadd.style.display = 'block';
                isaddIpt.checked = false;
            }

        }
    }

    //保存方法
    function saveAddress() {
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
        isaddIpt.checked = false;
        username.value = '';
        province.value = '';
        city.style.display = 'none';
        area.style.display = 'none';
        city.value = '';
        area.value = '';
        useraddress.value = '';
        userphone.value = '';
    }


};

//地址操作
(function () {
    //监听父组件操作
    userAddressUl.addEventListener('click', function (event) {
        //删除
        if (event.target.classList.contains('dlt')) {
            let row = event.target.closest('li');
            console.log(row.getAttribute('address-id'));

            let isDlt = document.querySelector('.isDlt');
            isDlt.style.display ='block';
            let isyes = isDlt.querySelector('.isyes');
            let isno = isDlt.querySelector('.isno');
            isyes.onclick = function () {
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
                        //重新渲染
                        getAddressList()
                    }
                })
                isDlt.style.display ='none';
            }
            isno.onclick = function () {
                isDlt.style.display ='none';
            }


            //阻止了事件冒泡
            event.stopPropagation();
            return;
        }
        //编辑
        if (event.target.classList.contains('redact')) {
            let row = event.target.closest('li');
            // console.log(row.getAttribute('address-id'));
            // console.log(row.querySelector('.name').innerHTML);
            // console.log(row.querySelector('.pho').innerHTML);
            // console.log(row.querySelector('.location').innerHTML);
            // console.log(row.querySelector('.locationDtl').innerHTML);

            //1.下面输入框出现 2.新增地址勾选框隐藏，出现编辑地址提示字符 3.输入框获取当前li的值，判断是否为编辑
            //4.为编辑时点击保存后删除点击的li，再新增li到原本的位置

            let isadd = document.querySelector('.isadd');
            let addTable = document.querySelector('.addTable');
            addTable.style.display = 'block';
            isadd.style.display = 'none';
            //分割字符串
            let locationArray = row.querySelector('.location').innerHTML.split(' ')

            //调用编辑
            addModify(row.getAttribute('address-id'), row.querySelector('.name').innerHTML, locationArray[0], locationArray[1], locationArray[2], row.querySelector('.locationDtl').innerHTML, row.querySelector('.pho').innerHTML)


            //阻止了事件冒泡
            event.stopPropagation();
            return;
        }

        //设为默认（下面的字改变,提到最前面）
        if (event.target.classList.contains('default')) {
            let row = event.target.closest('li');
            console.log('点击了设为默认');
            //ie为true
            hc_ajax.ajax({
                method: 'post',
                url: BASE_URL + '/api_address',
                data: { status: 'defaultAddress', userId: localStorage.getItem('token'), addressId: row.getAttribute('address-id') },
                ContentType: 'url',
                success(res) {
                    console.log(res);
                    if (res.code != 0) {
                        console.log(res);
                        return;
                    };
                    //刷新列表
                    getAddressList()
                }
            })

            //阻止了事件冒泡
            event.stopPropagation();
            return;
        };

        // 设为当前
        if (event.target.closest('li')) {
            let row = event.target.closest('li');
            console.log(row.getAttribute('address-id'));
            //isActive为true
            hc_ajax.ajax({
                method: 'post',
                url: BASE_URL + '/api_address',
                data: { status: 'activeAddress', userId: localStorage.getItem('token'), addressId: row.getAttribute('address-id') },
                ContentType: 'url',
                success(res) {
                    console.log(res);
                    if (res.code != 0) {
                        console.log(res);
                        return;
                    };
                    //刷新列表
                    getAddressList()
                }
            })

        };

    });

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
            //调用渲染方法
            renderAddressList(res.data);
        },
    })




}
//地址列表渲染方法
function renderAddressList(data) {

    if (data.length == 0) {
        userAddressUl.innerHTML = `<p class='noAddress'>暂无地址，快去添加收货地址吧</p>`;
        return;
    };

    //排序，isDefault为true的值放前面
    data.sort((a, b) => {
        return (b.isDefault === true) - (a.isDefault === true);
    });


    let str = '';
    data.forEach(item => {
        str += `
            <li address-id="${item.address_id}" class="${item.isActive ? 'isActive' : ''}">
                <div class="tle">
                    <span class="name">${item.takename}</span>
                    <span class="pho">${item.tel}</span>
                </div>
                <div class="con">
                    <p class="location" >${item.province} ${item.city} ${item.district}</p>
                    <p class="locationDtl">${item.streetname}</p>
                </div>
                <div class="opt">
                    <div class="default ${item.isDefault ? 'isDefault' : ''}">${item.isDefault ? '默认地址' : '设为默认'}</div>
                    <div>
                        <span class="redact">编辑</span>
                        <span class="dlt">删除</span>
                    </div>
                </div>
            </li>
        `
    })
    userAddressUl.style.width = data.length * 250 + 'px';
    userAddressUl.style.left = '0px'
    userAddressUl.innerHTML = str;
    console.log(data.length);


    //地址列表移动
    move(data.length)
}
//地址列表移动
function move(length) {
    let prev = document.querySelector('.prev');
    let next = document.querySelector('.next');
    //移动下标
    let num = 0;

    if (length <= 4) {
        userAddressUl.style.left = '0px'
        prev.onclick = null;
        next.onclick = null;
    } else {
        console.log('触发了');

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
            num = num >= length - 4 ? length - 4 : num;
            userAddressUl.style.transition = '.5s';
            userAddressUl.style.left = (-250 * num) + 'px'
        };
    }
}
