module V2
  module Controllers
    class Feeds < ::V2::Base

      desc 'info flow'
      resource :info_flows do

        desc 'get info flow index'
        params do
          optional :name, type: String, default: '主站', desc: '信息流名称'
          optional :id,  type: Integer, default: 0, desc: '边界url_code'
          optional :action,  type: String, default: 'next', desc: '翻页方向 (down next) (up prev)'
          optional :page,  type: Integer, default: 1, desc: '页面'
          optional :per_page,  type: Integer, default: 30, desc: '每页显示数量'
        end
        get do
          params[:id] = nil if params[:id] <= 0
          case params[:action]
          when blank?
            params[:action] = nil
          when 'up'
            params[:action] = 'prev'
          when 'down'
            params[:action] = 'next'
          end
          info_flow = InfoFlow.find_by_name params[:name]
          #cache(key: "api:v2:feeds:index", etag: Time.now, expires_in: Settings.api.expires_in) do
            info_flow = info_flow.posts_with_ads(page: params[:page], \
              per_page: params[:per_page], \
              page_direction: params[:action], \
              boundary_post_url_code: params[:id], \
              ads_required: false)
          #end
          info_flow
        end

      end

    end
  end
end
