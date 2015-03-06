class WelcomeController < ApplicationController
  authorize_object :welcome

  def index
    @posts = Post.limit(20)
  end
end
