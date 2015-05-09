class UsersController < ApplicationController
  load_resource only: :current

  def messages
    return render :text => '', layout: false if params['data'].blank? || params['data']['code'].to_i != 0
    render '_messages', layout: false
  end

  def current
    render json: current_user.to_json
  end
end
