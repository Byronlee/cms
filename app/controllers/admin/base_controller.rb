class Admin::BaseController < ApplicationController
  load_and_authorize_resource
  respond_to :html

  layout "admin"

end