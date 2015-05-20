namespace :new_front do
  desc 'add new columns '
  task :add_new_columns => :environment do
    {
       'tv' => '氪TV',
       'o2o' => 'O2O',
       'hardware' => '新硬件',
       'fun' => 'Fun!!',
       'enterprise' => '企业服务',
       'sports' => 'Fit&Health',
       'edu' => '在线教育',
       'finance' => '互联网金融',
       'company' => '大公司',
       'activity' => '近期活动'
    }.each do |slug, name| 
      unless Column.find_by_slug(slug)
        puts "create #{slug} => #{name} ..."
        Column.create!(name: name, slug: slug, order_num: 0, introduce: 'new column') 
      end
    end
  end
end