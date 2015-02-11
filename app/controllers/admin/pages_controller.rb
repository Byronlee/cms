class Admin::PagesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @pages = @pages.page params[:page]
  end

  def update
    @page.update(page_params)
    respond_with @page, location: admin_pages_path
  end

  def create
    @page.save
    respond_with @page, location: admin_pages_path
  end

  def destroy
    @page.destroy
    redirect_to :back
  end

  private

  def page_params
    params.require(:page).permit(:title, :body, :slug) if params[:page]
  end
end
