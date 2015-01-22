class ExceptionNotificationWorker 
  include Sidekiq::Worker
  sidekiq_options :queue => :krx2015, :backtrace => true

  def perform options, message
  	@options = eval(options)
  	@notifier ||= Slack::Notifier.new(@options[:webhook_url], @options)
    @notifier.ping(message, {})
  end

end