class UsersController < ApplicationController
  def messages
    return render :text => '', layout: false if params['data'].blank? || params['data']['code'].to_i != 0
    render '_messages', layout: false
  end
end
