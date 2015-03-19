# == Schema Information
#
# Table name: head_lines
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  order_num  :integer
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)
#  post_type  :string(255)
#  image      :string(255)
#  user_id    :integer
#  url_code   :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :head_line do
    url "http://localhost/admin/posts/1"
    order_num 10
  end

  factory :head_line2, :class => 'HeadLine' do
    url "http://localhost/admin/posts/2"
    order_num 10
  end
end
