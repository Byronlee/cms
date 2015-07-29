jQuery ->

  $("select#s_type").on 'change', (o) ->
    $('.input-small').addClass('hidden')
    $('#s_'+$(this).val()).removeClass('hidden')

  # 上传头图
  $('#fileupload').fileupload()
  .bind('fileuploadstart', (e, data) ->
    $('.feature-img-empty span.slug').html('正在上传...')
  ).bind('fileuploaddone', (e, data) ->
    if data.result.link
      $('.feature-img-empty').html('<img src="'+data.result.link+'"><span class="slug">+ 点击上传头图</span>')
      $('.refresh-btn').removeClass('hidden')
      $('#newsflash_cover').val(data.result.link)

    else
     alert '上传错误，稍后再试!'
     $('.feature-img-empty a span.slug').html('+ 点击上传头图')
  ).bind 'fileuploadfail', (e, data) ->
    alert '上传错误，稍后再试!'
    $('.feature-img-empty a span.slug').html('+ 点击上传头图')

  record_post_manage_session_path = (o)->
    $(o).on 'click', ->
      console.log($(o).attr('href'))
      $.get '/asynces/posts/record_post_manage_session_path', { path: $(o).attr('href') }, ->

  record_post_manage_session_path o for o in ["a[href='/krypton/posts/draft']", "a[href='/krypton/posts/myown']",
   "a[href='/krypton/posts']", "a[href='/krypton/posts/reviewings']",
   "a[href='/krypton/favorites']"]

  $("select#post_source_type").on 'change', (o)->
    $("input#post_user_id").val("785") if $(this).val() == "contribution"

  $("input#post_user_id").on 'keyup', (o)->
    if $("input#post_user_id").val() == "785"
      $("select#post_source_type").val("contribution")
    else
      if $("select#post_source_type").val() == "contribution"
         $("select#post_source_type").val("original")
    return