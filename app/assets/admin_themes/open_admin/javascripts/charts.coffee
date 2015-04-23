jQuery ->
  setInterval("$('text[text-anchor=end]').remove()", 0);
  $('.posts').highcharts
    chart: type: 'line'
    title: text: '最近10天各个资源趋势图'
    subtitle: text: '今日登录用户: 1000000'
    xAxis: categories: [
      '4/11'
      '4/10'
      '4/9'
      '4/8'
      '4/7'
      '4/6'
      '4/5'
      '4/4'
      '4/3'
      '前天'
      '昨天'
      '今天'
    ]
    yAxis: title: text: '每日新增数量'
    plotOptions: line:
      dataLabels: enabled: true
      enableMouseTracking: false
    series: [
      {
        name: '文章'
        data: [
          7.0
          6.9
          9.5
          14.5
          18.4
          21.5
          25.2
          26.5
          23.3
          18.3
          13.9
          9.6
        ]
      }
      {
        name: '评论'
        data: [
          3.9
          4.2
          5.7
          8.5
          11.9
          15.2
          17.0
          16.6
          14.2
          10.3
          6.6
          4.8
        ]
      }
      {
        name: '用户'
        data: [
          1.9
          14.2
          5.7
          8.5
          13.9
          13.2
          11.0
          16.6
          11.2
          10.3
          3.6
          4.8
        ]
      }
    ]

