# == Schema Information
#
# Table name: info_flows
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class InfoFlow < ActiveRecord::Base

  validates :name, presence: true
  validates_uniqueness_of :name

  has_and_belongs_to_many :columns
  has_and_belongs_to_many :ads

 def posts_with_ads(page_num)
    posts = Post.where(:column_id => self.columns).order("created_at desc").page(page_num)
    post_begin_index = posts.offset_value + 1
    post_end_index = [posts.current_page * posts.limit_value, posts.total_count].min
    ads = self.ads.order("position desc").select{|ad| ad.position >= post_begin_index - 1 && ad.position <= post_end_index }
    posts_arr = posts.to_a
    #merger posts with ads
    ads.each do |ad|
      posts_arr.insert(ad.position, ad)
    end

    #make a sign to seperate post between days
    current_day = posts.first.created_at.strftime("%F")
    posts_arr.each_with_index do |item, index|
      if item.class.to_s == "Post" && item.created_at.strftime("%F") != current_day
        current_day = item.created_at.strftime("%F")
        posts_arr.insert(index, {:date => current_day, :type => "seperate"})
      end
    end

    [posts_arr, posts.total_count]
  end
end