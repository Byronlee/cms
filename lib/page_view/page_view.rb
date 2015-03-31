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
            cache_value = Redis::HashKey.new('page_views')[cache_key]
            views_count = cache_value
            if views_count.nil?
              views_count = self.#{field}.to_i
            else
              views_count = views_count.to_i
            end
            Redis::HashKey.new('page_views')[cache_key] = views_count.next
          end
        METHOD_MSG
      end
    end
  end
end

ActiveRecord::Base.send :extend, PageView::ActiveRecord
