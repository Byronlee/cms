module V2
  module Helpers

    def action(params)
      case params[:action]
      when 'up' then '>'
      when 'down' then '<'
      else '<' end
    end

    def adjust_tags(tag)
      tags_list = [ tag ]
      case tag
      when 'cn-startups' then tags_list << '国内创业公司'
      when 'us-startups' then tags_list << '国外创业公司'
      when 'cn-news' then tags_list << '国内资讯'
      when 'breaking' then tags_list << '国外资讯'
      when 'column' then tags_list << '专栏文章' << '专栏'
      when 'digest' then tags_list << '生活方式'
      else tags_list end
    end

    def attributes_for_keys(keys)
      attrs = {}
      keys.each do |key|
        attrs[key] = params[key] if params[key].present? or (params.has_key?(key) and params[key] == false)
      end
      attrs
    end

    def not_found!(resource = nil)
      message = ["404"]
      message << resource if resource
      message << "Not Found"
      render_api_error!(message.join(' '), 404)
    end

    def render_api_error!(message, status)
      error!({ 'message' => message }, status)
    end

    def warden
      env['warden']
    end

    def authenticated
      if request.headers['X-Token'].present? or params[:api_key].present?
        request.headers['X-Token'] == Settings.api.v2.XToken \
          or params[:api_key] == Settings.api.v2.api_key ?
          true : false
      else
        false
      end
      #return true if warden.authenticated?
    end

    def current_user
      #warden.user || @user
      sso_token = params[:sso_token]
      authentication = Authentication.from_access_token(sso_token)
      authentication.user || User.create!(authentication: authentication)
    end

    def generate_review_url(post)
      if post.published?
        "#{Settings.site}/p/#{post.url_code}.html"
      else
        "#{Settings.site}/p/preview/#{post.key}.html"
      end
    end

    def admin_edit_post_url(post, auth)
      if auth.present? && auth.user.editable
        if post.published?
          "#{Settings.site}/krypton/posts/#{post.id}/edit"
        else
          "#{Settings.site}/krypton/posts/#{post.id}/publish"
        end
      else
        nil
      end
    end

    def coming_out(post, auth)
      post.review
      post.activate_publish_schedule if auth.present? and auth.user.editable
      post
    end

  end
end
