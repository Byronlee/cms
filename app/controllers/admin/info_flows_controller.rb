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
    @ads_in_info_flow = @info_flow.ads.order('position')
    @ads = Ad.all.order('position') - @ads_in_info_flow
  end

  def update_columns
    update_association('columns', params['column_ids']) if params[:column_ids]
  end

  def update_ads
    update_association('ads', params['ad_ids']) if params[:ad_ids]
  end

  def destroy_column
    destroy_association('columns', params[:column_id])
    redirect_to columns_and_ads_admin_info_flow_path(@info_flow)
  end

  def destroy_ad
    destroy_association('ads', params[:ad_id])
    redirect_to columns_and_ads_admin_info_flow_path(@info_flow, anchor: 'info_flow_ads')
  end

  private

  def destroy_association(associations, id)
    @obj = associations.chop.classify.constantize.find(id)
    @info_flow.send(associations.to_sym).send(:delete, @obj)
    @info_flow.update_info_flows_cache
  end

  def update_association(associations, ids)
    ActiveRecord::Base.transaction do
      @obj = associations.chop.classify.constantize
      @info_flow.send associations.concat('=').to_sym, @obj.where(id: ids)
      @info_flow.update_info_flows_cache
    end
    render :json => { 'result' => 'sucess' }
  end

  def info_flow_params
    params.require(:info_flow).permit(:name) if params[:info_flow]
  end
end
