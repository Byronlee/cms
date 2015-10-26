module V2
  module Controllers
    class MobileAds < ::V2::Base

      desc 'mobile ad feature'
      resource :mobile_ads do

        desc 'get all mobile ads list'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
          optional :state,  type: Boolean, default: true, desc: '正在展示的广告'
          #optional :ad_enable_time,  type: Time, default: Time.now.strftime('%F %T'), desc: '展示开始时间'
          #optional :ad_end_time,  type: Time, default: (Time.now + 7.days).strftime('%F %T'), desc: '展示结束时间'
        end
        get do
          ads = MobileAd.recent.where(state: params[:state])
          .where("ad_enable_time < ? and ad_end_time > ? and ad_type = ? ", Time.now, Time.now, 0)
          .order(created_at: :desc).page(params[:page]).per(params[:per_page])
          #cache(key: "api:v2:ads", etag: Time.now, expires_in: Settings.api.expires_in) do
            present ads, with: Entities::MobileAdDetail
          #end
        end

        desc 'show mobile count'
        get 'api/:id' do
          ad = MobileAd.where(id: params[:id]).first
          ad.increase_api_count if ad
          #cache(key: "api:v2:ads:#{params[:id]}", etag: Time.now, expires_in: Settings.api.expires_in) do
            present ad, with: Entities::MobileAd
          #end
        end

        desc 'click mobile count'
        get 'click/:id' do
          ad = MobileAd.where(id: params[:id]).first
          ad.increase_click_count if ad
          #cache(key: "api:v2:ads:#{params[:id]}", etag: Time.now, expires_in: Settings.api.expires_in) do
            present ad, with: Entities::MobileAd
          #end
        end

      end
    end
  end
end
