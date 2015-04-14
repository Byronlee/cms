class Asynces::CommentsController < ApplicationController
  def excellents
    comments_data = CacheClient.instance.excellent_comments
    @comments = comments_data.present? ? JSON.parse(comments_data) : []
    render '_excellents', :layout => false
  end
end
