class ExceptionNotificationWorker < BaseWorker
  def perform(options, message)
    @options = eval(options)
    @notifier ||= Slack::Notifier.new(@options[:webhook_url], @options)
    @notifier.ping(message, {})
  end
end
