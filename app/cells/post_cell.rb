class PostCell < Cell::Rails
  helper PostsHelper
  helper ApplicationHelper

  def header(args)
    @post = args[:post]
    render
  end

  def content(args)
    @post = args[:post]
    render
  end

  def share(args)
    @user = args[:user]
    @post = args[:post]
    @has_favorite = @user.favorite_of? @post rescue false
    render
  end

  def author(args)
    @user = args[:author]
    render
  end

  def relate(args)
    @post = args[:post]
    @posts = @post.find_related_tags.published.where.not(id: @post.id).limit(3)
    @posts = @post.author.posts.published.where.not(id: @post.id).order('created_at DESC').limit(3) if @posts.blank?
    render
  end

  def ad
    render
  end
end
