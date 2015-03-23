set :scm, :git
set :repo_url, "git@github.com:x36kr/36krx2015.git"
set :deploy_to, -> { "/var/www/apps/krypton" }
set :ssh_options, { keys: %w{~/.ssh/id_rsa}, forward_agent: true, auth_methods: %w(publickey) }
set :deploy_to, -> { "/var/www/apps/krypton" }
server 'www-data@119.254.100.96', roles: %w[web app db], port: 52221, primary: true #, sidekiq: true, whenever: true
server 'www-data@119.254.100.96', roles: %w{web app}, port: 52222
server 'www-data@119.254.100.96', roles: %w{web app}, port: 52223
