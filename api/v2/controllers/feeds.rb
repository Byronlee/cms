module V2
  module Controllers
    class Feeds < ::V2::Base

      desc 'info flow'
      resource :feeds do

        desc 'get info flow index'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get do
          info_flow = InfoFlow.find_by_name Settings.default_info_flow
          info_flow.posts_with_ads(params[:page])[0]
        end


      end

    end
  end
end
