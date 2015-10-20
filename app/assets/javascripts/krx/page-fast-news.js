$(document).ready(function(){
    var prevIndex = -1;
    $('body').on('click', '.fase-time-line h2 a', function(e) {
        e && e.preventDefault();
        var curIndex = $(this).parents('.item').index('.fase-time-line > .item');
        if(prevIndex == curIndex) {
            if($(this).data('show')) {
                $(this).data('show', false).parents('.item').removeClass('ac');
            } else {
                //点击快讯并展开时发送统计请求
                if($(this).data('id')){
                    addPageView($(this).data('id'))
                };
                $(this).data('show', true).parents('.item').addClass('ac');
            }
        } else {
            //点击快讯并展开时发送统计请求
            if($(this).data('id')){
                addPageView($(this).data('id'))
            };
            $('.fase-time-line > .item').removeClass('ac').find('.item-details a').data('show', false);
            $(this).data('show', true).parents('.item').addClass('ac');
        }
        $(this).parents('.item').removeClass('lastest');
        prevIndex = curIndex;
        $('.fase-time-line').find('.weixin').removeClass('ac').find('.panel-weixin').remove();
        $('.top-articles section').removeClass('active');
    });



	 // 微信
     // function wxClick(e) {
     //    e.preventDefault();
     //    e.stopPropagation();
     //    $(this).parents('article').siblings().find('.weixin').removeClass('ac').find('.panel-weixin').remove();
     //    var codeUrl = $(this).data('url');
     //    var html = '<div class="panel-weixin">'
     //                    + '<section class="weixin-section">'
     //                        + '<p>'
     //                            + '<img alt="533066" src="http://s.jiathis.com/qrcode.php?url=' + codeUrl + '">'
     //                        + '</p>'
     //                    + '</section>'
     //                    + '<h3>打开微信“扫一扫”，打开网页后点击屏幕右上角分享按钮</h3>'
     //                + '</div>';
     //    $(this).toggleClass('ac');
     //    if($(this).hasClass('ac')) {
     //        $(this).append(html);
     //    } else {
     //        $(this).find('.panel-weixin').remove();
     //    }
     // }
    // $('body').on('click', '.fase-time-line .item-details .weixin','.top-articles .weixin', function(e) {
    //     e.preventDefault();
    //     e.stopPropagation();
    //     $(this).parents('article').siblings().find('.weixin').removeClass('ac').find('.panel-weixin').remove();
    //     var codeUrl = $(this).data('url');
    //     var html = '<div class="panel-weixin">'
    //                     + '<section class="weixin-section">'
    //                         + '<p>'
    //                             + '<img alt="533066" src="http://s.jiathis.com/qrcode.php?url=' + codeUrl + '">'
    //                         + '</p>'
    //                     + '</section>'
    //                     + '<h3>打开微信“扫一扫”，打开网页后点击屏幕右上角分享按钮</h3>'
    //                 + '</div>';
    //     $(this).toggleClass('ac');
    //     if($(this).hasClass('ac')) {
    //         $(this).append(html);
    //     } else {
    //         $(this).find('.panel-weixin').remove();
    //     }
    // });

// 微博分享
    $('body').on('click','.hot-news .weibo',function(e) {
        e.stopPropagation();
    });

    $('body').on('click', '.page-fast-main .weixin', function(e) {
        e.preventDefault();
        e.stopPropagation();
        // $('.page-fast-main .weixin').removeClass('ac').find('.panel-weixin').remove();
        // // $(this).parents('article').siblings().find('.weixin').removeClass('ac').find('.panel-weixin').remove();
        var codeUrl = $(this).data('url');
        var html = '<div class="panel-weixin">'
                        + '<section class="weixin-section">'
                            + '<p>'
                                + '<img alt="533066" src="http://s.jiathis.com/qrcode.php?url=' + codeUrl + '">'
                            + '</p>'
                        + '</section>'
                        + '<h3>打开微信“扫一扫”，打开网页后点击屏幕右上角分享按钮</h3>'
                    + '</div>';
        $(this).toggleClass('ac');
        if($(this).hasClass('ac')) {
            $(this).append(html);
        } else {
            $(this).find('.panel-weixin').remove();
        }
    });


    /**
     * 加载更多(TODO:需要再跟后端联调加载逻辑)
     */

    function bindLoadMore(wrapper){
        wrapper = wrapper || $('.fase-time-line').eq(0);
        $('.J_listLoadMore', wrapper).click(function(e){
            e.preventDefault();
            var trigger = $(this);
            if(trigger.hasClass('no-data'))return;
            if(trigger.hasClass('loading'))return;
            trigger.addClass('loading');

            $.get(trigger.attr('href'), function(list){
                var newWrapper = trigger.parent();
                // $(list).appendTo($('.fase-time-line'));
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

    // 最热快讯
    window.countedStaticsItem = window.countedStaticsItem || [];
    function addPageView(id){
        if(countedStaticsItem.indexOf(id)>-1)return;
        countedStaticsItem.push(id);
        /**
         * 发送统计请求
         */
        window._hmt && _hmt.push(['_trackPageview', '/clipped/'+id]);
        $.post(KR_CONFIG_OBJECT.trackClipPage.replace('{id}', id), {
            id: id
        });
    }
    var bindItemActions = function (e){
        if($(this).hasClass('active')){
            $(this).removeClass('active');
        } else{
            //点击快讯并展开时发送统计请求
            if($(this).data('id')){
                addPageView($(this).data('id'))
            };
            $(this).addClass('active')
                .siblings().removeClass('active');
        }
        // $('.J_fastSectionList .wrap').perfectScrollbar('update');

        // if($(this).parents().is('.fast-news-panel')) {
            $('.page-fast-main .weixin').removeClass('ac').find('.panel-weixin').remove();
            $('.fase-time-line h2 a').data('show', false).parents('.item').removeClass('ac');
    };
    $('body').delegate('.top-articles section', 'click', bindItemActions);
});