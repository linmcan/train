const BASE_URL = 'http://110.41.43.118:3008';

//获取元素
//导航栏商店子菜单部分
let shopNav = document.querySelector('.shop-subnav');
let shopUl = shopNav.querySelector('ul');
let shopLi = shopUl.getElementsByClassName('cat');//所有导航分类
//搜索部分
let search = document.querySelector('.search-content')
let searchInput = search.querySelector('input')
let searchA = search.querySelector('a')
console.log(searchInput);



//请求元素全局变量
let catData = {};//商品导航
let classifyData = {};//商品子导航

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

        event.preventDefault();
        // 添加查询参数
        let hrefvalue = `search.html?keywords=${inputValue}`;
        searchA.setAttribute('href', hrefvalue); 

        window.location.href = hrefvalue;
    });
})();






