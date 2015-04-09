jQuery ->
  return unless window.ga

  ga('send', 'pageview')

  #头条点击
  $('#headline_top').click               -> ga('send', 'event', 'link', 'headline_top',                      ga_user_id)
  $('#headline_one').click               -> ga('send', 'event', 'link', 'headline_one',                      ga_user_id)
  $('#headline_two').click               -> ga('send', 'event', 'link', 'headline_two',                      ga_user_id)
  $('#headline_three').click             -> ga('send', 'event', 'link', 'headline_three',                    ga_user_id)
  $('#headline_four').click              -> ga('send', 'event', 'link', 'headline_four',                     ga_user_id)

  #登录点击
  $('.second-nav__login').click          -> ga('send', 'event', 'link', 'login_top_nav',                     ga_user_id)
  $('.login_before_comment').click       -> ga('send', 'event', 'link', 'login_comment',                     ga_user_id)

  #搜索点击
