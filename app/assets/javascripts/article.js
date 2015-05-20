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

});