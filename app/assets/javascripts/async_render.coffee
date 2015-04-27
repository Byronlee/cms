class AsymcRender
  constructor: (@stack) ->
    @stack =  $('div[async=true]')

  render: ->
    $.each @stack, (key, obj)->
      $.get $(obj).attr('async-url'), {}, (data)->
        $(obj).hide().html(data).fadeIn(1500) 
        eval($(obj).attr('async-callback')) if $(obj).attr('async-callback')

jQuery ->
  asymc_render = new AsymcRender
  asymc_render.render()