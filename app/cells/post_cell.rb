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
    @has_favorite = @user.like? @post rescue false
    render
  end

  def author(args)
    @user = args[:author]
    render
  end

  def mobile_author(args)
    @user = args[:author]
    render
  end

  def relate(args)
    @post = args[:post]
    @posts = @post.related_posts
    render
  end

  def ad
    render
  end

  def hot
    render
  end

  def today
    render
  end


  def report
    render
  end

  def reward
    render
  end
end
