#ActiveRecord::Base.connection.execute("select setval('newsflash_topic_colors_id_seq', 1, false)")
#NewsflashTopicColor.delete_all

site_colors = [
  { site_name: 'Google',   color: '#ddd'  },
  { site_name: 'Baidu',    color: '#000'  },
  { site_name: 'Twitter',  color: '#ccc'  },
  { site_name: 'Facebook', color: 'green' },
  { site_name: '腾讯',     color: 'red'   },
  { site_name: '阿里巴巴',  color: 'blue' }
]

site_colors.each do |site|
  NewsflashTopicColor.find_or_create_by(site_name: site[:site_name]) do |t|
    t.color = site[:color]
  end
end

#site_colors.each do | site |
#  NewsflashTopicColor.create site
#end

#ActiveRecord::Base.connection.execute("select setval('columns_id_seq', 1, false)")
#Column.delete_all
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

columns.each do |column|
  Column.find_or_create_by(name: column[:name]) do |t|
    t.name = column[:name]
    t.slug = column[:slug]
  end
end
#columns.each do | column |
#  Column.new(column).save(:validate => false)
#end

#ActiveRecord::Base.connection.execute("select setval('pages_id_seq', 1, false)")
#Page.delete_all
pages = [
  { title: '36氪投稿细则', slug: 'contribute',  body: Settings.contribute },
  { title: '关于36氪',    slug: 'about',       body: Settings.about },
  { title: '36氪招聘',    slug: 'hire',        body: Settings.hire },
  { title: '氪月报',      slug: 'krmonthly',   body: Settings.krmonthly }
]

pages.each do |page|
  Page.find_or_create_by(title: page[:title]) do |t|
    t.slug = page[:slug]
    t.body = page[:body]
  end
end
#pages.each do | page |
#  Page.create!(page)
#end


# <script>
# var _hmt = _hmt || [];
# (function() {
  # var hm = document.createElement("script");
  # hm.src = "//hm.baidu.com/hm.js?713123c60a0e86982326bae1a51083e1";
  # var s = document.getElementsByTagName("script")[0];
  # s.parentNode.insertBefore(hm, s);
# })();
# </script>


fragments = {
  footer_body:      { name: "公共footer", content: Settings.footer_body, content_type: :plain },
  baidu_statistics: { name: "百度统计", content: Settings.baidu_statistics, content_type: :plain },
  extra_metas:   { name: "额外的metadata", content: Settings.extar_metadata, content_type: :plain }
}.each do |key, attributes|
  FragmentTemplate.find_or_create_by!(key: key) do |template|
    template.assign_attributes attributes
  end
end


#reset  all columns order num to 0
Column.update_all(:order_num => 0)
#set column headers info
{
  'tv' => {'name' => '氪TV', 'order_num' => 1000},
  'o2o' => {'name' => 'O2O', 'order_num' => 900},
  'hardware' => {'name' => '新硬件', 'order_num' => 800},
  'fun' => {'name' => 'Fun!!', 'order_num' => 700},
  'enterprise' => {'name' => '企业服务', 'order_num' => 600},
  'sports' => {'name' => 'Fit&Health', 'order_num' => 500},
  'edu' => {'name' => '在线教育', 'order_num' => 400},
  'finance' => {'name' => '互联网金融', 'order_num' => 300},
  'company' => {'name' => '大公司', 'order_num' => 200},
  'activity' => {'name' => '近期活动', 'order_num' => 100}
}.each do |slug, values| 
  unless column =  Column.find_by_slug(slug)
    puts "create #{slug} => #{name} ..."
    Column.create!(name: values["name"], slug: slug, order_num: values["order_num"], introduce: 'columns header') 
  else
    column.update_attribute(:order_num, values["order_num"]) unless column.order_num == values["order_num"]
  end
end
