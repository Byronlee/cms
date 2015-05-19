namespace :new_front do
  desc 'add new columns '
  task :add_new_columns => :environment do
    {
       'O2O' => 'O2O',
       'new-hardware' => '新硬件',
       'social-copy' => '社交&文创',
       'enterprise-services' => '企业服务',
       'physical-health' => '体育健康',
       'internet-finance' => '互联网金融',
       'online-education' => '在线教育',
       'major-company' => '大公司'
    }.each{|slug, name| Column.create!(name: name, slug: slug, order_num: 0, introduce: 'new column')}
  end
end