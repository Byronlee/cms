# == Schema Information
#
# Table name: newsflashes
#
#  id                       :integer          not null, primary key
#  original_input           :text
#  hash_title               :string(255)
#  description_text         :text
#  news_url                 :string(255)
#  newsflash_topic_color_id :integer
#  news_summaries           :string(8000)
#  created_at               :datetime
#  updated_at               :datetime
#  user_id                  :integer
#  cover                    :string(255)
#  is_top                   :boolean          default(FALSE)
#  toped_at                 :datetime
#  views_count              :integer          default(0)
#  column_id                :integer
#  extra                    :text
#  display_in_infoflow      :boolean
#  pin                      :boolean          default(FALSE)
#

require 'spec_helper'

describe Newsflash do
end
