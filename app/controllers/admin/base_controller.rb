class Admin::BaseController < ApplicationController
  load_and_authorize_resource if: lambda{ |controller| controller.controller_name !~ /dashboard/ }

  respond_to :html

  layout "admin"

end