class Ability
  include CanCan::Ability

  def initialize(user, _controller_namespace)
    return anonymous if user.blank?
    public_ability(user)
    send user.role.to_sym, user
  end

  # 读者
  def reader(_user)
    # 不能进入后台
    # 可以评论
  end

  # 投稿者
  def contributor(user)
    can :read, :dashboard
    can [:read, :create], Newsflash
    can :manage, Newsflash, :user_id => user.id
    can [:new, :myown], Post
    can [:read, :column, :reviewings], Post, :id => user.posts.pluck(:id)
    can :manage, Post, :id => user.posts.drafted.pluck(:id)
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
    cannot :toggle_tag, Post
    can :manage, Newsflash
    can :read, Comment, :commentable_type => 'Post', :commentable_id => user.posts.pluck(:id)
  end

  # 编辑
  def editor(user)
    can :read, :dashboard
    can :manage, Post
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

  def public_ability(user)
    anonymous
    can :create, Comment unless user.muted?
    can :preview, Post
    can [:edit, :update], User, :id => user.id
    can :manage, Favorite, :user_id => user.id
  end

  def anonymous
    can :read, :welcome
    can :index, :welcome
    can :read, [Ad, Post, Column, Page, Newsflash, User]
    can [:news, :feed, :hots, :today_lastest, :feed_bdnews], Post
    can [:read, :execllents], Comment
    can :changes, :welcome
    cannot :create, Comment
  end
end
