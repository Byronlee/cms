// 支付宝打赏
function crowdFunding(url_code,author,title,user){
    $.post(KR_CONFIG_OBJECT.crowdFunding,{
        user_nick_name: author,
        article_title: title,
        reward_nick_name: user
    }).done(function(data) {
        if(data.data){
          $("#article-section-" + url_code).find('.top-tip-shap img').attr('src', data.data.QRImgUrl);
        }
    });
}

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
     * 评论
     */
    $('body').delegate('.J_addCommentBtn', 'click', function(e){
        e.preventDefault();
        var postId = $(this).data('post-id');
        $('body, html').animate({
            scrollTop: $("#article-section-"+postId).find('.single-post-comment').offset().top
        }, 400);
        $("#article-section-"+postId).find('.single-post-comment textarea').trigger('focus');
    })

    /**
     * 分享展开操作
     */
    $('body').delegate('.J_showAllShareBtn', 'click', function(e){
        e.preventDefault();
        $(this).siblings('.external').removeClass('external');
        $(this).hide();
        $(this).parents('.hide-external').removeClass('hide-external');
    })

    /**
     * 添加收藏
     */
    $('body').delegate('.J_addFavorite', 'click', function(e){
      if (($('.require-login').data().uid == undefined || $('.require-login').data().uid == '')){
        return
      }
        e.preventDefault();
        var countWrap = $(this).find('span');
        var count = countWrap.text()-0;
        var trigger = $(this);
        if($(this).hasClass('is-favorite')){
            $(this).removeClass('is-favorite');
            trigger.removeClass('icon-fly');
            countWrap.html(count - 1);
        }else{
            $(this).addClass('is-favorite');
            countWrap.html(count + 1);
            setTimeout(function(){
                trigger.addClass('icon-fly');
            },0);
        }
    })

  // *************************Begin无缝加载********************************
  // 隐藏footer
  $('.common-footer').hide();
  var readingDom = '<a href=" " class="reading-open" data-stat-click="Wenzhang.chenjinyuedu.click">'
              + '<span></span>'
              + '<span></span>'
              + '<span></span>'
              + '<span></span>'
          + '</a >'
          + '<div class="reading-tips">'
              + '<p>'
                  + '在这里可以<br/>'
                  + '开启纯净阅读模式！'
              + '</p >'
              + '<a href="#" class="btn-known">我知道了</a >'
          + '</div>';

    $('.fixed-tools').html(readingDom + $('.fixed-tools').html());
    //$('.icon-qr').before($(readingDom));

    // 获取当前初始化文章的打赏二维码
    var url_code = $('.reading-off .article-section').attr('data-aid');
    var titleCur = $('.reading-off .article-section:eq(0)').find('.single-post__title').html(),
        authorCur = $('.reading-off .article-section:eq(0)').find('.author .name').html();
    crowdFunding(url_code,authorCur,titleCur,'EE');
    // 获取广告的内容
    var ad = $('.reading-off .article-section:eq(0)').find('.ad').html().replace(/<script.*?<\/script>/img, '');
    // 获取第二篇文章内容
    var nextArticleData = '';
    var date = new Date();
    if(window.location.href.indexOf('preview') == -1){
      $.get('/p/' + url_code + '.html?t=' + date.getTime(), function(data) {
        nextArticleData = data;
      });
    } else {
      $('.common-footer').show();
    }
    // 判断该文章是否已存在
    function  pexist(obj,aid){
    var isexists = 0;

    $.each($(obj).find('.article-section'),function(i,v){
      if($(this).data('aid') == aid){
        isexists = 1;
      }

    });
    return isexists;
  }

  var curscrolltop = -1;
  // 判断是否在视野内
  function invisiblezone() {
    var wT = $(window).scrollTop(),
      wH = $(window).height();
    if(Math.abs(wT - curscrolltop) < 20) {
      return 0;
    }
    var d = 0; //1 向下滑动   2  向上滑动
    if((wT - curscrolltop) > 0) {
      d = 1;
    } else if((wT - curscrolltop) < 0) {
      d = 2;
    }

    var wB = $(window).scrollTop() + $(window).height();
    if(curscrolltop > -1) {
      $.each($('.reading-off .article-section'),function(i,v){
        var title = $(this).find('.single-post__title').html(),
          url = $(this).data('url'),
          oT = $(this).offset().top,
          pH = oT + $(this).outerHeight();


        // 向下滑动
        var date = new Date();
        if(d == 1) {
          if((oT > wT) && (oT < (wT + wH / 3))) {
            if(window.location.href != url) {
              var state = {
                title: title,
                url: window.location.href
              }
              window.history.pushState(state, document.title, url);
              document.title = title;
              krtracker('trackPageView', location.pathname);
              _hmt.push(['_trackPageview', location.pathname]);
            }
          }
        } else if(d == 2) {
          // 向上滑动
          if((pH < (wT + wH)) && (pH > (wT + wH / 3))) {

            if(window.location.href != url) {
              var state = {
                title: title,
                url: window.location.href
              }
              window.history.pushState(state, document.title, url);
              document.title = title;
              krtracker('trackPageView', location.pathname);
              _hmt.push(['_trackPageview', location.pathname]);
            }
          }
        }
      });
    }

    curscrolltop = wT;
  }

  // 获取文章内容
  var isgeting = 0;
  function getArticle(curAid) {
    var articleData = '';
    var date = new Date();
    $.ajax({
      url: '/p/' + curAid + '.html?t=' + date.getTime(),
      type: 'get',
      beforeSend: function() {
        isgeting = 1;
      },
      success: function(data) {
        // 获取内容成功
        isgeting = 0;
        if(data) {
          articleData = "<div class='ajax-article-main'>" + data + "</div>";
          nextArticleData = articleData;
        } else {
          //alert('没有文章了！');
        }
      }
    });
  }


  // 渲染文章
  function renderArticle(data) {
    data = "<div class='ajax-article-main'>" + data + "</div>";
    var date = new Date();
    var url_code = $($.parseHTML(data,true)).find('.article-section').attr('data-aid');
    if(data) {
      var dH = $(document).height(),
        showNextCon = '';
      $(window).scrollTop(dH + 100);
      // 替换广告的内容
      // console.log(data);

      showNextCon = $($.parseHTML(data,true)).find('.ad').html(ad).parents('.ajax-article-main').html();
      $('.reading-off .article-section:last').after(showNextCon);


      var title = $($.parseHTML(data,true)).find('.ad').html(ad).end().find('.single-post__title').html(),
        url = $($.parseHTML(nextArticleData,true)).find('.ad').html(ad).parents('.article-section').data('url'),
        author = $($.parseHTML(data,true)).find('.ad').html(ad).end().find('.author .name').html();
        // console.log(author);
      // 获取打赏二维码
      crowdFunding(url_code,author,title,'EE');
      var state = {
        title: title,
        url: window.location.href
      }
      window.history.pushState(state, document.title, url);
      document.title = title;
      krtracker('trackPageView', location.pathname);
      _hmt.push(['_trackPageview', location.pathname]);
    }
  }

  // 处理滚动事件
  $(window).scroll(function() {
    if(window.location.href.indexOf('preview') != -1) return;
    var sT = $(window).scrollTop();
    invisiblezone();
    // console.log('aa: ' + (sT + $(window).height() + 50) + 'bb: ' + $(document).height());
    if((sT + $(window).height() + 300) > $(document).height()) {
      var aidC = $($.parseHTML(nextArticleData,true)).find('.ad').html(ad).parents('.article-section').data('aid');

      // console.log(aidC);

      if(aidC){
        // if(!aidC) return;
        if(!pexist('.reading-off', $($.parseHTML(nextArticleData,true)).find('.ad').html(ad).parents('.article-section').data('aid'))) {
          renderArticle(nextArticleData);
        }
        if(isgeting) return;
        nextArticleData = getArticle(aidC);
      }else{
        $('.common-footer').show();
      }
    }
  });
  // *************************End无缝加载********************************

  // =============================沉浸模式===============================
  if(!window.localStorage.getItem('readingStatus')) {
        $('.reading-tips').addClass('show');
    }

    $('.btn-known').click(function(e) {
        e.preventDefault();
        $('.reading-tips').removeClass('show');
        window.localStorage.setItem('readingStatus',true);
    });

    var reading = false;
    $('.reading-open').click(function(e) {
      e.preventDefault();
      if(!window.localStorage.getItem('readingStatus')) {
        window.localStorage.setItem('readingStatus',true);
        $('.reading-tips').removeClass('show');
      }
      // 判断当前阅读模式按钮的状态
      $(this).toggleClass('active');
        if($(this).is('.active')) {
          reading = true;
          $('.reading-off').addClass('reading-model');
        } else {
          reading = false;
          $('.reading-off').removeClass('reading-model');
          return;
      }


        var html = '';

        // 输出当前可视区域的文章
        var readingOnNextData = '';
        var existHtml = '';   //非阅读模式已存在的文章
        var curIndex = 0;


        if(window.location.href.indexOf('preview') != -1) {
          existHtml = '<div class="article-section" data-aid="'+ $('.reading-off .article-section').data('aid') +'" data-url="'+ $('.reading-off .article-section').data('url') +'"><div class="inner"><article class="single-post"><section class="single-post-header">' + $('.reading-off .article-section').find('.single-post-header').html() + '</section><br/><section class="article">' + $('.reading-off .article-section').find('.article').html() + '</article></article></div></div>';
        } else {
        // 获取当前可视区范围内文章的ID
          var path = window.location.pathname,
          id = path.match(/\/p\/(\d+)\.html$/)[1];
          // var path = window.location.pathname;
          // // ******需要根据url进行截取id******
          // var id = path.substr(1,location.pathname.substr(1).length - 5);
          // var id = path.match(\/(\d+)\.html$);


          // 循环获取非阅读模式已存在的文章，并对其下一篇文章进行获取
          $('.reading-off .article-section').each(function(i, val) {
            existHtml += '<div class="article-section" data-aid="'+ $(this).data('aid') +'" data-url="'+ $(this).data('url') +'"><div class="inner"><article class="single-post"><section class="single-post-header">' + $(this).find('.single-post-header').html() + '</section><br/><section class="article">' + $(this).find('.article').html() + '</article></article></div></div>';
            if($(this).data('aid') == id) {
              curIndex = i;
            }
          });
        }

        $(existHtml).appendTo($('.reading-article .content-wrapper'));
        if(!$('.reading-off .article-section').eq(curIndex).next().html()) {
          if(isgeting) return;
          if(window.location.href.indexOf('preview') == -1){
            getArticle(id);
            readingOnNextData = '<div class="ajax-article-main"><div class="article-section" data-aid="'+ $($.parseHTML(nextArticleData,true)).children().parents('.article-section').data('aid') +'" data-url="'+ $($.parseHTML(nextArticleData,true)).children().parents('.article-section').data('url') +'"><div class="inner"><article class="single-post"><section class="single-post-header">' + $($.parseHTML(nextArticleData,true)).find('.single-post-header').html() + '</section><br/><section class="article">' + $($.parseHTML(nextArticleData,true)).find('.article').html() + '</article></article></div></div></div>';
          }
        }

        $('.reading-article').addClass('active').scrollTop(0);
        // $('.reading-article').show().animate({'top': 0}, 500).scrollTop(0);
        // 阅读模式下，定位至当前的文章
        setTimeout(function() {
          var s = $('.reading-on .article-section').eq(curIndex).offset().top - $('.reading-on').offset().top - 20;
          $('.reading-article').scrollTop(s);
          // $('.reading-article').animate({scrollTop: ($('.reading-on .article-section').eq(curIndex).offset().top - $('.reading-on').offset().top)}, 800);
        }, 50);
        $('body').height($(window).height()).css('overflow','hidden');
        var readingCurscrolltop = -1;
        $('.reading-article').scroll(function() {
          if(window.location.href.indexOf('preview') != -1) return;
          var sT = $(this).scrollTop();

          // 判断视野范围
          var wT = sT,
            wH = $(window).height();
          if(Math.abs(wT - readingCurscrolltop) < 20) {
            return 0;
          }
          var d = 0; //1 向下滑动   2  向上滑动
          if((wT - readingCurscrolltop) > 0) {
            d = 1;
          } else if((wT - readingCurscrolltop) < 0) {
            d = 2;
          }

          var wB = sT + $(window).height();
          if(readingCurscrolltop > -1) {
            $.each($('.reading-on .article-section'), function(i, v) {
              var title = $(this).find('.single-post__title').html(),
                url = $(this).data('url'),
                curItem = i;
              var oT = 20;
              $.each($(this).prevAll(), function() {
                oT = oT + $(this).height() + 20;
              })

              var pH = oT + $(this).outerHeight();

              // 向下滑动
              if(d == 1) {
                if((oT > wT) && (oT < (wT + wH / 3))) {
                  if(window.location.href != url) {
                    var state = {
                      title: title,
                      url: window.location.href
                    }
                    window.history.pushState(state, document.title, url);
                    document.title = title;
                    krtracker('trackPageView', location.pathname);
                    _hmt.push(['_trackPageview', location.pathname]);
                  }
                }
              } else if(d == 2) {
                // 向上滑动
                if((pH < (wT + wH)) && (pH > (wT + wH / 3))) {

                  if(window.location.href != url) {
                    var state = {
                      title: title,
                      url: window.location.href
                    }
                    window.history.pushState(state, document.title, url);
                    document.title = title;
                    krtracker('trackPageView', location.pathname);
                    _hmt.push(['_trackPageview', location.pathname]);
                  }
                }
              }

            });
          }

          readingCurscrolltop = wT;


          // console.log('aa: ' + (sT + $(window).height()) + 'bb: ' + $('.reading-on .article-detail-wrap').height());
          if((sT + $(window).height()) > ($('.reading-on .article-detail-wrap').height())) {
            if(!$('.reading-open').is('.active')) return;
            var aidC = $($.parseHTML(nextArticleData,true)).find('.article-section').data('aid');
            // console.log('aidC:' + aidC);
            if(!aidC) return;
            readingOnNextData = '<div class="ajax-article-main"><div class="article-section" data-aid="'+ $($.parseHTML(nextArticleData,true)).find('.article-section').data('aid') +'" data-url="'+ $($.parseHTML(nextArticleData,true)).find('.article-section').data('url') +'"><div class="inner"><article class="single-post"><section class="single-post-header">' + $($.parseHTML(nextArticleData,true)).find('.single-post-header').html() + '</section><br/><section class="article">' + $($.parseHTML(nextArticleData,true)).find('.article').html() + '</article></article></div></div></div>';
            // 判断是否已经存在
            if(!pexist('.reading-on',$($.parseHTML(readingOnNextData,true)).find('.article-section').data('aid'))) {
              if(readingOnNextData) {
                // var dH = $('.reading-on .article-detail-wrap').height() + 30,
                var showNextCon = '';
                // $('reading-on').scrollTop(dH + 100);
                showNextCon = $($.parseHTML(readingOnNextData,true)).html();
                $('.reading-on .article-section:last').after(showNextCon);
                renderArticle(nextArticleData);
                // var title = $($.parseHTML(readingOnNextData,true)).find('.single-post__title').html(),
                // url = $($.parseHTML(readingOnNextData,true)).find('.article-section').data('url');

                // var state = {
                //  title: title,
                //  url: window.location.href
                // }
                // window.history.pushState(state, document.title, url);
                // document.title = title;
              }
            }
            if(isgeting) return;
            nextArticleData = getArticle(aidC);
          }
        })
    });
    $('body').on('click','.reading-on',function(e) {
      e.preventDefault();
      e.stopPropagation();
      var _This = $(this);
      $('.reading-open').removeClass('active');
      _This.removeClass('active').find('.article-section').remove();
      // _This.hide().css('top', '100%').find('.article-section').remove();
      $('body').css({'height': 'auto', 'overflow': 'auto'});
      $('.reading-off').removeClass('reading-model');
      if(window.location.href.indexOf('preview') != -1) return;
      var path = window.location.pathname;
      var id = path.match(/\/p\/(\d+)\.html$/)[1];
      $('.reading-off .article-section').each(function() {
        if($(this).data('aid') == id) {
          var s = $(this).offset().top - 20;
          $('body').scrollTop(s);
        }
      });
    });
    $('body').on('click', '.reading-on .article-section', function(e) {
		e.stopPropagation();
	})
});