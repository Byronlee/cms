require "faraday"
require "json"

set :notification_url, "https://hooks.slack.com/services/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"

namespace :notification do
  task :started do
    deployer = `git config user.name`.chomp
    text = "#{deployer} is deploying #{fetch(:application)}"
    Faraday.post fetch(:notification_url), {
      payload: JSON.generate({ text: text })
    }
  end

  task :finished do
    deployer = `git config user.name`.chomp
    text = "#{deployer} deployed #{fetch(:application)} successfully"
    Faraday.post fetch(:notification_url), {
      payload: JSON.generate({ text: text })
    }
  end
end

namespace :deploy do
  before 'deploy',   'notification:started'
  after  'finished', 'notification:finished'
end
