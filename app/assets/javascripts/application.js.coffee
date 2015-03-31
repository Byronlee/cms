#= require jquery
#= require jquery_ujs
#= require ./timeago/timeago
#= require ./timeago/timeago.zh-cn

if !window.BAIDU_CLB_fillSlot || $('html').is('.portable-device')
  window.BAIDU_CLB_fillSlot = (id) ->

do ->
  _alert = alert
  # 屏蔽百度挟持代码弹出的 alert
  window.alert = (message) -> _alert(message) unless message.match("malicious javascript")


mobilecheck = ->
  check = false
  ((a) ->
    if /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(a) or /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0, 4))
      check = true
    return
  ) navigator.userAgent or navigator.vendor or window.opera
  check

goSearch = (f) ->
  v = document.search_baidu.cust_data.value
  d = v + '%20site:36kr.com'
  url = ''
  f.method = 'get'
  if !mobilecheck()
    url = 'http://www.baidu.com/baidu?word_display=' + v + '&word=' + d
    window.open url, '_new'
  else
    url = 'http://www.baidu.com/from=844b/s?word=' + d + '&t_kt=0&sa=is_1&ms=1&rq=' + v
    window.open url, '_self'
  false

message = (data) ->
  $.get '/users/messages', { data: data }, (html) ->
    $('li.notice').html html
    return
  return

doFavorite = (url_code) ->
  $.post '/favorites', { 'url_code': url_code }, (result) ->
    if $('.icon-star').hasClass('active')
      $('.icon-star').removeClass 'active'
    else
      $('.icon-star').addClass 'active'
    if result['success'] == 'add'
      $('#star-count').text result['count']
      $('.icon-star').addClass 'active'
    else if result['success'] == 'del'
      $('.icon-star').removeClass 'active'
      $('#star-count').text result['count']
    return
  return

$(document).ready ->
  $('.dropdown_login_out_link').on 'click', ->
    $('.real_login_out_link').trigger 'click'
    return
  $('.require-login').on 'click', ->
    if ($('.require-login').data().uid == undefined or $('.require-login').data().uid == '') and confirm('请登录后继续操作！ (●—●)')
      window.location.href = '/users/auth/krypton'
    return
  $('.single-post-header__headline img[src*=yestone]').after '<small><a href="">Yestone.com 版权图片库</a></small>'
  return