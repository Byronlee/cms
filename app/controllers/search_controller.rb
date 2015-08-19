require 'uri'
class SearchController < ApplicationController
  def search
    params[:q] = URI.unescape(params[:q]).gsub('/','')
    if params[:q].blank?
      @message = '搜索关键词不能为空'
      @posts = Post.none
    elsif params[:q].length > Settings.elasticsearch.query.max_length
      @message = '搜索关键词过长'
      @posts = Post.none
    else
      @posts = Post.search(params)
    end

    respond_to do |format|
      format.html do
        if request.xhr?
          render 'search/_list', locals: { :posts => @posts }, layout: false 
        end
      end
      format.json do 
        render json: Post.posts_to_json(@posts, true)
      end
      format.xml do
        #/api/wx.xml?q=ibm&to_user=toUser&from_user=fromUser&page=1&per_page=5
        render 'search/search', locals: { :posts => @posts }, layout: false
      end
    end

  end
end
