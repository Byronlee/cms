jQuery ->
  window.draw_chats = ->
    setInterval("$('text[text-anchor=end]').remove()", 0);
    range = date_range
    console.log(range)
    $('.posts').highcharts
      chart: type: 'line'
      title: text: '最近10天各资源趋势图'
      subtitle: text: "今日登录用户: " + sessions
      xAxis: categories: range.concat(['前天', '昨天', '今天'])
      yAxis: title: text: '每日新增数量'
      plotOptions: line:
        dataLabels: enabled: true
        enableMouseTracking: false
      series: [
        {
          name: '文章'
          data: posts_data
        }
        {
          name: '评论'
          data: comments_data
        }
        {
          name: '用户'
          data: users_data
        }
      ]