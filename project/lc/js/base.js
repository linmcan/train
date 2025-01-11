const BASE_URL = 'http://110.41.43.118:3008';
// 登录状态
const USERNAME = localStorage.getItem('username');
const TOKEN = localStorage.getItem('token');

//获取元素
//登录注册
let login = document.querySelector('.login');
let register = document.querySelector('.register');
//用户
let user = document.querySelector('.user');
let loginUser = user.querySelector('span');
let loginout = user.querySelector('.user-subnav .user-btn');
//购物车
let cartSub = document.querySelector('.cart-subnav');
let cartMsg = cartSub.querySelector('.cart-msg');
let cartlist = cartSub.querySelector('.cart-list')
let cartBtn = cartSub.querySelector('.cart-btn')

//导航栏商店子菜单部分
let shopNav = document.querySelector('.shop-subnav');
let shopUl = shopNav.querySelector('ul');
let shopLi = shopUl.getElementsByClassName('cat');//所有导航分类
//搜索部分
let search = document.querySelector('.search-content');
let searchInput = search.querySelector('input');
let searchA = search.querySelector('a');


//请求元素全局变量
let catData = {};//商品导航
let classifyData = {};//商品子导航


// 验证登录状态
(function () {

    // 封装交互状态
    function loginStatusRender(isLogin, isLoginout, txt) {
        user.style.display = isLogin;
        loginUser.innerHTML = `${txt}`;

        login.style.display = isLoginout;
        register.style.display = isLoginout;
    };

    if (USERNAME && TOKEN) {
        loginStatusRender('block', 'none', USERNAME);

        // 调用获取购物车数据方法
        getCartValue();

    } else {
        loginStatusRender('none', 'block', '');
    };

    //点击退出按钮
    loginout.onclick = function () {
        // 清除本地存储
        localStorage.removeItem('username');
        localStorage.removeItem('token');
        // 交互
        loginStatusRender('none', 'block', '');
        // // 显示暂无购物车
        cartMsg.style.display = 'block';
        cartlist.style.display = 'none';
    };



    //点击登录按钮
    login.onclick = function () {
        let goodsId = hc_ajax.getUrlValue('goodsId');
        let catId = hc_ajax.getUrlValue('catId');
        let catName = hc_ajax.getUrlValue('catName');
        console.log('参数' + goodsId, catId);

        // 带参数的跳转
        if (catId) {
            location.href = `login.html?catName=${catName}&catId=${catId}`
        } else {
            location.href = goodsId ? `login.html?goodsId=${goodsId}` : 'login.html';
        }


    };

    //点击注册
    register.onclick = function () {
        let goodsId = hc_ajax.getUrlValue('goodsId');
        let catId = hc_ajax.getUrlValue('catId');
        let catName = hc_ajax.getUrlValue('catName');
        if (catId) {
            window.location.href = `register.html?catName=${catName}&catId=${catId}`;
        } else {
            window.location.href = goodsId ? `register.html?goodsId=${goodsId}` : 'register.html';
        }
    }


})();

//购物车方法
function getCartValue() {

    hc_ajax.ajax({
        method: 'post',
        url: BASE_URL + '/api_cart',
        data: { userId: TOKEN, status: 'viewcart' },
        ContentType: 'url',
        success(res) {
            if (res.code != 0) {
                console.log(res);
                return;
            };

            //购物车验证
            let cartCount = res.data.length;
            if (cartCount == 0) {
                // 显示暂无购物车
                cartMsg.style.display = 'block';
                cartlist.style.display = 'none';
                cartBtn.innerHTML = '快去抢购物良仓商品吧！';
                cartBtn.onclick = function () {
                    location.href = `category.html?catName=新品`;
                };
                return;
            };

            //购物车有商品
            cartMsg.style.display = 'none';
            cartlist.style.display = 'block';
            cartBtn.innerHTML = '点击购买';
            cartBtn.onclick = function () {
                location.href = `cart.html`;
            };

            //DOM组装
            let str = '';
            res.data.forEach(item => {
                str += `
					<li class="goods">
						<a href="detail.html?goodsId=${item.goods_id}&catId=${item.cat_id}"><img src="${item.goods_thumb}" alt="" /></a>
						<div>
							<p>${item.goods_name}</p>
							<p>服装尺码:S;颜色:米白/黑;</p>
							<p>
								<span>数量：${item.goods_number}件</span>
								<span>¥${parseInt(item.price * 0.9)}.00</span>
								<span>¥${item.price}.00</span>
							</p>
						</div>
					</li>
				`;
            });

            // 添加到页面
            cartlist.innerHTML = str;
        }
    })
};

//请求商品分类导航的数据
(function () {
    hc_ajax.ajax({
        method: 'get',
        url: BASE_URL + '/api_cat',
        success(res) {
            console.log(res);
            // 验证请求结果
            if (res.code != 0) {
                console.log(res);
                return;
            };

            //想要的结果
            catData = res.data;

            //遍历操作
            let str = '';
            catData.forEach(item => {
                // 累加数据
                str += `
                    <li class='cat'>
                        <a href="category.html?catId=${item.cat_id}&catName=${item.cat_name}" catId='${item.cat_id}'>
                            <img src="${item.cat_img}" alt="" />
                            <p>${item.cat_name}</p>
                        </a>
                    </li>
                `;
            });
            // 添加到对应的结构
            shopUl.innerHTML = str;
        }
    });
})();

//请求商品分类导航的小分类数据
(function () {
    hc_ajax.ajax({
        method: 'get',
        url: BASE_URL + '/api_classify',
        success(res) {
            console.log(res);
            // 数据
            classifyData = res.data;
            //插入小分类的li
            let listChild = document.createElement('li');
            listChild.className = 'listChild';
            let children = shopUl.children;
            //插入子导航合集
            shopUl.insertBefore(listChild.cloneNode(true), children[7]);
            shopUl.insertBefore(listChild.cloneNode(true), children[15]);
            shopUl.insertBefore(listChild.cloneNode(true), children[17]);
            //获取所有子导航合集
            let shopliChild = shopNav.querySelectorAll('ul .listChild');

            // 思路：鼠标移入对应菜单栏的时候，对catID进行匹配，再将数据放进对应listChild里面
            //遍历所有导航分类
            for (let index = 0; index < shopLi.length; index++) {
                //鼠标移入导航栏
                shopLi[index].onmouseenter = function () {
                    //遍历子导航数据
                    for (let i = 0; i < classifyData.length; i++) {
                        //匹配cat_id                  
                        if (catData[index].cat_id === classifyData[i].cat_id) {
                            //生成插入数据
                            let str = '';
                            classifyData[i].data.forEach(item => {
                                str += `<a href="">${item.product_content}</a>`
                            })
                            //进行插入,移入显示
                            let location = parseInt(index / 7)
                            shopliChild[location].innerHTML = str;
                            shopliChild[location].style.display = 'block'
                        }
                    }
                };
                //鼠标移出导航栏
                shopLi[index].onmouseleave = function () {
                    let location = parseInt(index / 7)
                    shopliChild[location].style.display = 'none'
                };
            }
            // 保证移入子导航栏还能显示
            for (let i = 0; i < shopliChild.length; i++) {
                shopliChild[i].onmouseenter = function () {
                    shopliChild[i].style.display = 'block'
                };
                shopliChild[i].onmouseleave = function () {
                    shopliChild[i].style.display = 'none'
                };
            }
        }
    })
})();

//搜索
(function () {
    searchA.addEventListener('click', function (event) {
        // 获取输入框的值
        let inputValue = searchInput.value;
        //阻止a的默认事件
        event.preventDefault();
        if (inputValue =='') {
           let searchPop = document.querySelector('.seachPop')
           searchPop.style.display = inputValue =='' ? 'block' :'none';

           let popClick = document.querySelector('.seachPop span')
           popClick.onclick = function () {
                searchPop.style.display = 'none';
           }
           return
        }
        
        // 添加查询参数
        let hrefvalue = `search.html?keywords=${inputValue}`;
        searchA.setAttribute('href', hrefvalue);

        window.location.href = hrefvalue;
    });
    // 键盘事件
    searchInput.addEventListener('keydown', function (event) {
        if (event.key === 'Enter') {
            // 触发点击事件
            searchA.click();
        }
    });
})();






