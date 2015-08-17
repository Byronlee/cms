# == Schema Information
#
# Table name: sites
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  description  :text
#  domain       :string(255)
#  info_flow_id :integer
#  admin_id     :integer
#  created_at   :datetime
#  updated_at   :datetime
#  slug         :string(255)
#

class Site < ActiveRecord::Base

  validates_presence_of :name, :description, :domain, :info_flow_id, :admin_id, :slug
  validates_uniqueness_of :name, :slug

  validates_each :admin_id do |record, attr, value|
    record.errors.add(attr, "用户不存在!") if User.where(id: value).blank?
  end

  belongs_to :info_flow
  has_and_belongs_to_many :columns
  has_many :column_sites

  def admin
    auth = Authentication.where(uid: admin_id.to_s).first
    auth.user
  end
end
