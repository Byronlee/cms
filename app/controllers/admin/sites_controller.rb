class Admin::SitesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @sites = Site.order('created_at desc').page params[:page]
  end

  def update
    @site.columns = Column.where(id: params[:site][:column_ids])
    @site.update(site_params)
    respond_with @site, location: admin_sites_path
  end

  def create
    @site.save
    @site.update(columns: Column.where(id: params[:site][:column_ids]))
    respond_with @site, location: admin_sites_path
  end

  def destroy
    @site.destroy
    redirect_to :back
  end

  private

  def site_params
    params.require(:site).permit(:name, :domain, :info_flow_id, :admin_id, :description) if params[:site].present?
  end
end
