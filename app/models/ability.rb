class Ability
  include CanCan::Ability

  def initialize(user, controller_namespace)
    unless controller_namespace == 'Admin'
      public_ability
      can :create, Comment if user
    end
    can :preview, Post
    send user.role.to_sym, user if user
  end

  # 读者
  def reader(user)
    # 不能进入后台
    # 可以评论
  end

  # 投稿者
  def contributor(user)
    can :read, :dashboard
    can [:read, :create], Newsflash
    can :manage, Newsflash, :user_id => user.id
  end

  # 运营
  def operator(user)
    # 头条（all）
    # 用户 (reader)
    # 评论
    # 文章(只看)
    can :read, :dashboard
    can :read, User
    can [:read, :reviewings], Post
    can :manage, HeadLine
  end

  # 作者
  def writer(user)
    #不能进入后台， 可以评论
  end

  # 编辑
  def editor(user)
  end

  # 管理员
  def admin(user)
    can :manage, :all
  end

  def public_ability
     can :read, :welcome
     can :read, [Ad, Post, Column, Page, Newsflash, User, Comment]
     can :update_views_count, Post
     cannot :create, Comment
  end
end
