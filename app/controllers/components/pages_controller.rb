class Components::PagesController < ApplicationController
  def show
    @page = Page.find(params['id'])
    render :json => @page
  end
end
