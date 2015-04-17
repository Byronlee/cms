# == Schema Information
#
# Table name: posts
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  summary         :text
#  content         :text
#  title_link      :string(255)
#  must_read       :boolean
#  slug            :string(255)
#  state           :string(255)
#  draft_key       :string(255)
#  column_id       :integer
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  cover           :text
#  source          :string(255)
#  comments_count  :integer
#  md_content      :text
#  url_code        :integer
#  views_count     :integer          default(0)
#  catch_title     :text
#  published_at    :datetime
#  key             :string(255)
#  remark          :text
#  extra           :text
#  source_type     :string(255)
#  favorites_count :integer
#

require "spec_helper"

describe Post do
  include Rails.application.routes.url_helpers

  describe '#get_assess_url' do
    before do
      @post = create :post, :published, title_link: nil
    end

    it do
      expect(@post.get_access_url).to eq 'http://localhost:3000' + post_show_by_url_code_path(@post.url_code)
    end
  end

  describe '#column_name' do
    before do
      @post = create :post, :published
    end

    it do
      expect(@post.column_name).to eq @post.column.name
    end
  end

  describe '#auto_generate_summary' do
    before do
      @post = create :post, :published, content: 'ssssssss. asdfasdfasdf', summary: nil
    end

    it do
      expect(@post.summary).to eq 'ssssssss.'
    end
  end

  describe '#check_head_line_cache_for_destroy' do
    before do
      @post = create :post, :published
      @head_line = create :head_line, url_code: @post.url_code
    end

    it do
      @post.destroy
      expect(HeadLine.find_by_url_code(@post.url_code)).to eq nil
    end
  end

  describe '#check_head_line_cache' do
    before do
      @post = create :post, :published
      @head_line = create :head_line, url_code: @post.url_code
    end

    it do
      @post.undo_publish
      @post.save
      expect(HeadLine.find_by_url_code(@post.url_code)).to eq nil
    end
  end

  describe '#sanitize_content' do
    before do
      @post = create :post, :published
    end

    it do
      expect(@post.sanitize_content).to match(/fuck you/)
    end
  end
end
