(function() {
    hc_ajax.ajax({
        method:'get',
        url :  BASE_URL + '/api_classify',
        success(res){
            console.log(res);

            //插入小分类的li,每七行的小分类在一起，层叠且默认隐藏
            let listChild = document.createElement('li');
            listChild.className = 'listChild'; 
            let children = shopUl.children;
            //插入三个小分类的li
            shopUl.insertBefore(listChild.cloneNode(true), children[7])
            shopUl.insertBefore(listChild.cloneNode(true), children[15])
            shopUl.insertBefore(listChild.cloneNode(true), children[17])
            //获取所有小分类的li
            let shopliChild = shopNav.querySelectorAll('ul .listChild')
            let data = res.data;
            data.forEach((item,index) => {
                // console.log(data[index].data);
                data[index].data.forEach(item =>{
                    console.log(item.product_content);
                })
            })
            
        }
    })
})();