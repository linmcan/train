//面包屑导航
let position = document.querySelector('.position')

//左边图片列表 图片轮换
let image = document.getElementById('image');

let left = image.querySelector('.left');
let right = image.querySelector('.right');

// 大图列表
let mainImg = image.querySelector('.mainImg');
let bul = mainImg.querySelector('ul');
let bli = bul.getElementsByTagName('li');
// 滑块
let slide = mainImg.querySelector('.slide');
//详细大图
let big = image.querySelector('.big');
let bigImg = big.getElementsByTagName('img');
// 小图列表
let listBox = image.querySelector('.list-box');
let sul = listBox.querySelector('ul');
let sli = sul.getElementsByTagName('li');

//右边详列表
let goodsInfo = document.querySelector('.goodInfo');
//下面广告位
let bannerdetail = document.querySelector('.bannerdetail');
//商品介绍
let introduction = document.querySelector('.introduction-main')
//猜你喜欢
let recommendation = document.querySelector('.recommendation')
//获取商品数据
let goodsId = hc_ajax.getUrlValue('goodsId');

//请求商品详细数据
(function () {
    hc_ajax.ajax({
        method: 'get',
        url: BASE_URL + '/api_goods',
        data: { goodsId },
        success(res) {
            if (res.code != 0) {
                console.log(res);
                return;
            };

            let goodsData = res.data;

            //判断商品是否存在
            if (goodsData.length == 0) {
                let main = document.querySelector('.main')
                main.innerHTML = '<p style="height: 200px; text-align: center; font-size: 30px;">商品已下架...</p>'
                return
            }

            // //面包屑方法
            bread(goodsData[0].cat_id, goodsData[0].goods_name);

            //左边图片列表
            let mainbanner = '';
            let alltype = '';
            console.log(goodsData[0]);
            goodsData[0].banner.forEach((item, index) => {


                mainbanner += `
                    <li>
                        <div><img src="${item}" alt=""></div>
                    </li>
                `;
                alltype += `
                    <div class="type${index}">
                        <div class="imgCon">
                            <img src="${item}" >
                        </div>
                    </div>
                `
            });
            let ul = mainbanner + `<li>
                        <div><img src="${goodsData[0].banner[0]}" alt=""></div>
                    </li>`
            bul.innerHTML = ul;
            sul.innerHTML = mainbanner;
            big.innerHTML = `<img src="${goodsData[0].banner[0]}" alt="" class="bigImg">`
            //图片移动方法
            move()

            // 右边介绍
            let info = `
                <!-- 商品喜爱数 -->
                <div class="goodsFavCount">${goodsData[0].star_number}</div>
                <!-- 店铺名字 -->
                <div class="dpName">
                    <a href="">${goodsData[0].brand_name}</a>
                </div>
                <!-- 商品名字 -->
                <div class="gdName">${goodsData[0].goods_name} </div>
                <!-- 商品价格 -->
                <div class="infoItem">价格:&nbsp; &nbsp; <span>¥${goodsData[0].price}元</span></div>
                <!-- 包邮正品 -->
                <div class="shipNote"><span> 免运费</span><span>正品授权</span></div>
                <!-- 商品种类 -->
                <div class="goodType">
                    <div class="type-title">种类:&nbsp;&nbsp;</div>
                    <div class="alltype">
                        ${alltype}
                    </div>

                </div>
                <!-- 商品数量 -->
                <div class="amountCon">
                    数量: &nbsp;&nbsp;
                    <div class="mopt">
                        <span class='subtract'><img src="img/good/reduce.png" alt=""></span>
                        <input type="text" class="inpt" value="1">
                        <span class='add'><img src="img/good/add.png" alt=""></span>
                    </div>
                </div>
                <!-- 立即购买 -->
                <div class="buynow">
                    <a href="#">立即购买</a>
                    <!-- <p>已售罄，即将到货</p> -->
                </div>
                <!--加入购物车  分享-->
                <div class="cart-share">
                    <a href="#" class="addcart"><span>加入购物车</span></a>
                    <a href="#" class="share"><span>分享</span></a>
                </div>
            `;
            goodsInfo.innerHTML = info;
            addgoods();


            //下面广告
            let bannerdtl = '';
            goodsData[0].product_banner.forEach(item => {
                bannerdtl += `
                    <img src="${item}" alt="">
                `
            })
            bannerdetail.innerHTML = bannerdtl;
            //介绍
            let introduce = `
                    <p> ${goodsData[0].lc_recommend[4]}</p>
                `;
            introduction.innerHTML = introduce;

            //猜你喜欢方法
            recom(goodsData[0].cat_id)
        }
    })
})();

// 返回顶部
(function () {
    let oBackTop = document.querySelector('.back-top');

    // 监听页面卷动事件
    document.onscroll = function () {
        //验证滚动出去的值
        let scrollTop = document.documentElement.scrollTop;
        let isShow = scrollTop >= 400 ? 'block' : 'none';
        oBackTop.style.display = isShow;
    };

    // 点击事件
    oBackTop.onclick = function () {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    };

})();




//面包屑导航
function bread(goodsType, goodsName) {
    let typeName = '';
    hc_ajax.ajax({
        method: 'get',
        url: BASE_URL + '/api_cat',
        success(res) {
            // 验证请求结果
            if (res.code != 0) {
                console.log(res);
                return;
            };
            //匹配商品种类
            res.data.forEach(item => {
                if (goodsType == item.cat_id) {
                    typeName = item.cat_name;
                }
            })

            //生成面包屑导航
            let pst = `
                <a href="">良仓</a> &gt;
                <a href="">${typeName}</a> &gt;
                <a href="#">${goodsName}</a>
            `
            position.innerHTML = pst;
        }
    })

}
//购买，加入购物车操作
function addgoods() {
    //获取添加的元素
    //数量加减
    let mopt = document.querySelector('.mopt');
    let subtract = mopt.querySelector('.subtract');
    let quantity = mopt.querySelector('input');
    let add = mopt.querySelector('.add');
    //立即购买
    let buynow = document.querySelector('.buynow');
    //加入购物车
    let addcart = document.querySelector('.cart-share .addcart')
    console.log(mopt);

    let num = 1;
    quantity.value = num;

    // 点击减
    subtract.onclick = function () {
        num = --num <= 1 ? 1 : num;
        quantity.value = num;
    };
    // 点击加
    add.onclick = function () {
        num = ++num >= 10 ? 10 : num;
        quantity.value = num;
    };

    // 点击立即购买
    buynow.onclick = function () {
        let USERNAME = localStorage.getItem('username');
        let TOKEN = localStorage.getItem('token');
        // 验证登录状态
        if (!USERNAME || !TOKEN) {
            let modal = document.querySelector('.modal');
            modal.style.display = localStorage.getItem('token') ? 'none' : 'block';
            let log = document.querySelector('.log');
            let ret = document.querySelector('.ret');
            log.onclick = function(){
                let goodsId = hc_ajax.getUrlValue('goodsId');  
                // 带参数的跳转
                location.href = goodsId ? `login.html?goodsId=${goodsId}` : 'login.html';
            }
            ret.onclick = function(){
                location.href = `index.html`;
            }
            return;
        };

        //先加入结算清单，跳转到地址页面
        hc_ajax.ajax({
            method: 'post',
            url: BASE_URL + '/api_settlement',
            data: {
                status: 'addsettlement',
                userId: localStorage.getItem('token'),
                from: 'product',
                goodsId: goodsId,
                goodsNumber: num,
            },
            ContentType: 'url',
            success(res) {
                console.log(res);
                if (res.code != 0) {
                    console.log(res);
                    return;
                };

                //跳转到地址页面
                location.href = 'result.html';
            }
        })
    };

    // 点击加入购物车
    addcart.onclick = function () {
        let USERNAME = localStorage.getItem('username');
        let TOKEN = localStorage.getItem('token');
        // 验证登录状态
        if (!USERNAME || !TOKEN) {
            let modal = document.querySelector('.modal');
            modal.style.display = localStorage.getItem('token') ? 'none' : 'block';
            let log = document.querySelector('.log');
            let ret = document.querySelector('.ret');
            log.onclick = function(){
                let goodsId = hc_ajax.getUrlValue('goodsId');  
                // 带参数的跳转
                location.href = goodsId ? `login.html?goodsId=${goodsId}` : 'login.html';
            }
            ret.onclick = function(){
                location.href = `index.html`;
            }
            return;
        };

        // 加车
        hc_ajax.ajax({
            method: 'post',
            url: BASE_URL + '/api_cart',
            data: {
                status: 'addcart',
                goodsId,
                userId: TOKEN,
                goodsNumber: num
            },
            ContentType: 'url',
            success(res) {
                // console.log(res);
                if (res.code != 0) {
                    console.log(res);
                    return;
                };
                // 交互 弹出好看的框
                alert('加入购物车成功');
                // 调用头部的购物车方法
                getCartValue();
            },
        })

    };
}
//猜你喜欢
function recom(goodType) {
    //调取总页数
    hc_ajax.ajax({
        method: 'get',
        url: BASE_URL + `/api_goods`,
        data: { page: 1, pagesize: 3, catId: `${goodType}` },
        success(res) {
            if (res.code != 0) {
                console.log(res);
                return;
            };
            // 设置总页数
            console.log('页数' + res.page);

            Radom(res.page);
        }
    })
    //随机生成
    function Radom(pageCount) {
         let pgc = pageCount;
        hc_ajax.ajax({
            method: 'get',
            url: BASE_URL + `/api_goods`,
            data: { page: Math.floor(Math.random() * pageCount), pagesize: 3, catId: `${goodType}` },
            success(res) {
                if (res.code != 0) {
                    console.log(res);
                    return;
                };
                console.log(res.data);

                let str = '<div class="recommendation-title">猜你喜欢 <button class="changeBtn">换一换</button></div>';
                res.data.forEach(item => {
                    str += `
                        <div class="recommendation-goods">
                            <a href="detail.html?goodsId=${item.goods_id}" class=""><img src="${item.goods_thumb}" alt=""></a>
                            <a href="" class="name">${item.goods_name}</a>
                            <p class="dpName">${item.brand_name}</p>
                            <p class="price">￥${item.price}</p>
                        </div>
                    `
                })
                recommendation.innerHTML = str;

                let btn = document.querySelector('.changeBtn')

                btn.onclick = function(){
                    //回调渲染
                    Radom(pgc);
                }
            }
        })
    }
};
//商品图片轮播和放大镜
function move() {
    // 大图下标
    let n = 0;
    // 小图下标
    let m = 0;
    //锁
    let lock = false;

    //下一张
    right.onclick = function () {
        //节流
        if (lock) return;

        //上锁
        lock = true;
        n++;

        //小图
        m++;
        m = m >= sli.length ? 0 : m;
        console.log(m);

        //加过渡动画
        bul.style.transition = '.5s';
        bul.style.left = n * -350 + 'px';

        for (let i = 0; i < sli.length; i++) {
            sli[i].style.border = 'none'
        };
        sli[m].style.border = ' 2px solid #5993f4'
        //改详细大图图源
        let smallSrc = sli[m].querySelector('div img').getAttribute('src');
        bigImg[0].src = smallSrc;

        if (m >= 2 && m <= sli.length - 3) {
            sul.style.transition = '.5s';
            sul.style.left = -84 * (m - 2) + 'px'
        } else if (m == 4) {
            sul.style.transition = '.5s';
            sul.style.left = '-34px'
        }
    }
    //上一张
    left.onclick = function () {
        //节流
        if (lock) return;
        //上锁
        lock = true;

        //业务
        n--;
        m--;
        //先验证
        if (n < 0 && m < 0) {
            n = bli.length - 1;
            // 拉回设置  清除过渡动画
            bul.style.transition = 'none';
            bul.style.left = n * -350 + 'px'; // 4
            n--;

            m = sli.length;
            // 拉回设置  清除过渡动画
            sul.style.transition = 'none';
            sul.style.left = (m - 5) * -84 + 'px'; // 4
            m--;
        };

        //异步程序永远是运行在同步之后
        setTimeout(function () {
            bul.style.transition = '0.5s';
            bul.style.left = n * -350 + 'px';

            for (let i = 0; i < sli.length; i++) {
                sli[i].style.border = 'none'
            };
            sli[m].style.border = ' 2px solid #5993f4'
            //改详细大图图源
            let smallSrc = sli[m].querySelector('div img').getAttribute('src');
            bigImg[0].src = smallSrc;

            if (m >= 2 && m <= sli.length - 2) {
                sul.style.transition = '.5s';
                sul.style.left = -84 * (m - 2) + 'px'
            } else if (m == 4) {
                sul.style.transition = '.5s';
                sul.style.left = '-168px'
            }
        })

    };

    //监听过渡动画完成事件
    bul.ontransitionend = function () {

        //开锁
        lock = false;

        // console.log(n);
        //验证
        if (n >= bli.length - 1) {
            //设置下标为0
            n = 0;
            // console.log(n);
            //清除过渡动画
            bul.style.transition = 'none';
            //再拉回
            bul.style.left = n * -350 + 'px';

            m = 0;
            sul.style.transition = 'none';
            //再拉回
            sul.style.left = '0px';
            sli[0].style.border = ' 2px solid #5993f4'
        }

    }
    console.log(sli.length);

    //点击小图跳转
    for (let i = 0; i < sli.length; i++) {
        sli[i].onclick = function () {
            n = i;
            m = i;
            bul.style.transition = '.5s';
            bul.style.left = n * -350 + 'px';

            for (let i = 0; i < sli.length; i++) {
                sli[i].style.border = 'none'
            };
            sli[m].style.border = ' 2px solid #5993f4'
            //改详细大图图源
            let smallSrc = sli[m].querySelector('div img').getAttribute('src');
            bigImg[0].src = smallSrc;



            if (m >= 2 && m <= sli.length - 3) {
                sul.style.transition = '.5s';
                sul.style.left = -84 * (m - 2) + 'px'
            } if (m == 4) {
                sul.style.transition = '.5s';
                sul.style.left = -84 * (m - 2) + 'px'
            }
        }

    }


    // 放大镜鼠标移入
    mainImg.onmousemove = function (event) {
        // 最终设置的值，先减去滑块的一半, 再减去净位置(元素到浏览器窗口的距离)
        let l = event.clientX - slide.offsetWidth / 2 - mainImg.getBoundingClientRect().left;
        let t = event.clientY - slide.offsetWidth / 2 - mainImg.getBoundingClientRect().top;

        //控制范围
        if (l <= 0) { l = 0 };
        if (t <= 0) { t = 0 };
        //滑块可以移动最大值
        let maxXY = mainImg.clientWidth - slide.offsetWidth;
        if (l >= maxXY) { l = maxXY };
        if (t >= maxXY) { t = maxXY };

        //设置滑块
        slide.style.left = l + 'px';
        slide.style.top = t + 'px';

        // //比例
        let biliXY = (bigImg[0].offsetWidth - big.clientWidth) / (mainImg.clientWidth - slide.offsetWidth);

        //设置右边大图跟随
        bigImg[0].style.left = -l * biliXY + 'px';
        bigImg[0].style.top = -t * biliXY + 'px';


    };

    // 鼠标移入移出
    mainImg.onmouseenter = function () {
        slide.style.display = 'block';
        big.style.display = 'block';
    };
    mainImg.onmouseleave = function () {
        slide.style.display = 'none';
        big.style.display = 'none';
    };
}

