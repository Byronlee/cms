$(document).ready(function(){

    /**
     * 初始化左侧
     */
    initFastSection();

    /**
     * 初始化移动端切换
     */
    initMobileNav('.J_resultListWrap');


    /**
     * 分类导航固定交互
     */
    $('.J_newsListNavBar').stick_in_parent();


    /**
     * 加载更多(TODO:需要再跟后端联调加载逻辑)
     */

    function bindLoadMore(wrapper){
        wrapper = wrapper || $('.J_articleList').eq(0);
        $('.J_listLoadMore', wrapper).click(function(e){
            e.preventDefault();
            var trigger = $(this);
            if(trigger.hasClass('no-data'))return;
            if(trigger.hasClass('loading'))return;
            trigger.addClass('loading');
            $.get(trigger.attr('href'), function(list){
                var newWrapper = trigger.parent();
                $(list).insertAfter(trigger);
                trigger.remove();

                //触发一下滚动，让固定的元素重新定位
                $(window).trigger('scroll');
                if($('.timeago').length >= 1) {
                    $('.timeago').timeago();
                }
                bindLoadMore(newWrapper);
            }, 'html');
        });

    }
    bindLoadMore();


});