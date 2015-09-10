class HeadCell < Cell::Rails
  helper ApplicationHelper

  def basic_info
    render
  end

  def ios_meta
    render
  end

  def ios_icons
    render
  end

  def ios_startup
    render
  end

  def twitter_card_meta(args)
    @post = args[:post]
    render
  end

  def facebook_open_graph_meta(args)
    @post = args[:post]
    render
  end

  def weibo_card_meta(args)
    @post = args[:post]
    render
  end

  def dns_prefetch
    render
  end

  def html5
    render
  end

  def ga(args)
    @current_user = args[:current_user]
    render
  end

  def js_tracker_36kr
    render
  end
end
