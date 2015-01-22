class Admin::HeadlinesController < Admin::BaseController
   def index
  	@headlines = Headline.order('updated_at desc').page params[:page]
  end

  def update
    @headline.update(headline_params)
  	respond_with @headline, location: admin_headlines_path
  end

  def create
  	@headline.save
  	respond_with @headline, location: admin_headlines_path
  end

  def destroy
  	@headline.destroy
    redirect_to :back
  end

  private

  def headline_params
    params.require(:headline).permit(:url, :order_num) if params[:headline]
  end
end
