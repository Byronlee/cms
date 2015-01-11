class WelcomeController < ApplicationController
  authorize_object :welcome

  def index
  end
end
