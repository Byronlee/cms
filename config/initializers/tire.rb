Tire::Model::Search.index_prefix "krypton_#{Rails.env.to_s.downcase}"
Tire.configure do
  url Settings.elasticsearch.server
end

module Tire
  module Model
    module AutoRefreshCallbacks
      def self.included(base)
        base.send :after_commit, lambda { self.respond_to?(:tire) and tire.index.refresh }
      end
    end
  end
  module Utils
    LUCENE_SPECIAL_CHARACTERS = Regexp.new("(" + %w[
      + - && || ! ( ) { } [ ] ^ " ~ * ? : \\ /
    ].map { |s| Regexp.escape(s) }.join("|") + ")")

    LUCENE_BOOLEANS = /\b(AND|OR|NOT)\b/

    def escape_query(s)
      return unless s
      # 6 slashes =>
      #  ruby reads it as 3 backslashes =>
      #    the first 2 =>
      #      go into the regex engine which reads it as a single literal backslash
      #    the last one combined with the "1" to insert the first match group
      special_chars_escaped = s.gsub(LUCENE_SPECIAL_CHARACTERS, '\\\\\1')

      # Map something like 'fish AND chips' to 'fish "AND" chips', to avoid
      # Lucene trying to parse it as a query conjunction
      special_chars_escaped.gsub(LUCENE_BOOLEANS, '"\1"')
    end
  end

end

class ActiveRecord::Base
  include Tire::Model::AutoRefreshCallbacks
end
