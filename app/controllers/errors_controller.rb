class ErrorsController < ActionController::Base
  layout nil

  def index
  end

  def apology
    render 'apology'
  end
end
