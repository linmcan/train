//元素获取
let mian = document.querySelector('.main');
let position = mian.querySelector('.position');

let osmBar = mian.querySelector('.osm-bar');
let osmUl = osmBar.querySelector('.osm-ul');
let osmLi = osmUl.getElementsByTagName('li');

let good = mian.querySelector('.good');
let goodUl = good.querySelector('ul');

let priceUl = document.querySelector('.price-list ul')

//获取当前传递过来的 cat_id
let catId = hc_ajax.getUrlValue('catId');
let catName = hc_ajax.getUrlValue('catName');
console.log(catId);

let page = 1;
// 拿到上面的catId了之后，马上请求当前第一页  ID的商品
goodsRender();
// 调用分页器
getMaxPageCount();

// 获取总页数
function getMaxPageCount() {

    hc_ajax.ajax({
        method: 'get',
        url: BASE_URL + '/api_goods',
        data: { page, pagesize: 9, ...(catId !== null ? { catId: `${catId}` } : {}) },
        success(res) {
            if (res.code != 0) {
                console.log(res);
                return;
            };

            // 设置总页数
            pageCount = res.page;

            // 后面才能调用分页器
            Pagination();
        },

    })
};
// 分页器
function Pagination() {
    // 调用分页器
    $('.pager').pagination({
        // 总页数
        pageCount: pageCount,
        current: 1,
        prevContent: '上一页',
        nextContent: '下一页',
        mode: 'fixed',
        coping: true,
        homePage: '首页',
        endPage: '末页',
        isHide: true,
        jump: true,
        callback(obj) {
            //当前页
            page = obj.getCurrent();
            //调用数据方法
            goodsRender();
        },
    });
}
//导航栏
(function () {
    // 面包屑导航,在末尾添加
    let now = `&gt; <a href="">${catName}</a>`
    position.insertAdjacentHTML('beforeend', now);
    // 导航栏生成
    hc_ajax.ajax({
        method: 'get',
        url: BASE_URL + '/api_cat',
        success(res) {
            // 验证请求结果
            if (res.code != 0) {
                console.log(res);
                return;
            };

            //想要的结果
            let catData = res.data;

            //分类列表
            let str = `
                <li class="new"><a href="category.html?catName=新品">新品</a></li>
            `;
            catData.forEach(item => {
                str += `
                    <li>
                        <a href="category.html?catId=${item.cat_id}&catName=${item.cat_name}" catId='${item.cat_id}'>
                            ${item.cat_name}
                        </a>
                    </li>
                `;
            });
            str += `
                <li><a href="#">品牌</a></li>
            `;

            osmUl.innerHTML = str
        }
    });
    //子导航栏
    hc_ajax.ajax({
        method: 'get',
        url: BASE_URL + '/api_classify',
        success(res) {
            // 验证请求结果
            if (res.code != 0) {
                console.log(res);
                return;
            };
            //想要的结果
            let classifyData = res.data;

            //插入子导航合集
            let listChild = document.createElement('div');
            listChild.className = 'listChild';
            osmUl.appendChild(listChild)

            // 创建子导航
            for (let index = 0; index < osmLi.length; index++) {
                //鼠标移入导航栏
                osmLi[index].onmouseenter = function () {
                    if (index > 0 && index < 16) {
                        let a = osmLi[index].querySelector('a')
                        let catid = a.getAttribute('catId')

                        //匹配catid
                        for (let i = 0; i < classifyData.length; i++) {
                            if (catid === classifyData[i].cat_id) {
                                //生成插入数据
                                let str = '';
                                classifyData[i].data.forEach(item => {
                                    str += `<a href="">${item.product_content}</a>`
                                })
                                listChild.innerHTML = str;
                            }
                        }

                        if (index >= 10) {
                            listChild.style.top = '91px'
                            listChild.style.display = 'block'
                        } else {
                            listChild.style.top = '46px'
                            listChild.style.display = 'block'
                        }
                    }
                };
                //鼠标移出导航栏
                osmLi[index].onmouseleave = function () {
                    listChild.style.display = 'none'
                };
            }

            listChild.onmouseenter = function () { listChild.style.display = 'block' };
            listChild.onmouseleave = function () { listChild.style.display = 'none' };
        }
    });
})();


//数据渲染
function goodsRender(minPrice, maxPrice) {
    // 请求数据
    hc_ajax.ajax({
        method: 'get',
        url: BASE_URL + `/api_goods`,
        data: { page, pagesize: 9, ...(catId !== null ? { catId: `${catId}` } : {}) },
        success(res) {

            console.log('数据',res);
            // 验证请求结果
            if (res.code != 0) {
                console.log(res);
                return;
            };

            //想要的结果
            let goodsData = res.data;
            console.log(parseInt(minPrice),maxPrice);
            

            //添加商品
            let strLi = ''
            goodsData.forEach(item => {
                if ((!maxPrice && item.price >= minPrice) || 
                    (item.price >= minPrice && item.price <= maxPrice) || 
                    (!minPrice)) {
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
                }

            })
            goodUl.innerHTML = strLi
        }
    });

};

//价格筛选
(function () {
    priceUl.addEventListener('click', function (event) {
        if (event.target.closest('li')) {
            let row = event.target.closest('li');
            console.log(parseInt(row.getAttribute('minPrc')), row.getAttribute('maxPrc'));

            goodsRender(row.getAttribute('minPrc'), row.getAttribute('maxPrc'))
        }
    })
})();