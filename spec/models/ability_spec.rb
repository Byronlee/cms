require "spec_helper"
require "cancan/matchers"

describe Ability do
  subject { Ability.new user, nil }

  context "anonymous" do
    let(:user) { nil }
    it do
      should be_able_to :index, :welcome
      should be_able_to :read, :welcome
      should be_able_to :read, Ad
      should be_able_to :read, Post
      should be_able_to :read, Column
      should be_able_to :read, Page
      should be_able_to :read, Newsflash
      should be_able_to :read, User

      should be_able_to :news, Post
      should be_able_to :feed, Post
      should be_able_to :hots, Post
      should be_able_to :today_lastest, Post
      should be_able_to :feed_bdnews, Post

      should be_able_to :read, Comment
      should be_able_to :execllents, Comment

      should_not be_able_to :create, Comment
      should_not be_able_to :read, :dashboard
    end
  end

  context "reader role" do
    let(:user) { create :user, :reader }
    before do
      @favorite = create :favorite, user_id: user.id
    end

    it do
      should be_able_to :index, :welcome
      should be_able_to :create, Comment
      should be_able_to :comments_count, Post
      should be_able_to :preview, Post
      should be_able_to :edit, user
      should be_able_to :update, user
      should be_able_to :manage, @favorite

      should_not be_able_to :read, :dashboard
    end

    it 'shutup user cannot comment'do
      user.shutup!
      should_not be_able_to :create, Comment
    end
  end

  context "contributor role" do
    let(:user) { create :user, :contributor }

    before do
      @newsflash = create :newsflash, user_id: user.id
      @post = create :post, :published, author: user
      @comment = create :comment
    end

    it do
      should be_able_to :read, :dashboard
      should be_able_to [:read, :create], Newsflash
      should be_able_to :manage, @newsflash
      should be_able_to :new, Post
      should be_able_to :myown, Post

      should be_able_to :read, @post
      should be_able_to :read, @comment
    end

    it do
      @post.undo_publish
      @post.save
      should be_able_to :reviewings, @post
    end
  end

  context "operator role" do
    let(:user) { create :user, :operator }

    it do
      should be_able_to :read, :dashboard
      should be_able_to :read, User
      should be_able_to :shutup, User

      should be_able_to :read, Post
      should be_able_to :reviewings, Post
      should be_able_to :toggle_tag, Post
      should be_able_to :manage, HeadLine
      should be_able_to :create, Comment
    end
  end

  context "writer role" do
    let(:user) { create :user, :writer }

    before do
      @post = create :post, :published, author: user
      @comment = create :comment
    end

    it do
      should be_able_to :read, :dashboard
      should be_able_to :read, Post
      should be_able_to :reviewings, Post
      should be_able_to :update, @post
      should be_able_to :destroy, @post
      should_not be_able_to :toggle_tag, Post
      should be_able_to :manage, Newsflash
      should be_able_to :read, @comment
    end
  end

  context "editor role" do
    let(:user) { create :user, :editor }

    it do
      should be_able_to :read, :dashboard
      should be_able_to :manage, Post
      should be_able_to :manage, Newsflash
      should be_able_to :manage, Column
      should be_able_to :manage, Comment
      should be_able_to :manage, HeadLine
      should be_able_to :manage, Page
      should be_able_to :change_author, Post
      should_not be_able_to :toggle_tag, Post
    end

    it 'shutup user cannot manage comment'do
      user.shutup!
      should_not be_able_to :manage, Comment
    end
  end

  context "admin role" do
    let(:user) { create :user, :admin }

    it do
      should be_able_to :manage, :all
    end
  end
end
