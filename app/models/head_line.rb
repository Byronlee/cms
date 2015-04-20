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
#  state      :string(255)
#

class HeadLine < ActiveRecord::Base
  include AASM
  aasm.attribute_name :state
  paginates_per 20

  validates :url, presence: true
  validates_uniqueness_of :url
  validates :url, :url => { :allow_blank => true }

  belongs_to :user

  after_destroy :fetch_remote_metas
  after_save :fetch_remote_metas

  scope :published, ->{ where(:state => :published) }
  scope :archived, ->{ where(:state => :archived) }

  aasm do
    state :published, :initial => true
    state :archived

    event :publish do
      transitions :from => [:archived], :to => :published
    end

    event :archive do
      transitions :from => [:published], :to => :archived
    end
  end

  def replies_count
    0
  end

  def excerpt
    title
  end

  private

  def fetch_remote_metas
    logger.info 'perform the worker to fetch remote metas'
    # logger.info HeadLinesComponentWorker.perform_async
    logger.info HeadLinesComponentWorker.new.perform
    true
  end
end
