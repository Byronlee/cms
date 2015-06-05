module V1
  module Controllers
    class Columns < ::V1::Base

      desc 'Columns Feature'
      resource :columns do

        desc 'get all posts ids list'
        get ':id' do
          column = Column.find params[:id]
          ids = column.posts.map(&:url_code)
          { column_id: params[:id], post_ids: ids }
        end

      end
    end
  end
end
