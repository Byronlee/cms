jQuery ->
  return unless window.ga

  ga('send', 'pageview')

  #头条点击
  $('#headline_top').click               -> ga('send', 'event', 'link', 'headline#top',                      ga_user_id)
  $('#headline_one').click               -> ga('send', 'event', 'link', 'headline#one',                      ga_user_id)
  $('#headline_two').click               -> ga('send', 'event', 'link', 'headline#two',                      ga_user_id)
  $('#headline_three').click             -> ga('send', 'event', 'link', 'headline#three',                    ga_user_id)
  $('#headline_four').click              -> ga('send', 'event', 'link', 'headline#four',                     ga_user_id)

  #登录点击
  $('.second-nav__login').click          -> ga('send', 'event', 'link', 'login#top_nav',                     ga_user_id)
  $('.login_before_comment').click       -> ga('send', 'event', 'link', 'login#comment',                     ga_user_id)

  #搜索点击
  $("#search_input_field").focus         -> ga('send', 'event', 'link', 'search#focus',                      ga_user_id)
