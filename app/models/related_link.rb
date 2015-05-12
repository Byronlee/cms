# == Schema Information
#
# Table name: related_links
#
#  id          :integer          not null, primary key
#  url         :string(255)
#  link_type   :string(255)
#  title       :string(255)
#  image       :string(255)
#  description :text
#  extra       :text
#  created_at  :datetime
#  updated_at  :datetime
#  post_id     :integer
#  user_id     :integer
#

require 'common'
class RelatedLink < ActiveRecord::Base
  typed_store :extra do |s|
    s.text :video_url, default: ''
    s.integer :video_duration, default: 0
  end

  validates_presence_of :url
  validates_uniqueness_of :url

  belongs_to :post
  belongs_to :user

  def self.parse_url(url)
    return {result: false, msg: 'URL不可为空', metas: {}} unless url.present?
    code, msg = valid_of?(url)
    return {result: false, msg: msg, metas: {}} unless code
    begin
      og = OpenGraph.new(url)
      metas = {
        title: og.title,
        type: og.type,
        url: og.url,
        description: og.description,
        image: og.images.first,
        video: get_customer_meta_of(og, :video),
        video_duration: get_customer_meta_of(og, :video, :duration)
      }
    rescue Exception => ex
      return {result: false, msg: ex.message, metas: {}}
    end

    {result: true, msg:'', metas: metas}
  end
end
