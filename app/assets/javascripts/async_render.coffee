class AsymcRender
  constructor: (@stack) ->
    @stack ||= $('div[async]')

  render: ->
    $.each @stack, (key, obj)->
      $.get $(obj).attr('async-url'), {}, (data)->
        $(obj).hide().html(data).fadeIn(1500)
        eval($(obj).attr('async-callback')) if $(obj).attr('async-callback')

window.async_render = (obj = '') ->
  asymc_render = null
  if obj
    asymc_render = new AsymcRender
    console.log(asymc_render)

  else
    asymc_render = new AsymcRender(obj)

  asymc_render.render()

jQuery ->
  window.async_render()
