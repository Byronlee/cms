class Admin::FragmentTemplatesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @fragment_templates = @fragment_templates.page params[:page]
  end

  def update
    @fragment_template.update(fragment_template_params)
    respond_with @fragment_template, location: admin_fragment_templates_path
  end

  def create
    @fragment_template.save
    respond_with @fragment_template, location: admin_fragment_templates_path
  end

  def destroy
    @fragment_template.destroy
    redirect_to :back
  end

  protected

  def fragment_template_params
    params.require(:fragment_template).permit(:key, :name, :content_type, :content) if params[:fragment_template]
  end
end
