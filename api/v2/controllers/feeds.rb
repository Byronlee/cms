module V2
  module Controllers
    class Feeds < ::V2::Base

      desc 'info flow'
      resource :feeds do

        desc 'get info flow index'
        params do
          optional :info_flow, type: String, default: '主站', desc: ' 信息流名称'
          optional :page_direction,  type: String, default: '', desc: '翻页方向'
          optional :boundary_post_url_code,  type: Integer, default: 0, desc: '边界url_code'
        end
        get do
          params[:page_direction] = nil if params[:page_direction].blank?
          params[:boundary_post_url_code] = nil if params[:boundary_post_url_code] <= 0
          info_flow = InfoFlow.find_by_name params[:info_flow]
          #cache(key: "api:v2:feeds:index", etag: Time.now, expires_in: Settings.api.expires_in) do
            info_flow = info_flow.posts_with_ads(1, params[:page_direction], params[:boundary_post_url_code], false)
          #end
          info_flow
        end


      end

    end
  end
end
