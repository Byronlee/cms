class ErrorsController < ApplicationController
  def render_404
    respond_to do |format|
      format.html { render 'errors/404', layout: 'application', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

  def render_500
    respond_to do |format|
      format.html { render template: 'errors/500', layout: 'application', status: 500 }
      format.all { render nothing: true, status: 500 }
    end
  end
end
