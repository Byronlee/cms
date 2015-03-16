set :deploy_to, -> { "/var/www/apps/krypton" }
server 'www-data@119.254.103.241', roles: %w[web app db], primary: true #, sidekiq: true, whenever: true