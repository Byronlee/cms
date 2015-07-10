module V2
  module Controllers
    class Feeds < ::V2::Base

      desc 'info flow'
      resource :info_flows do

        desc 'get info flow index'
        # per_page
        # page
        params do
          optional :info_flow_name, type: String, default: '主站', desc: '信息流名称'
          # down next up prev
          optional :page_direction,  type: String, default: 'next', desc: '翻页方向'
          optional :boundary_post_url_code,  type: Integer, default: 0, desc: '边界url_code'
          optional :per_page,  type: Integer, default: 30, desc: '每页显示数量'
          optional :page,  type: Integer, default: 1, desc: '页面'
        end
        get do

          case params[:page_direction]
          when blank?
            params[:page_direction] = nil
          when 'up'
            params[:page_direction] = 'next'
          when 'down'
            params[:page_direction] = 'prev'
          end

          params[:boundary_post_url_code] = nil if params[:boundary_post_url_code] <= 0

          info_flow = InfoFlow.find_by_name params[:info_flow_name]
          #cache(key: "api:v2:feeds:index", etag: Time.now, expires_in: Settings.api.expires_in) do
            info_flow = info_flow.posts_with_ads(page: params[:page], per_page: params[:per_page], page_direction: params[:page_direction], boundary_post_url_code: params[:boundary_post_url_code], ads_required: false)
          #end
          info_flow
        end


      end

    end
  end
end
