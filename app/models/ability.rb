class Ability
  include CanCan::Ability

  def initialize(user, controller_namespace)
    send "define_#{controller_namespace.downcase}_ability", user
  end

  def define__ability(user)
    public_page_ability(user)
    admin_page_ability(user)
  end

  def define_admin_ability(user)
    admin_page_ability(user)
  end

  def define_asynces_ability(user)
    public_page_ability(user)
    admin_page_ability(user)
  end

  # 用户界面权限
  def public_page_ability(user)
    anonymous
    return unless user
    can :create, Comment unless user.muted?
  end

  # 管理界面权限
  def admin_page_ability(user)
    return unless user

    can [:edit, :update], User, :id => user.id
    can :manage, Favorite, :user_id => user.id
    can :manage, Column

    send user.role.to_sym, user
  end

  # 未登录
  def anonymous
    can [:read, :site_map, :site_map2, :changes], :welcome
    can :read, [Ad, Post, Column, Page, Newsflash]
    can [:read, :posts], User
    can [:news, :feed, :hots, :today_lastest, :feed_bdnews, :bdnews, :archives, :preview, :baidu_feed, :xiaozhi_feed, :xiaozhi_news, :chouti_feed, :chouti_news, :uc_feed, :ucnews, :partner_feed, :coop_news, :coop_feed], Post
    can [:read, :excellents], Comment
    cannot :create, Comment
    cannot :toggle_tag, Newsflash
  end

  # 读者
  def reader(_user)
    cannot :read, Column
  end

  # 投稿者
  def contributor(user)
    can :read, :dashboard
    can [:read, :create], Newsflash
    can :manage, Newsflash, :user_id => user.id
    cannot [:set_top, :set_down, :toggle_tag], Newsflash
    can [:new, :myown], Post
    can [:read, :column, :reviewings], Post, :id => user.posts.pluck(:id)
    can :manage, Post, :id => user.posts.drafted.pluck(:id)
    can :create, RelatedLink
    can :manage, RelatedLink, :post_id => user.posts.drafted.pluck(:id)
    can :read, Comment, :commentable_type => 'Post', :commentable_id => user.posts.pluck(:id)
  end

  # 运营
  def operator(user)
    can :read, :dashboard
    can [:read, :shutup], User
    can [:read, :reviewings, :toggle_tag, :article_toggle_tag, :edit, :update, :do_publishm, :publish], Post
    can :manage, HeadLine
    can :toggle_tag, Newsflash
    cannot :destroy, HeadLine
    can :manage, Comment unless user.muted?
    can :manage, MobileAd
  end

  # 作者
  def writer(user)
    can :read, :dashboard
    can [:read, :reviewings, :article_toggle_tag], Post
    can :manage, Post, :user_id => user.id
    can :manage, RelatedLink, :post_id => user.posts.pluck(:id)
    can :create, RelatedLink
    can :manage, Newsflash
    cannot :toggle_tag, Post
    can :read, Comment, :commentable_type => 'Post', :commentable_id => user.posts.pluck(:id)
  end

  # 专栏作者
  def column_writer(user)
    cannot :manage, Column
    can :read, :dashboard
    can [:new, :myown], Post
    can [:read, :column, :reviewings], Post, :id => user.posts.pluck(:id)
    can [:update, :edit, :preview], Post, :id => user.posts.reviewing.pluck(:id)
    can :manage, Post, :id => user.posts.drafted.pluck(:id)
    cannot [:toggle_tag, :article_toggle_tag], Post
    cannot :toggle_tag, Newsflash
  end

  # 编辑
  def editor(user)
    can :read, :dashboard
    can :read, :dashboard_resource
    can :manage, Post
    can :manage, RelatedLink
    can :manage, Newsflash
    can :manage, Column
    can :manage, Comment unless user.muted?
    can :manage, HeadLine
    cannot :destroy, HeadLine
    can :manage, Page
    can [:change_author], Post
    cannot :toggle_tag, Post
  end

  # 投资人
  def investor(user)
    cannot :manage, Column
    cannot :manage, RelatedLink
    can :read, :dashboard
    can [:new, :myown], Post
    can [:read, :column, :reviewings], Post, :id => user.posts.pluck(:id)
    can [:update, :edit, :preview], Post, :id => user.posts.reviewing.pluck(:id)
    can :manage, Post, :id => user.posts.drafted.pluck(:id)
    cannot [:toggle_tag, :article_toggle_tag], Post
    cannot :toggle_tag, Newsflash
  end

  # 投资机构
  def organization(user)
    cannot :manage, Column
    can :read, :dashboard
    can [:new, :myown], Post
    can [:read, :column, :reviewings], Post, :id => user.posts.pluck(:id)
    can [:update, :edit, :preview], Post, :id => user.posts.reviewing.pluck(:id)
    can :manage, Post, :id => user.posts.drafted.pluck(:id)
    cannot [:toggle_tag, :article_toggle_tag], Post
    cannot :toggle_tag, Newsflash
  end

  # 创业者
  def entrepreneur(user)
    cannot :manage, Column
    can :read, :dashboard
    can [:new, :myown], Post
    can [:read, :column, :reviewings], Post, :id => user.posts.pluck(:id)
    can [:update, :edit, :preview], Post, :id => user.posts.reviewing.pluck(:id)
    can :manage, Post, :id => user.posts.drafted.pluck(:id)
    cannot [:toggle_tag, :article_toggle_tag], Post
    cannot :toggle_tag, Newsflash
  end

  # 管理员
  def admin(_user)
    can :manage, :all
  end
end
