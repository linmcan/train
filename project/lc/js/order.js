(function () {
    let tradeNo = hc_ajax.getUrlValue('trade_no');
    console.log(tradeNo);
    //支付订单查询
    hc_ajax.ajax({
        method: 'post',
        url: 'http://110.41.43.118:3008/api_payquery',
        data: {
            userId: localStorage.getItem('token'),
            tradeNo
        },
        ContentType: 'url',
        success(res) {
            console.log(res);
            if (res.code != 0) {
                console.log(res);
                return;
            };

            getOrder()

        }
    })
    //刷新的时候获取用户订单列表
    getOrder();

    //获取订单列表
    function getOrder() {
        hc_ajax.ajax({
            method: 'post',
            url: 'http://110.41.43.118:3008/api_order',
            data: {
                userId: localStorage.getItem('token'),
                status: 'vieworder'
            },
            ContentType: 'url',
            success(res) {
                console.log(res);
                if (res.code != 0) {
                    console.log(res);
                    return;
                };
            }
        })
    }
})();