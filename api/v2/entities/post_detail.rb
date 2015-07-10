module V2
  module Entities
    class PostDetail < ::V2::Entities::Post
      format_with(:iso_timestamp) { |dt| dt.iso8601 if dt }
      expose :id         , documentation: 'not null, primary key'
      expose :state      , documentation: '状态'
      expose :content    , documentation: '内容'
      expose :favoriter_sso_ids
      expose :tag_list   , documentation: '标签'
      with_options(format_with: :iso_timestamp) do
        expose :created_at , documentation: ''
        expose :updated_at , documentation: ''
      end

      private
      def content
        str = object.sanitize_content
        doc = Nokogiri::HTML.fragment(str)
        images = doc.css 'img'
        images.each do |image|
          src = image.attributes["src"].value
          image.attributes["src"].value = "#{src}!mobile" if src.scan(URI.regexp)[0].include?("a.36krcnd.com") and object.url_code > 200_000
        end
        doc.to_html
      end

    end
  end
end
