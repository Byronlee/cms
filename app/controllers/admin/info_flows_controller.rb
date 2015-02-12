class Admin::InfoFlowsController < Admin::BaseController
  def index
    @info_flows = Column.info_flows
  end

  def edit
    @columns = Column.all
  end

  def update
    if params[:column_ids]
      Column.update_all(in_info_flow:false)
      Column.where(id:params[:column_ids]).update_all(in_info_flow:true)
    end
    render :json => {"result" => "sucess"}
  end

  def destroy
  end
end
