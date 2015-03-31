namespace :page_views do
  desc 'sync page views count to database'
  task :persist => :environment do
    index = 1
    $redis.hscan_each("page_views") do |k, v|
      model_name, id, attr = k.split('#')
      model = model_name.classify.constantize.find(id)
      model.instance_eval("persist_#{attr}")
      puts "#{Time.now} process[#{index}] #{k} => #{v} done"
      index += 1
    end
  end
end