//获取元素
//主图广告
let main = document.querySelector('.main');
let mainbanner = main.querySelector('.banner');
let mainPerv = mainbanner.querySelector('.prev');
let mainNext = mainbanner.querySelector('.next');
let mainUl = mainbanner.querySelector('ul');
let mainSlide = mainbanner.querySelector('div');
//商品列表
let good = document.querySelector('.good');
let goodUl = good.querySelector('.good-list');
//更多按钮
let more = main.querySelector('.more')
let moreclick = 0;

//广告位轮播图
(function () {
    // 请求数据
    hc_ajax.ajax({
        method: 'get',
        url: BASE_URL + '/api_banner',
        data: { bannerId: 1 },
        success(res) {
            console.log(res);
            // 验证请求结果
            if (res.code != 0) {
                console.log(res);
                return;
            };

            //想要的结果
            let bannerData = res.data;


            //遍历操作
            let strimg = '';
            let strSlide = '';
            bannerData.forEach(item => {
                // 累加数据
                strimg += `
                    <li class='bannerli'>
                        <a href="detail.html?goodsId=${item.goods_id}">
                            <img src="${item.goods_thumb}" alt="" />
                            <p>${item.goods_name}</p>
                        </a>
                    </li>
                `;
                strSlide += `
                    <span></span>
                `;
            });
            // 添加到对应的结构
            mainUl.style.width = `${1000 * (bannerData.length + 1)}px`
            // 重复添加第一个，用于做轮播
            strimg += `
                <li class='bannerli'>
                    <a href="">
                        <img src="${bannerData[0].goods_thumb}" alt="" />
                        <p>${bannerData[0].goods_name}</p>
                    </a>
                </li>
            `
            mainUl.innerHTML = strimg;
            mainSlide.innerHTML = strSlide;

            // 轮播滑动
            move();
        }
    });
})();

//热门商品
(function () {
    // 请求数据
    hc_ajax.ajax({
        method: 'get',
        url: BASE_URL + '/api_goods',
        data: { page: 1, pagesize: 9 },
        success(res) {
            console.log(res);
            // 验证请求结果
            if (res.code != 0) {
                console.log(res);
                return;
            };

            //想要的结果
            let goodsData = res.data;

            //添加商品
            let strLi = ''
            goodsData.forEach(item => {
                //列表累加
                strLi += `
                    <li>
                        <a href="detail.html?goodsId=${item.goods_id}">
                            <div class="goods">
                                <img src="${item.goods_thumb}" alt="">
                                <div class="goods-name">
                                    <p>￥${item.price}</p>
                                    <p>${item.goods_name}</p>
                                    <p>${item.goods_desc}</p>
                                </div>
                            </div>
                        </a>
                        <div class="bar">
                            <a class="store">
                                <img src="${item.brand_thumb}" alt="">
                                ${item.brand_name}
                            </a>
                            <a class="like">${item.star_number} <div class='likeimg'></div></a>
                        </div>
                    </li>
                `

            })
            goodUl.innerHTML = strLi

            like()
        }
    });
})();

//点击更多方法
more.onclick = function () {
    moreclick++;
    hc_ajax.ajax({
        method: 'get',
        url: BASE_URL + '/api_goods',
        data: { page: 1 + moreclick, pagesize: 9 },
        success(res) {
            // console.log(res);
            let moreData = res.data;

            let strLi = '';
            moreData.forEach(item => {
                //列表累加
                strLi += `
                    <li>
                        <a href="detail.html?goodsId=${item.goods_id}">
                            <div class="goods">
                                <img src="${item.goods_thumb}" alt="">
                                <div class="goods-name">
                                    <p>￥${item.price}</p>
                                    <p>${item.goods_name}</p>
                                    <p>${item.goods_desc}</p>
                                </div>
                            </div>
                        </a>
                        <div class="bar">
                            <a class="store">
                                <img src="${item.brand_thumb}" alt="">
                                ${item.brand_name}
                            </a>
                            <a class="like">${item.star_number} <div class='likeimg'></div></a>
                        </div>
                    </li>
                `
            });
            goodUl.insertAdjacentHTML('beforeend', strLi);
            like();
        }
    })
};

// 返回顶部
(function(){
	let oBackTop = document.querySelector('.back-top');
	
	// 监听页面卷动事件
	document.onscroll = function(){
		//验证滚动出去的值
		let scrollTop = document.documentElement.scrollTop;
		let isShow = scrollTop >= 400 ? 'block' : 'none';
		oBackTop.style.display = isShow;
	};
	
	// 点击事件
	oBackTop.onclick = function(){
		window.scrollTo({top: 0, behavior: 'smooth'});
	};
	
})();


//轮播图方法
function move() {
    // 图片信号量
    let n = 0;
    // 下标信号量
    let m = 0;
    //锁
    let lock = false;

    let aLi = mainUl.getElementsByTagName('li');
    let aslide = mainSlide.getElementsByTagName('span');

    // 下一张
    let next = function () {
        //节流
        if (lock) return;
        //上锁
        lock = true;

        n++;
        m++;

        m = m >= aslide.length ? 0 : m;

        play(n, m)
    };
    mainNext.onclick = next;
    
    //上一张
    mainPerv.onclick = function () {
        //节流
        if (lock) return;
        //上锁
        lock = true;


        n--;
        m--;

        //先验证是否转到末尾
        if (n < 0 && m < 0) {
            n = aLi.length - 1;
            mainUl.style.transition = 'none';
            mainUl.style.left = n * -1000 + 'px';
            n--;

            m = aslide.length;
            // console.log(aslide.length);

            m--;
        };

        //异步进行跳转
        setTimeout(function () {
            play(n, m)
        })

    };

    //监听过渡动画完成事件
    mainUl.ontransitionend = function () {
        //开锁
        lock = false;
        //验证
        if (n >= aLi.length - 1) {
            //设置下标为0
            n = 0;
            m = 0;
            mainUl.style.transition = 'none';
            mainUl.style.left = '0px';
            //第一个下标变色
            aslide[m].style.background = '#25292e';
        }

    };

    //点击下标跳转
    for (let i = 0; i < aslide.length; i++) {
        aslide[i].onclick = function () {
            n = i;
            m = i;
            play(n, m);
        };
    };

    //轮播图自动播放
    let timer = setInterval(next, 3000);

    mainbanner.onmouseenter = function(){
        clearInterval(timer)
    }
    mainbanner.onmouseleave = function(){
        timer = setInterval(next, 3000)
    }
};
//轮播图移动方法
function play(n, m) {
    let aslide = mainSlide.getElementsByTagName('span');
    //移动
    mainUl.style.transition = '0.5s';
    mainUl.style.left = n * -1000 + 'px';
    //排他
    for (let i = 0; i < aslide.length; i++) {
        aslide[i].style.background = '#999';
    };
    aslide[m].style.background = '#25292e';
};

function like() {
    //点击喜爱
    let likeElement = goodUl.querySelectorAll('li .bar .like');
    let likeclick = goodUl.querySelectorAll('li .bar .like .likeimg');
    let islike = false;
    likeclick.forEach((item, index) => {
        likeclick[index].onclick = function () {
            //改变背景
            likeclick[index].style.backgroundPosition = islike ? '0px -610px' : '0px -583px';
            console.log(likeclick[index]);
            //获取喜爱数
            let currentValue = likeElement[index].textContent.trim();
            let currentNumber = parseInt(currentValue, 10);
            
            // currentNumber = islike ? currentNumber : currentNumber+1;
            // console.log(currentNumber);
            //点击后取反
            islike = !islike;

        }
    })
}