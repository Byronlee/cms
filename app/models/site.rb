# == Schema Information
#
# Table name: sites
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text
#  domain              :string(255)
#  info_flow_id        :integer
#  admin_id            :integer
#  created_at          :datetime
#  updated_at          :datetime
#  columns_id_and_name :string(255)      default([]), is an Array
#  slug                :string(255)
#

class Site < ActiveRecord::Base
  belongs_to :info_flow
  has_and_belongs_to_many :columns
  validates_presence_of :name, :description, :domain, :info_flow_id, :admin_id
  validates_uniqueness_of :name
  validates_each :admin_id do |record, attr, value|
    record.errors.add(attr, "用户不存在!") if User.where(id: value).blank?
  end

  def admin
    User.find(admin_id)
  end
end
