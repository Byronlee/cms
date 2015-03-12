class ExcellentCommentsComponentWorker < BaseWorker
  def perform
    comments = Comment.excellent.order('created_at desc').limit(6)
    Redis::HashKey.new('comments')['excellent'] =
      comments.to_json(
        :methods => [:human_created_at],
        :include => {
          :user => {
            :only => [],
            :methods => :name},
          :commentable =>{
            :only => [:id, :title, :url_code]}})
  end
end