require 'yaml'

if File.exist? File.expand_path("../config/gem_sources.yml", __FILE__)
  gem_sources_file = File.expand_path("../config/gem_sources.yml", __FILE__)
  puts "NOTE: Using the following gem sources from `config/gem_sources.yml`:"
  @custom_gem_source = true
else
  gem_sources_file = File.expand_path("../config/gem_sources.yml.example", __FILE__)
end
sources_yaml = YAML::load(File.read(gem_sources_file))
sources_yaml['gem_sources'].each do |source_str|
  puts source_str if @custom_gem_source
  source source_str
end

gem 'rails', '4.1.6'
gem 'pg', '~> 0.17.1'
gem 'fume-settable', '~> 0.0.3'
gem "dalli", "~> 2.7.0"
gem "redis", "~> 3.0.1"
gem 'redis-objects', '~> 1.0.1'
gem 'redis-namespace', "~> 1.5.1"
gem 'redis-stat'
gem 'newrelic-redis'
gem 'sidekiq', '~> 3.1.2'
gem 'faraday', '~> 0.9.0'

# models
gem "ancestry", "~> 2.1.0"
gem 'enumerize'
gem "carrierwave", "~> 0.10.0"
gem 'carrierwave-upyun', '~> 0.1.6'
gem "mini_magick", "~> 3.7.0"
gem "acts-as-taggable-on", "~> 3.2.6"
gem "cancancan", "~> 1.8.2"
gem "fume-cancan", "~> 0.0.3"
gem "rails-i18n", "~> 4.0.2"
gem "activerecord-typedstore", "0.5.0"
gem "opengraph_parser"
gem 'aasm'
gem 'by_star'

# views
gem "simple_form", "~> 3.0.1"
gem "fume-nav", "~> 0.0.2"
gem "kaminari", "~> 0.15.1"
gem "kaminari-bootstrap", "~> 3.0.1"
gem 'devise-i18n', '~> 0.10.3'
gem 'slim-rails'
gem 'polymer-rails', '~> 0.2.8'
gem 'acts_as_graph_object'
gem 'google-analytics-rails'
gem 'cells'

# controllers
gem 'devise', "~> 3.4.1"
gem 'devise-async' , "~> 0.9.0"
gem "responders"
gem 'omniauth-oauth2'
gem 'newrelic_rpm'
gem 'slack-notifier'
gem 'exception_notification'
gem 'httparty'

# api
gem 'grape' , "~> 0.10.1"
gem 'grape-entity' , "~> 0.4.4" # orgnize data
gem 'grape-jbuilder' , "~> 0.2.0"
gem 'grape-swagger', github: 'tim-vandecasteele/grape-swagger'
gem 'grape-swagger-rails', github: 'tian-xiaobo/grape-swagger-rails'
gem 'swagger-ui_rails'
gem 'rack-cors' #solve the CORS problem
gem 'hashie', '~> 3.3.2'

# assets
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks', "~> 2.0.2"
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem "therubyracer"
gem "less-rails"
gem "twitter-bootstrap-rails"


gem "rails-assets-html5shiv", "~> 3.7.0"
#gem "rails-assets-respond", "~> 1.4.0"

group :development do
  # gem "better_errors", "~> 1.1.0"
  # gem "binding_of_caller", "~> 0.7.2"
  gem "puma", "~> 2.8.0"
  gem "quiet_assets", "~> 1.0.2"
  gem "annotate"
  gem 'spring'
end

group :development, :test do
  gem "capsum", "~> 1.0.0", require: false
  gem 'capistrano-rails'
  gem "capistrano-rbenv"
  gem 'capistrano-bundler'
  gem "capistrano-sidekiq", "~> 0.3.4", require: false
  gem 'pry-nav', '~> 0.2.4'
  gem "pry-doc"
  gem "factory_girl_rails", "~> 4.4.1"
  gem 'guard-rspec'
  gem 'guard-livereload'
  #gem 'web-console', '~> 2.0'
end

group :test do
  gem "rspec-rails", "~> 2.14.1"
  gem "json_spec", "~> 1.1.1"
  gem "rspec-sidekiq", '~> 1.0.0'
  gem "simplecov", "~> 0.9.1", require: false
  gem "shoulda-matchers", "~> 2.6.1"
  gem 'database_cleaner', '~> 1.3.0'
  gem "mocha", "~> 1.1.0"
  #gem "webmock", "~> 1.18.0"
  gem "minitest"
end
