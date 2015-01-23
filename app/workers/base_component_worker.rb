class BaseComponentWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :krx2015, :backtrace => true
end