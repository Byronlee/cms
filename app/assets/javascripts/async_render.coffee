class AsymcRender
  constructor: (@stack) ->
    if !@stack
      @stack = $('div[async]')
    else
      @stack = @stack.find('div[async]')

  render: ->
    $.each @stack, (key, obj)->
      $.get $(obj).attr('async-url'), {}, (data)->
        $(obj).hide().html(data).fadeIn(1500)
        eval($(obj).attr('async-callback')) if $(obj).attr('async-callback')

window.async_render = (parent = null) ->
  asymc_render = null
  if parent == null
    asymc_render = new AsymcRender
  else
    asymc_render = new AsymcRender(parent)
  asymc_render.render()

jQuery ->
  window.async_render()
