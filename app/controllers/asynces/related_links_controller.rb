class Asynces::RelatedLinksController < ApplicationController
  def get_metas_info
  	response.headers['content-type'] = 'application/json'
    render json: RelatedLink.parse_url(params[:url])
  end
end
