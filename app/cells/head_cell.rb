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

  def iphone_media
    render
  end

  def ipad_media
    render
  end

  def ipad_retina_media
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
end
