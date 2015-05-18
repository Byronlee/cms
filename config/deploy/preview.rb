set :branch, 'master'

set :rbenv_ruby, '2.1.5'
set :rbenv_type, :user
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

#server 'www-data@119.254.100.96', roles: %w[web app db], port: 52223, primary: true #, sidekiq: true, whenever: true
server 'www-data@119.254.100.96', roles: %w[web app db], port: 52228, primary: true #, sidekiq: true, whenever: true

namespace :deploy do
  #after "deploy:finished", "deploy:web3_preview_lbp"
  after "deploy:finished", "deploy:web4_preview_lbp"
end
