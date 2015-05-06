class ExcellentCommentsComponentWorker < BaseWorker
  sidekiq_options :queue => :krx2015, :backtrace => true
  
  def perform
    comments = Comment.excellent.order('comments.created_at desc').limit(6)
    Redis::HashKey.new('comments')['excellent'] =
      comments.to_json(
        :include => {
          :user => {
            :only => [],
            :methods => [:display_name]},
          :commentable =>{
            :only => [:id, :title, :url_code]}})
  end
end