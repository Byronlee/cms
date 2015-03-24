set :application, 'krypton'
set :scm, :git
set :repo_url, "git@github.com:x36kr/36krx2015.git"
set :deploy_to, "/var/www/apps/krypton"
set :rails_env, 'production'
set :ssh_options, { keys: %w{~/.ssh/id_rsa}, forward_agent: true, auth_methods: %w(publickey) }

SSHKit.config.command_map[:rake]  = "bundle exec rake"
SSHKit.config.command_map[:rails] = "bundle exec rails"

set :format, :pretty
set :log_level, :debug

set :linked_files, %w{
  config/database.yml
  config/redis.yml
  config/sidekiq.yml
  config/settings.rb
  config/secrets.yml
}

set :linked_dirs, %w{tmp/cache public/uploads}

set :keep_releases, 5

namespace :deploy do

  desc "serurely manages database config file after deploy"
  task :setup_config do
    on roles(:web) do |host|
      execute :mkdir, "-p #{deploy_to}/shared/config"
      upload! "config/config.yml.sample", "#{deploy_to}/shared/config/config.yml"
      upload! "config/database.yml.sample", "#{deploy_to}/shared/config/database.yml"
      upload! "config/secrets.yml.sample", "#{deploy_to}/shared/config/secrets.yml"
    end
  end

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

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

