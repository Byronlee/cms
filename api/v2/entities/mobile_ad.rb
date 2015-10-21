module V2
  module Entities
    class MobileAd < Grape::Entity
      expose :id, :ad_position, :cache_api_count, :cache_click_count
    end
  end
end
