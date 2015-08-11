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
        $('.J_listLoadMore', wrapper).unbind().click(function(e){
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

    var navBarTop = $('.J_newsListNavBar').length && $('.J_newsListNavBar').offset().top;

    $(window).resize(function(){
        navBarTop = $('.J_newsListNavBar').length && $('.J_newsListNavBar').offset().top;
    });

    if($('.categories [data-type="all"]').hasClass('active')){
        $('.pre-load-ads .J_channelIndexAd').clone().prependTo($('.J_articleList'));
    }

    $('.J_newsListNavBar a.active').data('listWrapper', $('.J_articleList').eq(0))
    $('.J_newsListNavBar a.tab').click(function(e){
        e.preventDefault();



        var url = $(this).attr('href');
        var link = $(this);

        if(link.siblings('.loading').length){
            return;
        }

        window.scrollTo(0, Math.min($(window).scrollTop(),navBarTop));

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
            $('.pre-load-ads .J_channelAd').clone().prependTo(newWrapper);
            newWrapper.show()
                .siblings().hide();
            link.addClass('active').removeClass('loading')
                .siblings().removeClass('active');
            newWrapper.append(list);
            bindLoadMore(newWrapper);
            $(window).trigger('scroll');
            $(".timeago").timeago();

        }, 'html');
    });

    $('body').on('click','.J_articleList .mask-tags', function(e) {
        e.preventDefault();
        e.stopPropagation();
        var index = 0,
            type = $(this).data('type');

        $('.J_newsListNavBar a').each(function() {
            if($(this).data('type') == type) {
                $(this).click();
            }
        });
    });


    var feedData = {};
    $.get('https://rong.36kr.com/api/hostsite/fetchFeeds',{
        page: 1,
        pageSize: 10
    }).done(function(data){
        feedData = data;
        var feedInner = '{@each data.data as item, k}'
                + '<section class="feed">'
                    + '<header>'
                        + '<a href="${item.innerImgLink}" class="figure">'
                            + '<img src="${item.mainImgUrl}" alt="" width="25">'
                        + '</a>'
                        + '<a href="${item.innerImgLink}" class="name">${item.mainName}</a>'
                        + '<i></i>'
                        + '<span>${item.feedTime}</span>'
                    + '</header>'
                    + '<div class="penel-body">'
                        + '<p>$${item.content}</p>'
                    + '</div>'
                + '</section>'
                + '{@/each}';
        juicer.set('cache',true);
        juicer.set('errorhandling',false);
        juicer.set('strip',true);
        juicer.set('detection',false);

        var compiled_tpl = juicer(feedInner);
        var html = compiled_tpl.render(feedData);
        $('.feed-inner').append(html);
    });


});