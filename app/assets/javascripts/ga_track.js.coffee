jQuery ->
  return unless window.ga

  ga('send', 'pageview')

  #头条点击
  $('#headline_top').click               -> ga('send', 'event', 'link', 'headline#top',                     ga_user_id)
  $('#headline_one').click               -> ga('send', 'event', 'link', 'headline#one',                     ga_user_id)
  $('#headline_two').click               -> ga('send', 'event', 'link', 'headline#two',                     ga_user_id)
  $('#headline_three').click             -> ga('send', 'event', 'link', 'headline#three',                   ga_user_id)
  $('#headline_four').click              -> ga('send', 'event', 'link', 'headline#four',                    ga_user_id)

  #登录点击
  $('.second-nav__login').click          -> ga('send', 'event', 'link', 'login#top_nav',                    ga_user_id)
  $('.login_before_comment').click       -> ga('send', 'event', 'link', 'login#comment',                    ga_user_id)

  #搜索点击
  $("#search_input_field").focus         -> ga('send', 'event', 'link', 'search#focus',                     ga_user_id)

  #翻页点击
  $('#info_flows_prev_link').click       -> ga('send', 'event', 'link', 'paginate#info_flows#previous',     ga_user_id)
  $('#info_flows_next_link').click       -> ga('send', 'event', 'link', 'paginate#info_flows#next',         ga_user_id)
  $('#columns_prev_link').click          -> ga('send', 'event', 'link', 'paginate#columns#previous',        ga_user_id)
  $('#columns_next_link').click          -> ga('send', 'event', 'link', 'paginate#columns#next',            ga_user_id)
  $('#tag_prev_link').click              -> ga('send', 'event', 'link', 'paginate#tag#previous',            ga_user_id)
  $('#tag_next_link').click              -> ga('send', 'event', 'link', 'paginate#tag#next',                ga_user_id)

  #新闻标题点击
  $(".info_flow_news_title").click       -> ga('send', 'event', 'link', 'news#info_flows#title',            ga_user_id)
  #新闻图片点击
  $(".info_flow_news_image").click       -> ga('send', 'event', 'link', 'news#info_flows#image',            ga_user_id)

  #注销点击
  $('.dropdown_login_out_link').click    -> ga('send', 'event', 'link', 'logout#top_nav',                   ga_user_id)

  #分类下拉点击
  $(".man-nav__item_category").click     -> ga('send', 'event', 'link', 'nav#categories',                   ga_user_id)
  #活动下拉点击
  $(".man-nav__item_event").click        -> ga('send', 'event', 'link', 'nav#events',                       ga_user_id)

  #客户端下载
  $('#app_download_top_nav').click       -> ga('send', 'event', 'link', 'app_download#top_nav',             ga_user_id)
  $('#app_download_footer').click        -> ga('send', 'event', 'link', 'app_download#footer',              ga_user_id)
