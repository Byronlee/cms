window.reply_comment = (parent)->
  comment_id = parent.find(".comment_details").attr("data-comment-id")
  user_name = parent.find(".comment_details").find(".avatar img").attr("alt")
  user_name = user_name.replace('36氪用户','')
  mark_reply_msg = "回复：" + user_name + "<span onclick='delete_reply_comment(this)'>X</span>"
  parent.find("form.comment_form input.re_comment_id").remove()
  parent.find("form.comment_form").append("<input class='re_comment_id' type='hidden' name='comment[parent_id]' value='" + comment_id + "'>")
  parent.find("form.comment_form span.reply_message").attr('class','reply_message reply_msg')
  parent.find("form.comment_form span.reply_message").html(mark_reply_msg)
  parent.find("textarea#post").focus()

window.delete_reply_comment = (o)->
  $(o).parent().html("")
  $("form.comment_form input.re_comment_id").remove()
  $("form.comment_form span.reply_message").attr('class','reply_message')

window.bind_comment = () ->
  $('body').delegate '.comment-submit-btn', 'click', (o) ->
    postId = $(this).data('post-id')
    parent = $("#article-section-" + postId)
    comment_message = parent.find('form.comment_form #post').val()
    frm = parent.find('form.comment_form')
    uid = parent.find('.single-post-comment__form').data("uid")
    if !uid || comment_message == ''
      return
    $.ajax
      type: frm.attr('method')
      url: frm.attr('action')
      data: frm.serialize() + '&current_maxid=' + (parent.find('.comment_details').data('comment-id') or 0)
      beforeSend: ->
        $(o).attr 'diabled', 'true'
        parent.find('span.ladda-label').html '提交评论...'
        return
      success: (data) ->
        parent.find('.single-post-comment__comments').prepend data
        parent.find('.comment_total_count').text parent.find('.comments_total_count').data('total-count') or 0
        parent.find('.comment_form_count').text parent.find('.comments_total_count').data('total-count') or 0
        parent.find('#error_msg').text parent.find('.comments_total_count').data('message')
        if parent.find('.comments_total_count').data('message') == ''
          frm[0].reset()
        parent.find('span.reply_message span').trigger 'click'
        parent.find('.timeago').timeago()
        initLazyLoad()
        return
      complete: ->
        parent.find(o).removeAttr 'diabled'
        parent.find('span.ladda-label').html '提交评论'
        return
    return

window.commentsLoadComplete = (parent) ->
  parent.find('.timeago').timeago()
  parent.find('.comment_total_count').text parent.find('.comments_total_count').data('total-count') or 0
  parent.find('.comment_form_count').text parent.find('.comments_total_count').data('total-count') or 0
  anchor = $('a[name="' + window.location.hash + '"]')
  if anchor.length > 0
    parent.find('body').animate { scrollTop: parent.find('a[name="' + window.location.hash + '"]').offset().top }, 600
  return

window.check_comment_submit_btn = (parent) ->
  uid = parent.find('.single-post-comment__form').data("uid")
  if !uid
    $('textarea#post.textarea, button.ladda-button.comment-submit-btn').attr('disabled','disabled')
  return
