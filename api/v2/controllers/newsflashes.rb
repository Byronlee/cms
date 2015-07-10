module V2
  module Controllers
    class Newsflashes < ::V2::Base

    desc 'Newsflashes Feature'
      resource :newsflashes do

      	desc 'Get all Newsflashs list'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get 'index' do
          @newsflashes = Newsflash.order(id: :desc)
            .page(params[:page]).per(params[:per_page])
          #cache(key: "api:v2:newsflashs:index", etag: Time.now, expires_in: Settings.api.expires_in) do
            present @newsflashes, with: Entities::Newsflash
          #end
        end

      end
      
    end
  end
end
