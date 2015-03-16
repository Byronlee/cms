set :deploy_to, -> { "/var/www/apps/krypton" }
server '119.254.100.96', roles: %w[web app db], port: 52221, primary: true #, sidekiq: true, whenever: true
server '119.254.100.96', roles: %w{web app}, port: 52222
