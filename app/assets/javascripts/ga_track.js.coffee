jQuery ->
  return unless window.ga

  ga('send', 'pageview')

  #$('#logo').click               -> ga('send', 'event', 'link', 'logo',                      ga_user_id)

  # $('#subscription_email').focus -> ga('send', 'event', 'link', 'subscription#create.focus', ga_user_id)

  # $('.product-link').click       -> ga('send', 'event', 'link', 'notes#show',                ga_user_id)
  # $('.post-url').click           -> ga('send', 'event', 'link', 'notes#hit',                 ga_user_id)
  # $('.load-more-notes').click    -> ga('send', 'event', 'link', 'notes#load_more',           ga_user_id)
  # $('#query').focus              -> ga('send', 'event', 'link', 'notes#search.focus',        ga_user_id)

  # $('.share-wechat a').hover(
  #   ->
  #     $trigger = $(this)
  #     return if $trigger.data('ga-sent')

  #     timer = setTimeout ->
  #       ga('send', 'event', 'link', 'share#wechat', ga_user_id)
  #       $trigger.data('ga-sent', true)
  #     , 3000
  #     $trigger.data('ga-timer', timer)
  #   , ->
  #     clearTimeout $(this).data('ga-timer')
  # )

  # $('.share-weibo a').click      -> ga('send', 'event', 'link', 'share#weibo',               ga_user_id)
