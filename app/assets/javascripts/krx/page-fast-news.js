$(document).ready(function(){
    var prevIndex = -1;
    $('body').on('click', '.fase-time-line h2 a', function(e) {
        e && e.preventDefault();
        var curIndex = $(this).parents('li').index('.fase-time-line li');
        if(prevIndex == curIndex) {
            if($(this).data('show')) {
                $(this).data('show', false).parents('li').removeClass('ac');
            } else {
                $(this).data('show', true).parents('li').addClass('ac');
            }
        } else {
            $('.fase-time-line li').removeClass('ac').find('.item-details a').data('show', false);
            $(this).data('show', true).parents('li').addClass('ac');
        }
        prevIndex = curIndex;
        $('.fase-time-line').find('.weixin').removeClass('ac').find('.panel-weixin').remove();
    });



	 // 微信
    $('body').on('click', '.fase-time-line .item-details .weixin', function(e) {
        e.preventDefault();
        e.stopPropagation();
        $(this).parents('article').siblings().find('.weixin').removeClass('ac').find('.panel-weixin').remove();
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
        wrapper = wrapper || $('.fase-time-line').parents('.content-wrapper').eq(0);
        $('.J_listLoadMore', wrapper).click(function(e){
            e.preventDefault();
            var trigger = $(this);
            if(trigger.hasClass('no-data'))return;
            if(trigger.hasClass('loading'))return;
            trigger.addClass('loading');
            
            $.get(trigger.attr('href'), function(list){
                var newWrapper = trigger.parent();
                $(list).appendTo($('.fase-time-line'));
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