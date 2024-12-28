let shopNav = document.querySelector('.shop-subnav')
let shopli = shopNav.querySelectorAll('ul li')
let shopliChild = shopNav.querySelectorAll('ul .listChild')
console.log(shopNav);
console.log(shopli);
console.log(shopliChild);

for (let i = 0; i < shopli.length; i++) {
    if (i >= 0 && i <= 6) {
        shopli[i].onmouseenter = function () {
            shopliChild[0].style.display = 'block'
        }
        shopli[i].onmouseleave = function () {
             shopliChild[0].style.display = 'none'
        }
    } else if (i >= 8 && i <= 14) {
        shopli[i].onmouseenter = function () {
            shopliChild[1].style.display = 'block'
        }
        shopli[i].onmouseleave = function () {
            shopliChild[1].style.display = 'none'
       }
    }
    else if (i == 16) {
        shopli[i].onmouseenter = function () {
            shopliChild[2].style.display = 'block'
        }
        shopli[i].onmouseleave = function () {
            shopliChild[2].style.display = 'none'
       }
    }
}
