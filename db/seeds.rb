ActiveRecord::Base.connection.execute("select setval('newsflash_topic_colors_id_seq', 1, false)")
NewsflashTopicColor.delete_all
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

ActiveRecord::Base.connection.execute("select setval('columns_id_seq', 1, false)")
Column.delete_all
columns = [
  { name:  '国外资讯', slug:    'breaking'},
  { name:  '创业公司', slug:    'startup-type'},
  { name:  '评论', slug:    'review'},
  { name:  '移动' , slug:   'mobile'},
  { name:  '生活方式', slug: 'digest'},
  { name:  '国外创业公司' , slug:   'us-startups'},
  { name:  '社交', slug:    'social'},
  { name:  '科技', slug:    'tech'},
  { name:  '工具', slug:    'tool'},
  { name:  '企业级产品' , slug:   'biz'},
  { name:  '国内创业公司' , slug:   'cn-startups'},
  { name:  '硬件' , slug:   'hardware'},
  { name:  '信息图' , slug:   'infographics'},
  { name:  '国内资讯' , slug:   'cn-news'},
  { name:  '存档' , slug:   'archives'},
  { name:  '专栏' , slug:   'column'},
  { name:  '36Kr' , slug:   '36kr'}
]

columns.each do | column |
  Column.new(column).save(:validate => false)
end

pages = [
  {title: '36氪投稿细则', slug: 'contribute', body: Settings.contribute },
  {title: '关于36氪',    slug: 'about',      body: Settings.about },
  {title: '36氪招聘',    slug: 'hire',       body: Settings.hire }
]

pages.each do | page |
  Page.create!(page)
end























