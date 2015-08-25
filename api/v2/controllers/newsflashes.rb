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

        desc 'Get n tags for pd or nf list'
        params do
          optional :tags,  type: String, desc: '多个标签用逗号隔开'
          optional :start_date, type: Integer, desc: '开始日期ISO-8601 时间戳(Unix timestamp)秒'
          optional :end_date, type: Integer, desc: '结束日期ISO-8601 时间戳(Unix timestamp)秒'
        end
        post 'krweekly' do
          post_hash = {}
           params[:tags].split(',').each do |tag|
             post_hash[tag] = Newsflash.select(:id,:original_input,:hash_title,:description_text,:news_summaries,:created_at)
             .where(created_at: Time.at(params[:start_date].to_i)..Time.at(params[:end_date].to_i))
             .tagged_with(tag).order('created_at desc')
           end
           post_hash
        end

      end
      
    end
  end
end
