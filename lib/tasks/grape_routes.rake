namespace :grape do
  desc 'Print compiled grape routes'
  task :grape_routes => :environment do
    API::API2.routes.each do |route|
      puts route
    end
  end
end
