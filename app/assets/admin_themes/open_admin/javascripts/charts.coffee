jQuery ->
  # setInterval("$('text[text-anchor=end]').remove()", 0);
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

    categories_industry = [
      '36氪'
      '小米'
      '华为'
      'OTO'
      '融资'
      '百度快搜'
      '智能手表'
      'Appple Watch'
      '红米手机'
      '酒店融资'
    ]
    categories_search = [
      '百度'
      '红杉资本'
      '融资36氪'
      'OTO'
      '融资'
      '快搜'
      '手表'
      'Watch'
      '红米手机连锁'
      '酒店'
    ]

    $('.synthesis').highcharts
      chart: type: 'bar'
      title: text: '最近一个月热点词汇分析'
      xAxis: [
        {
          categories: categories_industry
          reversed: false
          labels: step: 1
        }
        {
          opposite: true
          reversed: false
          categories: categories_search
          linkedTo: 0
          labels: step: 1
        }
      ]
      yAxis:
        title: text: null
        labels: formatter: ->
          Math.abs(@value) / 50 + 'M'
        min: -20000
        max: 20000
      plotOptions: series: stacking: 'normal'
      tooltip: formatter: ->
        '<b>' + @series.name + ': ' + @point.category + '</b><br/>' + '峰值: ' + Highcharts.numberFormat(Math.abs(@point.y), 0)
      series: [
        {
          name: '行业热点词汇'
          data: [
            -200
            -280
            -580
            -1165
            -2565
            -4456
            -8244
            -11126
            -15259
            -18900
          ]
        }
        {
          name: '搜索排行'
          data: [
            710
            383
            3754
            1658
            1543
            8000
            9000
            12000
            15000
            18940
          ]
        }
      ]


