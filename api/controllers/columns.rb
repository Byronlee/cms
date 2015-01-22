module API
  class Columns < Grape::API
    KEYS = [:name, :introduce, :cover, :icon]

    desc 'Columns Feature'
    resource :columns do

      # Get all columns list
      # params[:page]
      # params[:per_page]: default is 30
      # Example
      # /api/v1/columnss?state=&page=1&per_page=15
      desc 'Get all columns list'
      params do
        optional :page,  type: Integer, default: 1, desc: "page"
        optional :per_page,  type: Integer, default: 30, desc: "per_page"
      end
      get 'index' do
        @columns = Column.order(id: :desc).page(params[:page]).per(params[:per_page])
        present @columns, with: APIEntities::Column
      end

    end
  end
end
