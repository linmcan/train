// 基础地址
const BASE_URL = 'http://110.41.43.118:3008';

(function () {

	let username = document.querySelector('.username');
	let password = document.querySelector('.password');
	let loginBtn = document.querySelector('.loginBtn');
	let registBtn = document.querySelector('.registBtn');

	// 点击事件
	loginBtn.onclick = function () {

		if (username.value == '' || password.value == '') {
			alert('用户名或密码不能为空');
			return;
		};

		//登录
		hc_ajax.ajax({
			method: 'post',
			url: BASE_URL + '/api_user',
			data: { username: username.value, password: password.value, status: 'login' },
			ContentType: 'url',
			success(res) {
				console.log(res);
				if (res.code != 0) {
					alert('用户名或密码错误');
					return;
				};

				// 登录成功，存储登录状态
				window.localStorage.setItem('username', res.username);
				window.localStorage.setItem('token', res.user_id);


				// 分情况跳转 首页 详情
				let goodsId = hc_ajax.getUrlValue('goodsId');
				let catId = hc_ajax.getUrlValue('catId');
				let catName = hc_ajax.getUrlValue('catName');
				if (catId) {
					window.location.href = `category.html?catName=${catName}&catId=${catId}`;
				} else {
					// 跳转到首页
					window.location.href = goodsId ? `detail.html?goodsId=${goodsId}` : 'index.html';
				}

			}
		})


	};

	//注册
	registBtn.onclick = function () {
		// 分情况跳转
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