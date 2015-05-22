$(document).ready(function(){

    /**
     * 初始化左侧
     */
    initFastSection();

    /**
     * 初始化移动端切换
     */
    initMobileNav('.J_headImages, .J_articleListWrap');


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

                bindLoadMore(newWrapper);
            }, 'html');
        });

    }
    bindLoadMore();


    /**
     * 分类加载(TODO:需要联调加载逻辑)
     */
    var navBarTop = $('.J_newsListNavBar').offset().top;
    $('.J_newsListNavBar a').eq(0).data('listWrapper', $('.J_articleList').eq(0))
    $('.J_newsListNavBar a').click(function(e){
        e.preventDefault();



        var url = $(this).attr('href');
        var link = $(this);

        if(link.siblings('.loading').length){
            return;
        }


        if(link.data('listWrapper')){
            $(this).addClass('active')
                .siblings().removeClass('active');
            link.data('listWrapper').show()
                .siblings().hide();
            return;
        }

        var newWrapper = $('<div class="articles J_articleList"></div>').insertAfter($('.J_articleList').eq(0));
        link.data('listWrapper', newWrapper);


        link.addClass('loading');
        $.get(url, function(list){
            newWrapper.show()
                .siblings().hide();
            link.addClass('active').removeClass('loading')
                .siblings().removeClass('active');
            newWrapper.append(list);
            bindLoadMore(newWrapper);
            window.scrollTo(0, Math.min($(window).scrollTop(),navBarTop));
        }, 'html');
    });


});