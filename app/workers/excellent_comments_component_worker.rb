class ExcellentCommentsComponentWorker < BaseWorker
  def perform
    comments = Comment.excellent.order('created_at desc').limit(6)
    Redis::HashKey.new('comments')['excellent'] =
      comments.to_json(
        :methods => [:human_created_at],
        :include => {
          :user => {
            :only => [],
            :methods => [:display_name]},
          :commentable =>{
            :only => [:id, :title, :url_code]}})
  end
end