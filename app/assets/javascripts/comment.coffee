window.reply_comment = (o)->
  comment_id = $(o).parents(".comment_details").attr("data-comment-id")
  user_name = $(o).parents(".comment_details").find(".avatar img").attr("alt")
  user_name = user_name.replace('36氪用户','')
  mark_reply_msg = "回复：" + user_name + "<span onclick='delete_reply_comment(this)'>X</span>"
  $("form.comment_form input.re_comment_id").remove()
  $("form.comment_form").append("<input class='re_comment_id' type='hidden' name='comment[parent_id]' value='" + comment_id + "'>")
  $("form.comment_form span.reply_msg").html(mark_reply_msg)
  $("textarea#post").focus()

window.delete_reply_comment = (o)->
  $(o).parent().html("")
  $("form.comment_form input.re_comment_id").remove()

