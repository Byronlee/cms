require 'uri'
class SearchController < ApplicationController

  def search
    @data = Java::Search.search params
    @total_count = @data['data']['totalCount']
    @posts = @data['data']['article']

    respond_to do |format|
      format.html do
        if request.xhr?
          render 'search/_list', locals: { :posts => @posts }, layout: false
        end
      end
      format.xml do
        if @posts.length > 0
          #/api/wx.xml?q=ibm&to_user=toUser&from_user=fromUser&page=1&per_page=5
          render 'api/wx', locals: { :posts => @posts }, layout: false
        else
          render text: ''
        end
      end
    end

  end
  
  def search_ruby
    params[:q] = URI.unescape(params[:q]).gsub('/','') unless params[:q].blank?
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
        if @posts.length > 0
          #/api/wx.xml?q=ibm&to_user=toUser&from_user=fromUser&page=1&per_page=5
          render 'api/wx', locals: { :posts => @posts }, layout: false
        else
          render text: ''
        end
      end
    end
    
  end

end
