jQuery ->
  $("select#s_type").on 'change', (o) ->
    $('.input-small').addClass('hidden')
    $('#s_'+$(this).val()).removeClass('hidden')