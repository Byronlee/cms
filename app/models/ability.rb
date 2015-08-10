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
    can [:read, :site_map, :changes], :welcome
    can :read, [Ad, Post, Column, Page, Newsflash]
    can [:read, :posts], User
    can [:news, :feed, :hots, :today_lastest, :feed_bdnews, :bdnews, :archives, :preview, :baidu_feed, :xiaozhi_feed, :xiaozhi_news, :uc_feed, :ucnews], Post
    can [:read, :excellents], Comment
    cannot :create, Comment
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
    cannot [:set_top, :set_down], Newsflash
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
    can [:read, :reviewings, :toggle_tag], Post
    can :manage, HeadLine
    cannot :destroy, HeadLine
    can :manage, Comment unless user.muted?
  end

  # 作者
  def writer(user)
    can :read, :dashboard
    can [:read, :reviewings], Post
    can :manage, Post, :user_id => user.id
    can :manage, RelatedLink, :post_id => user.posts.pluck(:id)
    can :create, RelatedLink
    cannot :toggle_tag, Post
    can :manage, Newsflash
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
    cannot :toggle_tag, Post
  end

  # 编辑
  def editor(user)
    can :read, :dashboard
    can :manage, Post
    can :manage, RelatedLink
    can :manage, Newsflash
    can :manage, Column
    can :manage, Comment unless user.muted?
    can :manage, HeadLine
    cannot :destroy, HeadLine
    can :manage, Page
    can :change_author, Post
    cannot :toggle_tag, Post
  end

  # 管理员
  def admin(_user)
    can :manage, :all
  end
end
