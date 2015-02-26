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

  def columns_and_ads
    @columns = @info_flow.columns
    @ads = @info_flow.ads
  end

  def edit_columns
    @columns_in_info_flow = @info_flow.columns
    @columns = Column.all - @columns_in_info_flow
  end

  def edit_ads
    @ads_in_info_flow = @info_flow.ads.order("position")
    @ads = Ad.all.order("position") - @ads_in_info_flow
  end

  def update_columns
    if params[:column_ids]
      ActiveRecord::Base.transaction do
        @info_flow.columns.clear
        @info_flow.columns << Column.where(id:params[:column_ids])
      end
    end
    render :json => {"result" => "sucess"}
  end

  def update_ads
    if params[:ad_ids]
      ActiveRecord::Base.transaction do
        @info_flow.ads.clear
        @info_flow.ads << Ad.where(id:params[:ad_ids])
      end
    end
    render :json => {"result" => "sucess"}
  end

  def destroy_column
    @column = Column.find params[:column_id]
    @info_flow.columns.delete(@column)
    redirect_to columns_and_ads_admin_info_flow_path(@info_flow)
  end

  def destroy_ad
    @ad = Ad.find params[:ad_id]
    @info_flow.ads.delete(@ad)
    redirect_to columns_and_ads_admin_info_flow_path(@info_flow, anchor:'info_flow_ads')
  end

  private

  def info_flow_params
    params.require(:info_flow).permit(:name) if params[:info_flow]
  end
end
