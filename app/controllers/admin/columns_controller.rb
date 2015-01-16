class Admin::ColumnsController < Admin::BaseController
  def index
  	@columns = Column.all
  end

  def update
  	@column.update(column_params)
  	respond_with @column, location: admin_columns_path
  end

  def create
  	@column.save
  	respond_with @column, location: admin_columns_path
  end

  def destroy
  	@column.destroy
    redirect_to :back
  end

  private

  def column_params
    params.require(:column).permit(:name, :introduce) if params[:column]
  end
end
