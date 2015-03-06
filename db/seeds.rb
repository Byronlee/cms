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

columns = [
  {id: 1, name:  '国外资讯', slug:    'breaking'},
  {id: 2, name:  '创业公司', slug:    'startup-type'},
  {id: 3, name:  '评论', slug:    'review'},
  {id: 4, name:  '移动' , slug:   'mobile'},
  {id: 5, name:  '生活方式', slug: 'digest'},
  {id: 6, name:  '国外创业公司' , slug:   'us-startups'},
  {id: 7, name:  '社交', slug:    'social'},
  {id: 8, name:  '科技', slug:    'tech'},
  {id: 9, name:  '工具', slug:    'tool'},
  {id: 10, name:    '企业级产品' , slug:   'biz'},
  {id: 11, name:    '国内创业公司' , slug:   'cn-startups'},
  {id: 12, name:    '硬件' , slug:   'hardware'},
  {id: 13, name:    '信息图' , slug:   'infographics'},
  {id: 14, name:    '国内资讯' , slug:   'cn-news'},
  {id: 15, name:    '存档' , slug:   'archives'},
  {id: 16, name:    '专栏' , slug:   'column'},
  {id: 17, name:    '36Kr' , slug:   '36kr'}
]

columns.each do | column |
  Column.create column
end
