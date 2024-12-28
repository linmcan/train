//左边图片列表 图片轮换
let image = document.getElementById('image')

let left = image.querySelector('.left')
let right = image.querySelector('.right')

// 大图列表
let mainImg = image.querySelector('.mainImg')
let bul = mainImg.querySelector('ul')
let bli = mainImg.querySelectorAll('ul li')
// 滑块
let slide = mainImg.querySelector('.slide')

//详细大图
let big = image.querySelector('.big')
let bigImg = big.querySelector('img')

// 小图列表
let listBox = image.querySelector('.list-box')
let sul = listBox.querySelector('ul')
let sli = listBox.querySelectorAll('ul li')

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
    console.log(n);


    //加过渡动画
    bul.style.transition = '.5s';
    bul.style.left = n * -350 + 'px';

    for (let i = 0; i < sli.length; i++) {
        sli[i].style.border = 'none'
    };
    sli[m].style.border = ' 2px solid #5993f4'
    //改详细大图图源
    let smallSrc = sli[m].querySelector('div img').getAttribute('src');
    bigImg.src = smallSrc;

    console.log(sli.length - 3);

    if (m >= 2 && m <= 5) {
        sul.style.transition = '.5s';
        sul.style.left = -84 * (m - 2) + 'px'
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
        //要开始运动 4 - 3
        n--;

        m = sli.length;
        // 拉回设置  清除过渡动画
        sul.style.transition = 'none';
        sul.style.left = (m - 5) * -84 + 'px'; // 4
        //要开始运动 4 - 3
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
        bigImg.src = smallSrc;

        if (m >= 2 && m <= 5) {
            sul.style.transition = '.5s';
            sul.style.left = -84 * (m - 2) + 'px'
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

    // console.log(mainImg.offsetWidth);
    // //比例
    let biliXY = (bigImg.offsetWidth - big.clientWidth) / (mainImg.clientWidth - slide.offsetWidth);

    // //设置右边大图跟随
    bigImg.style.left = -l * biliXY + 'px';
    bigImg.style.top = -t * biliXY + 'px';

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