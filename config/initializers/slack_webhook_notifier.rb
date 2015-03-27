require 'exception_notification/sidekiq'

module ExceptionNotifier
  class SlackNotifier

    attr_accessor :notifier

    def initialize(options)
        @options = options
        @message_opts = options.fetch(:additional_parameters, {})
    end

    def call(exception, options={})
      message = [
        "项目:  36krx2015",
        "发生错误时间: #{ Time.now.to_s }",
        "错误类型: #{exception.class}",
        "错误信息: #{ exception.message }",
        "请求连接: #{options[:env]["HTTP_HOST"]}#{options[:env]["REQUEST_PATH"]}",
        "浏览器信息: #{options[:env]["HTTP_USER_AGENT"]}"
        #"Backtrack: #{ exception.backtrace[0..4].join("\n")}"
      ].join("\n")
      ExceptionNotificationWorker.perform_async(@options.to_s, message, exception)
    end
  end
end