module V2
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

    def not_found!

    end

    def authenticated
      if request.headers['X-Token'].present? or params[:api_key].present?
        request.headers['X-Token'] == '501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je' or params[:api_key] == '501Cd1AvUL4AxxVEX60gCFJK7HCd9y8ySDvG29Je' ?
          true : false
      else
        false
      end
      #return true if warden.authenticated?
      #params[:access_token] && @user = User.find_by_authentication_token(params[:access_token])
    end

    def current_user
      User.where(authentication_token: params[:authentication_token]).first
    end

    def init_and_exchange_token
      sso_user = V2::Passport.new(params[:sso_token]).me
      unless sso_user.is_a? TrueClass or sso_user.is_a? FalseClass
        # sso 有用户的情况
        current_user = User.find_by_origin_ids(sso_user['id']) || User.find_by_sso_id(sso_user['id'])
         if current_user.blank?
           #sso有用户新站没有这个用户
           user_attr = { sso_id: sso_user.id,  email: sso_user.email, name: sso_user.nickname || sso_user.username,
             phone: sso_user.phone, avatar_url: sso_user.avatar, password: 'VEX60gCF' }
           current_user = User.create user_attr
         end
      else # sso sso_token 无效或者没有用户的情况
        current_user = User.new
      end
      [current_user,sso_user]
      #warden.user || @user
    end

    def warden
      env['warden']
    end

  end
end