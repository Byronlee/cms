jQuery ->
  return unless window.ga

  ga('send', 'pageview')

  $('#headline_top').click               -> ga('send', 'event', 'link', 'headline_top',                      ga_user_id)
  $('#headline_one').click               -> ga('send', 'event', 'link', 'headline_one',                      ga_user_id)
  $('#headline_two').click               -> ga('send', 'event', 'link', 'headline_two',                      ga_user_id)
  $('#headline_three').click             -> ga('send', 'event', 'link', 'headline_three',                    ga_user_id)
  $('#headline_four').click              -> ga('send', 'event', 'link', 'headline_four',                     ga_user_id)
