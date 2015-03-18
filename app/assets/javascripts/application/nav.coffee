jQuery ->
  $('.dropdown_login_out_link.login_out').on 'click', ->
    $( ".login_out_link" ).trigger( "click" )
