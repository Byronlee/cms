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
end

class ActiveRecord::Base
  include Tire::Model::AutoRefreshCallbacks
end
