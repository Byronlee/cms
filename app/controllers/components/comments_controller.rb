class Components::CommentsController < ApplicationController
  def index
    @comments = Redis::HashKey.new('comments')['excellent']
    render :json => @comments
  end
end
