$(document).ready(function(){

    /**
     * 初始化左侧
     */
    initFastSection();

    /**
     * 初始化移动端切换
     */
    initMobileNav('.content-wrapper');


    /**
     * 分享展开操作
     */
    $('.J_showAllShareBtn').click(function(e){
        e.preventDefault();
        $(this).siblings('.external').removeClass('external');
        $(this).hide();
    });

    /**
     * 添加收藏
     * commented by chad liu,已经在application.js.coffee中实现了
     */
    // $('.J_addFavorite').click(function(e){
    //     e.preventDefault();
    //     var countWrap = $(this).find('span');
    //     var count = countWrap.text()-0;
    //     var trigger = $(this);
    //     if($(this).hasClass('is-favorite')){
    //         $(this).removeClass('is-favorite');
    //         trigger.removeClass('icon-fly');
    //         countWrap.html(count - 1);
    //     }else{
    //         $(this).addClass('is-favorite');
    //         countWrap.html(count + 1);
    //         setTimeout(function(){
    //             trigger.addClass('icon-fly');
    //         },0);
    //     }
    // })

});