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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :head_line do
    url "http://36kr.com/p/531980.html"
    post_type 'article'
    order_num 10
    state 'published'
    title 'title'
  end

  factory :head_line2, :class => 'HeadLine' do
    url "http://3531964.html"
    post_type 'article'
    order_num 10
    state 'published'
    title 'title'
  end
end
