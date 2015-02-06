  site_colors = [
    { site_name: 'Google',   color: '#ddd'  },
    { site_name: 'Baidu',    color: '#000'  },
    { site_name: 'Twitter',  color: '#ccc'  },
    { site_name: 'Facebook', color: 'green' },
    { site_name: '腾讯',     color: 'red'   },
    { site_name: '阿里巴巴',  color: 'blue' }
  ]

  site_colors.each do | site |
    NewsflashTopicColor.create site
  end
