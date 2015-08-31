Tire::Model::Search.index_prefix "krypton_#{Rails.env.to_s.downcase}"

Tire.configure do
  url Settings.elasticsearch.server
end

module Tire

  module Model
    module AutoRefreshCallbacks
      def self.included(base)
        base.send :after_commit, -> { self.respond_to?(:tire) and tire.index.refresh }
      end
    end
  end

  module Utils
    LUCENE_BOOLEANS = /\b(AND|OR|NOT)\b/

    LUCENE_SPECIAL_CHARACTERS = Regexp.new("(" + %w[
      + - && || ! ( ) { } [ ] ^ " ~ * ? : \\ /
    ].map { |s| Regexp.escape(s) }.join("|") + ")")

    def escape_query(s)
      return unless s
      special_chars_escaped = s.gsub(LUCENE_SPECIAL_CHARACTERS, '\\\\\1')
      special_chars_escaped.gsub(LUCENE_BOOLEANS, '"\1"')
    end
  end

end

class ActiveRecord::Base
  include Tire::Model::AutoRefreshCallbacks if Settings.elasticsearch.auto_index
end
