class ColumnsHeaderComponentWorker < BaseWorker
	sidekiq_options :queue => :krx2015, :backtrace => true
	
  def perform
    Redis::HashKey.new('columns')['header'] = 
      Column.headers.to_json(only: [:slug, :name, :updated_at])
  end
end