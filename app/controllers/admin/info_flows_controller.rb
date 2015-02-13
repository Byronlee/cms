class Admin::InfoFlowsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @info_flows = InfoFlow.order('created_at desc').page params[:page]
  end

  def update
    @info_flow.update(info_flow_params)
    respond_with @info_flow, location: admin_info_flows_path
  end

  def create
    @info_flow.save
    respond_with @info_flow, location: admin_info_flows_path
  end

  def destroy
    @info_flow.destroy
    redirect_to :back
  end

  private

  def info_flow_params
    params.require(:info_flow).permit(:name) if params[:info_flow]
  end

  # def index
  #   @info_flows = Column.info_flows
  # end

  # def edit
  #   @columns = Column.all
  # end

  # def update
  #   if params[:column_ids]
  #     Column.update_all(in_info_flow:false)
  #     Column.where(id:params[:column_ids]).update_all(in_info_flow:true)
  #   end
  #   render :json => {"result" => "sucess"}
  # end

  # def destroy
  #   @column = Column.find params[:id]
  #   @column.update_attribute(:in_info_flow, false)
  #   redirect_to admin_info_flows_path
  # end
end
