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

    def not_found!(resource = nil)
      message = ["404"]
      message << resource if resource
      message << "Not Found"
      render_api_error!(message.join(' '), 404)
    end

    def render_api_error!(message, status)
      error!({ 'message' => message }, status)
    end

    def authenticated
      if request.headers['X-Token'].present? or params[:token].present?
        request.headers['X-Token'] == Settings.api.v1.XToken \
          or params[:token] == Settings.api.v1.token ?
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

    def warden
      env['warden']
    end

    def weibo_post(object)
      if !object.nil? && object.state == "published"
        {
          "display_name" => "#{object.title}",
          "image" =>  {
          "url" => "#{object.cover_real_url}!s2",
          "width" => 120,
          "height" =>  120
        },
          "author" =>  {
          "display_name" =>  "#{object.author.name||"36Kr"}",
          "url" => "#{Settings.site}",
          "object_type" =>  "person"
        },
          "summary" =>  "#{object.summary||""}",
          "url" =>  "#{Settings.site}/p/#{object.url_code}.html",
          "links" =>  {
          "url" =>  "#{Settings.site}/p/#{object.url_code}.html",
          "scheme" =>  "scheme://www.36kr.com/p/#{object.url_code}",
          "display_name" =>  "阅读全文"
        },
          "tags" =>  [ {
          "display_name" =>  "#{object.tag_list.first||""}" }
        ],
          "create_at" => "#{object.created_at||Time.now}",
          "object_type" =>  "article"
        }
      else
        { "errcode" => "-1","msg" => "NotFound!" }
      end
    end

    def weibo_newsflash(object)
      img_url = object.fast_type == 'newsflash' ? \
        "http://a.36krcnd.com/nil_class/40202777-0930-44ef-a435-7baecc36fece/krec.png" : \
        "http://a.36krcnd.com/nil_class/ff30ebc4-6533-48ea-bff4-8544a4a82b0e/pnd.png"
      if !object.nil?
        {
          "display_name" => "#{object.hash_title}",
          "image" =>  {
          "url" => "#{img_url}!s2", "width" => 120, "height" =>  120
        },
          "author" =>  {
          "display_name" =>  "#{object.author.name || '36Kr' }",
          "url" => "#{Settings.site}",
          "object_type" =>  "person"
        },
          "summary" =>  "#{object.description_text || ''}",
          "url" =>  "#{Settings.site}/clipped/#{object.id}.html",
          "links" =>  {
          "url" =>  "#{Settings.site}/clipped/#{object.id}.html",
          "scheme" =>  "scheme://www.36kr.com/clipped/#{object.id}",
          "display_name" =>  "阅读全文"
        },
          "tags" =>  [ {
          "display_name" =>  "#{object.tag_list.first || ''}" }
        ],
          "create_at" => "#{object.created_at || Time.now}",
          "object_type" =>  @newsflash.fast_type
        }
      else
        { "errcode" => "-1","msg" => "NotFound!" }
      end
    end

  end
end
