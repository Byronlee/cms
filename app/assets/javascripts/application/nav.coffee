jQuery ->
  $('.dropdown_login_out_link.login_out').on 'click', ->
    alert(2)
    $( ".login_out_link" ).trigger( "click" )
