require 'exception_notification/rails'
require File.expand_path('../slack_webhook_notifier', __FILE__)
include ExceptionNotifier

ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, AbstractController::ActionNotFound and ActionController::RoutingError are already added.
  # config.ignored_exceptions += %w{ActionView::TemplateError CustomError}

  # 这里默认把路由错误给过滤掉了
  config.ignored_exceptions = []

  config.ignore_if do |exception, options|
    # (not Rails.env.production?) || (not Rails.env.test?)
    not Rails.env.production?
  end

  config.add_notifier :slack, {
    :webhook_url => 'https://hooks.slack.com/services/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',
    :http_method => :post
  }

end
