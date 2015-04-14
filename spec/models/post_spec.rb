# == Schema Information
#
# Table name: posts
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  summary        :text
#  content        :text
#  title_link     :string(255)
#  must_read      :boolean
#  slug           :string(255)
#  state          :string(255)
#  draft_key      :string(255)
#  column_id      :integer
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#  cover          :text
#  source         :string(255)
#  comments_count :integer
#  md_content     :text
#  url_code       :integer
#  views_count    :integer          default(0)
#  catch_title    :text
#  published_at   :datetime
#  key            :string(255)
#  remark         :text
#

require "spec_helper"

describe Post do
  describe "#autoset_source_info" do
    let(:source_urls) {
      %{
        http://google.com/ooxx
        http://com.google/ooxx
      }
    }
    context "original" do
      let(:post) { create :post, source_type: :original, source_urls: source_urls }
      it { expect(post.source_urls).to be_blank }
    end
    context "translation" do
      let(:post) { create :post, source_type: :translation, source_urls: source_urls }
      it { expect(post.source_urls).to be_present }
    end

    context "reference" do
      let(:post) { create :post, source_type: :translation, source_urls: source_urls }
      it { expect(post.source_urls).to be_present }
    end
  end
end
