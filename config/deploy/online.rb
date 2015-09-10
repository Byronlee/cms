set :branch, 'master'
#ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :rbenv_ruby, '2.1.5'
set :rbenv_type, :user
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

server 'www-data@119.254.100.96', roles: %w[web app db], port: 52221, primary: true #, sidekiq: true, whenever: true
server 'www-data@119.254.100.96', roles: %w{web app}, port: 52222
server 'www-data@119.254.100.96', roles: %w{web app}, port: 52223
server 'www-data@119.254.100.96', roles: %w{web app}, port: 52224
server 'www-data@119.254.100.96', roles: %w{web app}, port: 52227
server 'www-data@119.254.100.96', roles: %w{web app}, port: 52228
server 'www-data@119.254.100.96', roles: %w{web app}, port: 52229

namespace :deploy do
  after "deploy:finished", "deploy:web5_online_lbp"
end
