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
    ads = get_ads_with_period_of posts
    flow = mix_posts_and_ads posts, ads
    flow = mix_seperate_by_date flow, posts

    [flow, posts.total_count]
  end

  private

  def get_ads_with_period_of(posts)
    post_begin = posts.offset_value
    post_end = [posts.current_page * posts.limit_value, posts.total_count].min
    ads = self.ads.where(:position => post_begin..post_end).order("position desc")
    ads.collect{|ad| ad.position -= post_begin; ad} #减去分页造成的偏移
  end

  def mix_posts_and_ads(posts, ads)
    posts_mix = posts.dup.to_a
    ads.each do |ad|
      posts_mix.insert(ad.position, ad)
    end
    posts_mix
  end

  def mix_seperate_by_date(flow, posts)
    return [] if posts.blank?
    current_date = posts.first.created_at.strftime("%F")
    flow.each_with_index do |item, index|
      if item.class.to_s == "Post" && item.created_at.strftime("%F") != current_date
        current_date = item.created_at.strftime("%F")
        flow.insert(index, {:date => current_date, :type => "seperate"})
      end
    end
    flow
  end
end