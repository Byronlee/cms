class WelcomeController < ApplicationController
  authorize_object :welcome

  def index
    @posts = Post.limit(20)
    @posts_with_ads = JSON.parse Redis::HashKey.new('info_flow')['主站']
  end
end
