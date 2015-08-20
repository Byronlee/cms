jQuery ->
  return unless window.ga

  ga('send', 'pageview')

  #头条点击
  $('#headline_top').click               -> ga('send', 'event', 'link', 'headline#top',                     ga_user_id)
  $('#headline_one').click               -> ga('send', 'event', 'link', 'headline#one',                     ga_user_id)
  $('#headline_two').click               -> ga('send', 'event', 'link', 'headline#two',                     ga_user_id)
  $('#headline_three').click             -> ga('send', 'event', 'link', 'headline#three',                   ga_user_id)
  $('#headline_four').click              -> ga('send', 'event', 'link', 'headline#four',                    ga_user_id)
  $('#headline_five').click              -> ga('send', 'event', 'link', 'headline#five',                    ga_user_id)

  #专栏导航点击
  $('a[id^=column_header_]').click       -> ga 'send', 'event', 'link', $(this).attr('id').replace('header_', 'header#'), ga_user_id

  #登录点击
  $('.J_login').click                    -> ga('send', 'event', 'link', 'login#top_nav',                    ga_user_id)
  $('.login_before_comment').click       -> ga('send', 'event', 'link', 'login#comment',                    ga_user_id)

  #搜索点击
  $(".J_searchForm input").focus         -> ga('send', 'event', 'link', 'search#focus',                     ga_user_id)

  #翻页点击
  $('#info_flows_next_link').click       -> ga('send', 'event', 'link', 'paginate#info_flows#next',         ga_user_id)
  $('#columns_next_link').click          -> ga('send', 'event', 'link', 'paginate#columns#next',            ga_user_id)
  $('#search_next_link').click           -> ga('send', 'event', 'link', 'paginate#search#next',             ga_user_id)
  $('#user_domain_next_link').click      -> ga('send', 'event', 'link', 'paginate#newsflashes#next',        ga_user_id)
  $('.newsflashes_next_link').click      -> ga('send', 'event', 'link', 'paginate#product_notes#next',      ga_user_id)
  $('.product_notes_next_link').click    -> ga('send', 'event', 'link', 'paginate#user_domain#next',        ga_user_id)
  $('#tag_next_link').click              -> ga('send', 'event', 'link', 'paginate#tag#next',                ga_user_id)

  #新闻标题点击
  $(".info_flow_news_title").click       -> ga('send', 'event', 'link', 'news#info_flows#title',            ga_user_id)
  #新闻图片点击
  $(".info_flow_news_image").click       -> ga('send', 'event', 'link', 'news#info_flows#image',            ga_user_id)

  #注销点击
  $('.J_logout').click                   -> ga('send', 'event', 'link', 'logout#top_nav',                   ga_user_id)

  #客户端下载
  $('.app-download').hover               -> ga('send', 'event', 'link', 'app_download#top_nav',             ga_user_id)
  $('.app_download_footer').click        -> ga('send', 'event', 'link', 'app_download#footer',              ga_user_id)

  # 融标签的相关统计
  $('.compiled.rong-company-link').click -> ga('send', 'event', 'link', 'rong-company-link#click',          ga_user_id)
  $('.compiled.rong-company-link').hover -> ga('send', 'event', 'hover', 'rong-company-link#hover',         ga_user_id)

  # 简讯导航点击
  $('.newsflashes_nav').click           -> ga('send', 'event', 'link', 'aside-nav#newsflashes',             ga_user_id)
  $('.next_nav').click         -> ga('send', 'event', 'link', 'aside-nav#product_notes',           ga_user_id)

  #回到顶部
  $(".J_up").click                      -> ga('send', 'event', 'link', 'common#arrow-up',                   ga_user_id)
