//搜索关键字
let keywords = hc_ajax.getUrlValue('keywords');

//面包屑导航
let position = document.querySelector('.position');
//搜索结果
let searchResult =document.querySelector('.searchResult');
//搜索列表
let searchUl = document.querySelector('.sec-list');

let page = 1;

getSearch()
// 调用分页器
getMaxPageCount();

// 获取总页数
function getMaxPageCount(){
	
	hc_ajax.ajax({
        method: 'get',
		url: BASE_URL + '/api_search',
		data: {page, pagesize: 12 ,keywords},
		success(res){
			if(res.code != 0){
				console.log(res);
				return;
			};
			
			// 设置总页数
			pageCount = Math.floor(res.count / 12)+1;
			
			// 后面才能调用分页器
			Pagination();
		},
		
	})
};

// 分页器
function Pagination(){
	// 调用分页器
	$('.pager').pagination({
		// 总页数
		pageCount : pageCount,
		current: 1,
		prevContent: '上一页',
		nextContent: '下一页',
		mode : 'fixed',
		coping: true,
		homePage: '首页',
		endPage: '末页',
		isHide: true,
		jump: true,
		callback(obj){
			//当前页
			page = obj.getCurrent();
			//调用数据方法
			getSearch();
		},	
	});	
}

//请求数据
function getSearch() {
    hc_ajax.ajax({
        method:'get',
        url: BASE_URL + '/api_search',
        data:{page,pagesize:12,keywords},
        success(res) {
            console.log(res);
            
            let pst = `
                <a href="">良仓</a> &gt;
                <a href="">搜索结果</a> &gt;
                <a href="#">${keywords}</a>
            `
            position.innerHTML = pst;

            let result = `
                <div>商品</div>
                <div>${res.count}</div>
            `;
            searchResult.innerHTML = result;

            let searchData = res.data;
            let str ='';
            searchData.forEach(item => {
                str += `
                    <li>
                        <div class="bar">
                            <a class="store">
                                <img src="${item.brand_thumb}" alt="">
                                ${item.brand_name}
                            </a>
                            <a href="" class="like">${item.star_number} <div></div></a>
                        </div>
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

                    </li>
                `
            });
            searchUl.innerHTML=str;


        }
    })
};
