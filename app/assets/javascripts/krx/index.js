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
    $('.J_newsListNavBar a').click(function(e){
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
        }, 'html');


// $('.J_fastSectionList .wrap').bind('scroll', function bind(e){

//         if(!$('.J_fastSectionNavBar a[name="product"]').hasClass('active')){
//             return;
//         }
//         //var top = $(this).scrollTop();
//         var wrap = $(this);
//         $(this).find('.panel:visible section').each(function(){
//             var item = $(this);
//             var bound = item.offset().top - wrap.offset().top - wrap.height() + item.height()/2;

//             if(bound<0){
//                 if(item.data('id')){
//                     addPageView(item.data('id'))
//                 };
//             }

//         });
//     });
        if($(this).is(':last-child')) {
            $(window).bind('scroll', function() {
                $('.article-list .articles:last-child').addClass('articles-pdn');
                var wrap = $('.article-list .articles-pdn');
                
                wrap.find('article').each(function() {
                    var item = $(this);
                    var bound = item.offset().top - wrap.offset().top - wrap.height() + item.height() / 2;
                    console.log('bound: ' + (item.offset().top - wrap.offset().top));
                    if(bound < 0) {
                        if(item.data('id')) {
                            addPageView(item.data('id'));
                        }
                    }
                })
            })
        }
    });

    $('body').on('click','.mask-tags', function(e) {
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

     /**
     * 绑定大图交互
     */

    $('body').on('click','.article-list .articles article .product img', function(e) {
        e.stopPropagation();
        $('.article-list .articles article .product').magnificPopup({
            delegate: 'img', // child items selector, by clicking on it popup will open
            type: 'image'
            // other options
        });
        $.magnificPopup.open({
            items: {
                src: $(this).attr('src')
            },
            type: 'image'
        }, 0);
    })

     // 微信
    $('body').on('click', '.article-list .articles-pdn .weixin', function(e) {
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

    
    
    // ProDuct Note
    // $('body').on('click','.product h3', function() {
    //     $(this).next().toogleClass('show');
    //     $('.product .main').toogleClass('show');
    // });
        

    // $(".feed img").bind("error",function(){ 
    //     console.log(222);  
    //     this.src="../images/default_avatar.png";   
    // }); 
        
});