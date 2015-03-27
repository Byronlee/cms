class ExceptionNotificationWorker < BaseWorker
  def perform(options, message, e)
    @options = eval(options)
    @notifier ||= Slack::Notifier.new(@options[:webhook_url], @options)
    @notifier.ping(message, {})
    record_exception_to_log(message, e)
  end

  def record_exception_to_log(message, e)
    @file_path ||= "#{Rails.root}/public/logger/a14f30b84.log"
    @logger ||= Logger.new(@file_path, 1, 1000)
    @logger.info "\n" + message
    @logger.info e.backtrace.join("\n") + "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
  end
end
