module V1
  module Helpers

    def action(params)
      case params[:action]
      when 'up' then '>='
      when 'down' then '<='
      else '<=' end
    end

    def attributes_for_keys(keys)
      attrs = {}
      keys.each do |key|
        attrs[key] = params[key] if params[key].present? or (params.has_key?(key) and params[key] == false)
      end
      attrs
    end

  end
end