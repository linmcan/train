// 基础地址
const BASE_URL = 'http://110.41.43.118:3008';

(function(){
	
	let username = document.querySelector('.username');
	let password = document.querySelector('.password');
	let loginBtn = document.querySelector('.loginBtn');
	
	// 点击事件
	loginBtn.onclick = function(){
		
		if(username.value == '' || password.value == ''){
			alert('用户名或密码不能为空');
			return;
		};
		
		//登录
		hc_ajax.ajax({
			method: 'post',
			url: BASE_URL + '/api_user',
			data: {username: username.value, password: password.value, status: 'login'},
            ContentType: 'url',
			success(res){
				console.log(res);
				if(res.code != 0){
					alert('用户名或密码错误');
					return;
				};
				
				// 登录成功，存储登录状态
				window.localStorage.setItem('username', res.username);
				window.localStorage.setItem('token', res.user_id);

                
				// 分情况跳转 首页 详情
				let goodsId = hc_ajax.getUrlValue('goodsId');
				let catId = hc_ajax.getUrlValue('catId');
				if(goodsId){
					window.location.href = `detail.html?goodsId=${goodsId}&catId=${catId}`;
				}else{
					// 跳转到首页
					window.location.href = 'index.html';
				}
			
			}
		})
		
		
	};
	
})();