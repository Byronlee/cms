class BaseWorker
  include Sidekiq::Worker
  # TODO: 所有的队列名称应该放到配置里面去，集中管理,现在分散在了各个work中，不好管理

  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end
end
