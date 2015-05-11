class Asynces::RelatedLinksController < ApplicationController
  def get_metas_info
    render json: RelatedLink.parse_url(params[:url])
  end
end
