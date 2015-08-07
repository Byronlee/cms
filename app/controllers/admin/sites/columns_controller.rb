class Admin::Sites::ColumnsController < Admin::BaseController
  authorize_resource
  before_filter :find_site, except: [:destroy]
  
  def index
    @column_sites = @site.column_sites.important
  end

  def update_order_nums
    order_num = 100
    params[:ids] && params[:ids].reverse.each do |id|
      column_site = ColumnSite.find id
      column_site.update_attribute(:order_num, order_num)
      order_num += 100
    end
    render :json => {result: :success}
  end

  private
  def find_site
    @site = Site.find params[:site_id]
  end
end
