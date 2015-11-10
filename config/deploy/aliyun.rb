#set :branch, 'staging'
set :deploy_to, "/data/apps/krypton"
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :rbenv_ruby, '2.1.5'
set :rbenv_type, :user
set :default_env, { path: "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH" }
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

set :ssh_options, { forward_agent: true, port: 22 }
server 'www@123.56.15.161', roles: %w[web app db], primary: true #, sidekiq: true, whenever: true
