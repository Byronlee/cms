class UsersController < ApplicationController
  def messages
    return if params['data']['code'].to_i != 0
    render '_messages', layout: false
  end
end
