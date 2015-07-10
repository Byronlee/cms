module V2
  module Entities
    class Newsflash < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 if dt }
      expose :id
      expose :original_input
      expose :description_text
      expose :news_url
      expose :news_summaries
      expose :user_id
      expose :cover
      expose :toped_at
      expose :views_count
      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
  end
end
