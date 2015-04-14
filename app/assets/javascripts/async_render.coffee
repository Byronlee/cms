class AsymcRender
  constructor: (@stack) ->
    @stack =  [
      ['/posts/hots', '#hot_posts_position']
    ]

  run: (url, destination)->
    $.get url, {}, (data)->
      $(destination).html(data)

  render: ->
    for key, val of @stack
      @run(val[0], val[1])

jQuery ->
  asymc_render = new AsymcRender
  asymc_render.render()