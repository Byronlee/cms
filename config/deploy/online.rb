set :scm, :git
set :repo_url, "git@github.com:x36kr/36krx2015.git"
set :deploy_to, -> { "/var/www/apps/krypton" }
set :ssh_options, { keys: %w{~/.ssh/id_rsa}, forward_agent: true, auth_methods: %w(publickey) }
server '119.254.100.96', user: "www-data", roles: %w[web app db], port: 52221, primary: true #, sidekiq: true, whenever: true
server '119.254.100.96', user: "www-data", roles: %w{web app}, port: 52222
