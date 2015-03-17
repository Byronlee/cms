module V1
  module Helpers

    def action(params)
      case params[:action]
      when 'up' then '>'
      when 'down' then '<'
      else '<' end
    end

    def attributes_for_keys(keys)
      attrs = {}
      keys.each do |key|
        attrs[key] = params[key] if params[key].present? or (params.has_key?(key) and params[key] == false)
      end
      attrs
    end

    def authenticated_tmp
      p request.headers['X-Token']
      if request.headers['X-Token'].present? or params[:api_key].present?
        request.headers['X-Token'] == '501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je' or params[:api_key] == '501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je' ?
         true : false
      else
        false
      end
    end

    def authenticated
      return true if warden.authenticated?
      params[:access_token] && @user = User.find_by_authentication_token(params[:access_token])
    end

    def current_user
      warden.user || @user
    end

    def warden
      env['warden']
    end

  end
end
