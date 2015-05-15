class Asynces::HeadLinesController < ApplicationController
  def get_metas_info
  	response.headers['content-type'] = 'application/json'
    render json: HeadLine.parse_url(params[:url])
  end
end
