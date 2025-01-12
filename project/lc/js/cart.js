let cartTable = document.getElementById('cart-table');
let buy = document.querySelector('.buy');
//监听是否登录
(function () {
    let modal = document.querySelector('.modal');
    modal.style.display = localStorage.getItem('token') ? 'none' : 'block';
    let log = document.querySelector('.log');
    let ret = document.querySelector('.ret');
    log.onclick = function(){
        location.href = `login.html`;
    }
    ret.onclick = function(){
        location.href = `index.html`;
    }
})();

(function () {
    hc_ajax.ajax({
        method: 'post',
        url: BASE_URL + '/api_cart',
        data: { userId: TOKEN, status: 'viewcart' },
        ContentType: 'url',
        success(res) {
            console.log(res);
            if (res.code != 0) {
                console.log(res);
                return;
            };
            //渲染购物车
            let cartData = `
                <tr>
                    <th><input type="checkbox" placeholder="#" class='selectall'> 全选</th>
                    <th>良品</th>
                    <th>数量</th>
                    <th>单价（元）</th>
                    <th>小计（元）</th>
                    <th>操作</th>
                </tr>
            `;
            res.data.forEach(item => {
                cartData += `
                    <tr class='goodsTr'>
                        <td><input type="checkbox" placeholder="#" class='check' goodsId ='${item.goods_id}'></td>
                        <td>
                            <div class="goodsitem">
                                <a href="detail.html?goodsId=${item.goods_id}&catId=${item.cat_id}"><img src="${item.goods_thumb}" alt=""></a>
                                <div class="info">
                                    <p class="sp-name">${item.goods_name}</p>
                                </div>
                            </div>
                        </td>
                        <td class='mopt'>
                            <span class='subtract' goodsId ='${item.goods_id}'>-</span> 
                            <input placeholder="#" type="text" value="${item.goods_number}" class='moptNum' readonly>
                            <span class='add' goodsId ='${item.goods_id}'>+</span>
                            <!--<p>已售空，即将到货</p>-->
                        </td>
                        <td>${parseInt(item.price * 0.9)}.00</td>
                        <td class='sum' price='${parseInt(item.price * 0.9)}'> ${parseInt(item.price * 0.9) * item.goods_number}.00</td>
                        <td><span class='dlt' goodsId ='${item.goods_id}'>删除</span></td>
                    </tr>
                `;
            })
            cartTable.innerHTML = cartData;
            cartOpera();
        }
    })
})();

//购物车操作
function cartOpera() {
    //监听父组件点击方法
    cartTable.addEventListener('click', function (event) {
        //全选
        if (event.target.classList.contains('selectall')) {
            console.log(event.target.checked);
            let check = document.getElementsByClassName('check');
            for (let i = 0; i < check.length; i++) {
                check[i].checked = event.target.checked;
                check[i].setAttribute('check', event.target.checked ? 'checked' : '');
            }
            getPriceAll()
        }
        //单选
        if (event.target.classList.contains('check')) {
            event.target.setAttribute('check', event.target.checked ? 'checked' : '');
            //全选框判断
            let check = document.getElementsByClassName('check');
            let selectall = document.querySelector('.selectall')
            let allChecked = Array.from(check).every(i => i.checked);
            selectall.checked = allChecked;

            getPriceAll()
        }
        //加减按钮
        if (event.target.classList.contains('subtract') || event.target.classList.contains('add')) {
            let numDom = event.target.closest('.mopt').querySelector('.moptNum');
            let num = parseInt(numDom.value);
            //减
            if (event.target.classList.contains('subtract')) {
                num--;
                num = num <= 1 ? 1 : num;

                numDom.value = num;

            }
            //加
            if (event.target.classList.contains('add')) {
                num++;
                num = num >= 10 ? 10 : num;

                numDom.value = num;
            }

            //重新改变购物车
            hc_ajax.ajax({
                method: 'post',
                url: BASE_URL + '/api_cart',
                data: { status: 'addcart', goodsId: event.target.getAttribute('goodsId'), userId: localStorage.getItem('token'), goodsNumber: num, },
                ContentType: 'url',
                success(res) {
                    if (res.code != 0) {
                        console.log(res);
                        return;
                    };
                    // 更新头部的购物车
                    getCartValue();
                    //更新小计dom
                    let parent = event.target.closest('.goodsTr');
                    let priceDom = parent.querySelector('.sum');
                    let price = parseFloat(priceDom.getAttribute('price'))
                    priceDom.innerHTML = num * price + '.00'
                    //调用总价
                    getPriceAll()
                },
            })
        }

        // 删除按钮
        if (event.target.classList.contains('dlt')) {
            // 找到最近的 goods-tr 元素
            let row = event.target.closest('.goodsTr');
            if (row) {
                row.remove(); // 删除
            }
            hc_ajax.ajax({
                method: 'post',
                url: BASE_URL + '/api_cart',
                data: {
                    status: 'delcart',
                    userId: localStorage.getItem('token'),
                    goodsId: event.target.getAttribute('goodsId'),
                },
                ContentType: 'url',
                success(res) {
                    console.log(res);
                    if (res.code != 0) {
                        console.log(res);
                        return;
                    };

                    // 更新头部的购物车
                    getCartValue();
                }
            })

            getPriceAll()
        }
    });

    //总价方法
    function getPriceAll() {
        let checkAll = document.querySelectorAll('[check="checked"]');
        //总价dom和数字
        let priceAllDom = document.querySelector('.allSum');
        let priceAllNum = 0;

        checkAll.forEach(item => {
            // // 获取当前勾选项的父级元素
            let parent = item.closest('.goodsTr');

            let mopt = parent.querySelector('.mopt');
            let numDom = mopt.querySelector('input');

            let priceDom = parent.querySelector('.sum');

            let num = numDom.value;
            let price = parseFloat(priceDom.getAttribute('price'))
            priceAllNum += num * price;
        });
        // 设置
        priceAllDom.innerHTML = '¥' + priceAllNum + '.00';
    }

    //结算按钮
    buy.onclick = function () {
        let checkAll = document.querySelectorAll('[check="checked"]');
        if (checkAll.length == 0) {
            //提示框
            let nogoods = document.querySelector('.nogoods');
            nogoods.style.display = 'block';
            let btn = nogoods.querySelector('span');
            btn.onclick = function () {
                nogoods.style.display = 'none'; 
            }
            return;
        };

        let goodsIdArr = [];
        checkAll.forEach(item => {
            goodsIdArr.push(item.getAttribute('goodsId'));
        });
        let goodsId = goodsIdArr.join('&');
        console.log(goodsId);

        hc_ajax.ajax({
            method: 'post',
            url: BASE_URL + '/api_settlement',
            data: {
                status : 'addsettlement',
                userId : localStorage.getItem('token'),
                from : 'cart',
                goodsId: goodsId,
            },
            ContentType: 'url',
            success(res){
                    console.log(res);
                    if(res.code != 0){
                        console.log(res);
                        return;
                    };
                    
                    //跳转到地址页面
                    location.href = 'result.html';
            }
        })
        
    }

};



