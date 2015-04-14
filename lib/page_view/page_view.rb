module PageView
  module ActiveRecord
    ###
    # usage: page_view_field :views_count, interval: 600
    #        page_view_field [:views_count, :api_hits_count], interval: 600
    # interval: unit is seconds, default is 600 seconds, in other word, 10 minutes
    ###
    def page_view_field(fields, options = {})
      fields = [] << fields unless fields.class == Array
      options[:interval] ||= 600

      fields.each do |field|
        field = field.to_sym unless field.is_a? Symbol

        class_eval <<-RUBY
          def increase_#{field}
            views_count = update_cache_#{field.to_s}(views_count)
            if cache_#{field}_time.nil?
              update_cache_#{field}_time
            elsif(Settings.page_views.persist && (Time.parse(cache_#{field}_time) + #{options[:interval]}.seconds <= Time.now))
              persist_to_#{field}(views_count)
              update_cache_#{field}_time
            end
            views_count
          end

          def cache_#{field}
            views_count = Redis::HashKey.new('page_views')[#{field}_key]
            (views_count.presence || self.#{field}).to_i
          end

          def persist_#{field}(options = {})
            views_count = cache_#{field}
            persist_to_#{field}(views_count, options)
            update_cache_#{field}_time
            views_count
          end

          private

          def cache_#{field}_time
            Redis::HashKey.new('page_views')[#{field}_time_key]
          end

          def #{field}_key
            self.class.to_s + '#' + self.id.to_s + '#' + :#{field}.to_s
          end

          def #{field}_time_key
            self.class.to_s + '#' + self.id.to_s + '#' + :#{field}.to_s + '#' + 'updated_at'
          end

          def update_cache_#{field}(views_count)
            views_count = Redis::HashKey.new('page_views')[#{field}_key]
            if views_count
              views_count = views_count.to_i.next
            else
              views_count = self.#{field}.to_i.next
            end
            Redis::HashKey.new('page_views')[#{field}_key] = views_count
          end

          def update_cache_#{field}_time
            Redis::HashKey.new('page_views')[#{field}_time_key] = Time.now
          end

          def persist_to_#{field}(views_count, options)
            return unless views_count.to_i > self.#{field}
            unless options[:skip_callbacks]
              self.update_attribute(:#{field}, views_count.to_i)
            else
              self.update_column(:#{field}, views_count.to_i)
            end
          end
        RUBY

      end
    end
  end
end

ActiveRecord::Base.send :extend, PageView::ActiveRecord