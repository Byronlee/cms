require "spec_helper"
require "cancan/matchers"

describe Ability do

  shared_context "public ability" do
    subject { Ability.new user, '' }
    let(:user) { nil }
  end

  shared_context "admin ability" do
    subject { Ability.new user, 'Admin' }
    let(:user) { nil }
  end

  shared_examples "has public ability" do
    it do
      should be_able_to :read, :welcome
      should be_able_to :read, Ad
      should be_able_to :read, Post
      # should be_able_to :read, Column
      should be_able_to :read, Page
      should be_able_to :read, Newsflash
      should be_able_to :read, User

      should be_able_to :news, Post
      should be_able_to :feed, Post
      should be_able_to :hots, Post
      should be_able_to :archives, Post
      should be_able_to :today_lastest, Post
      should be_able_to :feed_bdnews, Post

      should be_able_to :read, Comment
      should be_able_to :excellents, Comment
    end
  end

  context "anonymous" do
    context "public page" do
      include_context "public ability"

      it_behaves_like 'has public ability'

      it do
        should_not be_able_to :create, Comment
        should_not be_able_to :read, :dashboard
        should_not be_able_to :read, Favorite
        should_not be_able_to :new, Post
      end
    end

    context "admin page" do
      include_context "admin ability"

      it do
        should_not be_able_to :read, :dashboard
        should_not be_able_to :read, Ad
        should_not be_able_to :read, Post
        should_not be_able_to :read, Column
        should_not be_able_to :read, Page
        should_not be_able_to :read, Newsflash
        should_not be_able_to :read, User
        should_not be_able_to :read, Comment
        should_not be_able_to :read, Favorite
      end
    end
  end

  context "reader role" do
    context "public page" do
      include_context "public ability" do
        let(:user) { create :user, :reader }
      end

      before do
        @favorite = create :favorite, user_id: user.id
      end

      it_behaves_like 'has public ability'

      it do
        should be_able_to :create, Comment
        should be_able_to :preview, Post
        should be_able_to :edit, user
        should be_able_to :update, user
        should be_able_to :manage, @favorite

        should_not be_able_to :new, Post
        should_not be_able_to :read, :dashboard
      end

      it 'shutup user cannot comment'do
        user.shutup!
        should_not be_able_to :create, Comment
      end
    end

    context "admin page" do
      include_context "admin ability" do
        let(:user) { create :user, :reader }
      end

      before do
        @favorite = create :favorite, user_id: user.id
      end

      it do
        should_not be_able_to :read, :dashboard
        should_not be_able_to :read, Ad
        should_not be_able_to :read, Post
        should_not be_able_to :read, Column
        should_not be_able_to :read, Page
        should_not be_able_to :read, Newsflash
        should_not be_able_to :read, Comment

        should be_able_to :update, user
        should be_able_to :manage, @favorite
      end

    end
  end

  context "contributor role" do
    context "public page" do
      include_context "public ability" do
        let(:user) { create :user, :contributor }
      end

      before do
        @newsflash = create :newsflash, user_id: user.id
        @post = create :post, :published, author: user
        @comment = create :comment, commentable_id: @post.id, commentable_type: 'Post'
      end

      it_behaves_like 'has public ability'

      it do
        should be_able_to :new, Post
      end

      it do
        @post.undo_publish
        @post.save
        should be_able_to :reviewings, @post
      end
    end

    context "admin page" do
      include_context "admin ability" do
        let(:user) { create :user, :contributor }
      end

      before do
        @newsflash = create :newsflash, user_id: user.id
        @post = create :post, :published, author: user
        @comment = create :comment, commentable_id: @post.id, commentable_type: 'Post'
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
    end
  end

  context "column writer role" do
    context "public page" do
      include_context "public ability" do
        let(:user) { create :user, :column_writer }
      end

      before do
        @newsflash = create :newsflash, user_id: user.id
        @post = create :post, :published, author: user
        @comment = create :comment, commentable_id: @post.id, commentable_type: 'Post'
      end

      it_behaves_like 'has public ability'

      it do
        should be_able_to :new, Post
      end

      it do
        @post.undo_publish
        @post.save
        should be_able_to :reviewings, @post
      end
    end

    context "admin page" do
      include_context "admin ability" do
        let(:user) { create :user, :column_writer }
      end

      before do
        @newsflash = create :newsflash, user_id: user.id
        @post = create :post, :published, author: user
        @comment = create :comment, commentable_id: @post.id, commentable_type: 'Post'
      end

      it do
        should be_able_to :read, :dashboard
        should_not be_able_to :manage, Column
        should be_able_to :new, Post
        should be_able_to :myown, Post
        should be_able_to :read, @post
        should be_able_to :column, Post
        should be_able_to :reviewings, Post
        should_not be_able_to [:edit, :update], @post
        should be_able_to :read, @post
        should_not be_able_to :toggle_tag, Post
        should be_able_to :read, @comment
      end
    end
  end

  context "operator role" do
    context "public page" do
      include_context "public ability" do
        let(:user) { create :user, :operator }
      end

      it_behaves_like 'has public ability'

      it do
        should be_able_to :read, :dashboard
        should be_able_to :read, User
        should be_able_to :create, Comment
      end
    end

    context "admin page" do
      include_context "admin ability" do
        let(:user) { create :user, :operator }
      end

      it do
        should be_able_to :read, :dashboard
        should be_able_to :read, User
        should be_able_to :shutup, User

        should be_able_to :read, Post
        should be_able_to :reviewings, Post
        should be_able_to :toggle_tag, Post
        should be_able_to :manage, HeadLine
      end
    end
  end

  context "writer role" do
    context "public page" do
      include_context "public ability" do
        let(:user) { create :user, :writer }
      end

      before do
        @post = create :post, :published, author: user
        @comment = create :comment, commentable_id: @post.id, commentable_type: 'Post'
      end

      it do
        should be_able_to :read, :dashboard
      end
    end

    context "admin page" do
      include_context "admin ability" do
        let(:user) { create :user, :writer }
      end

      before do
        @post = create :post, :published, author: user
        @comment = create :comment, commentable_id: @post.id, commentable_type: 'Post'
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
  end

  context "editor role" do
    context "public page" do
      include_context "public ability" do
        let(:user) { create :user, :editor }
      end

      it_behaves_like 'has public ability'

      it do
        should be_able_to :read, :dashboard
      end

      it 'shutup user cannot manage comment'do
        user.shutup!
        should_not be_able_to :manage, Comment
      end
    end

    context "admin page" do
      include_context "admin ability" do
        let(:user) { create :user, :editor }
      end

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
  end

  context "admin role" do
    context "public page" do
      include_context "public ability" do
        let(:user) { create :user, :admin }
      end

      it do
        should be_able_to :manage, :all
      end
    end

    context "admin page" do
      include_context "admin ability" do
        let(:user) { create :user, :admin }
      end

      it do
        should be_able_to :manage, :all
      end
    end
  end
end
