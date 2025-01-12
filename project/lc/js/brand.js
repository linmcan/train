let brands = {
    A: ["Apple（苹果）","Alibaba（阿里巴巴）","Airbnb（爱彼迎）","Adidas（阿迪达斯）","Audi（奥迪）","Anta（安踏）","Alipay（支付宝）", "Acer（宏碁）"],
    B: ["BMW（宝马）","Benz（奔驰）", "Baidu（百度）","BYD（比亚迪）","Boeing（波音）", "Burberry（巴宝莉）", "BMW Mini（宝马迷你）","Bose（博士）"],
    C: ["Chanel（香奈儿）","Canon（佳能）","CocaCola（可口可乐）","China Mobile（中国移动）","Citibank（花旗银行）","Cadillac（凯迪拉克）", "Carlsberg（嘉士伯）","Cathay Pacific（国泰航空）"],
    D: ["Dell（戴尔）","Dior（迪奥）","Dyson（戴森）","Danone（达能）","Dell EMC（戴尔易安信）","DHL（敦豪）","Dongfeng（东风）","Dongpeng Airlines（东航）"],
    E: ["Ericsson（爱立信）","Evergrande（恒大）","eBay（易趣）","Epson（爱普生）","Electrolux（伊莱克斯）","Emirates（阿联酋航空）","Erdos（鄂尔多斯）"],
    F: ["Ferrari（法拉利）","Ford（福特）","Firefox（火狐）","Fedex（联邦快递）","Foxconn（富士康）","Ferrero Rocher（费列罗）","Fendi（芬迪）"],
    G: ["Google（谷歌）","Gucci（古驰）","Gap（盖璞）","Gree（格力）","Galaxy（三星旗下）","Genting（云顶集团）","GSK（葛兰素史克）"],
    H: ["Heineken（喜力）","Honda（本田）","Huawei（华为）","Hyundai（现代）","H&M（海恩斯和莫里斯）","Haier（海尔）","Home Depot（家得宝）"],
    I: ["Ikea（宜家）","Intel（英特尔）","Inditex（Inditex集团）","Infiniti（英菲尼迪）","Instagram（照片墙）","IKEA Family（宜家家庭会员）","IMAX（IMAX）"],
    J: ["Jaguar（捷豹）","JetBlue（捷蓝航空）","JD.com（京东）","Johnson & Johnson（强生）","JPMorgan Chase（摩根大通）","Joyoung（九阳）","J.Crew（杰西卡·克莱尔）"],
    K: ["KFC（肯德基）","Kindle（亚马逊Kindle）","Kodak（柯达）","KPMG（毕马威）","Kate Spade（凯特·丝蓓）","Kawasaki（川崎）","Kingsoft（金山软件）","K-Swiss（瑞士步）","Kohl's（科尔士百货公司）","Krispy Kreme（多乐圈）"],
    L: ["Lexus（雷克萨斯）","Louis Vuitton（路易威登）","Lenovo（联想）","LG（乐金）","Lifebuoy（舒肤佳）","LinkedIn（领英）","Longines（浪琴）","Lululemon（露露乐蒙）","Lynx（凌仕）","Lancome（兰蔻）"],
    M: ["McDonald's（麦当劳）","Mercedes-Benz（梅赛德斯-奔驰）","Microsoft（微软）","Marriott（万豪）","Mazda（马自达）","Miele（美诺）","Mitsubishi（三菱）","Motorola（摩托罗拉）",    "Maybelline（美宝莲）","Muji（无印良品）"],
    N: ["Nike（耐克）","Nintendo（任天堂）","Nestlé（雀巢）","New Balance（新百伦）","Netflix（网飞）","Nokia（诺基亚）","Nivea（妮维雅）","Nest（Nest智能家居）","Nautica（诺蒂卡）","Neiman Marcus（内曼·马库斯）"],
    O: ["Omega（欧米茄）","Oracle（甲骨文）","Old Navy（老海军）","Olympus（奥林巴斯）","Oreo（奥利奥）","Opel（欧宝）","Orange（法国电信）","Overstock.com（奥维斯特）","Oakley（欧克利）","Office Depot（欧迪办公）"],
    P: ["Pepsi（百事可乐）","Porsche（保时捷）","PayPal（贝宝）","Puma（彪马）","Pantene（潘婷）","Philips（飞利浦）", "Pizza Hut（必胜客）","Prada（普拉达）","Pandora（潘多拉）","Pernod Ricard（保乐力加）"],
    Q: ["Qualcomm（高通）","Quicksilver（快银）","Qantas（澳洲航空）","Queen（皇后）","Quiksilver（快银）","Qatar Airways（卡塔尔航空）","Quilted Northern（柔软北方）","Quality Inn（品质酒店）","Quasar"],
    R: ["Range Rover（揽胜）","Rolex（劳力士）","Rolls-Royce（劳斯莱斯）","Red Bull（红牛）","Ritz-Carlton（丽思卡尔顿）","Ralph Lauren（拉夫·劳伦）","Ray-Ban（雷朋）","Roku（乐播）","Radisson Blu（拉迪森布鲁酒店）","Ramada（华美达酒店）"],
    S: ["Samsung（三星）","Sony（索尼）","Starbucks（星巴克）","Swarovski（施华洛世奇）","Subway（赛百味）","Suzuki（铃木）","Santander（桑坦德银行）","Sephora（丝芙兰）","Shell（壳牌）","Siemens（西门子）"],
    T: ["Toyota（丰田）","Tiffany & Co.（蒂芙尼）","Tsingtao Beer（青岛啤酒）","Tommy Hilfigers","Tory Burch（托里·伯奇）","Tudor（帝舵）","Turkish Airlines（土耳其航空）","Tata Motors（塔塔汽车）","Timberland（添柏岚）","T-Mobile（T-Mobile美国）"],
    U: ["Uber（优步）","Unilever（联合利华）","Under Armour（安德玛）","United Airlines（美国联合航空）","Universal Studios（环球影城）","UPS（联合包裹运送服务公司）","USPS（美国邮政服务）","Udemy（优达学城）","Urban Outfitters（城市户外）","USAA（美国退伍军人协会保险）"],
    V: ["Volkswagen（大众）","Visa（维萨）","Volvo（沃尔沃）","Versace（范思哲）","Virgin Atlantic（维珍大西洋航空）","Victoria's Secret（维多利亚的秘密）","Vodafone（沃达丰）","Vans（万斯）","Verizon（威瑞森）"],
    W: ["WhatsApp（WhatsApp）","Walmart（沃尔玛）","Westin（威斯汀酒店）","Westinghouse（西屋电气）","Wyndham（温德姆）","Whole Foods Market（全食超市）","Wyndham Rewards（温德姆奖赏计划）"],
    X: ["Xbox（Xbox）","Xiaomi（小米）","Xerox（施乐）","Xfinity（Xfinity）","X-Men（X战警）","X-rite（爱色丽）"],
    Y: ["Yahoo!（雅虎）","YouTube（优兔）","Yves Saint Laurent（圣罗兰）","Yeti（Yeti酷饮）","Yelp（Yelp）","Yoplait（优诺酸奶）"],
    Z: ["Zara（飒拉）","Zippo（芝宝）","Zillow（Zillow房产）","Zurich Insurance（苏黎世保险）","Zoom（Zoom视频会议软件）","Zales（杰尔斯珠宝）"]   
};

(function(){
    let brandArr = document.querySelector('.brandArr')
    let str = ''

    //渲染
    Object.keys(brands).forEach(letter => {
        let bra = ''
        // 遍历每个品牌并添加到表格中
        brands[letter].forEach(brand => {
        bra +=`
            <span>${brand}</span>
        `
        });
        str += `
            <tr>
                <td id="${letter}">${letter}</td>
                <td>${bra}</td>
            </tr>
        `;
    });
    brandArr.innerHTML = str; // 将生成的行添加到表格主体


    //点击位移
    let tltArr = document.querySelectorAll('.brandTitle span');
    console.log(tltArr);
    tltArr.forEach(anchor => {
        anchor.addEventListener('click', function () {
            let targetId = this.getAttribute('class'); // 获取目标 ID
            let targetElement = document.getElementById(targetId); // 获取目标元素
            
            let targetPosition = targetElement.getBoundingClientRect().top + window.scrollY - 185;//185为上面定死的高
            window.scrollTo({top: targetPosition,behavior: 'smooth'});
        });
    });

    //返回顶部
    let oBackTop = document.querySelector('.back-top');
	// 监听页面卷动事件
	document.onscroll = function(){
		//验证滚动出去的值
		let scrollTop = document.documentElement.scrollTop;
		let isShow = scrollTop >= 400 ? 'block' : 'none';
		oBackTop.style.display = isShow;
	};
	
	// 点击事件
	oBackTop.onclick = function(){
		window.scrollTo({top: 0, behavior: 'smooth'});
	};
})();
