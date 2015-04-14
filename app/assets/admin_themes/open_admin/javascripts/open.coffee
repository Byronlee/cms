jQuery ->
  $("select#s_type").on 'change', (o) ->
    $('.input-small').addClass('hidden')
    $('#s_'+$(this).val()).removeClass('hidden')

  # 上传头图
  $('#fileupload').fileupload()
  .bind('fileuploadstart', (e, data) ->
    $('.feature-img-empty a span.slug').html('正在上传...')
  ).bind('fileuploaddone', (e, data) ->
    if data.result.link
      $('.feature-img-empty').html('<img src="'+data.result.link+'">')
      $('.refresh-btn').removeClass('hidden')
      $('#newsflash_cover').val(data.result.link)
      window.cover_imags.push data.result.link

    else
     alert '上传错误，稍后再试!'
     $('.feature-img-empty a span.slug').html('+ 点击上传头图')
  ).bind 'fileuploadfail', (e, data) ->
    alert '上传错误，稍后再试!'
    $('.feature-img-empty a span.slug').html('+ 点击上传头图')