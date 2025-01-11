// 基础地址
const BASE_URL = 'http://110.41.43.118:3008';
//获取元素
//用户名
let userName = document.querySelector('.username')
let userNameMsg = document.querySelector('.username-msg');
//验证码
let code = document.querySelector('.codeInput');
let codeMsg = document.querySelector('.code-msg');
let codeImg = document.querySelector('.codeimg');
let codeChange = document.querySelector('.change');
//密码
let password = document.querySelector('.passwordInput');
let passwordMsg = document.querySelector('.password-msg');
let pwdStrength = document.querySelector('.pwd-strength');
let pwdStrengthSpan = pwdStrength.querySelectorAll('span');
//确认密码
let confirmpsd = document.querySelector('.confirm');
let confirmMsg = document.querySelector('.confirm-msg');
//条款
let agree = document.querySelector('.agree')
//注册按钮
let registBtn = document.querySelector('.registbtn')

//通过验证
let usernameStatus = false;
let codeStatus = false;
let passwordStatus = false;
let confirmStatus = false;
let agreeStatus = false;

//生成的验证码
let codeStr = '';
let passwordIpt = '';


// 验证交互效果方法
function msgRender(obj = null, objMsg = null, isShow = 'block', color = 'red', txt = '', borderColor = 'transparent') {
	objMsg.style.display = isShow;
	objMsg.style.color = color;
	objMsg.innerHTML = txt;
	obj.style.borderColor = borderColor;
};
//用户名验证
userName.onblur = function () {
	// 前端要做校验 3-12位字母数字下划线组成的用户名
	let re = /^[0-9a-zA-Z_]{3,12}$/g;
	if (!re.test(userName.value)) {
		msgRender(userName, userNameMsg, 'block', 'red', '用户名必须为3-12位字母数字下划线组成', 'red');
		usernameStatus = false;
		return;
	};

	// 查看后台数据验证是否已注册
	hc_ajax.ajax({
		method: 'post',
		url: BASE_URL + '/api_user',
		data: { username: userName.value, status: 'check' },
		ContentType: 'url',
		success(res) {
			console.log(res);
			if (res.code != 0) {
				console.log(res);
				msgRender(userName, userNameMsg, 'block', 'red', '用户名已存在', 'red');
				usernameStatus = false;
				return;
			};

			// 通过验证
			msgRender(userName, userNameMsg, 'block', 'green', '用户名可用', 'transparent');
			usernameStatus = true;
		}

	})

};
//验证码验证
code.onblur = function () {
	if (code.value != codeStr) {
		msgRender(code, codeMsg, 'block', 'red', '验证码错误', 'red');
		codeStatus = false;
	} else {
		msgRender(code, codeMsg, 'block', 'green', '验证码正确', 'transparent');
		codeStatus = true;
	}
};
//密码验证
password.onblur = function () {
	//正则验证
	let regex = /^[a-zA-Z0-9]{6,12}$/;
	passwordIpt = password.value;
	if (!regex.test(password.value)) {
		msgRender(password, passwordMsg, 'block', 'red', '密码必须为6-12位数字或大小写字母组成', 'red');
		passwordStatus = false;
		return;
	}

	//三档强度验证
	msgRender(password, passwordMsg, 'none', 'red', '密码格式正确', 'transparent');
	// 调用强中弱方法
	strengthColor();
	// 弱中强颜色封装
	function strengthColor(color1 = '#fff', color2 = '#fff', color3 = '#fff') {
		pwdStrengthSpan[0].style.background = color1;
		pwdStrengthSpan[1].style.background = color2;
		pwdStrengthSpan[2].style.background = color3;
	}
	function titleColor(color1 = '#cbcbcb', color2 = '#cbcbcb', color3 = '#cbcbcb') {
		pwdStrengthSpan[3].style.color = color1;
		pwdStrengthSpan[4].style.color = color2;
		pwdStrengthSpan[5].style.color = color3;
	}

	switch (this.value.length) {
		case 6:
		case 7:
			strengthColor('#E93C3C', '#fff', '#fff');
			titleColor('#fff', '#cbcbcb', '#cbcbcb');
			break;
		case 8:
		case 9:
		case 10:
			strengthColor('#E93C3C', '#E5C200', '#fff');
			titleColor('#cbcbcb', '#fff', '#cbcbcb');
			break;
		case 11:
		case 12:
			strengthColor('#E93C3C', '#E5C200', '#00D2E5');
			titleColor('#cbcbcb', '#cbcbcb', '#fff');
			pwdStrength.style.background = '#00D2E5';
			break;
	};
	re();
	console.log('第一次' + passwordIpt);

	passwordStatus = true;
};
//再次验证
confirmpsd.onblur = re;
function re() {
	console.log('第二次' + passwordIpt);

	if (confirmpsd.value != passwordIpt) {
		msgRender(confirmpsd, confirmMsg, 'block', 'red', '两次密码不一致', 'red');
		confirmStatus = false;
		console.log(usernameStatus, codeStatus, passwordStatus, confirmStatus);
		return;
	}
	msgRender(confirmpsd, confirmMsg, 'block', 'green', '密码一致', 'transparent');
	confirmStatus = true;
	console.log(usernameStatus, codeStatus, passwordStatus, confirmStatus);
};
//勾选
agree.onchange = function () {
	console.log(this.checked);
	agreeStatus = this.checked;
};

//注册
registBtn.onclick = function () {
	if (!usernameStatus) {
		userName.focus();
		msgRender(userName, userNameMsg, 'block', 'red', '用户名不可用', 'red');
		return;
	};

	if (!codeStatus) {
		code.focus();
		msgRender(code, codeMsg, 'block', 'red', '请输入正确的验证码', 'red');
		return;
	};

	if (!passwordStatus) {
		password.focus();
		msgRender(password, passwordMsg, 'block', 'red', '请输入正确的密码', 'red');
		return;
	};

	if (!confirmStatus) {
		confirmpsd.focus();
		msgRender(confirmpsd, confirmMsg, 'block', 'red', '密码不一致', 'red');
		return;
	};

	if (!agreeStatus) {
		alert('请勾选协议');
		return;
	};
	// if(!(usernameStatus && codeStatus && passwordStatus && confirmStatus && agreeStatus)){
	// 	return;
	// }
	hc_ajax.ajax({
		method: 'post',
		url: BASE_URL + '/api_user',
		data: { username: userName.value, password: password.value, status: 'register' },
		ContentType: 'url',
		success(res) {
			console.log(res);
			if (res.code != 0) {
				console.log(res);
				return;
			};

			// 带参数跳转
			let goodsId = hc_ajax.getUrlValue('goodsId');
			let catId = hc_ajax.getUrlValue('catId');
			let catName = hc_ajax.getUrlValue('catName');
			if (catId) {
				window.location.href = `login.html?catName=${catName}&catId=${catId}`;
			} else {
				window.location.href = goodsId ? `login.html?goodsId=${goodsId}` : 'login.html';
			}
		}
	})

};



// 验证码效果
(function () {

	// 解构
	let { random } = Math;


	// 默认要显示验证码
	let codeArr = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
		'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
		'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
		'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
		'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];

	// 调用一次
	getCode();

	// 点击换一张
	codeChange.onclick = getCode;

	//生成验证码方法
	function getCode() {
		// 清除验证码
		codeStr = '';
		// 清除验证码框的内容
		code.value = '';
		// 清除验证码
		codeImg.innerHTML = '';
		//四位
		for (let i = 0; i < 4; i++) {
			// 创建DOM
			let span = document.createElement('span');
			// 随机 0-61
			span.innerHTML = codeArr[parseInt(random() * 62)];
			codeStr += span.innerHTML;

			// 随机颜色
			span.style.color = `rgb(${random() * 255}, ${random() * 255}, ${random() * 255})`;
			// 随机字体大小 12 -22
			span.style.fontSize = parseInt(random() * 13 + 10) + 'px';
			// 斜体
			span.style.fontStyle = random() < 0.5 ? 'italic' : 'none';
			span.style.fontWeight = random() < 0.5 ? 'bold' : 'normal';
			// 添加到容器
			codeImg.appendChild(span);
		};

	};


})();