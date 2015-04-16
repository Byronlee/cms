# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#  is_excellent     :boolean
#  is_long          :boolean
#  state            :string(255)
#  email            :string(255)
#

require 'spec_helper'

describe Comment do
  describe 'auto set is long comment' do
    let(:comment) { create :comment, content: '4' * 141 }

    it do
      expect(comment.is_long).to be true
    end
  end

  describe 'order_by_content' do
    before do
      @comment_s =  create :comment, content: '4' * 3
      @comment_l =  create :comment, content: '3' * 10
    end

    it do
      expect(Comment.order_by_content.first.content.length).to eq 10
    end
  end
end
