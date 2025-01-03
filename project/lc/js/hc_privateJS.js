/*
    2024/12/28 开始制作 自用封装js方法
    作者：linmo
*/

//ajax请求
let hc_ajax = {
    //ajax方法，传入请求方法，数据地址，请求参数，请求成功运行的函数
    ajax({ method, url, data = {}, success } = {}) {
        // 创建ajax实例对象
        let xhr = new XMLHttpRequest();
        // 监听事件
        xhr.onreadystatechange = function () {
            // 验证ajax的状态
            if (xhr.readyState == 4) {
                //验证http状态
                if (xhr.status >= 200 && xhr.status < 300 || xhr.status == 304) {
                    //拿参数改JSON格式
                    let successdata = JSON.parse(xhr.response);
                    //把拿到的数据给到自定义的success函数
                    success(successdata);
                }
            }
        };

        //处理请求参数data（post上传表单和json，get请求url编码，toLowerCase()全转小写）
        let str;
        if (method.toLowerCase() === 'post' && data && typeof data === 'object') {
            // 如果是 POST 请求，并且 data 是对象
            if (data instanceof FormData) {
                //提交表单
                str = data;
            } else {
                //提交json
                str = JSON.stringify(data);
            }
        } else {
            //get请求数据转换为 URL 编码格式
            str = Object.entries(data).map((item) => {
                return item.join('=');
            }).join('&');
        }


        if (method.toLowerCase() == 'get') {
            // 配置
            xhr.open('get', url + '?' + str);
            // 发送
            xhr.send();
        } else if (method.toLowerCase() == 'post') {
            // 配置
            xhr.open('post', url);
            //判断请求参数
            if (data instanceof FormData) {
                //自动处理，无方法
            } else if (typeof data === 'object') {
                //以json格式发送
                xhr.setRequestHeader('Content-Type', 'application/json');
            } else {
                //以 URL 编码的格式发送
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            }
            // 发送
            xhr.send(str);
        }
    },

    //获取地址参数的属性值
	getUrlValue(pre){
		let obj = Object.fromEntries(window.location.search.replace('?', '').split('&').map(item => {
			return item.split('=')
		}));
		return obj[pre] ? decodeURIComponent(obj[pre] ): null;
	},
}