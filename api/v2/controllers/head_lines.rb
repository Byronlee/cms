module V2
  module Controllers
    class HeadLines < ::V2::Base
      KEYS = [:url, :title, :post_type, :image ,:order_num]

      desc 'Head line Feature'
      resource :head_lines do

        desc 'Get all head_line list'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get 'index' do
          @head_lines = HeadLine.published.order(order_num: :desc)
            .page(params[:page]).per(params[:per_page])
          cache(key: "api:v2:head_lines:index", etag: Time.now, expires_in: Settings.api.expires_in) do
            present @head_lines, with: Entities::HeadLine
          end
        end

        desc 'Get head line detail'
        params do
        end
        get ':id' do
          @head_line = HeadLine.where(id: params[:id]).first
          not_found! if @head_line.blank?
          cache(key: "api:v2:head_lines:#{@head_line.id}", etag: @head_line.updated_at, expires_in: Settings.api.expires_in) do
            present @head_line, with: Entities::HeadLine
          end
        end

        desc 'Get head line by page'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
          optional :action,  type: String, default: 'down', desc: '下翻页 down 和 上翻页 up'
        end
        get ':id/page' do
          head_line = HeadLine.where(id: params[:id]).first
          not_found! if head_line.blank?
          unless head_line.blank?
            @head_lines = HeadLine.where("created_at #{action params } :date",
              date: head_line.created_at).order('order_num desc')
            @head_lines = @head_lines.page(params[:page]).per(params[:per_page])
          end
          cache(key: "api:v2:head_lines:#{params[:id]}:page", etag: head_line.updated_at, expires_in: Settings.api.expires_in) do
            present @head_lines, with: Entities::HeadLine
          end
        end

        desc 'Create a new head line'
        params do
          requires :url, type: String, desc: '链接'
          requires :title, type: String, desc: '标题'
          requires :image, type: String, desc: '图片链接'
          requires :post_type, type: String, default: 'article' , desc: 'article,vedio...'
          requires :order_num, type: Integer, desc: '位置'
        end
        post 'new' do
          @head_line = HeadLine.new params.slice(*KEYS)
          if @head_line.save
            present @head_line, with: Entities::HeadLine
          else
            error!({ error: @head_line.errors.full_messages }, 400)
          end
        end

#        desc 'update a head line'
#        params do
#          requires :id, desc: '编号'
#          requires :url, type: String, desc: '链接'
#          requires :title, type: String, desc: '标题'
#          requires :image, type: String, desc: '图片链接'
#          requires :post_type, type: String, default: 'article' , desc: 'article,vedio...'
#          requires :order_num, type: Integer, desc: '位置'
#        end
#        patch ':id' do
#          @head_line = HeadLine.find(params[:id])
#          @head_line.update_attributes params.slice(*KEYS)
#          present @head_line, with: Entities::HeadLine
#        end
#
#        desc 'delete head line.available only for admin'
#        delete ':id' do
#          head_line = HeadLine.find(params[:id])
#          if head_line
#            head_line.destroy
#          else
#            not_found!
#          end
#        end

      end

    end
  end
end
