class AsymcRender
  constructor: (@stack) ->
    @stack =  $('div[async=true]')

  render: ->
    $.each @stack, (key, obj)->
      $.get $(obj).attr('async-url'), {}, (data)->
        $(obj).html(data)
        eval($(obj).attr('async-callback')) if $(obj).attr('async-callback')

jQuery ->
  asymc_render = new AsymcRender
  asymc_render.render()