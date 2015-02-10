module V1
  module Controllers
    class HeadLines < ::V1::Base
      KEYS = [:url, :order_num]

      desc 'Head line Feature'
      resource :head_lines do

        desc 'Get all head_line list'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get 'index' do
          @head_lines = HeadLine.all.order(created_at: :desc)
            .page(params[:page]).per(params[:per_page])
          present @head_lines, with: Entities::HeadLine
        end

        desc 'Get head line detail'
        params do
        end
        get ':id' do
          @head_line = HeadLine.find params[:id]
          present @head_line, with: Entities::HeadLine
        end

        desc 'Get head line by page'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
          optional :action,  type: String, default: 'down', desc: '下翻页 down 和 上翻页 up'
        end
        get ':id/page' do
          head_line = HeadLine.find params[:id]
          unless head_line.blank?
            @head_lines = HeadLine.where("created_at #{action params } :date",
              date: head_line.created_at).order(created_at: :desc)
            @head_lines = @head_lines.page(params[:page]).per(params[:per_page] || 30)
          end
          present @head_lines, with: Entities::HeadLine
        end

        desc 'Create a new head line'
        params do
          requires :url, type: String, desc: '链接'
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

        desc 'update a head line'
        params do
          requires :id, desc: '编号'
          requires :url, type: String, desc: '链接'
          requires :order_num, type: Integer, desc: '位置'
        end
        patch ':id' do
          @head_line = HeadLine.find(params[:id])
          @head_line.update_attributes params.slice(*KEYS)
          present @head_line, with: Entities::HeadLine
        end

        desc 'delete head line.available only for admin'
        delete ':id' do
          head_line = HeadLine.find(params[:id])
          if head_line
            head_line.destroy
          else
            not_found!
          end
        end

      end

    end
  end
end