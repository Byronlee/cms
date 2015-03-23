set :application, 'krypton'
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

fetch(:linked_files).concat %w{
  config/database.yml
  config/redis.yml
  config/sidekiq.yml
  config/newrelic.yml
  config/settings.rb
  config/secrets.yml
}

fetch(:linked_dirs).concat %w{
  public/uploads
  tmp/cache
}

namespace :deploy do
  desc "reload the database with seed data"
  task :seed do
    on roles(fetch(:migration_role)) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:seed"
        end
      end
    end

  end

  after "deploy:migrate", "deploy:updated"
  after "newrelic:notice_deployment", "deploy:restart"
end

load "config/deploy/recipes/notification.rb"

