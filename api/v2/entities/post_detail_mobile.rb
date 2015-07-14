module V2
  module Entities
    class PostDetailMobile < ::V2::Entities::Post
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
          #image.attributes["src"].value = "#{src}!mobile" if src.scan(URI.regexp)[0].include?("a.36krcnd.com") and object.url_code > 200_000
          image.attributes["src"].value = rand_cdn(src,'mobile') if src.scan(URI.regexp)[0].include?("a.36krcnd.com") and object.url_code > 200_000
        end
        doc.to_html
      end

      def rand_cdn(raw_url, prefix)
        match = /(http:\/\/.\.36krcnd\.com)(.*)/.match(raw_url)
        return raw_url unless match
        host = "http://#{['a', 'b', 'c', 'd', 'e'][rand(5)]}.36krcnd.com"
        "#{host}#{match[2]}!#{prefix}"
      end

    end
  end
end
