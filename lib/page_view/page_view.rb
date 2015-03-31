module PageView
  module ActiveRecord
    def page_view_field(fields)
      fields = [] << fields unless fields.is_a? Array
      fields.each do |field|
        field = field.to_sym unless field.is_a? Symbol
        class_eval <<-METHOD_MSG
          def increase_#{field}
            filed_name = /^increase_(.*)/i.match(__method__.to_s)[1]
            cache_key = self.class.to_s+'#'+self.id.to_s+'#'+ filed_name
            views_count = Redis::HashKey.new('page_views')[cache_key]
            if views_count.nil?
              views_count = self.#{field}.to_i
            else
              views_count = views_count.to_i
            end
            Redis::HashKey.new('page_views')[cache_key] = views_count.next
          end

          def persist_#{field}
            filed_name = /^persist_(.*)/i.match(__method__.to_s)[1]
            cache_key = self.class.to_s+'#'+self.id.to_s+'#'+ filed_name
            views_count = Redis::HashKey.new('page_views')[cache_key]
            if views_count.present? && self.#{field}.to_i < views_count.to_i
              self.update_attribute(filed_name.to_sym, views_count.to_i)
            else
              Redis::HashKey.new('page_views')[cache_key] = self.#{field}.to_i
            end
          end
        METHOD_MSG
      end
    end
  end
end

ActiveRecord::Base.send :extend, PageView::ActiveRecord
