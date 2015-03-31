module PageView
  module ActiveRecord
    def page_view_field(*fields)
      fields.each do |field|
        field = field.to_sym unless field.is_a? Symbol

        class_eval <<-RUBY
          def increase_#{field}
            field_name = :#{field}
            cache_key = get_cache_key(field_name)
            views_count = Redis::HashKey.new('page_views')[cache_key]
            if views_count
              views_count = views_count.to_i
            else
              views_count = self.#{field}.to_i
            end
            Redis::HashKey.new('page_views')[cache_key] = views_count.next
          end

          def persist_#{field}(options = {})
            field_name = :#{field}
            cache_key = get_cache_key(field_name)
            views_count = Redis::HashKey.new('page_views')[cache_key]
            if views_count.present? && self.#{field}.to_i < views_count.to_i
              if options[:skip_callbacks]
                self.update_column(field_name, views_count.to_i)
              else
                self.update_attribute(field_name, views_count.to_i)
              end
              real_value = views_count.to_i
            else
              Redis::HashKey.new('page_views')[cache_key] = self.#{field}.to_i
              real_value = self.#{field}.to_i
            end
            real_value
          end

          def cache_#{field}
            field_name = :#{field}
            cache_key = get_cache_key(field_name)
            views_count = Redis::HashKey.new('page_views')[cache_key]
            (views_count.presence || self.#{field}).to_i
          end

          def get_cache_key(field_name)
            self.class.to_s + '#' + self.id.to_s + '#' + field_name.to_s
          end
        RUBY

      end
    end
  end
end

ActiveRecord::Base.send :extend, PageView::ActiveRecord
