let orderTable = document.querySelector('.order-table');

let orderStu = document.querySelector('.status');
let orderNostu = document.querySelector('.noStatus');

let seachIpt = document.querySelector('.seachIpt');
let seach = document.querySelector('.seach');


let ison = true;
let isStatus = true;

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

(function () {
    let tradeNo = hc_ajax.getUrlValue('trade_no');
    console.log(tradeNo);
    //支付订单查询
    hc_ajax.ajax({
        method: 'post',
        url: 'http://110.41.43.118:3008/api_payquery',
        data: {
            userId: localStorage.getItem('token'),
            tradeNo
        },
        ContentType: 'url',
        success(res) {
            console.log(res);
            if (res.code != 0) {
                console.log(res);
                return;
            };

            getOrder(isStatus)

        }
    })
    //刷新的时候获取用户订单列表，默认渲染完成的订单
    getOrder(isStatus);

    //点击选择已支付、未支付列表
    orderStu.onclick = function () {
        isStatus = true;
        orderStu.classList.add('ison');
        orderNostu.classList.remove('ison');

        getOrder(isStatus)
    };
    orderNostu.onclick = function () {
        isStatus = false;
        orderNostu.classList.add('ison');
        orderStu.classList.remove('ison');

        getOrder(isStatus)
    };

    //点击搜索
    seach.onclick = function () {
        console.log(seachIpt.value);
        getOrder(isStatus, seachIpt.value)
        seachIpt.value = ''
    }
    // 在输入框中监听键盘按下事件
    seachIpt.addEventListener('keydown', function (event) {
        if (event.key === 'Enter') {
            console.log(seachIpt.value);
            getOrder(isStatus, seachIpt.value);
            seachIpt.value = ''
        }
    });


    
    orderTable.addEventListener('click', function (event) {
        //点击删除
        if (event.target.classList.contains('dlt')) {
            let row = event.target.closest('tr');
            console.log(row.getAttribute('trade_no'));

            hc_ajax.ajax({
                method: 'post',
                url: BASE_URL + '/api_order',
                data: {
                    status: 'delorder',
                    userId: localStorage.getItem('token'),
                    tradeNo: row.getAttribute('trade_no')
                },
                ContentType: 'url',
                success(res) {
                    console.log(res);
                    if (res.code != 0) {
                        console.log(res);
                        return;
                    };
                    //更新uI
                    row.remove()
                    getOrder(isStatus)
                }
            })
        }

        //点击详细
        if (event.target.classList.contains('more')){
            let row = event.target.closest('tr');
            let moreMsg =document.querySelectorAll('.moreMsg');        
            for (let index = 0; index < moreMsg.length; index++) {
                if (moreMsg[index].getAttribute('trade_no') == row.getAttribute('trade_no')) {
                    moreMsg[index].style.display = ison?'table-row':'none';
                    ison=!ison;
                    console.log(ison);
                }
            }
            event.target.textContent = ison ? '详细':'收起';
        }
    })







    //获取订单列表
    function getOrder(isStatus, searchTradeNo) {
        hc_ajax.ajax({
            method: 'post',
            url: 'http://110.41.43.118:3008/api_order',
            data: {
                userId: localStorage.getItem('token'),
                status: 'vieworder'
            },
            ContentType: 'url',
            success(res) {
                console.log(res);
                if (res.code != 0) {
                    console.log(res);
                    return;
                };

                if (res.data.length == 0) {
                    orderTable.innerHTML = `
                        <tr>
                            <td colspan="7" class="nothing">您还有购买任何商品哦，～_～！</td>
                        </tr>
                    `
                }

                let str = `<tr>
                    <th>良品</th>
                    <th>单价（元）</th>
                    <th>数量</th>
                    <th>订单编号</th>
                    <th>订单金额</th>
                    <th>交易状态</th>
                    <th></th>
                </tr>`;

                let row = isStatus ? '支付成功' : '未支付'
                let hasData = false;
                res.data.forEach(item => {
                    if (item.status === row) {
                        //模糊查询
                        if (!searchTradeNo || item.trade_no.includes(searchTradeNo)) {
                            hasData = true;
                            let orderItem = '';
                            let orderPrice = '';
                            let orderNum = '';
                            let price = 0;
                            item.goods.forEach(item1 => {
                                orderItem += `
                                    <div class="orderItem">
                                        <a href=""><img src="${item1.goods_thumb}" alt=""></a>
                                        <div class="info">
                                            <p><a href="">品牌 ／ ${item1.brand_name}</a></p>
                                            <p><a href="">${item1.goods_name}</a></p>
                                        </div>
                                    </div>
                                `
                                orderPrice += ` <div class="orderPrice">${parseInt(item1.price * 0.9)}.00</div>`
                                orderNum += ` <div class="orderNum">${item1.goods_number}</div>`
                                price += parseInt(item1.price * 0.9) * item1.goods_number
                            })

                            let orderMore = `
                            <div class="msg">
                                <p>姓名：${item.order_address ? item.order_address.takename : ''}</p>
                                <p>电话号码：${item.order_address ? item.order_address.tel : ''}</p>
                                <p>住址：${item.order_address ? 
                                    `${item.order_address.province} ${item.order_address.city} ${item.order_address.district} ${item.order_address.streetname}` : ''}</p>
                            </div>
                        `;
                        


                            str += `
                                <tr trade_no='${item.trade_no}'>
                                    <td>${orderItem}</td>
                                    <td>${orderPrice}</td>
                                    <td>${orderNum}</td>
                                    <td>${item.trade_no}</td>
                                    <td>${price}.00</td>
                                    <td>${item.status}</td>
                                    <td>
                                        <button class="dlt">删除</button>
                                        <button class="more">详细</button>
                                    </td>
                                    
                                </tr>
                                <tr class='moreMsg' trade_no='${item.trade_no}'>
                                    <td colspan="7">${orderMore}</td>
                                </tr>
                            `
                        }

                    }

                })

                //如果str没有加东西
                if (!hasData) {
                    // 如果 str 为空，显示提示信息
                    orderTable.innerHTML = `
                        <tr>
                            <td colspan="7" class="nothing">没有找到任何商品哦，点此 <a>刷新</a></td>
                        </tr>`;
                    // 列表刷新
                    let reSeach = document.querySelector('.nothing a')
                    reSeach.onclick = function () {
                        getOrder(isStatus)
                    }
                } else {
                    // 如果 str 不为空，将生成的 HTML 插入到表格中
                    orderTable.innerHTML = str;
                }

            }
        })
    }

})();