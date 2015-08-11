# == Schema Information
#
# Table name: head_lines
#
#  id               :integer          not null, primary key
#  url              :string(255)
#  order_num        :integer
#  created_at       :datetime
#  updated_at       :datetime
#  title            :string(255)
#  post_type        :string(255)
#  image            :string(255)
#  user_id          :integer
#  url_code         :integer
#  state            :string(255)
#  section          :string(255)
#  display_position :text
#  summary          :text
#  hidden_title     :boolean
#  section_text     :string(255)
#

require 'spec_helper'

describe HeadLine do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe '#replice_count' do
    before do
      @head_lines = create :head_line
    end

    it do
      expect(@head_lines.replies_count).to eq 0
    end

    it do
      expect(@head_lines.excerpt).to eq @head_lines.title
    end
  end
end
