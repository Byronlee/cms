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

  after_save :update_info_flows_cache
  after_destroy :destroy_info_flows_cache

  DEFAULT_INFOFLOW = Settings.default_info_flow

  ###
  # options[:page]
  # options[:per_page]
  # options[:page_direction]
  # options[:boundary_post_url_code]
  # options[:ads_required]
  ###
  def posts_with_ads(options = {})

    boundary_post = Post.find_by_url_code(options[:boundary_post_url_code]) if options[:boundary_post_url_code].present?
    
    options[:page_num] = 1 if(options[:page_direction].present? && boundary_post.present?)
    posts = Post.where(:column_id => columns).published
    if options[:page_direction] == 'next' && boundary_post.present?
      posts = posts.where('posts.published_at < ?', boundary_post.published_at)
    elsif options[:page_direction] == 'prev' && boundary_post.present?
      posts = posts.where('posts.published_at > ?', boundary_post.published_at)
    end
    posts = posts.includes(:column, :related_links, author: [:krypton_authentication]).recent.page(options[:page_num]).per(options[:per_page] || 30)
    posts_with_associations = get_associations_of(posts)
 
    if options[:ads_required]
      ads = get_ads_with_period_of posts
      flow = mix_posts_and_ads posts_with_associations, ads
    else
      flow = posts_with_associations
    end

    { posts: flow, 
      total_count: posts.total_count,
      prev_page: posts.prev_page,
      next_page: posts.next_page,
      first_url_code: (posts.first ? posts.first.url_code : nil),
      last_url_code: (posts.last ? posts.last.url_code : nil)
     }
  end

  def update_info_flows_cache
    logger.info "perform the worker to update info flows of #{name}"
    logger.info InfoFlowsComponentWorker.new.perform(name)
    true
  end

  def posts(options = {})
    options[:page_num] ||= 1
    options[:per_page] ||= Settings.site_map.posts_count
    Post.where(:column_id => columns).published.includes(:author, :column).order('published_at desc').page(options[:page_num]).per(options[:per_page])
  end

  private

  def get_associations_of(posts)
    JSON.parse posts.to_json(
      :except => [:content],
      :methods => [:cover_real_url, :comments_counts],
      :include => {
        :related_links => {
          },
        :author => {
          :only => [:id, :domain, :sso_id, :email, :phone, :role], :methods => [:display_name, :avatar] },
        :column => {
          :only => [:id, :name, :slug] }
        }
      )
  end

  def get_ads_with_period_of(posts)
    post_begin = posts.offset_value
    post_end = [posts.current_page * posts.limit_value, posts.total_count].min
    ads = self.ads.where(:position => post_begin..post_end).order('position desc')
    ads.collect { |ad| ad.position -= post_begin; ad } # 减去分页造成的偏移
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
    current_date = posts.first.created_at.strftime('%F')
    flow.each_with_index do |item, index|
      if item.class.to_s == 'Post' && item.created_at.strftime('%F') != current_date
        current_date = item.created_at.strftime('%F')
        flow.insert(index, { :date => current_date, :type => 'seperate' })
      end
    end
    flow
  end

  def destroy_info_flows_cache
    Redis::HashKey.new('info_flow').delete(name)
  end
end