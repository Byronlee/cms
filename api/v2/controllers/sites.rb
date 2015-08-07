module V2
  module Controllers
    class Sites < ::V2::Base

      desc 'sites feature'
      resource :sites do

        desc 'get all sites list'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get do
          @sites = Site.all
          .order(created_at: :desc)
          .page(params[:page]).per(params[:per_page])
          #cache(key: "api:v2:sites", etag: Time.now, expires_in: Settings.api.expires_in) do
            present @sites, with: Entities::Site
          #end
        end

        desc 'get sites'
        params do
          optional :slug,  type: String, default: 'krspace', desc: '子站名称'
        end
        get ':slug' do
          @site = Site.find_by_slug(params[:slug])
          #cache(key: "api:v2:sites:#{params[:id]}", etag: Time.now, expires_in: Settings.api.expires_in) do
            present @site, with: Entities::Site
          #end
        end
      end
    end
  end
end
