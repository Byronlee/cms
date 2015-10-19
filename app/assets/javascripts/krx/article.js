// 支付宝打赏
function crowdFunding(author,title,user){
    $.post(KR_CONFIG_OBJECT.crowdFunding,{
        user_nick_name: author,
        article_title: title,
        reward_nick_name: user
    }).done(function(data) {
        if(data.data){
          $('.top-tip-shap img').attr('src', data.data.QRImgUrl);
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
    $('.J_showAllShareBtn').click(function(e){
        e.preventDefault();
        $(this).siblings('.external').removeClass('external');
        $(this).hide();
        $(this).parents('.hide-external').removeClass('hide-external');
    });

    /**
     * 添加收藏
     */
    $('.J_addFavorite').bind('click.J_addFavorite', function(e){
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
    // 获取当前初始化文章的打赏二维码
    var titleCur = $('.article-section:eq(0)').find('.single-post__title').html(),
        authorCur = $('.article-section:eq(0)').find('.author .name').html();
    crowdFunding(authorCur,titleCur,'EE');
    // 获取广告的内容
    var ad = $('.article-section:eq(0)').find('.ad').html().replace(/<script.*?<\/script>/img, '');
    // 获取第二篇文章内容
    var url_code = $('.article-section').attr('data-aid');
    var nextArticleData = $(".article-section:eq(0)").parent().html();
    // 判断该文章是否已存在
    function  pexist(aid){
    var isexists = 0;

    $.each($('.article-section'),function(i,v){
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
      $.each($('.article-section'),function(i,v){
        var title = $(this).find('.single-post__title').html(),
          url = $(this).data('url'),
          oT = $(this).offset().top,
          pH = oT + $(this).outerHeight();


        // 向下滑动
        if(d == 1) {
          if((oT > wT) && (oT < (wT + wH / 3))) {
            if(window.location.href != url) {
              var state = {
                title: title,
                url: window.location.href
              }
              window.history.pushState(state, document.title, url + '?data='+Math.random(100));
              document.title = title;
            }
          }
        } else if(d == 2) {
          // 向上滑动
          if((pH < (wT + wH)) && (pH > (wT + wH * 2 / 3))) {

            if(window.location.href != url) {
              var state = {
                title: title,
                url: window.location.href
              }
              window.history.pushState(state, document.title, url + '?data='+Math.random(100));
              document.title = title;
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
    console.log(curAid);
    var articleData = '';
    $.ajax({
      url: '/p/' + curAid + '.html',
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
    if(data) {
      var dH = $(document).height(),
        showNextCon = '';
      $(window).scrollTop(dH + 100);
      // 替换广告的内容
      // console.log(data);

      showNextCon = $($.parseHTML(data,true)).find('.ad').html(ad).parents('.ajax-article-main').html();
      $('.article-section:last').after(showNextCon);


      var title = $($.parseHTML(data,true)).find('.ad').html(ad).end().find('.single-post__title').html(),
        url = $($.parseHTML(nextArticleData,true)).find('.ad').html(ad).parents('.article-section').data('url'),
        author = $($.parseHTML(data,true)).find('.ad').html(ad).end().find('.author .name').html();
        // console.log(author);
      // 获取打赏二维码
      crowdFunding(author,title,'EE');
      var state = {
        title: title,
        url: window.location.href
      }
      window.history.pushState(state, document.title, url + '?data='+Math.random(100));
      document.title = title;
    }
  }

  // 处理滚动事件
  $(window).scroll(function() {
    var sT = $(window).scrollTop();
    invisiblezone();
    // console.log('aa: ' + (sT + $(window).height() + 50) + 'bb: ' + $(document).height());
    if((sT + $(window).height() + 50) > $(document).height()) {

      var aidC = $($.parseHTML(nextArticleData,true)).find('.ad').html(ad).parents('.article-section').data('aid');

      if(isgeting) return;
      // console.log(aidC);

      if(aidC){
        // if(!aidC) return;
        if(!pexist($($.parseHTML(nextArticleData,true)).find('.ad').html(ad).parents('.article-section').data('aid'))) {
          renderArticle(nextArticleData);
        }
        nextArticleData = getArticle(aidC);
      }
    }
  });
  // *************************End无缝加载********************************
});